//
//  ViewController.swift
//  EatSpector
//
//  Created by Pann Cherry on 4/17/19.
//

import UIKit
import AFNetworking
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business] = []
    var searching = false;
    var searchInput: [Business] = [];
    let cellSpacingHeight: CGFloat = 30
    let locationManager: CLLocationManager = CLLocationManager();
    
    
    override func viewDidLoad() {
        tableView.delegate = self
        
        tableView.rowHeight = 128
        
        //tableView.rowHeight = UITableView.automaticDimension
        
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        
        locationManager.distanceFilter = 75;
        //locationManager.stopUpdatingLocation()
        
        tableView.dataSource = self
        fetchBusinesses()
    }
    
    /*:
     # Set up navigation bar
     */
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true;
        let searchController = UISearchController(searchResultsController: nil);
        navigationItem.searchController = searchController;
        searchController.delegate = self as? UISearchControllerDelegate;
        navigationItem.hidesSearchBarWhenScrolling = false;
    }
    
    
    /*:
     # Count business
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            print(searchInput.count )
            return searchInput.count ;
        }
        else{
            print(businesses.count);
            return businesses.count;
        }
        
    }
    
    
    /*:
     # Get cell indexPath.row
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        //code to change color of selected cell background
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(red: 0.9, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        cell.contentView.backgroundColor = UIColor.init(red: 0.9, green: 1.0, blue: 1.0, alpha: 0.9)
        //code to set the cell background
        
       // let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
       // loadingMoreViews = InfiniteScrollActivityView(frame: frame)
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.height - 20, height: 128))
    
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        if searchInput.count != 0 {
            cell.business = searchInput[indexPath.row]
        } else {
            cell.business = businesses[indexPath.row]
        }
        return cell
    }
    
    
    /*:
     # Fetch business
     */
    func fetchBusinesses () {
        BusinessAPIManager().getBusinesses { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()
                //self.activityIndicator.stopAnimating()
                //self.refreshControl.endRefreshing()
            }
        }
    }
    
    
    /*:
     # Custom navigation bar
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 0.9)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    
    /*:
     # Search bar function
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInput = businesses.filter({ (Business) -> Bool in
            guard searchBar.text != nil else { return false;}
            return Business.name.lowercased().contains(searchText.lowercased())
        })
        searching = true;
        tableView.reloadData();
    }
    
    
    /*:
     # Search bar cancel function
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false;
        searchInput = []
        tableView.reloadData();
        searchBar.resignFirstResponder()
        
    }

    
}

