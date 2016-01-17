//
//  ViewController.swift
//  HZTableViewSample
//
//  Created by Moch Fariz Al Hazmi on 1/17/16.
//  Copyright © 2016 Alhazmi. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    
    @IBOutlet var tableView: HZMaterialTableView!
    
    var tasks = [
        "Material Button",
        "Material Navigation Bar",
        "Material Table View",
        "Material Table View Cell",
        "Material View",
        "Material Text Field",
        "Material Button",
        "Material Navigation Bar",
        "Material Table View",
        "Material Table View Cell",
        "Material View",
        "Material Text Field"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupNavigationBar()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let navigationController = self.navigationController as? HZMaterialNavigationController {
            navigationController.visibility = .Hidden
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let navigationController = self.navigationController as? HZMaterialNavigationController {
            navigationController.visibility = .Visible
        }
    }
    
    func setupNavigationBar() {
        self.title = "Tasks"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0.592, blue: 0.655, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }

}


extension ViewController: UITableViewDataSource, UITableViewDelegate, HZMaterialTableViewDelegate {
    
    // MARK: - UITableView Delegate Handler
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.materialDelegate = self
        self.tableView.materialNavigationController = self.navigationController
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"cell")
        cell.textLabel!.text = tasks[indexPath.row]
        
        return cell
    }
    
    func materialHeaderFloatButtonTouched(materialHeaderFloatButton: UIButton) {
        print(materialHeaderFloatButton.frame)
    }
}