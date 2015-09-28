//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate,UISearchBarDelegate {

    var businesses: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
//    var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
    var searchBar: UISearchBar = UISearchBar()
    var searchActive : Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        searchBar.delegate = self

        Business.searchWithTerm("Restaurants", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0xaf/255, green: 0x06/255, blue: 0x06/255, alpha: 1.0)
        self.navigationController!.navigationBar.translucent = false;
        
        searchBar.placeholder = "Search..."
        self.navigationItem.titleView = searchBar

//        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["thai"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            
//            for business in businesses {
//                print(business.name!)
//                print(business.address!)
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        searchBar.text = ""
        
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        print(filters)
        
        let deals = filters["deals"] as! Bool
        let categories = filters["categories"] as? [String]
        let distance = filters["distance"] as? Int
        
        var sortby = YelpSortMode.BestMatched
        if let rawsortby = filters["sortby"] as? Int {
            sortby = YelpSortMode(rawValue: rawsortby)!
        }
        
        Business.searchWithTerm("Restaurants", sort: sortby, categories: categories, deals: deals, distance: distance) { (businesses:[Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        let query = searchBar.text
        
        Business.searchWithTerm(query!, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        })

    }

}
