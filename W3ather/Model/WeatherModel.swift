//
//  WeatherData.swift
//  W3ather
//
//  Created by Nguyen Quoc Huy on 7/30/20.
//  Copyright © 2020 Nguyen Quoc Huy. All rights reserved.
//

import Foundation
struct WeatherModel {
    
    var cityName:String
    var minTemp:String
    var maxTemp:String
    var temp:String
    var description:String
    var code:Int
    var conditionName: String {
        switch code {
        case 200...233  :
            return "cloud.bolt.rain.fill"
        case 300...302:
            return "cloud.drizzle.fill"
        case 500...522:
            return "cloud.heavyrain.fill"
        case 600...623:
            return "cloud.snow.fill"
        case 701...751 :
            return "cloud.fog.fill"
        case 800:
            return "sun.max"
        case 801...900:
            return "cloud.sun.fill"
        default:
            return "cloud"
        }
    }
}
