//
//  FiltersViewController.swift
//  yelp
//
//  Created by CHRISTOPHER HINRICHS on 9/22/14.
//  Copyright (c) 2014 CHRISTOPHER HINRICHS. All rights reserved.
//

import UIKit

protocol FiltersViewDelegate {
    func setFilters(filters: NSDictionary) -> Void
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var delegate: FiltersViewDelegate!
    
    var expandedState = [Int: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var btn = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.Plain, target: self, action: "applyFilters")
        self.navigationItem.rightBarButtonItem = btn
        self.navigationItem.title = "Filters"
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applyFilters() {
    
        var filters: NSDictionary = [String: String]()
        delegate.setFilters(filters)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as FilterCell
        cell.filterLabel.text = "Cell \(indexPath.row)"
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
