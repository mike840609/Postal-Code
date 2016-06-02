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
        
        //精确到1000米,距离过滤器，定义了设备移动后获得位置信息的最小距离
        locationManager.distanceFilter = kCLLocationAccuracyKilometer
        
        //更新距离
        locationManager.distanceFilter = 10
        
        //如果是IOS8及以上版本需调用这个方法
        locationManager.requestAlwaysAuthorization()
        
        //使用应用程序期间允许访问位置数据
        locationManager.requestWhenInUseAuthorization();
        
        //启动定位 從這邊開始執行===========================================
        locationManager.startUpdatingLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //FIXME: CoreLocationManagerDelegate 中获取到位置信息的处理函数
    func  locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location:CLLocation = locations[locations.count-1] as CLLocation
        
        currLocation=location
        
        if (location.horizontalAccuracy > 0) {
            self.locationManager.stopUpdatingLocation()
            print("纬度: \(location.coordinate.latitude) 经度: \(location.coordinate.longitude)")
            self.locationManager.stopUpdatingLocation()
            print("结束定位")
        }
        
        //使用坐标，获取地址
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(currLocation, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print("error: \(error!.localizedDescription)")
                return
            }
            if placemarks != nil && placemarks!.count > 0{
                let placemark = placemarks![0] as CLPlacemark
                
                print(placemark.country)
                print(placemark.locality)
                print(placemark.name)
                print(placemark.postalCode)
                
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
                
                self.postCodeLabel!.text = "郵遞區號:\(self.postCode)"
                self.localLabel!.text = "目前位置:\(self.localString)"
                
                
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
    
    func  locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func showAlert(title:String,msg:String){
        
        let alert = UIAlertController(title: title, message:msg , preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
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
        annotation.title = "您的現在位置"
        annotation.subtitle = "\(self.localLabel!.text!)"
        
        mapView?.addAnnotation(annotation)
        
    }
    
    func reloadLocation(){
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
        
    }
    
    @IBAction func reloadBtnTapped(sender: AnyObject) {
        reloadLocation()
        showAlert("地址:\(localString)", msg: "郵遞區號:\(postCode)")
    }
    
    @IBAction func unwindToMapView(segue:UIStoryboardSegue){
        dismissViewControllerAnimated(true, completion: nil)
    }
}

