//
//  DateManager.swift
//  W3ather
//
//  Created by Nguyen Quoc Huy on 8/1/20.
//  Copyright © 2020 Nguyen Quoc Huy. All rights reserved.
//
import UIKit
extension Date {
    var hour: Int { return Calendar.current.component(.hour, from: self) } // get current hour from current Day
}
struct DataManager {
    let today = Date()
    let formatter=DateFormatter()   //use for format Date type
    
    func dayOfMonthUI()->[String] {
        var daysOfMonth:[String]=[]
        formatter.dateFormat="dd/MM"//format định dạng Date
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: today)
        for i in 1...3{
            let dayOfMonth=calendar.date(byAdding: .day, value: i, to: midnight)
            let dayOfMonthString=formatter.string(from: dayOfMonth!)
            daysOfMonth.append(dayOfMonthString)
        }
        //        let tomorrow=calendar.date(byAdding: .day, value: 1, to: midnight)!
        //        let dayAfterTomorrow=calendar.date(byAdding: .day, value: 2, to: midnight)
        //        let dayYonder=calendar.date(byAdding: .day, value: 3, to: midnight)
        return daysOfMonth
    }
    
    func dayOfWeek() -> [String] {
        var daysOfWeek:[String]=[]
        var tomorrowDayofWeek:String=""
        var dayAfterTomorrowDayOfWeek:String=""
        var dayYonderDayOfWeek:String=""
        formatter.dateFormat = "EEE" //formatDate
        //["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"] to ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let day = formatter.string(from: today)
        //current name day of week (Sun,Mon,...Sat)
        
        let calendar = Calendar(identifier: .gregorian)
        let days = calendar.weekdaySymbols
        //["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        
        for index in 0...6{
            if index <= 3 && days[index]==day
            {
                tomorrowDayofWeek=days[index+1]
                dayAfterTomorrowDayOfWeek=days[index+2]
                dayYonderDayOfWeek=days[index+3]
            }
            else if index == 4 && days[index]==day
            {
                tomorrowDayofWeek=days[5]
                dayAfterTomorrowDayOfWeek=days[6]
                dayYonderDayOfWeek=days[0]
            }
            else if index == 5 && days[index]==day{
                tomorrowDayofWeek=days[6]
                dayAfterTomorrowDayOfWeek=days[0]
                dayYonderDayOfWeek=days[1]
            }
            else if index == 6 && days[index]==day{
                tomorrowDayofWeek=days[0]
                dayAfterTomorrowDayOfWeek=days[1]
                dayYonderDayOfWeek=days[2]
                
            }
            daysOfWeek=[tomorrowDayofWeek,dayAfterTomorrowDayOfWeek,dayYonderDayOfWeek]
        }
        print(daysOfWeek)
        return daysOfWeek
    }
}
