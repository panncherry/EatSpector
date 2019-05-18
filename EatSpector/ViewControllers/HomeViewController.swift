//
//  ViewController.swift
//  EatSpector
//
//  Created by Pann Cherry on 4/17/19.
//

import UIKit
import AFNetworking
import CoreLocation

var allBusinesses: [Business] = []

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    var businesses: [Business] = []
    var filteredBusiness:[Business]!
    
    var searching = false;
    var searchInput: [Business] = [];
    
    let cellSpacingHeight: CGFloat = 30
    let locationManager: CLLocationManager = CLLocationManager();
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 128
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
       
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        self.activityIndicator.startAnimating()
        tableView.insertSubview(refreshControl, at: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.fetchBusinesses()
        }
    }
    
    
    // Count business
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchInput.count
        }
        else{
            return businesses.count
        }
    }
    
    
    // Get cell indexPath.row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        // code to change color of the cell user selected
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = backgroundView
        
        if searchInput.count != 0 {
            cell.business = searchInput[indexPath.row]
        } else {
            cell.business = businesses[indexPath.row]
        }
        return cell
    }
    
    
    // MARK: Fetch business
    func fetchBusinesses () {
        BusinessAPIManager().getBusinesses { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.filteredBusiness = businesses
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
    }
    

    // MARK: SET UP NAVIGATION BAR
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true;
        let searchController = UISearchController(searchResultsController: nil);
        navigationItem.searchController = searchController;
        searchController.delegate = self as? UISearchControllerDelegate;
        navigationItem.hidesSearchBarWhenScrolling = false;
    }
    
    // MARK: PRESENT CUSTOM NAVIGATION BAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.9)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.4, green: 1.0, blue: 1.0, alpha: 1.0)]
    }
    
    // MARK: PRESENT NAVIGATION BAR
    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor(red: 0.4, green: 1.0, blue: 1.0, alpha: 1.0)
    }
   
    
    // MARK: ACTION
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchBusinesses()
    }
    
    // MARK: NETWORK ERROR ALERT
    func networkErrorAlert(title:String, message:String){
        let networkErrorAlert = UIAlertController(title: "Network Error", message: "The internet connection appears to be offline. Please try again later.", preferredStyle: UIAlertController.Style.alert)
        networkErrorAlert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: { (action) in self.fetchBusinesses()}))
        self.present(networkErrorAlert, animated: true, completion: nil)
    }
    
    // MARK: SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
            let business = businesses[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.business = business
        }
    }
    
    // MARK: ACTION
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        businesses = searchText.isEmpty ? filteredBusiness : filteredBusiness.filter({ businesses -> Bool in
            let dataString = businesses.name
            return dataString.lowercased().range(of: searchText.lowercased()) != nil
        })
        tableView.reloadData()
    }
    
    // MARK: ACTION
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        fetchBusinesses()
    }
    
    // MARK: ACTION
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    

}
