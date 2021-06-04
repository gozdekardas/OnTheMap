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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
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
        
        //Hide activity indicatory when stops
        activityIndicatorView.hidesWhenStopped = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        activityIndicatorView.startAnimating()
        setUsersClosestLocation{ response, error in
            if  response {
                
                var annotations = [MKPointAnnotation]()
                let coordinate = CLLocationCoordinate2D(latitude: self.currentLatitude, longitude: self.currentLongitude)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = self.currentLocationStr
                
                annotations.append(annotation)
                
                self.mapView.addAnnotations(annotations)
                self.centerMapOnLocation(CLLocation(latitude: self.currentLatitude, longitude: self.currentLongitude), mapView: self.mapView)
                self.activityIndicatorView.stopAnimating()
            }else{
                self.showLoginFailure(message: "Error when getting location")
            }
        }
        
        
    }
    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 5000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    
    //MARK:- Intance Methods
    
    func setUsersClosestLocation(completion: @escaping (Bool, Error?) -> Void)  {
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
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }else{
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
    
    
    @IBAction func finish(_ sender: Any) {
        
        UdacityClient.postStudenLocation(longitude: currentLongitude, latitude: currentLatitude, mapString: currentLocationStr, mediaURL: mediaUrl ) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "backtoLogin", sender: nil)
                    // self.dismiss(animated: true, completion: nil)
                }
            }else{
                self.showLoginFailure(message: "Error when posting location" )
            }
        }
        
        
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        present(alertVC, animated: true)
        
        
    }
}
