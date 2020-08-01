//
//  WeatherManager.swift
//  W3ather
//
//  Created by Nguyen Quoc Huy on 7/31/20.
//  Copyright © 2020 Nguyen Quoc Huy. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherArray:[WeatherModel])
}
struct WeatherManager {
    var delegate:WeatherManagerDelegate?
    func fetchWeather(lat:Double,lon:Double) {
        let urlString="https://api.weatherbit.io/v2.0/forecast/daily?lat=\(lat)&lon=\(lon)&days=4&key=d702ceb3c7484a7886917d75a3b21533"
        performRequest(with: urlString)
    }
    func performRequest(with URL:String){
        AF.request(URL).responseJSON { (response) in
            do {
                let weatherJSON:JSON=JSON(try response.result.get())  //return JSON data
                let weatherModel=self.parseJSON(weatherJSON: weatherJSON)
                self.delegate?.didUpdateWeather(weatherArray: weatherModel)
            }
            catch{
                print(error)
            }
        }
    }
    
    //Parse JSON data to Swift Data ,then use it to create WeatherModel instance and and return [WeatherModel] ( array có 4 phần tử WeatherModel ở trong, tương đương với 4 ngày)
    func parseJSON(weatherJSON:JSON)->[WeatherModel]{
        var weatherArray:[WeatherModel]=[]  //empty array have WeatherModel datatype
        for i in 0...3{     //lặp qua các đối tượng của JSON (4 đối tượng tương đương với 4 ngày)
            let cityLabel=weatherJSON["city_name"].stringValue
            let minTemp=String(format:"%.0f",weatherJSON["data"][i]["min_temp"].doubleValue)
            let maxTemp=String(format:"%.0f",weatherJSON["data"][i]["max_temp"].doubleValue)
            let temp=String(format: "%.0f", weatherJSON["data"][i]["temp"].doubleValue)
            let descript=weatherJSON["data"][i]["weather"]["description"].stringValue
            let code=weatherJSON["data"][i]["weather"]["code"].intValue
            let weather=WeatherModel(cityName: cityLabel, minTemp: minTemp, maxTemp: maxTemp, temp: temp, description: descript, code: code)
            weatherArray.append(weather)
        }
        return weatherArray
    }
}
