//
//  customAnnotationView.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 2.06.2021.
//

import UIKit
import MapKit

class customAnnotationView: MKPinAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
