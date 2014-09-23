//
//  ViewController.swift
//  yelp
//
//  Created by CHRISTOPHER HINRICHS on 9/20/14.
//  Copyright (c) 2014 CHRISTOPHER HINRICHS. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, FiltersViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navFilterButton: UIBarButtonItem!
    var client: YelpClient!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentSearchTerm = "Thai"
    var searchBar: UISearchBar!
    
    var results: [NSDictionary] = [NSDictionary]()
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        searchBar.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        // Connect Yelp client
        client = YelpClient(consumerKey: YELP_KEY, consumerSecret: YELP_SECRET, accessToken: YELP_TOKEN, accessSecret: YELP_TOKEN_SECRET)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        // Hide search bar background
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clearColor()
        searchBar.translucent = true
        
        // Get Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func search(term: String) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        client.searchWithTerm(term, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            println(operation.request.URL.absoluteString)
            println(response)
            self.results = response["businesses"] as [NSDictionary]
            self.tableView.reloadData()
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                println(error)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        search(searchBar.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ResultCell") as ResultCell
        var result = results[indexPath.row]
        var name = result["name"] as NSString!
        cell.resultName.text = "\(indexPath.row + 1). \(name)"
        var location = result["location"] as NSDictionary!
        var streetAddresses = location["address"] as NSArray!
        var streetAddress = streetAddresses[0] as NSString
        var city = location["city"] as NSString!
        cell.resultAddress.text = "\(streetAddress), \(city)"
    
        var imgUrl = NSURL(string: result["image_url"] as NSString!)
        
        cell.resultImage.setImageWithURL(imgUrl)
        cell.resultImage.layer.cornerRadius = 5.0
        cell.resultImage.layer.masksToBounds = true
        var ratingUrl = NSURL(string: result["rating_img_url"] as NSString!)
        cell.resultRatingImg.setImageWithURL(ratingUrl)
        var ratingCount = result["review_count"] as Int!
        cell.resultNumReviews.text = "\(ratingCount) Reviews"

        // Get food categories
        var categories = result["categories"] as [[String]]
        var categoryString = ""
        for arr in categories {
            categoryString += arr[0]
            if arr != categories[categories.count - 1] {
                categoryString += ", "
            }
        }
        cell.resultDescription.text = categoryString
        
        // Calculate distance
        var coordinates = location["coordinate"] as NSDictionary!
        if coordinates != nil {
            var lat = coordinates["latitude"] as Double!
            var lon = coordinates["longitude"] as Double!
            var latDegrees = CLLocationDegrees(lat)
            var lonDegrees = CLLocationDegrees(lon)
            var loc = CLLocation(latitude: latDegrees, longitude: lonDegrees)
            var distance = currentLocation.distanceFromLocation(loc)
            var distanceInMiles = distance * 0.00062137
            let format = "%.2f"
            var milesStr = "\(NSString(format: format, distanceInMiles)) mi"
            cell.resultDistance.text = milesStr
        } else {
            cell.resultDistance.text = ""
        }
        
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (currentLocation == nil) {
            println("*** Location data received")
            currentLocation = locations.last as CLLocation
            client.location = currentLocation
            var g = CLGeocoder()
            g.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks: [AnyObject]!, error: NSError!) -> Void in
                
                if error == nil && placemarks != nil && placemarks.count > 0 {
                    var placemark = placemarks[0] as CLPlacemark
                    self.client.city = placemark.locality
                }
                self.search(self.currentSearchTerm)
            })
            locationManager.stopUpdatingLocation()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFilters" {
            // Pass the movie title to the details page
            var destination = segue.destinationViewController as FiltersViewController
            destination.delegate = self
            
        }
    }
    
    func setFilters(filters: NSDictionary) {
        println("Made it!")
    }
    
    /* func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var currentCell = tableView.cellForRowAtIndexPath(indexPath) as ResultCell
        var cellHeight = currentCell.resultName.bounds.size.height
        cellHeight += currentCell.resultRatingImg.bounds.size.height
        cellHeight += currentCell.resultAddress.bounds.size.height
        cellHeight += currentCell.resultDescription.bounds.size.height
        return cellHeight
        
    } */

}

