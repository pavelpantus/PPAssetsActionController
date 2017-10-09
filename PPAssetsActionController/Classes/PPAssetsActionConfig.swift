import UIKit

/**
 Configuration of Assets Action Controller.
 */
public struct PPAssetsActionConfig {
    
    /// Tint Color. System's by default.
    public var tintColor = UIView().tintColor
    
    /// Font to be used on buttons.
    public var font = UIFont.systemFont(ofSize: 19.0)
    
    /**
     Indicates whether Assets Action Controller should ask for photo permissions in case
     they were not previously granted.
     If false, no room will be allocated for Assets View Controller.
     */
    public var askPhotoPermissions = true
    
    /// Regular (folded) height of Assets View Controller.
    public var assetsPreviewRegularHeight: CGFloat = 140.0
    
    /// Expanded height of Assets View Controller.
    public var assetsPreviewExpandedHeight: CGFloat = 220.0
    
    /// Left, Right and Bottom insets of Assets Action Controller.
    public var inset: CGFloat = 16.0
    
    /// Spacing between Cancel and option buttons.
    public var sectionSpacing: CGFloat = 16.0
    
    /// Background color of Assets View Controller.
    public var backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.35)
    
    /// In and Out animation duration.
    public var animationDuration: TimeInterval = 0.5
    
    /// Height of each button (Options and Cancel).
    public var buttonHeight: CGFloat = 50.0
    
    /// If enabled shows live camera view as a first cell.
    public var showLiveCameraCell = true
    
    /// If enabled shows videos in Assets Collection Controller and autoplays them.
    public var showVideos = true

    public init() {}
}
