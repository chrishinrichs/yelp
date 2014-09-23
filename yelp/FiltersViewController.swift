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
    
    var isExpanded = [Int: Bool]()
    let sections = ["Distance", "Category"]
    let sectionData = ["Distance": [
        "Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"], "Category": ["All", "Restaurants", "Doctors", "Dentists"]]
    var selectedFilters = [String: String]()
    
    
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
        if isExpanded[section] != nil {
            if isExpanded[section]! {
                let sec = sections[section]
                let secData = sectionData[sec]!
                return secData.count
            } else {
                return 1
            }
        } else {
            return 1
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor.lightGrayColor()
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        label.font = UIFont.systemFontOfSize(22)
        label.text = "\(sections[section])"
        label.textColor = UIColor.blackColor()
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as FilterCell
        var sec = sections[indexPath.section]
        var secData = sectionData[sec]!
        if (isExpanded[indexPath.section] == nil || isExpanded[indexPath.section] == false) && selectedFilters[sec] != nil {
            
            cell.filterLabel.text = "\(selectedFilters[sec]!)"
            
        } else {
            cell.filterLabel.text = "\(secData[indexPath.row])"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionNum = indexPath.section
        let rowNum = indexPath.row
        if isExpanded[sectionNum] != nil {
            isExpanded[sectionNum] = !isExpanded[sectionNum]!
            if isExpanded[sectionNum] == false {
                // Update to the selected index
                var sectionName = sections[sectionNum]
                var data = sectionData[sectionName]!
                var newVal = data[rowNum]
                selectedFilters[sectionName] = newVal
            }
        } else {
            isExpanded[sectionNum] = true
        }
        tableView.reloadSections(NSIndexSet(index: sectionNum), withRowAnimation: UITableViewRowAnimation.Fade)

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
