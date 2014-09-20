//
//  ViewController.swift
//  yelp
//
//  Created by CHRISTOPHER HINRICHS on 9/20/14.
//  Copyright (c) 2014 CHRISTOPHER HINRICHS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var client: YelpClient!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var results: [NSDictionary] = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Hide search bar background
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clearColor()
        searchBar.translucent = true
        
        // Connect Yelp client
        client = YelpClient(consumerKey: YELP_KEY, consumerSecret: YELP_SECRET, accessToken: YELP_TOKEN, accessSecret: YELP_TOKEN_SECRET)
        

        
        tableView.delegate = self
        tableView.dataSource = self
        
        search("thai")
    }
    
    func search(term: String) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        client.searchWithTerm(term, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            println(response)
            var object = NSJSONSerialization.JSONObjectWithData(response as NSData, options: nil, error: nil) as NSDictionary
            println(object)
            self.results = object["businesses"] as [NSDictionary]
            self.tableView.reloadData()
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                println(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ResultCell") as ResultCell
        
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

}

