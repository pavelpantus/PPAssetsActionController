import UIKit
import MobileCoreServices


/**
 Assets Picker Delegate methods.
 */
public protocol PPAssetsActionControllerDelegate: class {
    /**
     Called when a user dismisses a picker by tapping cancel or background.
     Implementation is optional.
     - Parameter picker: Picker Controller that was dismissed.
    */
    func assetsPickerDidCancel(_ picker: PPAssetsActionController)

    /**
     Called when a user takes an image.
     Assets Picker is not dismissed automatically when the delegate method is called.
     Implementation is optional.
     - Parameters:
        - picker: Current picker controller.
        - image: Picture that was taken with system Image Picker Controller.
    */
    func assetsPicker(_ picker: PPAssetsActionController, didSnapImage image: UIImage)

    /**
     Called when a user takes a video.
     Assets Picker is not dismissed automatically when the delegate method is called.
     Implementation is optional.
     - Parameters:
        - picker: Current picker controller.
        - videoURL: URL of video that was taken with system Image Picker Controller.
     */
    func assetsPicker(_ picker: PPAssetsActionController, didSnapVideo videoURL: URL)

    /**
     Called when a user selects previews and presses send button.
     Assets Picker is not dismissed automatically when the delegate method is called.
     Implementation is optional.
     - Parameters:
        - picker: Current picker controller.
        - images: Images that were selected with Preview Picker.
     */
    func assetsPicker(_ picker: PPAssetsActionController, didFinishPicking images: [UIImage])
}


/**
 Default implementation for delegate methods to make them optional.
 */
extension PPAssetsActionControllerDelegate {
    func assetsPickerDidCancel(_ picker: PPAssetsActionController) {}
    func assetsPicker(_ controller: PPAssetsActionController, didSnapImage image: UIImage) {}
    func assetsPicker(_ controller: PPAssetsActionController, didSnapVideo videoURL: URL) {}
    func assetsPicker(_ controller: PPAssetsActionController, didFinishPicking images: [UIImage]) {}
}


/**
 Custom implementation of action sheet controller with assets preview.
 It is highly customizable (check out PPAssetsPickerConfig) and easy to use.
 */
public class PPAssetsActionController: UIViewController {

    public weak var delegate: PPAssetsActionControllerDelegate?

    fileprivate var foldedPositionConstraint: NSLayoutConstraint!
    fileprivate var shownPositionConstraint: NSLayoutConstraint!
    fileprivate var optionsController: PPOptionsViewController!
    fileprivate var assetsController: PPAssetsCollectionController!
    fileprivate let assetsContainer = UIView()
    fileprivate var config = PPAssetsActionConfig()
    
    public init(with options: [PPOption], aConfig: PPAssetsActionConfig? = nil) {
        super.init(nibName: nil, bundle: nil)

        transitioningDelegate = self
        modalPresentationStyle = .custom

        if let aConfig = aConfig {
            config = aConfig
        }

        optionsController = PPOptionsViewController(aConfig: config)
        optionsController.options = options
        optionsController.delegate = self

        assetsController = PPAssetsCollectionController(aConfig: config)
        assetsController.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityLabel = "assets-action-view"
        view.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(recognizer:)))
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)

        assetsContainer.backgroundColor = UIColor.white
        assetsContainer.translatesAutoresizingMaskIntoConstraints = false
        assetsContainer.layer.cornerRadius = 5.0
        view.addSubview(assetsContainer)

        let bottomCornersFiller = UIView()
        bottomCornersFiller.backgroundColor = assetsContainer.backgroundColor
        bottomCornersFiller.translatesAutoresizingMaskIntoConstraints = false
        assetsContainer.addSubview(bottomCornersFiller)

        let assetsSeparator = UIView()
        assetsSeparator.translatesAutoresizingMaskIntoConstraints = false
        assetsSeparator.backgroundColor = optionsController.tableView!.separatorColor
        bottomCornersFiller.addSubview(assetsSeparator)

        assetsController.willMove(toParentViewController: self)
        addChildViewController(assetsController)
        assetsController.didMove(toParentViewController: self)
        assetsContainer.addSubview(assetsController.collectionView!)
        
        optionsController.willMove(toParentViewController: self)
        addChildViewController(optionsController)
        optionsController.didMove(toParentViewController: self)
        view.addSubview(optionsController.tableView)

        let views: [String : Any] = ["options": optionsController.tableView!,
                                     "assets": assetsController.collectionView!,
                                     "assetsContainer": assetsContainer,
                                     "filler": bottomCornersFiller,
                                     "assetsSeparator": assetsSeparator]
        
        let si: CGFloat
        if #available(iOS 10.0, *) {
            si = 0
        } else if #available(iOS 9.0, *) {
            si = 8.0
        } else {
            si = 15.0
        }
        
        let metrics = ["M": config.inset,
                       "ACM": 6.0,
                       "MLW": 1 / UIScreen.main.scale,
                       "SI": si]

        foldedPositionConstraint = NSLayoutConstraint(item: assetsContainer,
                                                      attribute: .top,
                                                      relatedBy: .equal,
                                                      toItem: view,
                                                      attribute: .bottom,
                                                      multiplier: 1.0,
                                                      constant: 0.0)
        shownPositionConstraint = NSLayoutConstraint(item: optionsController.tableView,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: view,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: 0.0)
        view.addConstraint(NSLayoutConstraint(item: assetsContainer,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: optionsController.tableView,
                                              attribute: .top,
                                              multiplier: 1.0,
                                              constant: 0.0))
        shownPositionConstraint.isActive = false
        view.addConstraint(foldedPositionConstraint)
        assetsContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-ACM-[assets]-ACM-|",
                                                                      options: [],
                                                                      metrics: metrics,
                                                                      views: views))
        assetsContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-ACM-[assets]-ACM-|",
                                                                      options: [],
                                                                      metrics: metrics,
                                                                      views: views))
        assetsContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[filler]|",
                                                                      options: [],
                                                                      metrics: metrics,
                                                                      views: views))
        assetsContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[filler(ACM)]|",
                                                                      options: [],
                                                                      metrics: metrics,
                                                                      views: views))
        bottomCornersFiller.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-SI-[assetsSeparator]-SI-|",
                                                                          options: [],
                                                                          metrics: metrics,
                                                                          views: views))
        bottomCornersFiller.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[assetsSeparator(MLW)]|",
                                                                          options: [],
                                                                          metrics: metrics,
                                                                          views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-M-[assetsContainer]-M-|",
                                                           options: [],
                                                           metrics: metrics,
                                                           views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-M-[options]-M-|",
                                                           options: [],
                                                           metrics: metrics,
                                                           views: views))
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if(foldedPositionConstraint.isActive) {
            view.backgroundColor = config.backgroundColor
            foldedPositionConstraint.isActive = false
            shownPositionConstraint.isActive = true
            assetsContainer.layer.cornerRadius = 5.0
            view.layoutIfNeeded()
        }
    }
}


