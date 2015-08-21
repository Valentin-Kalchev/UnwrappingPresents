//
//  Presents.swift
//  UnwrappingPresents
//
//  Created by Valentin Kalchev on 04/08/2015.
//  Copyright © 2015 TriggertrapLtd. All rights reserved.
//

struct Presents: Unwrappable {
    
    private var unwrappables = [Unwrappable]()
    private var currentUnwrappable = 0
    
    internal var completionHandler: CompletionHandler = { (success) -> Void in }
    
    init(unwrappables: [Unwrappable]) {
        self.unwrappables = unwrappables
    }
    
    mutating func unwrap(completionHandler: CompletionHandler) -> Void {
        self.completionHandler = completionHandler
        self.currentUnwrappable = 0
        
        print("Will unwrap presents")
        unwrapCurrentUnwrappable()
    } 
    
    private mutating func unwrapCurrentUnwrappable() {
        if currentUnwrappable > self.unwrappables.count - 1 {
            print("Did unwrap presents")
            self.completionHandler(success: true)
        } else {
            self.unwrappables[currentUnwrappable].unwrap({ (success) -> Void in
                if success {
                    self.nextUnwrappable()
                } else {
                    self.completionHandler(success: false)
                }
            })
        }
    }
    
    private mutating func nextUnwrappable() {
        self.currentUnwrappable++
        
        if Manager.sharedInstance.canUnwrap {
            self.unwrapCurrentUnwrappable()
        } else {
            self.completionHandler(success: false)
        }
    }
}
