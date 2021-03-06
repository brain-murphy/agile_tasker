//
//  Task.swift
//  agile-tasker
//
//  Created by Abhishek Sen on 9/24/16.
//  Copyright © 2016 Brian Murphy. All rights reserved.
//

import UIKit

class Task {
    
    var name : String!
    var courseName : String?
    var workLeft : Int!
    var dueDate : String!
    var details : String?
    var urgencyValue : Float!
    var isComplete : Bool!
    
    var priority: Float {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        let dueDateDate = dateFormatter.date(from: dueDate)
        
        let now = NSDate.init()
        
        let timeRemaining = dueDateDate!.timeIntervalSince(now as Date)
        
        let timeMargin = timeRemaining - (Double(workLeft) * 3600.0)
        
        if timeMargin <= 0 {
            return 1000.0
        } else {
            return (urgencyValue * 10000) / Float(timeMargin)
        }
    }
    
    
    
    init(name: String, courseName: String?, workLeft: Int, dueDate: String, details: String?, urgencyValue: Float) {
        
        self.name = name
        self.courseName = courseName
        self.workLeft = workLeft
        self.dueDate = dueDate
        self.details = details
        self.urgencyValue = urgencyValue
        self.isComplete = false
        
    }
}
