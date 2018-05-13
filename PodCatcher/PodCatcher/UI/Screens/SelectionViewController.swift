//
//  SelectionViewController.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//


import UIKit

/// A custom table view controller to allow users to select `VirtualObject`s for placement in the scene.
class SelectionViewController: UITableViewController, UIAdaptivePresentationControllerDelegate {
    
    var items = [String]()
    
    @objc open static func instantiate() -> SelectionViewController {
        let tableVC = SelectionViewController()
        let popOverViewController: SelectionViewController = tableVC
        popOverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        popOverViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popOverViewController.popoverPresentationController?.backgroundColor = UIColor.white
        return popOverViewController
    }
    
    @objc open var completionHandler: ((_ selectRow: Int) -> Void)?
    
    fileprivate var selectRow:Int?
    
    var selectedObjectRows = IndexSet()
    
    weak var delegate: SelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ObjectCell.self, forCellReuseIdentifier: ObjectCell.reuseIdentifier)
        tableView.register(CancelCell.self, forCellReuseIdentifier: CancelCell.reuseIdentifier)
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
        tableView.rowHeight = 70
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 350, height: tableView.contentSize.height)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if (selectRow != nil) {
            let selectIndexPath:IndexPath = IndexPath(row: selectRow!, section: 0)
            tableView.scrollToRow(at: selectIndexPath, at: .middle, animated: true)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedObjectRows.contains(indexPath.row) {
            delegate?.virtualObjectSelectionViewController(self, didDeselectObject: object)
        } else {
            delegate?.virtualObjectSelectionViewController(self, didSelectObject: object)
        }
        self.dismiss(animated: true, completion: {
            UIView.animate(withDuration: 0.2) {
                self.tableView.alpha = 0
            }
            if self.completionHandler != nil {
                let selectRow:Int = indexPath.row
                self.completionHandler!(selectRow)
            }
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == items.count - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CancelCell.reuseIdentifier, for: indexPath) as? CancelCell else {
                fatalError("Expected `\(CancelCell.self)` type for reuseIdentifier \(CancelCell.reuseIdentifier). Check the configuration in Main.storyboard.")
            }
            cell.modelName = items[indexPath.row]
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ObjectCell.reuseIdentifier, for: indexPath) as? ObjectCell else {
                fatalError("Expected `\(ObjectCell.self)` type for reuseIdentifier \(ObjectCell.reuseIdentifier). Check the configuration in Main.storyboard.")
            }
            cell.modelName = items[indexPath.row]
            if selectedObjectRows.contains(indexPath.row) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
    }
    
    //    @objc open func setItems(_ items:Array<String>) {
    //        self.items = items
    //    }
    
    @objc open func setSelectRow(_ selectRow:Int) {
        self.selectRow = selectRow
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .clear
    }
}
