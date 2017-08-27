//
//  MapVC.swift
//  RobinPrototype
//
//  Created by Martijn van Gogh on 01-07-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    var LM = CLLocationManager()
    var timer = Timer()
    var calculateDistanceTimer = Timer()
    var countDownTimer = Timer()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    var overlayView: UIView!
    let info1 = CustomPointAnnotation()
    var firstRouteDraw = true
    
    var locCount = 1
    var destImageName = "location2.png"
    var navTitle = "Entrepotdok"
    var destLat: CLLocationDegrees = 52.367837
    var destLon: CLLocationDegrees = 4.916808
    var alertText: String = ""
    var mapInfoText = ""
    var info9Region = CLCircularRegion()
    var playIt = PlaySound()
    

    @IBOutlet var map: MKMapView!
    @IBOutlet var distanceLabel: OpmaakLabel!
    
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate : Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LM.stopMonitoring(for: info9Region)
        LM.stopUpdatingLocation()
        timer.invalidate()
        calculateDistanceTimer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.setHidesBackButton(true, animated: false)
        title = navTitle
        
        info9Region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: destLat, longitude: destLon), radius: 10, identifier: "locatie")
        
        createOverlay()
        timer = Timer.scheduledTimer(timeInterval: 12.0, target: self, selector: #selector(MapVC.stopIndicator), userInfo: nil, repeats: false)
        
        info9Region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: destLat, longitude: destLon), radius: 10, identifier: "locatie entrepotdok")
        

        
        LM = CLLocationManager()
        LM.delegate = self
        LM.requestAlwaysAuthorization()
        self.LM.desiredAccuracy = kCLLocationAccuracyBest
        
        self.map.delegate = self // zorgt voor het weergeven van pins als customicons
        
        info1.coordinate = CLLocationCoordinate2DMake(destLat, destLon)
        info1.title = navTitle
        info1.subtitle = navTitle
        info1.imageName = destImageName
        map.addAnnotation(info1)
        
        LM.startMonitoring(for: info9Region)
        
        //call first time to draw route
        drawRoute()
        
        //calls repeatedly after every 100 seconds to update distance.
        calculateDistanceTimer = Timer.scheduledTimer(timeInterval: 100, target: self, selector: #selector(updateDistance), userInfo: nil, repeats: true)
        
        
    }
    //timermethod which updates distancelabel every 100 seconds
    func updateDistance() {
        drawRoute()
    }
    
    
    
    func drawRoute() {
        //calculates and (only the first time) draws the route.
        let directionsRequest = MKDirectionsRequest()
        let entrepotdok = MKPlacemark(coordinate: CLLocationCoordinate2DMake(info1.coordinate.latitude, info1.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.source = MKMapItem.forCurrentLocation() //geeft rechtstreeks de coordinaten voor de huidige locatie
        directionsRequest.destination = MKMapItem(placemark: entrepotdok)
        directionsRequest.transportType = MKDirectionsTransportType.walking
        let directions = MKDirections(request: directionsRequest)
        
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                if self.firstRouteDraw {
                    self.map.add(route.polyline)
                    self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    self.firstRouteDraw = false
                }
                
                let distance = (route.distance/1000)
                print(distance)
                let y = Double(round(10*distance)/10)
                self.distanceLabel.text = "\(y) km"
                
            }
        }
        
    }
    
    
    //stopt de indicator als het laden langer duurt dan x seconden
    func stopIndicator() {
        removeOverlay()
        timer.invalidate()
        
    }
    
    //Creates overlay en actindicator direct bij loaden
    func createOverlay() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.4
        indicator.center = view.center
        indicator.startAnimating()
        overlayView.addSubview(indicator)
        view.addSubview(overlayView)
    }
    //removes overlay en actindicator wanneer klaar met renderen
    func removeOverlay() {
        UIApplication.shared.endIgnoringInteractionEvents()
        timer.invalidate()
        overlayView.alpha = 0.0
        indicator.stopAnimating()
        indicator.removeFromSuperview()
        overlayView.removeFromSuperview()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        switch status {
        case .notDetermined:
            print(".NotDetermined")
            break
            
        case .authorizedAlways:
            print(".Authorized")
            self.LM.startUpdatingLocation()
            break
            
        case .denied:
            print(".Denied")
            break
            
        default:
            print("Unhandled authorization status")
            break
            
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location:CLLocation = locations.last as CLLocation!
        print("didUpdateLocations:  \(location.coordinate.latitude), \(location.coordinate.longitude)")
        map.showsUserLocation = true
        
    }
    //Monitoren van entry in regio
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Did enter region")
        
        let alert1 = UIAlertController(title: "\(navTitle)!", message: alertText, preferredStyle: UIAlertControllerStyle.alert)
        alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            
        }))
        
        self.present(alert1, animated: true, completion:nil)
        
        
        
        
    }
    
    //renderen van de lijn die de route weergeeft
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3
        removeOverlay()
        return renderer
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("delegate called")
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    // Selectorfunc right bar button item
    func naarQuiz() {
        calculateDistanceTimer.invalidate()
        //performSegueWithIdentifier(identifier, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destination = segue.destination as UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController!
        }
        
        /*if destination is UitlegVC {
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            
        }*/
        
    }
}


class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
