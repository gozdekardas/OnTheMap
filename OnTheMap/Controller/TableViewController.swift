//
//  TableViewController.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 2.06.2021.
//

import UIKit


class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userLocations: [Location]!{
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.userLocations
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableCell")!
        let loc = self.userLocations[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "\(loc.firstName) \(loc.lastName)"
        cell.detailTextLabel?.text = "\(loc.mediaURL)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loc = self.userLocations[(indexPath as NSIndexPath).row]
        UIApplication.shared.openURL(URL(string: loc.mediaURL)!)
        
    }
    
}









