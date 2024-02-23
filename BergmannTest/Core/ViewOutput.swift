//
//  ViewOutput.swift
//  PokerHelper
//
//  Created by Никита Лужбин on 29.04.2023.
//

import Foundation

protocol ViewOutput: AnyObject {
    
    func viewIsReady()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
    
    func back()
}


// MARK: - Default Implementation
extension ViewOutput {
    
    func viewIsReady() {  }
    
    func viewWillAppear() {  }
    
    func viewDidAppear() {  }
    
    func viewWillDisappear() {  }
    
    func viewDidDisappear() {  }
    
    func back() { }
}
