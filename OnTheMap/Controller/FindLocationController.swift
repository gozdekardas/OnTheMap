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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.register(customAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
            determineCurrentLocation()
        print("done")
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(mRegion, animated: true)
        
        // Get user's Current Location and Drop a pin
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
        mkAnnotation.title = self.setUsersClosestLocation(mLattitude: mUserLocation.coordinate.latitude, mLongitude: mUserLocation.coordinate.longitude)
        mapView.addAnnotation(mkAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    //MARK:- Intance Methods
    
    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)
        
        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
            
            if let mPlacemark = placemarks{
                if let dict = mPlacemark[0].addressDictionary as? [String: Any]{
                    if let Name = dict["Country"] as? String{
                        if let City = dict["State"] as? String{
                            self.currentLocationStr = Name + ", " + City
                            print(self.currentLocationStr)
                        }
                    }
                }
            }
        }
        return currentLocationStr
    }
    @IBAction func finish(_ sender: Any) {
        
        
    }
}
