//
//  ViewController.swift
//  W3ather
//
//  Created by Nguyen Quoc Huy on 7/29/20.
//  Copyright © 2020 Nguyen Quoc Huy. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
extension Date {
    var hour: Int { return Calendar.current.component(.hour, from: self) } // get hour only from Date
}
class ViewController: UIViewController, UISearchBarDelegate{
    var timer = Timer()
    
    @IBOutlet weak var backgroundView: UIImageView!
    
    
    @IBAction func searchBtnPressed(_ sender: UIBarButtonItem) {
        //tạo viewController search bằng code
        let searchController=UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate=self
        
        present(searchController, animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {//kích search thì sẽ trigger
        //Không cho user tương tác với màn hình sau khi nhấn search
        self.view.isUserInteractionEnabled = true
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text//lấy text từ searchBar cho vào searchRequest
        let activeSearch=MKLocalSearch(request: searchRequest)
        activeSearch.start { (reponse, error) in
            if reponse == nil{
                print("ERROR")
            }
            else{
                if let lat = reponse?.boundingRegion.center.latitude, let lon = reponse?.boundingRegion.center.longitude{
                    self.requestInfo(lat: lat, lon: lon)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Change Background
        changeBackground()
    }
    
    func changeBackground(){
        // check if day or night shift
        let hour=Date().hour
        if hour<18 && hour>6{   //DayTime
            backgroundView.image=UIImage(named: "DayBackground")
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9818513989, green: 0.7714535594, blue: 0.3961427212, alpha: 1)
        }
        else{//Night time
            backgroundView.image=UIImage(named: "NightBackGround")
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3051784337, green: 0.344889164, blue: 0.7166694999, alpha: 1)
        }
    }
    
    func requestInfo(lat:Double, lon:Double) {
        
        AF.request("https://api.weatherbit.io/v2.0/forecast/daily?lat=\(lat)&lon=\(lon)&days=3&key=d702ceb3c7484a7886917d75a3b21533").responseJSON { (response) in
            do {
                let weatherJSON:JSON=JSON(try response.result.get())
                let cityName=weatherJSON["city_name"].stringValue
                let minTemp=weatherJSON["data"][0]["min_temp"]
                let maxTemp=weatherJSON["data"][0]["max_temp"].doubleValue
                let temp=weatherJSON["data"][0]["temp"]
                let description=weatherJSON["data"][0]["weather"]["description"]
                let code=weatherJSON["data"][0]["weather"]["code"].intValue
                
            }
            catch{
                print(error)
            }
            
        }
        
    }
}

