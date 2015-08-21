//
//  Unwrappable.swift
//  UnwrappingPresents
//
//  Created by Valentin Kalchev on 03/08/2015.
//  Copyright © 2015 TriggertrapLtd. All rights reserved.
//
 
typealias CompletionHandler = (success: Bool) -> Void

protocol Unwrappable {
    var completionHandler: CompletionHandler { get set }
    mutating func unwrap(completionHandler: CompletionHandler)
}
