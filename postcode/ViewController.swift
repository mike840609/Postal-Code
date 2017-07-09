//
//  ViewController.swift
//  postcode
//
//  Created by 蔡鈞 on 2016/3/21.
//  Copyright © 2016年 蔡鈞. All rights reserved.

//Api : http://zip5.5432.tw/zip5json.py?adrs=

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager!
    var currLocation : CLLocation!
    var postCode = ""
    var localString = ""
    
    @IBOutlet weak var mapView:MKMapView?
    @IBOutlet weak var postCodeLabel:UILabel?
    @IBOutlet weak var localLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.distanceFilter = kCLLocationAccuracyKilometer
        
        locationManager.distanceFilter = 10
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.requestWhenInUseAuthorization();
        
        // start locate ===========================================
        locationManager.startUpdatingLocation()
        
    }

    
    
    //FIXME: CoreLocationManagerDelegate
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location:CLLocation = locations[locations.count-1] as CLLocation
        
        currLocation=location
        
        if (location.horizontalAccuracy > 0) {
            self.locationManager.stopUpdatingLocation()
            
            self.locationManager.stopUpdatingLocation()
        }
        
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(currLocation, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print("error: \(error!.localizedDescription)")
                return
            }
            if placemarks != nil && placemarks!.count > 0{
                let placemark = placemarks![0] as CLPlacemark
                
                print(placemark.country ?? "")
                print(placemark.locality ?? "")
                print(placemark.name ?? "")
                print(placemark.postalCode ?? "")
                
                guard let country = placemark.country else{
                    return
                }
                guard let locality = placemark.locality else{
                    return
                }
                guard let name = placemark.name else{
                    return
                }
                guard let postcode = placemark.postalCode else{
                    return
                }
                
                self.localString = country+locality+name
                self.postCode = postcode
        
                self.showLocalPoint()
                
                self.postCodeLabel!.text = "Zip Code:\(self.postCode)"
                self.localLabel!.text = "Now Location:\(self.localString)"
                
                
                //self.localString =
                //這邊拼湊轉回來的地址
                //name         街道地址
                //country      國家
                //province     省
                //locality     市
                //sublocality  縣.區
                //route        街道、路
                //streetNumber 門牌號碼
                //postalCode   郵遞區號
            }
        })
    }
    
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func showAlert(_ title:String,msg:String){
        
        let alert = UIAlertController(title: title, message:msg , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func showLocalPoint(){
        
        if let annotations = mapView?.annotations{
         mapView?.removeAnnotations(annotations)
        }
        
        let location = CLLocationCoordinate2DMake(currLocation.coordinate.latitude, currLocation.coordinate.longitude)
        
        let span = MKCoordinateSpanMake(0.002, 0.002)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView?.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Your Location"
        annotation.subtitle = "\(self.localLabel!.text!)"
        
        mapView?.addAnnotation(annotation)
        
    }
    
    func reloadLocation(){
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    @IBAction func reloadBtnTapped(_ sender: AnyObject) {
        reloadLocation()
        showAlert("Address:\(localString)", msg: ":Zip Code\(postCode)")
    }
    
    @IBAction func unwindToMapView(_ segue:UIStoryboardSegue){
        dismiss(animated: true, completion: nil)
    }
}

