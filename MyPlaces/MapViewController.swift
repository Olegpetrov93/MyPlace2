//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Oleg on 10/30/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var place : Place!
    let annotationIdentifier = "annotationIdentifier"
    
    var rating = RatingPresent()
    
    
   
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPLacemark()
    }
    
    private func setupPLacemark() {
        guard let location = place.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if error != nil {
                print("Error")
                return
            }
            
            guard placemarks != nil else { return }
            let placemark = placemarks?.first
            
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            
        }
        }
    }
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        annotationView?.canShowCallout = true
        
        if let imageDate = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageDate)
            annotationView?.rightCalloutAccessoryView = imageView
        }
       
        let stackView = RatingPresent(frame: CGRect(x: 0, y: 0, width: 50, height: 10))
        stackView.starSize = CGSize(width: 10, height: 10)
        stackView.rating = Int(place.rating)
            annotationView?.leftCalloutAccessoryView = stackView
        
        
        return annotationView
    }
    }

