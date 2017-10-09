import UIKit

protocol PPOptionsViewControllerDelegate: class {
    func optionsViewControllerShouldBeDismissed(_ controller: PPOptionsViewController)
    
    func optionsViewControllerDidRequestTopOption(_ controller: PPOptionsViewController)
}

/**
 Bottom part of Assets Picker Controller that consists of provided options,
 Cancel and Snap Photo or Video / Send X Items buttons.
 */
class PPOptionsViewController: UITableViewController {

    public weak var delegate: PPOptionsViewControllerDelegate?

    private var tableHeightConstraint: NSLayoutConstraint!
    private let cornerRadius: CGFloat = 5.0
    public var options: [PPOption] = []
    fileprivate var config: PPAssetsActionConfig!

    init(aConfig: PPAssetsActionConfig) {
        super.init(style: .plain)
        config = aConfig
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "option_cell_id")

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.bounces = false

        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0

        tableView.separatorInset = UIEdgeInsets.zero

        if #available(iOS 9.0, *) {
            tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 8.0)
        } else if #available(iOS 8.0, *) {
            tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 15.0)
        }

        tableHeightConstraint = NSLayoutConstraint(item: tableView,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: 0.0)
        tableView.addConstraint(tableHeightConstraint)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()

        tableHeightConstraint.constant = tableView.contentSize.height
    }
    
    func set(sendItemsCount count: Int) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
            if count > 0 {
                cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("Send %d Items", comment: "Send X Items"), count)
            } else {
                cell.textLabel?.text = NSLocalizedString("Snap Photo or Video", comment: "Snap Photo or Video")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return options.count + 1
        case 1:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option_cell_id", for: indexPath)

        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = config.tintColor
        cell.textLabel?.font = config.font

        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = NSLocalizedString("Snap Photo or Video", comment: "Snap Photo or Video")
            } else {
                cell.textLabel?.text = options[indexPath.row - 1].title
            }

            if (indexPath.row == options.count) {
                let maskPath = UIBezierPath(roundedRect: cell.bounds,
                                            byRoundingCorners: [.bottomRight, .bottomLeft],
                                            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
                let maskLayer = CAShapeLayer()
                maskLayer.frame = cell.bounds
                maskLayer.path = maskPath.cgPath
                cell.layer.mask = maskLayer
            }
        } else if (indexPath.section == 1) {
            cell.textLabel?.text = NSLocalizedString("Cancel", comment: "Cancel Action Sheet Button Label")
            cell.accessibilityLabel = "cancel-cell"
            cell.textLabel?.font = config.font
            cell.layer.cornerRadius = cornerRadius
            cell.layer.masksToBounds = true
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return config.sectionSpacing
        default:
            return 0.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return config.inset
        default:
            return 0.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return config.buttonHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            delegate?.optionsViewControllerShouldBeDismissed(self)
        } else {
            if indexPath.row == 0 {
                delegate?.optionsViewControllerDidRequestTopOption(self)
            } else if indexPath.row > 0 {
                options[indexPath.row - 1].handler()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footerView = view as? UITableViewHeaderFooterView {
            footerView.backgroundView?.backgroundColor = UIColor.clear
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.backgroundView?.backgroundColor = UIColor.clear
        }
    }
}
