//
//  File.swift
//  
//
//  Created by Richard Torcato on 2023-01-09.
//

import Foundation

public struct LocalNotification {
    internal init(identifier: String,
                  title: String,
                  body: String,
                  timeInterval: Double,
                  repeats: Bool) {
        self.identifier = identifier
        self.scheduleType = .time
        self.title = title
        self.body = body
        self.timeInterval = timeInterval
        self.dateComponents = nil
        self.repeats = repeats
    }
    
    internal init(identifier: String,
                  title: String,
                  body: String,
                  dateComponents: DateComponents,
                  repeats: Bool) {
        self.identifier = identifier
        self.scheduleType = .calendar
        self.title = title
        self.body = body
        self.timeInterval = nil
        self.dateComponents = dateComponents
        self.repeats = repeats
    }
    
    public enum ScheduleType {
        case time, calendar
    }
    
    public var identifier: String
    public var scheduleType: ScheduleType
    public var title: String
    public var body: String
    public var subtitle: String?
    public var bundleImageName: String?
    public var userInfo: [AnyHashable: Any]?
    public var timeInterval: Double?
    public var dateComponents: DateComponents?
    public var repeats: Bool
    public var categoryIdentifier: String?
}
