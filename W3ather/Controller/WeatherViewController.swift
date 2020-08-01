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
import CoreLocation

class WeatherViewController: UIViewController, UISearchBarDelegate{
    var dateManager=DataManager()
    var weatherManager=WeatherManager()
    let today = Date()
    let formatter=DateFormatter()   //use for format Date type
    let locationManager=CLLocationManager() //need to get user current location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate=self
        weatherManager.delegate=self
        
        locationManager.requestLocation()
        // trigger func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        
        //Change Background
        changeBackground()
    }
    
    @IBAction func currentWeatherPressed(_ sender: UIBarButtonItem) {
        locationManager.requestLocation()
    }
    
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var todayCondition: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var descript: UILabel!
    @IBOutlet weak var tomorrowDayOfWeek: UILabel!
    @IBOutlet weak var dayAfterTomorrowDayOfWeek: UILabel!
    @IBOutlet weak var dayYonderDayOfWeek: UILabel!
    @IBOutlet weak var tomorrowCondition: UIImageView!
    @IBOutlet weak var dayAfterTomorrowCondition: UIImageView!
    @IBOutlet weak var dayYonderCondition: UIImageView!
    @IBOutlet weak var tomorrowDayOfMonth: UILabel!
    @IBOutlet weak var dayAfterTomorrowDayOfMonth: UILabel!
    @IBOutlet weak var dayYonderDayOfMonth: UILabel!
    
    @IBAction func searchBtnPressed(_ sender: UIBarButtonItem) {
        //tạo viewController search bằng code
        let searchController=UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate=self
        present(searchController, animated: true, completion: nil)
    }
    
    //kích search ở keyboard thì sẽ trigger func
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Không cho user tương tác với màn hình sau khi nhấn search
        self.view.isUserInteractionEnabled = true
        searchRequest(searchBar: searchBar)
    }
    
    func searchRequest(searchBar: UISearchBar){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text//lấy text từ searchBar cho vào searchRequest
        let activeSearch=MKLocalSearch(request: searchRequest)
        activeSearch.start { (reponse, error) in
            if reponse == nil{ // Nếu reponse không được trả về
                print(self.cityLabel.text="Unknow Location")
            }
            else{   //nếu có reponse thì sẽ lấy lat and lon và chuyền vào fetchWeather
                if let lat = reponse?.boundingRegion.center.latitude, let lon = reponse?.boundingRegion.center.longitude{
                    let latt=Double(lat)
                    let long=Double(lon)
                    self.weatherManager.fetchWeather(lat: latt, lon: long)
                }
            }
        }
        dismiss(animated: true, completion: nil)//Tắt searchView khi xong
    }
    
    //MARK: - Change User Interface
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
    
    func updateUI(weatherArray:[WeatherModel]){
        let daysOfMonth=dateManager.dayOfMonthUI()
        let daysOfWeek=dateManager.dayOfWeek()
        
        cityLabel.text=weatherArray[0].cityName
        minTemp.text=weatherArray[0].minTemp
        maxTemp.text=weatherArray[0].maxTemp
        temp.text=weatherArray[0].temp
        descript.text=weatherArray[0].description
        todayCondition.image=UIImage(systemName: weatherArray[0].conditionName)
        tomorrowCondition.image=UIImage(systemName: weatherArray[1].conditionName)
        dayAfterTomorrowCondition.image=UIImage(systemName: weatherArray[2].conditionName)
        dayYonderCondition.image=UIImage(systemName: weatherArray[3].conditionName)
        
        tomorrowDayOfMonth.text=daysOfMonth[0]
        dayAfterTomorrowDayOfMonth.text=daysOfMonth[1]
        dayYonderDayOfMonth.text=daysOfMonth[2]
        
        tomorrowDayOfWeek.text=daysOfWeek[0]
        dayAfterTomorrowDayOfWeek.text=daysOfWeek[1]
        dayYonderDayOfWeek.text=daysOfWeek[2]
        
    }
}

//MARK: - WeatherManager Delegate
extension WeatherViewController:WeatherManagerDelegate{
    func didUpdateWeather(weatherArray: [WeatherModel]) {
        updateUI(weatherArray: weatherArray)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController:CLLocationManagerDelegate{
    //locationManager.requestLocation() will trigger func below
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location=locations.last{
            let lat=Double(location.coordinate.latitude)
            let long=Double(location.coordinate.longitude)
            weatherManager.fetchWeather(lat: lat, lon: long)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { //handle error nếu có
        print(error)
    }
}

