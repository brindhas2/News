//
//  DateFormatter.swift
//  RoboSoftNews
//
//  Created by Brindha S on 20/07/23.
//

import Foundation

struct DateFormatterString {
    static let shortDateFormat = "yyyy-MM-dd"
    static let kUTCDateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    static let shortDateFormat2 = "dd MMMM, yyyy"
    
}
/// Date formatter
 class RSDateFormatter: NSObject {
     
    class func dateFromString(_ dateStr: String?, _ format: String?) -> Date {
        let dateFormatter = GregorianDateFormatter()
        // date is related to US.
        if let anAbbreviation = TimeZone(abbreviation: "UTC") {
            dateFormatter.timeZone = anAbbreviation
        }
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format ?? ""
        let date = dateFormatter.date(from: dateStr ?? "")
        return date ?? Date()
    }
     
     class func stringFromDate(_ date: Date?, toStringWithFormat format: String?) -> String? {
        let dateFormatter = GregorianDateFormatter()
        dateFormatter.dateFormat = format ?? ""
        dateFormatter.locale = Locale(identifier: "en_US")
        var formatedDateStr: String? = nil
        if let aDate = date {
            formatedDateStr = dateFormatter.string(from: aDate)
        }
        return formatedDateStr
    }
     
}

class GregorianDateFormatter: DateFormatter {
    override public init() {
        super.init()
        self.calendar = Calendar(identifier: .gregorian)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
