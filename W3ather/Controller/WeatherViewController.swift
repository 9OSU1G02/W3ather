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
extension Date {
    var hour: Int { return Calendar.current.component(.hour, from: self) } // get hour only from current Day
}
class WeatherViewController: UIViewController, UISearchBarDelegate{
    var timer = Timer()
    var weatherManager=WeatherManager()
    let today = Date()
    let formatter=DateFormatter()
    let locationManager=CLLocationManager()
    
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {//kích search thì sẽ trigger
        //Không cho user tương tác với màn hình sau khi nhấn search
        self.view.isUserInteractionEnabled = true
        searchRequest(searchBar: searchBar)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate=self
        weatherManager.delegate=self
        
        locationManager.requestLocation()
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
    func searchRequest(searchBar: UISearchBar){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text//lấy text từ searchBar cho vào searchRequest
        let activeSearch=MKLocalSearch(request: searchRequest)
        activeSearch.start { (reponse, error) in
            if reponse == nil{
                print("ERROR")
            }
            else{
                if let lat = reponse?.boundingRegion.center.latitude, let lon = reponse?.boundingRegion.center.longitude{
                    let latt=Double(lat)
                    let long=Double(lon)
                    self.weatherManager.fetchWeather(lat: latt, lon: long)
                    
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension WeatherViewController:WeatherManagerDelegate{
    func didUpdateWeather(weather: [WeatherModel]) {
        self.cityLabel.text=weather[0].cityName
        self.minTemp.text=weather[0].minTemp
        self.maxTemp.text=weather[0].maxTemp
        self.temp.text=weather[0].temp
        self.descript.text=weather[0].description
        self.todayCondition.image=UIImage(systemName: weather[0].conditionName)
        
        self.tomorrowCondition.image=UIImage(systemName: weather[1].conditionName)
        self.dayAfterTomorrowCondition.image=UIImage(systemName: weather[2].conditionName)
        self.dayYonderCondition.image=UIImage(systemName: weather[3].conditionName)
        
        
        formatter.dateFormat="dd/MM"//format định dạng Date
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: today)
        let tomorrowDay=calendar.date(byAdding: .day, value: 1, to: midnight)!
        let tomorrowDay2=calendar.date(byAdding: .day, value: 2, to: midnight)
        let tomorrowDay3=calendar.date(byAdding: .day, value: 3, to: midnight)
        
        
        self.tomorrowDayOfMonth.text=formatter.string(from: tomorrowDay)
        self.dayAfterTomorrowDayOfMonth.text=formatter.string(from: tomorrowDay2!)
        self.dayYonderDayOfMonth.text=formatter.string(from: tomorrowDay3!)
        
        
        formatter.dateFormat = "EEE" //formatDate
        //["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"] to ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let day = formatter.string(from: today)
        //current name day of week (Sun,Mon,...Sat)
        
        let calendarDateName = Calendar(identifier: .gregorian)
        let days = calendarDateName.weekdaySymbols
        //["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        
        
        for index in 0...6{
            if index <= 3 && days[index]==day
            {
                tomorrowDayOfWeek.text=days[index+1]
                dayAfterTomorrowDayOfWeek.text=days[index+2]
                dayYonderDayOfWeek.text=days[index+3]
            }
            else if index == 4 && days[index]==day
            {
                tomorrowDayOfWeek.text=days[5]
                dayAfterTomorrowDayOfWeek.text=days[6]
                dayYonderDayOfWeek.text=days[0]
            }
            else if index == 5 && days[index]==day{
                tomorrowDayOfWeek.text=days[6]
                dayAfterTomorrowDayOfWeek.text=days[0]
                dayYonderDayOfWeek.text=days[1]
            }
        }
    }
}
extension WeatherViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location=locations.last{
            let lat=Double(location.coordinate.latitude)
            let long=Double(location.coordinate.longitude)
            weatherManager.fetchWeather(lat: lat, lon: long)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
