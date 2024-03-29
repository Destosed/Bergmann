//
//  ViewController.swift
//  PokerHelper
//
//  Created by Никита Лужбин on 29.04.2023.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable, message: "Loading this controller from a nib is unsupported in favor of initializer dependency injection.") // swiftlint:disable:this line_length
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this controller from a nib is unsupported in favor of initializer dependency injection.")
    }
    
}
