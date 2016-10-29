import UIKit
import PPAssetsActionController

class CustomizationsViewController: UITableViewController {
    
    fileprivate let option1String = NSLocalizedString("Option 1", comment: "Option 1 Button Title")
    fileprivate let option2String = NSLocalizedString("Option 2", comment: "Option 2 Button Title")
    fileprivate let option3String = NSLocalizedString("Option 3", comment: "Option 3 Button Title")
    fileprivate let option4String = NSLocalizedString("Option 4", comment: "Option 4 Button Title")
    fileprivate let option5String = NSLocalizedString("Option 5", comment: "Option 5 Button Title")

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0:
            handleDefault3Options()
        case 1:
            handleDefaultNoOptions()
        case 2:
            handleCustomOptionHeight3Options()
        case 3:
            handleCustomFontHeight2Options()
        case 4:
            handlePreviewHeight1Option()
        case 5:
            handleCustomInset4Options()
        case 6:
            handleSectionSpacing4Options()
        case 7:
            handleBackgroundColor5Options()
        case 8:
            handleCustomTintColor5Options()
        default: break
        }
    }
    
}

extension CustomizationsViewController {
    func handleDefault3Options() {
        let options = [
            PPOption(withTitle: option1String) { print("my option 1 callback") },
            PPOption(withTitle: option2String) { print("my option 2 callback") },
            PPOption(withTitle: option3String) { print("my option 3 callback") }
        ]
        let assetsPicker = PPAssetsActionController(with: options)
        assetsPicker.delegate = self
        present(assetsPicker, animated: true, completion: nil)
    }
    
    func handleDefaultNoOptions() {
        let assetsPicker = PPAssetsActionController(with: [])
        assetsPicker.delegate = self
        present(assetsPicker, animated: true, completion: nil)
    }
    
    func handleCustomOptionHeight3Options() {
        let options = [
            PPOption(withTitle: option1String) { print("my option 1 callback") },
            PPOption(withTitle: option2String) { print("my option 2 callback") },
            PPOption(withTitle: option3String) { print("my option 3 callback") }
        ]
        var config = PPAssetsActionConfig()
        config.buttonHeight = 75.0
        let assetsPicker = PPAssetsActionController(with: options, aConfig: config)
        assetsPicker.delegate = self
        present(assetsPicker, animated: true, completion: nil)
    }
    
    func handleCustomFontHeight2Options() {
        let options = [
            PPOption(withTitle: option1String) { print("my option 1 callback") },
            PPOption(withTitle: option2String) { print("my option 2 callback") }
        ]
        var config = PPAssetsActionConfig()
        config.font = UIFont.boldSystemFont(ofSize: 25.0)
        let assetsPicker = PPAssetsActionController(with: options, aConfig: config)
        assetsPicker.delegate = self
        present(assetsPicker, animated: true, completion: nil)
    }
    
    func handlePreviewHeight1Option() {
        let options = [
            PPOption(withTitle: option1String) { print("my option 1 callback") }
        ]
        var config = PPAssetsActionConfig()
        config.assetsPreviewRegularHeight = 70.0
        config.assetsPreviewExpandedHeight = 360.0
        let assetsPicker = PPAssetsActionController(with: options, aConfig: config)
        assetsPicker.delegate = self
        present(assetsPicker, animated: true, completion: nil)
    }
    
    func handleCustomInset4Options() {
        let options = [
            PPOption(withTitle: option1String) { print("my option 1 callback") },
            PPOption(withTitle: option2String) { print("my option 2 callback") },
            PPOption(withTitle: option3String) { print("my option 3 callback") },
            PPOption(withTitle: option4String) { print("my option 4 callback") }
        ]
        var config = PPAssetsActionConfig()
        config.inset = 50
        let assetsPicker = PPAssetsActionController(with: options, aConfig: config)
        assetsPicker.delegate = self
        present(assetsPicker, animated: true, completion: nil)
    }
    
    func handleSectionSpacing4Options() {
        let options = [
            PPOption(withTitle: option1String) { print("my option 1 callback") },
            PPOption(withTitle: option2String) { print("my option 2 callback") },
            PPOption(withTitle: option3String) { print("my option 3 callback") },
            PPOption(withTitle: option4String) { print("my option 4 callback") }
        ]
        var config = PPAssetsActionConfig()
        config.sectionSpacing = 40
        let assetsPicker = PPAssetsActionController(with: options, aConfig: config)
        assetsPicker.delegate = self
        present(assetsPicker, animated: true, completion: nil)
    }
    
    func handleBackgroundColor5Options() {
        let options = [
            PPOption(withTitle: option1String) { print("my option 1 callback") },
            PPOption(withTitle: option2String) { print("my option 2 callback") },
            PPOption(withTitle: option3String) { print("my option 3 callback") },
            PPOption(withTitle: option4String) { print("my option 4 callback") },
            PPOption(withTitle: option5String) { print("my option 5 callback") }
        ]
        var config = PPAssetsActionConfig()
        config.backgroundColor = UIColor.green
        let assetsPicker = PPAssetsActionController(with: options, aConfig: config)
        assetsPicker.delegate = self
        present(assetsPicker, animated: true, completion: nil)
    }
    
    func handleCustomTintColor5Options() {
        let options = [
            PPOption(withTitle: option1String) { print("my option 1 callback") },
            PPOption(withTitle: option2String) { print("my option 2 callback") },
            PPOption(withTitle: option3String) { print("my option 3 callback") },
            PPOption(withTitle: option4String) { print("my option 4 callback") },
            PPOption(withTitle: option5String) { print("my option 5 callback") }
        ]
        var config = PPAssetsActionConfig()
        config.tintColor = UIColor.magenta
        let assetsPicker = PPAssetsActionController(with: options, aConfig: config)
        assetsPicker.delegate = self
        present(assetsPicker, animated: true, completion: nil)
    }
}

extension CustomizationsViewController: PPAssetsActionControllerDelegate {
    func assetsPickerDidCancel(_ picker: PPAssetsActionController) {
        print("assetsPickerDidCancel")
    }
    
    func assetsPicker(_ controller: PPAssetsActionController, didFinishPicking images: [UIImage]) {
        dismiss(animated: true, completion: nil)
    }
    
    func assetsPicker(_ controller: PPAssetsActionController, didSnapImage image: UIImage) {
        dismiss(animated: true, completion: nil)
    }
    
    func assetsPicker(_ controller: PPAssetsActionController, didSnapVideo videoURL: URL) {
        dismiss(animated: true, completion: nil)
    }
}
