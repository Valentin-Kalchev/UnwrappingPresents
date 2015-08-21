//
//  Present.swift
//  UnwrappingPresents
//
//  Created by Valentin Kalchev on 04/08/2015.
//  Copyright © 2015 TriggertrapLtd. All rights reserved.
//
import UIKit

struct Present: Unwrappable  {
    internal var completionHandler: CompletionHandler = { (success) -> Void in }
    
    mutating func unwrap(completionHandler: CompletionHandler) -> Void {
        self.completionHandler = completionHandler
        
        print("Will unwrap present")
        
        let checkQueue = dispatch_queue_create("Check Serial Queue", DISPATCH_QUEUE_SERIAL)
        
        // Check the presents for 1 seconds
        dispatch_async(checkQueue) { () -> Void in
            sleep(1)
            
            if Manager.sharedInstance.canUnwrap {
                dispatch_semaphore_signal(Manager.sharedInstance.semaphore)
            }
        }
        
        dispatch_semaphore_wait(Manager.sharedInstance.semaphore, DISPATCH_TIME_FOREVER)
        print("Did unwrap present")
        
        self.completionHandler(success: true)
    }
}
