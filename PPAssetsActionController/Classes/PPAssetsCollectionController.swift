import UIKit

protocol PPAssetsViewControllerDelegate: class {
    func assetsViewController(_ controller: PPAssetsCollectionController, didChange itemsCount: Int)
}

/**
 Top part of Assets Action Controller that represents camera roll assets preview.
 */
class PPAssetsCollectionController: UICollectionViewController {

    public weak var delegate: PPAssetsViewControllerDelegate?

    private var flowLayout: PPCollectionViewLayout!
    fileprivate var heightConstraint: NSLayoutConstraint!
    private let assetManager = PPAssetManager()
    fileprivate var assets: [UIImage] = []
    private var selectedItemRows = Set<Int>()
    fileprivate var config: PPAssetsActionConfig!
    
    public init(aConfig: PPAssetsActionConfig) {
        flowLayout = PPCollectionViewLayout()
        config = aConfig
        super.init(collectionViewLayout: flowLayout)

        flowLayout.itemsInfoProvider = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = UIColor.clear
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.register(PPPhotoViewCell.self, forCellWithReuseIdentifier: PPPhotoViewCell.reuseIdentifier)

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
            self.assetManager.getImages(offset: 0, count: 20)
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
    }
    
    func selectedImages() -> [UIImage] {
        var selectedImages: [UIImage] = []
        for selectedRow in selectedItemRows {
            selectedImages.append(assets[selectedRow])
        }
        return selectedImages
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PPPhotoViewCell.reuseIdentifier, for: indexPath) as! PPPhotoViewCell

        cell.checked.tintColor = config.tintColor
        cell.set(assets[indexPath.row])
        if (heightConstraint.constant == config.assetsPreviewExpandedHeight) {
            cell.set(selected: selectedItemRows.contains(indexPath.row))
        }
        cell.accessibilityLabel = "asset-\(indexPath.row)"

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedItemRows.contains(indexPath.row) {
            selectedItemRows.remove(indexPath.row)
        } else {
            selectedItemRows.insert(indexPath.row)
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
                cell.set(selected: selectedItemRows.contains(indexPath.row))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == assets.count - 2) {
            self.assetManager.getImages(offset: assets.count, count: 20)
            { assets in
                if assets.count > self.assets.count {
                    self.assets = assets
                    self.collectionView?.reloadData()
                }
            }
        }
    }
}

extension PPAssetsCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageView = UIImageView(image: assets[indexPath.row])
        imageView.contentMode = .scaleAspectFill
        let factor = heightConstraint.constant / imageView.frame.height
        return CGSize(width: imageView.frame.width * factor, height: heightConstraint.constant)
    }
}
