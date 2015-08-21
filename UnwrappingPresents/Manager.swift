//
//  UnwrappableManager
//  UnwrappingPresents
//
//  Created by Valentin Kalchev on 04/08/2015.
//  Copyright © 2015 TriggertrapLtd. All rights reserved.
//

import UIKit

protocol ManagerLifecycle {
    func didFinishUnwrapping()
}

final class Manager {
    static let sharedInstance = Manager()
    
    var unwrappableDelegate: ManagerLifecycle?
    
    private let serialQueue = dispatch_queue_create("Unwrappable Serial Queue", DISPATCH_QUEUE_SERIAL)
    private var _canUnwrap: Bool
    
    internal var canUnwrap: Bool {
        return _canUnwrap
    }
    
    internal let semaphore = dispatch_semaphore_create(0)
    
    private init() {
        _canUnwrap = true
    }
    
    func startUnwrapping(var unwrappable: Unwrappable) {
        _canUnwrap = true
        
        dispatch_async(serialQueue) { () -> Void in
            unwrappable.unwrap({ (success) -> Void in
                if success {
                    print("Unwrapped all successfully")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.unwrappableDelegate?.didFinishUnwrapping()
                    })
                } else {
                    print("Failed to unwrap all")
                }
            })
        }
    }
    
    func pauseUnwrapping() {
        _canUnwrap = false
    }
    
    func resumeUnwrapping() {
        // Resume the thread from where it was paused
        _canUnwrap = true
        dispatch_semaphore_signal(semaphore)
    }
    
    func suspendUnwrapping() {
        _canUnwrap = false
        // Release the semaphore if it is currently blocking a thread, canUnwrapPresent is false therefore it can't accidently continue unwrapping the sequence
        dispatch_semaphore_signal(semaphore)
    }
}
