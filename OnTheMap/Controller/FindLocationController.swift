//
//  FindLocationController.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 3.06.2021.
//

import UIKit
import MapKit
import CoreLocation

class FindLocationController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager!
    var currentLocationStr = "Current location"
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    var mediaUrl = ""
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.register(customAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUsersClosestLocation()
        print("done")
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        // Get user's Current Location and Drop a pin
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(currentLatitude, currentLongitude)
        mkAnnotation.title = currentLocationStr
        mapView.addAnnotation(mkAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    
    }
    
    
    //MARK:- Intance Methods
    
    func setUsersClosestLocation()  {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) {
            (placemarks, error) -> Void in
            print(placemarks)
            if let mPlacemark = placemarks{
                self.currentLatitude = mPlacemark[0].location?.coordinate.latitude ?? 0.0
                self.currentLongitude = mPlacemark[0].location?.coordinate.longitude ?? 0.0
                if let dict = mPlacemark[0].addressDictionary as? [String: Any]{
                    
                    if let Name = dict["Country"] as? String{
                        if let City = dict["State"] as? String{
                            self.currentLocationStr = Name + ", " + City
                            print(self.currentLocationStr)
                        }
                    }
                    
                    print(self.currentLongitude)
                }
            }
        }
    }
    
    
    @IBAction func finish(_ sender: Any) {
        
        UdacityClient.postStudenLocation(longitude: currentLongitude, latitude: currentLatitude, mapString: currentLocationStr, mediaURL: mediaUrl ) { success, error in
            
        }
        
        self.performSegue(withIdentifier: "backToMap", sender: nil)
    }
}
