//
//  SerachController.swift
//  postcode
//
//  Created by 蔡鈞 on 2016/6/2.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

class SerachController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var codeLabel: UILabel!
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    func setView(){
        mapView.mapType = .standard
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
    }
    
    @IBAction func searchBtnTapped(_ sender: AnyObject) {
        
        guard let address = textField.text else{ return}
        
        getZipCodeFromApi(location: address, callback: { (success) in
            if success{
                self.setAnnotation(location: address)
            }
        })
        
        
    }
    
    
    
    func getZipCodeFromApi (location: String , callback : @escaping (Bool) -> Void){
        Alamofire.request("http://zip5.5432.tw/zip5json.py", parameters: ["adrs":location]).responseJSON(completionHandler: { (response) in
            
            print(response)
            
            switch response.result{
                
            case .success(let json):
                
                var jsonObj = SwiftyJSON.JSON(json)
                
                self.codeLabel.text = " Zip Code :" + String(describing: jsonObj["zipcode"])
                
                callback(true)
                
            case .failure(let err):
                
                print(err.localizedDescription)
                
                callback(false)
            }
            
        })
    }
    
    
    func setAnnotation(location: String){
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(location) { (placemarks , error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "error ")
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks[0]
            
            let annotation = MKPointAnnotation()
            
            annotation.title = location
            
            if let location = placemark.location{
                
                annotation.coordinate = location.coordinate

                
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
            }
            
            
        }
        
    }
    
}
