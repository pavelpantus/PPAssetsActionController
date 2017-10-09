import UIKit
import AVFoundation

protocol PPAssetsViewControllerDelegate: class {
    func assetsViewController(_ controller: PPAssetsCollectionController, didChange itemsCount: Int)

    func assetsViewControllerDidRequestCameraController(_ controller: PPAssetsCollectionController)
}

/**
 Top part of Assets Action Controller that represents camera roll assets preview.
 */
class PPAssetsCollectionController: UICollectionViewController {

    public weak var delegate: PPAssetsViewControllerDelegate?

    private var flowLayout: PPCollectionViewLayout!
    fileprivate var heightConstraint: NSLayoutConstraint!
    private let assetManager = PPAssetManager()
    fileprivate var assets: [MediaProvider] = []
    private var selectedItemRows = Set<Int>()
    fileprivate var config: PPAssetsActionConfig!
    fileprivate var captureSession: AVCaptureSession?
    fileprivate var captureLayer: AVCaptureVideoPreviewLayer?
    fileprivate let cameraIsAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
    
    public init(aConfig: PPAssetsActionConfig) {
        flowLayout = PPCollectionViewLayout()
        config = aConfig
        super.init(collectionViewLayout: flowLayout)

        flowLayout.itemsInfoProvider = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        stopCaptureSession()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = UIColor.clear
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false

        collectionView?.register(PPPhotoViewCell.self, forCellWithReuseIdentifier: PPPhotoViewCell.reuseIdentifier)
        collectionView?.register(PPVideoViewCell.self, forCellWithReuseIdentifier: PPVideoViewCell.reuseIdentifier)
        collectionView?.register(PPLiveCameraCell.self, forCellWithReuseIdentifier: PPLiveCameraCell.reuseIdentifier)

        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        heightConstraint = NSLayoutConstraint(item: collectionView!,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: config.assetsPreviewRegularHeight)
        collectionView?.addConstraint(heightConstraint)

        self.flowLayout.viewWidth = self.view!.frame.width

        let requestImages = {
            self.assetManager.getAssets(offset: 0, count: 20, imagesOnly: !self.config.showVideos)
            { assets in
                if assets.count > 0 {
                    self.assets = assets
                    self.collectionView?.reloadData()
                } else {
                    self.heightConstraint.constant = 0
                }
            }
        }
        
        if assetManager.authorizationStatus() == .authorized {
            requestImages()
        } else if config.askPhotoPermissions {
            assetManager.requestAuthorization { status in
                if status == .authorized {
                    requestImages()
                } else {
                    self.heightConstraint.constant = 0
                }
            }
        } else {
            self.heightConstraint.constant = 0
        }

        if rowCountForLiveCameraCell() == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.setupCaptureSession()
            }
        }
    }
    
    func selectedMedia() -> [MediaProvider] {
        return selectedItemRows.map { assets[$0] }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count + rowCountForLiveCameraCell();
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 && rowCountForLiveCameraCell() == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PPLiveCameraCell.reuseIdentifier, for: indexPath) as! PPLiveCameraCell
            cell.backgroundColor = UIColor.black
            cell.accessibilityLabel = PPLiveCameraCell.reuseIdentifier
            if let layer = captureLayer {
                cell.set(layer: layer)
            }
            return cell
        }

        let mediaProvider = assets[modifiedRow(for: indexPath.row)]
        var cell: PPCheckedViewCell!

        if let video = mediaProvider.video() {
            let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PPVideoViewCell.reuseIdentifier, for: indexPath) as! PPVideoViewCell

            let item = AVPlayerItem(asset: video)
            let player = AVPlayer(playerItem: item)
            player.volume = 0.0
            let playerLayer = AVPlayerLayer(player: player)

            videoCell.set(mediaProvider.image()!, playerLayer)

            cell = videoCell
        } else if let image = mediaProvider.image() {
            let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PPPhotoViewCell.reuseIdentifier, for: indexPath) as! PPPhotoViewCell

            photoCell.set(image)

            cell = photoCell
        }

        cell.checked.tintColor = config.tintColor
        if (heightConstraint.constant == config.assetsPreviewExpandedHeight) {
            cell.set(selected: selectedItemRows.contains(modifiedRow(for: indexPath.row)))
        }
        cell.accessibilityLabel = "asset-\(modifiedRow(for: indexPath.row))"

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && rowCountForLiveCameraCell() == 1 {
            delegate?.assetsViewControllerDidRequestCameraController(self)
            return
        }

        if selectedItemRows.contains(modifiedRow(for: indexPath.row)) {
            selectedItemRows.remove(modifiedRow(for: indexPath.row))
        } else {
            selectedItemRows.insert(modifiedRow(for: indexPath.row))
        }
        
        delegate?.assetsViewController(self, didChange: selectedItemRows.count)

        if (heightConstraint.constant < config.assetsPreviewExpandedHeight) {
            heightConstraint.constant = config.assetsPreviewExpandedHeight
            collectionView.setNeedsLayout()
            
            let flowLayout = PPCollectionViewLayout()
            flowLayout.itemsInfoProvider = self
            flowLayout.viewWidth = view.frame.width
            
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 1.0,
                           options: .curveEaseIn,
                           animations:
                {
                    // FIXME: iOS10 layout workaround. Think of a better way.
                    collectionView.superview?.superview?.layoutIfNeeded()
                    collectionView.setCollectionViewLayout(flowLayout, animated: true)
            }) { result in
                collectionView.reloadData()
            }
        } else {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            if let cell = collectionView.cellForItem(at: indexPath) as? PPPhotoViewCell {
                cell.set(selected: selectedItemRows.contains(modifiedRow(for: indexPath.row)))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == assets.count - 2) {
            self.assetManager.getAssets(offset: assets.count, count: 20, imagesOnly: !config.showVideos)
            { assets in
                if assets.count > self.assets.count {
                    self.assets = assets
                    self.collectionView?.reloadData()
                }
            }
        }

        if let videoCell = cell as? PPVideoViewCell {
            videoCell.startVideo()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let videoCell = cell as? PPVideoViewCell {
            videoCell.stopVideo()
        }
    }
}

// MARK: - Camera
extension PPAssetsCollectionController {
    func setupCaptureSession() {
        let defaultDevice = AVCaptureDevice.default(for: AVMediaType.video)
        if let input = try? AVCaptureDeviceInput(device: defaultDevice!) {
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            captureLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            captureLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            captureSession?.startRunning()
            collectionView?.reloadData()
        }
    }

    func stopCaptureSession() {
        if let session = captureSession {
            session.stopRunning()
            captureSession = nil
        }
    }
}

extension PPAssetsCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 && rowCountForLiveCameraCell() == 1 {
            return CGSize(width: heightConstraint.constant, height: heightConstraint.constant)
        }

        let imageView = UIImageView(image: assets[modifiedRow(for: indexPath.row)].image()!)
        imageView.contentMode = .scaleAspectFill
        let factor = heightConstraint.constant / imageView.frame.height
        return CGSize(width: imageView.frame.width * factor, height: heightConstraint.constant)
    }
}

extension PPAssetsCollectionController {
    func modifiedRow(for row: Int) -> Int {
        return row - (config.showLiveCameraCell ? rowCountForLiveCameraCell() : 0)
    }

    func rowCountForLiveCameraCell() -> Int {
        return cameraIsAvailable ? 1 : 0
    }
}
