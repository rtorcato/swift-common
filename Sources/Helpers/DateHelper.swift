//
//  DateHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-25.
//

import Foundation
import SwiftUI

class DateHelper {
    
    static let instance = DateHelper()
    private init() { }
    
    static let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "en_US")
      return formatter
    }()
    
    // MARK: Checking if current Date is Today
    static func isToday(date: Date) -> Bool {
        let currentDay: Date = Date()
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    // MARK: Checking currentHour
    static func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        return hour == currentHour
    }
    
    // MARK: Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    // MARK: Get current time interval
    static func getCurrentTimeInterval() -> TimeInterval {
        let startTime = NSDate()
        let interval = startTime.timeIntervalSince1970
        return interval
    }
    
    static func getEndDate(calComponent: Calendar.Component = .second, value: Int) -> Date? {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: calComponent, value: value, to: Date())
        return endDate
    }
    
    // MARK: Extracting Date
    // func fetchCurrentWeek() -> [Date]{
    //    var currentWeek: [Date] = []
    //    let today = Date()
    //    let calendar = Calendar.current
    //
    //    let week = calendar.dateInterval(of: .weekOfMonth, for: today)
    //
    //    guard let firstWeekDay = week?.start else {
    //        return []
    //    }
    //
    //    (0..<7).forEach { day in
    //
    //        if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay){
    //            currentWeek.append(weekday)
    //        }
    //    }
    //    return currentWeek
    // }
    
    // Wed, 04 Nov 2015 21:00:14 +0000
    static func dateWithPodcastDateString(_ dateString: String) -> Date? {
      dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
      return dateFormatter.date(from: dateString)
    }

    static func displayString(for date: Date) -> String {
      dateFormatter.dateFormat = "HH:mm MMMM dd, yyyy"
      return dateFormatter.string(from: date)
    }
}

// MARK: Current Week Days
// @Published var currentWeek: [Date] = []
//
// MARK: Current Day
// @Published var currentDay: Date = Date()
//
// MARK: Filtering Today Tasks
// @Published var filteredTasks: [Task]?

// MARK: Filter Today Tasks
// func filterTodayTasks(){
//
//    DispatchQueue.global(qos: .userInteractive).async {
//
//        let calendar = Calendar.current
//
//        let filtered = self.storedTasks.filter{
//            return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
//        }
//            .sorted { task1, task2 in
//                return task2.taskDate < task1.taskDate
//            }
//
//        DispatchQueue.main.async {
//            withAnimation{
//                self.filteredTasks = filtered
//            }
//        }
//    }
// }
