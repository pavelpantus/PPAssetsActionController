import UIKit

/**
 Cell representing photo asset in Assets Collection Controller.
 */
class PPPhotoViewCell: PPCheckedViewCell {
    func set(_ image: UIImage) {
        let photo = UIImageView(image: image)
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        backgroundView = photo
        
        setupCheckmark()
    }
}
