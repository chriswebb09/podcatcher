//
//  PopOverViewController.swift
//  Podcatch
//
//  Created by Christopher Webb-Orenstein on 2/9/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class PopOverViewController: UITableViewController, UIAdaptivePresentationControllerDelegate {
    
    private var titles: [String] = []
    private var descriptions: [String]?
    
    @objc var completionHandler: ((_ selectRow: Int) -> Void)?
    
    private var selectRow:Int?
    private var separ:Int?
    private var separatorStyle: UITableViewCellSeparatorStyle = UITableViewCellSeparatorStyle.none
    private var showsVerticalScrollIndicator:Bool = false
    
    @objc static func instantiate() -> PopOverViewController {
        let tableVC = UIStoryboard(name: "PopOver", bundle: nil).instantiateViewController(withIdentifier: "PopOverViewController") as! UITableViewController
        let popOverViewController:PopOverViewController = tableVC as! PopOverViewController
        tableVC.tableView.layer.borderWidth = 1
        tableVC.tableView.layer.cornerRadius = 14
        popOverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        popOverViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popOverViewController.popoverPresentationController?.backgroundColor = UIColor.white
        return popOverViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
        tableView.tableFooterView = UIView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        tableView.separatorStyle = separatorStyle
        tableView.accessibilityIdentifier = "PopUpTableView"
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        if (selectRow != nil) {
            let selectIndexPath:IndexPath = IndexPath(row: selectRow!, section: 0)
            tableView.scrollToRow(at: selectIndexPath, at: .middle, animated: true)
        }
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - table
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 250, height: tableView.contentSize.height)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let title: String? = titles[indexPath.row]
        cell = tableView.dequeueReusableCell(withIdentifier: "SingleTitleCell")!
        cell.textLabel?.text = title
        if selectRow == nil {
            cell.accessoryType = UITableViewCellAccessoryType.none
        } else {
            cell.accessoryType = selectRow == indexPath.row ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
        }
        return cell
    }
    
    @objc func setTitles(_ titles:Array<String>) {
        self.titles = titles
    }
    
    @objc func setDescriptions(_ descriptions:Array<String>) {
        self.descriptions = descriptions
    }
    
    @objc func setSelectRow(_ selectRow:Int) {
        self.selectRow = selectRow
    }
    
    @objc func setSeparatorStyle(_ separatorStyle:UITableViewCellSeparatorStyle) {
        self.separatorStyle = separatorStyle
    }
    
    @objc func setShowsVerticalScrollIndicator(_ showsVerticalScrollIndicator:Bool) {
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
    }
    
    override func tableView(_ tableview: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.dismiss(animated: true, completion: {
            if self.completionHandler != nil {
                let selectRow:Int = indexPath.row
                self.completionHandler!(selectRow)
            }
        })
    }
}


