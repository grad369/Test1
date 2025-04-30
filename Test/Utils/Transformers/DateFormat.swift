//
//  DateFormat.swift
//  Test
//
//  Created by vaskov on 30.04.2025.
//
import Foundation


public enum DateFormat: String {
    case full     = "HH:mm:ss dd/MM/yyyy"
    case date     = "dd/MM/yyyy"
    case time     = "HH:mm:ss"
    case calendar = "dd MMMM, yyyy"
    case server   = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
}

extension String {
    public func date(dateFormat: DateFormat = .server, isCurrentTimeZone: Bool = false) -> Date? {
        date(dateFormat: dateFormat.rawValue, isCurrentTimeZone: isCurrentTimeZone)
    }

    public func date(dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ", isCurrentTimeZone: Bool = false) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = isCurrentTimeZone ? TimeZone.current : TimeZone(identifier: "UTC")
        
        return formatter.date(from: self)
    }
}

extension Date {
    func text(dateFormat: DateFormat = .full, isCurrentTimeZone: Bool = true) -> String? {
        text(dateFormat: dateFormat.rawValue, isCurrentTimeZone: isCurrentTimeZone)
    }
    
    func text(dateFormat: String = "yyyy-MM-dd", isCurrentTimeZone: Bool = true) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = isCurrentTimeZone ? TimeZone.current : TimeZone(identifier: "UTC")
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
}
