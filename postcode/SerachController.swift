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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setView(){
        mapView.mapType = .Standard
        
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
    }
    
    @IBAction func searchBtnTapped(sender: AnyObject) {
    
        if let address = textField.text{
            
            
            Alamofire.request(.GET, "http://zip5.5432.tw/zip5json.py",parameters: ["adrs":address]).responseJSON{
                
                response in
                
                switch response.result{
                
                case .Success(let json):
                    
                    var jsonObj = SwiftyJSON.JSON(json)
                    
                    print(jsonObj["zipcode"])
                    
                    print(json)
                case .Failure(let err):
                    print(err.description)
                }
            }
            
        }
    }

}
