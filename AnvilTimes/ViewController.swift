//
//  ViewController.swift
//  AnvilTimes
//
//  Created by Tarang Khanna on 3/7/15.
//  Copyright (c) 2015 Thacked. All rights reserved.
//

import UIKit
import EventKit
import Foundation
import Alamofire

class ViewController: UIViewController {
    var url : String = "http://google.com?test=toto&test2=titi"
    var request : NSMutableURLRequest = NSMutableURLRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //println("here")
        request.URL = NSURL(string: "http://httpbin.org/get")
        request.HTTPMethod = "GET"
       // println(Alamofire.request(.GET, "http://httpbin.org/get"))
       // request.URL =  as NSURL
//        
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
//            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
//            println("AsSynchronous\(jsonResult)")
//
//            if (jsonResult != nil) {
//                // process jsonResult
//                println("AsSynchronous\(jsonResult)")
//            } else {
//                // couldn't load JSON, look at error
//            }
//            
//            
//        })
       
        
            Alamofire.request(.GET, "https://api.context.io/2.0/accounts/54fb32f0facadd69263c2abc/contacts/khanna17@purdue.edu/messages", parameters: ["limit":"100" ])
                .response { (request, response, data, error) in
                    println(request)
                    println(response)
                    println(data)
                    println(error)
            }
        
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
            //println(calendar.title)
            if calendar.title == "Home" || calendar.title ==  "Work" {
            
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
                //println(store.predicateForEventsWithStartDate(NSDate(), endDate: endDate, calendars: nil))
            }
        }
    }
    //var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
    //println("AsSynchronous\(jsonResult)")
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
