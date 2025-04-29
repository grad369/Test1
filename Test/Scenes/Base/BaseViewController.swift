//
//  BaseViewController.swift
//  Test
//
//  Created by vaskov on 29.04.2025.
//
import UIKit


class BaseViewController: UIViewController {
    // MARK: Object lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // MARK: Setup
    func setup() {
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .all
    }
    
    override var shouldAutorotate: Bool {
        true
    }    
    
}
