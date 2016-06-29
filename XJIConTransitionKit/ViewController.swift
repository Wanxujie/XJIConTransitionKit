//
//  ViewController.swift
//  XJIConTransitionKit
//
//  Created by 万旭杰 on 16/6/24.
//  Copyright © 2016年 万旭杰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    lazy var button1: XJAnimationButton = {
        let button1 = XJAnimationButton()
        button1.currentState = .XJAnimationButtonStateMenu
        return button1
    }()
    
    var button2: XJAnimationButton = {
        let button2 = XJAnimationButton()
        button2.currentState = .XJAnimationButtonStateCross
        return button2
    }()
    
    var button3: XJAnimationButton = {
        let button3 = XJAnimationButton()
        button3.currentState = .XJAnimationButtonStatePlus
        return button3
    }()
    
    var button4: XJAnimationButton = {
        let button4 = XJAnimationButton()
        button4.currentState = .XJAnimationButtonStateMenu
        return button4
    }()
    
    func setupView() {
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        view.addSubview(button4)
        button1.frame = CGRectMake(20, 100, 50, 50)
        button2.frame = CGRectMake(90, 100, 50, 50)
        button3.frame = CGRectMake(160, 100, 50, 50)
        button4.frame = CGRectMake(230, 100, 50, 50)
        button1.backgroundColor = UIColor.customRedColor()
        button2.backgroundColor = UIColor.customRedColor()
        button3.backgroundColor = UIColor.customRedColor()
        button4.backgroundColor = UIColor.customRedColor()
        
        button1.addTarget(self, action: #selector(ViewController.onButtonClick(_:)), forControlEvents: .TouchUpInside)
        button2.addTarget(self, action: #selector(ViewController.onButtonClick(_:)), forControlEvents: .TouchUpInside)
        button3.addTarget(self, action: #selector(ViewController.onButtonClick(_:)), forControlEvents: .TouchUpInside)
        button4.addTarget(self, action: #selector(ViewController.onButtonClick(_:)), forControlEvents: .TouchUpInside)
    }
    
    func onButtonClick(sender: XJAnimationButton) {
        if sender == button1 {
            if sender.currentState == .XJAnimationButtonStateMenu {
                sender.animationTransformToState(.XJAnimationButtonStateArrow)
            } else if sender.currentState == .XJAnimationButtonStateArrow {
                sender.animationTransformToState(.XJAnimationButtonStateMenu)
            }
        } else if sender == button2 {
            if sender.currentState == .XJAnimationButtonStateCross {
                sender.animationTransformToState(.XJAnimationButtonStatePlus)
            } else if sender.currentState == .XJAnimationButtonStatePlus {
                sender.animationTransformToState(.XJAnimationButtonStateCross)
            }
        } else if sender == button3 {
            if sender.currentState == .XJAnimationButtonStatePlus {
                sender.animationTransformToState(.XJAnimationButtonStateMinus)
            } else if sender.currentState == .XJAnimationButtonStateMinus {
                sender.animationTransformToState(.XJAnimationButtonStatePlus)
            }
        } else if sender == button4 {
            if sender.currentState == .XJAnimationButtonStateMenu {
                sender.animationTransformToState(.XJAnimationButtonStateCross)
            } else if sender.currentState == .XJAnimationButtonStateCross {
                sender.animationTransformToState(.XJAnimationButtonStateMenu)
            }
        }
    }
}

