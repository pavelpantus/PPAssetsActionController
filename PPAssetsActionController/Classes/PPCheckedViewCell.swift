import UIKit

/**
 Protocol that provides default implementation for `reuseIdentifier` method.
 */
protocol PPReusableView: class {
    static var reuseIdentifier: String { get }
}

extension PPReusableView {
    static var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

/**
 Cell with a checkmark in the bottom right corner.
 */
class PPCheckedViewCell: UICollectionViewCell {
    public let checked = UIImageView(image: UIImage(named: "checked", in: Bundle(for: PPAssetsActionController.classForCoder()), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate))
    public let unchecked = UIImageView(image: UIImage(named: "unchecked", in: Bundle(for: PPAssetsActionController.classForCoder()), compatibleWith: nil))

    func setupCheckmark() {
        checked.isHidden = true
        unchecked.isHidden = true
        checked.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        unchecked.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        addSubview(checked)
        addSubview(unchecked)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let height = checked.frame.height
        checked.frame = CGRect(x: backgroundView!.frame.width - 1.4 * height,
                               y: backgroundView!.frame.height - 1.4 * height,
                               width: height,
                               height: height)
        unchecked.frame = CGRect(x: backgroundView!.frame.width - 1.4 * height,
                                 y: backgroundView!.frame.height - 1.4 * height,
                                 width: height,
                                 height: height)
    }

    public func set(selected: Bool) {
        checked.isHidden = !selected
        unchecked.isHidden = selected
    }
}

extension PPCheckedViewCell: PPReusableView {}
