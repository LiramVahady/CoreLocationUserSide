//
//  ViewController.swift
//  UserLocationDemoB
//
//  Created by me on 04/11/2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: properties
    private let databaseService = DatabaseService.shared
    private let coreLocationManager = CLLocationManager()
    private let regionMeters: Double = 2000
    private var currentLat:Double = 0
    private var currentLongt: Double = 0
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkLocationServices()
    }
    
    
    //MARK: Functions
    private func configureLocationService(){
        coreLocationManager.delegate = self
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationServices(){
        
        if CLLocationManager.locationServicesEnabled(){
            //setup location manager
            configureLocationService()
            checkUserLocationPermission()
        }else{
            //(title: "Location service disable", message: "Please enable location service")
        }
    }
    
    private func centerViewOnUserLocation(){
        
        databaseService.fetchCurrentCoordinates { [weak self] dict in
            
            if let long = dict["long"] as? Double,
               let lat = dict["lat"] as? Double{
                self?.currentLongt = long
                self?.currentLat = lat
                let customLocation =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self?.currentLat ?? 0, longitude: self?.currentLongt ?? 0), latitudinalMeters: self?.regionMeters ?? 0, longitudinalMeters: self?.regionMeters ?? 0)
                    self?.mapView.setRegion(customLocation, animated: true)
             
            }
        }
    }
    
    func checkUserLocationPermission(){
        
        let authorizationStatus:CLAuthorizationStatus = coreLocationManager.authorizationStatus
        switch authorizationStatus{
        case .authorizedWhenInUse:
            //Do map stuff
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            coreLocationManager.startUpdatingLocation()
        case .denied:
            appearDialogToUser(title: "Permission denied", message: "Plese go to setting and allow location service")
        case .notDetermined:
            coreLocationManager.requestWhenInUseAuthorization()
        case .restricted:
            //alert to user
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("some")
        }
    }

}

extension ViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            let currentPin = mapView.view(for: annotation) ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            currentPin.image = UIImage(systemName: "car.fill")
            
            return currentPin
        }
       
        return nil
    }
}

extension ViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
       
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkUserLocationPermission()
    }
}
