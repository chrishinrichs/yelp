//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation

let distanceMapping = ["0.3 miles": 483, "1 mile": 1609, "5 miles": 8047, "20 miles": 32187]
let categoryMapping = ["Thai": "thai", "Barbeque": "bbq", "Chinese": "chinese", "French": "french"]


class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    var geoCoder = CLGeocoder()
    var city = "San Jose"
    var location: CLLocation!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, filters: [String: String], success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        var parameters = ["term": term, "location": city]
        if location != nil {
            parameters["cll"] = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        }
        for (key, value) in filters {
            switch (key) {
                case "Category":
                    if value != "All" {
                        parameters["category_filter"] = categoryMapping[value]
                    }
                case "Distance":
                    if value != "Auto" {
                        parameters["radius_filter"] = "\(distanceMapping[value]!)"
                    }
                default:
                    println("Unknown filter")
            }
        }
        
        return self.GET("search", parameters: parameters, success: success, failure: failure)
        
    }
    
}