// MARK: PPOptionsViewControllerDelegate

extension PPAssetsActionController: PPOptionsViewControllerDelegate {
    func optionsViewControllerShouldBeDismissed(_ controller: PPOptionsViewController) {
        dismiss(animated: true) { 
            self.delegate?.assetsPickerDidCancel(self)
        }
    }
    
    func optionsViewControllerDidRequestTopOption(_ controller: PPOptionsViewController) {
        let selectedImages = assetsController.selectedImages()
        if selectedImages.count > 0 {
            delegate?.assetsPicker(self, didFinishPicking: selectedImages)
        } else {
            openImagePicker()
        }
    }
}


// MARK: PPAssetsViewControllerDelegate

extension PPAssetsActionController: PPAssetsViewControllerDelegate {
    func assetsViewController(_ controller: PPAssetsCollectionController, didChange itemsCount: Int) {
        optionsController.set(sendItemsCount: itemsCount)
    }

    func assetsViewControllerDidRequestCameraController(_ controller: PPAssetsCollectionController) {
        openImagePicker()
    }
}


// MARK: UIGestureRecognizerDelegate

/**
 Handle tap on a background view to dismiss the picket view controller.
 */
extension PPAssetsActionController: UIGestureRecognizerDelegate {
    @objc fileprivate func handleBackgroundTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            dismiss(animated: true) {
                self.delegate?.assetsPickerDidCancel(self)
            }
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else {
            return false
        }

        if view.isDescendant(of: assetsContainer) ||
           view.isDescendant(of: optionsController.view) {
            return false
        }
        return true
    }
}


// MARK: UIViewControllerTransitioningDelegate

extension PPAssetsActionController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}


// MARK: UIViewControllerAnimatedTransitioning

extension PPAssetsActionController: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return config.animationDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let resultingColor: UIColor
        let animationOptions: UIViewAnimationOptions

        if shownPositionConstraint.isActive {
            shownPositionConstraint.isActive = false
            foldedPositionConstraint.isActive = true
            resultingColor = UIColor.clear
            animationOptions = .curveEaseOut
        } else {
            let views: [String: Any] = ["view": view]
            resultingColor = config.backgroundColor
            animationOptions = .curveEaseIn
            containerView.addSubview(view)

            containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                        options: [],
                                                                        metrics: nil,
                                                                        views: views))
            containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                        options: [],
                                                                        metrics: nil,
                                                                        views: views))
            containerView.setNeedsLayout()
            containerView.layoutIfNeeded()

            foldedPositionConstraint.isActive = false
            shownPositionConstraint.isActive = true
        }

        UIView.animate(withDuration: config.animationDuration,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: animationOptions,
                       animations:
            {
                containerView.layoutIfNeeded()
                self.view.backgroundColor = resultingColor
        }) { result in
            transitionContext.completeTransition(result)
        }
    }
}


// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension PPAssetsActionController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let videoURL = info[UIImagePickerControllerMediaURL] as? URL
        
        dismiss(animated: true) {
            if let image = image {
                self.delegate?.assetsPicker(self, didSnapImage: image)
            } else if let videoURL = videoURL {
                self.delegate?.assetsPicker(self, didSnapVideo: videoURL)
            }
        }
    }
}
