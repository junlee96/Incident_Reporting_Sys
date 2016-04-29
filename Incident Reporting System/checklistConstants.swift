//
//  checklistConstants.swift
//  Incident Reporting System
//
//  Created by Admin on 29/4/16.
//  Copyright © 2016 Dreamsmart. All rights reserved.
//

import UIKit

class checklistConstants {

    class func dateFormatter() -> NSDateFormatter {
        let aDateFormatter = NSDateFormatter()
        aDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        aDateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        aDateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return aDateFormatter
    }
    
}
