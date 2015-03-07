//
//  ViewController.swift
//  AnvilTimes
//
//  Created by Tarang Khanna on 3/7/15.
//  Copyright (c) 2015 Thacked. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventStore = EKEventStore()
        
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) {
        case .Authorized:
            insertEvent(eventStore)
        case .Denied:
            println("Access denied")
        case .NotDetermined:
         
            eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:
                {[weak self] (granted: Bool, error: NSError!) -> Void in
                    if granted {
                        self!.insertEvent(eventStore)
                    } else {
                        println("Access denied")
                    }
            })
        default:
            println("Case Default")
        }
    }
    
    func insertEvent(store: EKEventStore) {
   
        let calendars = store.calendarsForEntityType(EKEntityTypeEvent)
            as [EKCalendar]
        
        for calendar in calendars {
     
            if calendar.title == "ioscreator" {
            
                let startDate = NSDate() //current time
                
                let endDate = startDate.dateByAddingTimeInterval(2 * 60 * 60)
                
                // Create Event
                var event = EKEvent(eventStore: store)
                event.calendar = calendar
                
                event.title = "New Meeting"
                event.startDate = startDate
                event.endDate = endDate
                
             
                // Save Event in Calendar
                var error: NSError?
                let result = store.saveEvent(event, span: EKSpanThisEvent, error: &error)
                
                if result == false {
                    if let theError = error {
                        println("An error occured \(theError)")
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
