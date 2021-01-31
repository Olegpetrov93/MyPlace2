//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Oleg on 10/30/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {
    
    var place = Place()
    let annotationIdentifier = "annotationIdentifier"
    let locationManadger = CLLocationManager()
    let regionInMetrs = 1000.00
    var inkomeSegueIndentifier = ""
    var directionArray: [MKDirections] = []
    var placeCoordinate : CLLocationCoordinate2D?
    var previousLocation: CLLocation?{
        didSet {
            startTracingUserLocation()
        }
    }
    
    
    var rating = RatingPresent()
    
    @IBOutlet weak var mapPin: UIImageView!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonPress: UIBarButtonItem!
    @IBOutlet weak var getAddress: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAddress.isHidden = true
        locationAddressLabel.text = ""
        checkLocationServices()
        setupMapView()
    }

    @IBAction func centerViewInUserLocation() {
        showUserLocation()
    }
    
    @IBAction func getAddressAction(_ sender: Any) {
       getDirections()
    }
    
    
    private func setupMapView() {
        if inkomeSegueIndentifier == "showMap" {
            mapPin.isHidden = true
            locationAddressLabel.isHidden = true
            buttonPress.isEnabled = false
            getAddress.isHidden = false
            setupPlaceMark()
       }
    }
    
    private func resetMapView(withNew directions: MKDirections) {
        
        mapView.removeOverlay(mapView.overlays as! MKOverlay)
        directionArray.append(directions)
        let _ = directionArray.map( {$0.cancel()} )
        directionArray.removeAll()
    }
    
    private func setupPlaceMark() {
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
            self.placeCoordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    private func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocatinManager()
            chekcLocationAutorization()
        } else {
            locationAlertController()
        }
    }
    
    private func setupLocatinManager() {
        
        locationManadger.delegate = self
        locationManadger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func chekcLocationAutorization() {
        
        switch CLLocationManager.authorizationStatus() {
        
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if inkomeSegueIndentifier == "getAdress" {
                showUserLocation()
            }
            break
            
        case .denied:
            locationAlertController()
            break
            
        case .notDetermined:
            locationManadger.requestWhenInUseAuthorization()
            
        case .restricted:
            locationAlertController()
            break
            
        case .authorizedAlways:
            break
            
        @unknown default:
            print("New case is avalible")
        }
    }
    
    private func showUserLocation() {
        
        if let location = locationManadger.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMetrs,
                                            longitudinalMeters: regionInMetrs)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func startTracingUserLocation() {
        
        guard let previousLocation = previousLocation else { return }
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: previousLocation) > 50 else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showUserLocation()
        }
    }
    
    private func getDirections() {
        
        guard let location = locationManadger.location?.coordinate else { _ = UIAlertController(title: "Error", message: "Current location is not found", preferredStyle: .actionSheet)
        return
        }
        
        locationManadger.startUpdatingLocation()
        previousLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        guard let reguest = createDirectionRequest(from: location) else { _ = UIAlertController(title: "Error", message: "Destanation is not found", preferredStyle: .actionSheet)
            return
        }
        
        let directions = MKDirections(request: reguest)
        resetMapView(withNew: directions)
        
        directions.calculate { (response, error) in
            
            if error != nil {
                print("error")
                return
            }
            
            guard let response = response else { _ = UIAlertController(title: "Error", message: "Directions is not available", preferredStyle: .actionSheet)
                return
                
            }
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distanse = String(format: "%.1f", route.distance/1000)
                let timaInterval = route.expectedTravelTime
                
                print("Растояние до места \(distanse) км.")
                print("Время пути \(timaInterval) секунд.")
            }
        }
    }
    
    private func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        guard  let distinationCoordinate = placeCoordinate  else { return nil }
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: distinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func locationAlertController() {
        let actionSheet = UIAlertController(title: "Отсутствует доступ к геолокации пользователя", message: "Для предоставления геолокации необходимо перейти в настройки", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Настройки", style: .default, handler: {  _ in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)}))
        present(actionSheet, animated: true)
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
            annotationView?.leftCalloutAccessoryView = imageView
        }
        
        let stackView = RatingPresent(frame: CGRect(x: 0, y: 0, width: 50, height: 10))
        stackView.starSize = CGSize(width: 10, height: 10)
        stackView.rating = Int(place.rating)
        annotationView?.rightCalloutAccessoryView = stackView
        
        
        return annotationView
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        if inkomeSegueIndentifier == "showPlace" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showUserLocation()
            }
        }
        geocoder.cancelGeocode()
        
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            
            if error != nil { print("error"); return }
            
            let placemark = placemarks?.first
            
            let cityName = placemark?.locality
            let stritName = placemark?.thoroughfare
            let buildNumber = placemark?.subThoroughfare
            
            DispatchQueue.main.async {
                
                if cityName != nil && stritName != nil && buildNumber != nil {
                    self.locationAddressLabel.text = "\(cityName!), \(stritName!), \(buildNumber!)"
                } else if cityName != nil && stritName != nil  {
                    self.locationAddressLabel.text = "\(cityName!), \(stritName!)"
                } else if cityName != nil {
                    self.locationAddressLabel.text = "\(cityName!)"
                } else {
                    self.locationAddressLabel.text = ""
                }
            }
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
}
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        chekcLocationAutorization()
    }
}
