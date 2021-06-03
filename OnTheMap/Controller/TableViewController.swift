//
//  TableViewController.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 2.06.2021.
//

import UIKit


class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var userLocations: [Location]!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        tableView.delegate = self
        super.viewDidLoad()
        print("1")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = UdacityClient.getLocations() { locations, error in
            
            self.userLocations = locations.results
            self.tableView.reloadData()
            
        }
        tableView.reloadData()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableCell")!
        let loc = self.userLocations[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "\(loc.firstName) \(loc.lastName)"
        cell.detailTextLabel?.text = loc.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loc = self.userLocations[(indexPath as NSIndexPath).row]
        UIApplication.shared.openURL(URL(string: loc.mediaURL)!)
        
    }
    
}









