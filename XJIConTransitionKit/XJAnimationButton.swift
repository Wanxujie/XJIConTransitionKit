//
//  XJAnimationButton.swift
//  XJIConTransitionKit
//
//  Created by 万旭杰 on 16/6/24.
//  Copyright © 2016年 万旭杰. All rights reserved.
//

import UIKit
import CoreGraphics

enum XJAnimationButtonState {
    case XJAnimationButtonStateMenu
    case XJAnimationButtonStateArrow
    case XJAnimationButtonStateCross
    case XJAnimationButtonStatePlus
    case XJAnimationButtonStateMinus
}

enum XJAnimationButtonLineCap {
    case XJAnimationButtonLineCapButt
    case XJAnimationButtonLineCapRound
    case XJAnimationButtonLineCapSquare
}

class XJAnimationButton: UIButton {
    var lineHeight: CGFloat = 2.0
    var lineWidth: CGFloat = 8.0
    var lineSpacing: CGFloat = 30.0
    var lineColor: UIColor = UIColor.customYellowColor()
    var lineCap: XJAnimationButtonLineCap = .XJAnimationButtonLineCapRound
    var needsToupdateAppearance: Bool = false
    var currentState: XJAnimationButtonState? {
        didSet {
            if let state = currentState {
                transformToState(state)
            }
        }
    }
    
    
    private let xjScaleForArrow: CGFloat = 0.7
    private let xjAnimationKey = "xjAnimationKey"
    private let xjFrameRate: CGFloat = 1.0 / 30.0
    private let xjAnimationFrames: CGFloat = 10.0
    
    lazy var topLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    lazy var middleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    lazy var bottomLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override var frame: CGRect {
        didSet {
            super.frame = frame
            updateAppearance()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        lineColor = UIColor.whiteColor()
        lineHeight = 2.0
        lineSpacing = 8.0
        lineWidth = 30.0
        lineCap = .XJAnimationButtonLineCapRound
        currentState = .XJAnimationButtonStatePlus
        updateAppearance()
    }
    
    func updateAppearance() {
        needsToupdateAppearance = false
        topLayer.removeFromSuperlayer()
        middleLayer.removeFromSuperlayer()
        bottomLayer.removeFromSuperlayer()
        
        let x: CGFloat = CGRectGetWidth(self.bounds) / 2.0
        let heightDiff = lineHeight + lineSpacing
        var y: CGFloat = CGRectGetHeight(self.bounds) / 3.0
        
        topLayer = self.createLayer()
        topLayer.position = CGPointMake(x, y)
        y += heightDiff;
        
        middleLayer = self.createLayer()
        middleLayer.position = CGPointMake(x, y)
        y += heightDiff
        
        bottomLayer = self.createLayer()
        bottomLayer.position = CGPointMake(x, y)
        
        if let state = currentState {
            self.transformToState(state)
        }
    }
    
    func createLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: lineWidth, y: 0))
        layer.path = path.CGPath
        layer.lineWidth = lineHeight
        layer.backgroundColor = lineColor.CGColor
        layer.lineCap = lineCapString(lineCap)
        
        let bound = CGPathCreateCopyByStrokingPath(layer.path,
                                                   nil,
                                                   layer.lineWidth,
                                                   .Butt,
                                                   .Miter,
                                                   layer.miterLimit)
        layer.bounds = CGPathGetBoundingBox(bound)
        self.layer.addSublayer(layer)
        return layer
    }
    
    func lineCapString(lineCap: XJAnimationButtonLineCap) -> String {
        switch lineCap {
        case .XJAnimationButtonLineCapRound:
            return "round"
        case .XJAnimationButtonLineCapSquare:
            return "square"
        default:
            return "butt"
        }
    }
    
    func animationTransformToState(state: XJAnimationButtonState) {
        if currentState == state {
            return
        }
        var findAnimationForTransition = false
        if let currentState = currentState {
            switch currentState {
            case .XJAnimationButtonStateArrow:
                if state == .XJAnimationButtonStateMenu {
                    findAnimationForTransition = true
                    self.animationTransitionFromMenuToArrow(true)
                }
            case .XJAnimationButtonStateCross:
                if state == .XJAnimationButtonStateMenu {
                    findAnimationForTransition = true
                    self.animationTransitionFromMenuToCross(true)
                } else if state == .XJAnimationButtonStatePlus {
                    findAnimationForTransition = true
                    animationTransitionFromCrossToPlus(false)
                }
                
            case .XJAnimationButtonStateMinus:
                if state == .XJAnimationButtonStatePlus {
                    findAnimationForTransition = true
                    self.animationTransitionFromPLusToMinus(true)
                }
            case .XJAnimationButtonStatePlus:
                if state == .XJAnimationButtonStateCross {
                    findAnimationForTransition = true
                    self.animationTransitionFromCrossToPlus(true)
                } else if state == .XJAnimationButtonStateMinus {
                    findAnimationForTransition = true
                    self.animationTransitionFromPLusToMinus(false)
                }
            default:
                if state == .XJAnimationButtonStateArrow {
                    findAnimationForTransition = true
                    self.animationTransitionFromMenuToArrow(false)
                } else if state == .XJAnimationButtonStateCross {
                    findAnimationForTransition = true
                    self.animationTransitionFromMenuToCross(false)
                }
            }
        }
        
        if findAnimationForTransition == false {
            print("Can't find animation transition for this states!")
            self.transformToState(state)
        } else {
            currentState = state
        }
    }
    
    func transformToState(state: XJAnimationButtonState) {
        var transform: CATransform3D
        switch state {
        case .XJAnimationButtonStateArrow:
            topLayer.transform = self.arrowLineTransfrom(topLayer)
            middleLayer.transform = self.arrowLineTransfrom(middleLayer)
            bottomLayer.transform = self.arrowLineTransfrom(bottomLayer)
        case .XJAnimationButtonStateCross:
            transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - topLayer.position.y, 0.0)
            topLayer.transform = CATransform3DRotate(transform, CGFloat(M_PI_4), 0.0, 0.0, 1)
            middleLayer.transform = CATransform3DMakeScale(0, 0, 0)
            transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - bottomLayer.position.y, 0.0)
            bottomLayer.transform = CATransform3DRotate(transform, CGFloat(M_PI_4), 0.0, 0.0, -1)
        case .XJAnimationButtonStateMinus:
            topLayer.transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - topLayer.position.y, 0.0)
            middleLayer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            bottomLayer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
        case .XJAnimationButtonStatePlus:
            transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - topLayer.position.y, 0.0)
            topLayer.transform = transform
            middleLayer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            transform = CATransform3DMakeTranslation(0.0, middleLayer.position.y - bottomLayer.position.y, 0.0)
            bottomLayer.transform = CATransform3DRotate(transform, -CGFloat(M_PI_2), 0.0, 0.0, 1.0)
        default:
            topLayer.transform = CATransform3DIdentity
            middleLayer.transform = CATransform3DIdentity
            bottomLayer.transform = CATransform3DIdentity
        }
    }
    
    func arrowLineTransfrom(line: CALayer) -> CATransform3D {
        var transfom: CATransform3D
        if line == middleLayer {
            let middleLineXScale = lineHeight / lineWidth
            transfom = CATransform3DMakeScale(1.0 - middleLineXScale, 1.0, 1.0)
            transfom = CATransform3DTranslate(transfom, lineWidth * middleLineXScale / 2.0, 0.0, 0.0)
            return transfom
        }
        let lineMult: CGFloat = line == topLayer ? 1.0 : -1.0   // top or bottom
        var yShift: CGFloat = 0.0
        if lineCap == .XJAnimationButtonLineCapButt {
            yShift = CGFloat(sqrt(2) * Double(lineHeight / 4.0))
        }
        let lineShift = lineWidth * (1 - xjScaleForArrow) / 2
        transfom = CATransform3DMakeTranslation(-lineShift, middleLayer.position.y - line.position.y + yShift * lineMult, 0.0)
        let xTransform = lineWidth / 2 - lineShift
        transfom = CATransform3DTranslate(transfom, -xTransform, 0, 0.0)
        transfom = CATransform3DRotate(transfom, CGFloat(M_PI_4) * lineMult, 0.0, 0.0, -1.0)
        transfom = CATransform3DTranslate(transfom, xTransform, 0, 0.0)
        transfom = CATransform3DScale(transfom, xjScaleForArrow, 1, 1)
        return transfom
    }
    
    //MARK: animationTransition
    func animationTransitionFromMenuToArrow(reverse: Bool) {
        var times = [0.0, 0.5, 0.5, 1.0]
        var values = self.fromMenuToArrowAnimationValues(topLayer, reverse: reverse)
        let topAnimation = self.createKeyFrameAnimation()
        topAnimation.keyTimes = times
        topAnimation.values = values as [AnyObject]
        
        values = self.fromMenuToArrowAnimationValues(bottomLayer, reverse: reverse)
        let bottomAnimation = self.createKeyFrameAnimation()
        bottomAnimation.keyTimes = times
        bottomAnimation.values = values as [AnyObject]
        
        let middleTransfrom: CATransform3D = self.arrowLineTransfrom(middleLayer)
        values = [NSValue(CATransform3D: CATransform3DIdentity),
                  NSValue(CATransform3D: CATransform3DIdentity),
                  NSValue(CATransform3D: middleTransfrom),
                  NSValue(CATransform3D: middleTransfrom)]
        if reverse {
            values = NSMutableArray(array: values.reverseObjectEnumerator().allObjects)
        }
        times = [0.0, 0.4, 0.4, 1.0]
        let middleAnimation = self.createKeyFrameAnimation()
        middleAnimation.keyTimes = times
        middleAnimation.values = values as [AnyObject]
        
        middleLayer.addAnimation(middleAnimation, forKey: xjAnimationKey)
        topLayer.addAnimation(topAnimation, forKey: xjAnimationKey)
        bottomLayer.addAnimation(bottomAnimation, forKey: xjAnimationKey)
    }
    
    func animationTransitionFromMenuToCross(reverse: Bool) {
        var times = [0.0, 0.5, 1.0]
        var values = self.fromMenuToCrossAnimationValues(topLayer, reverse: reverse)
        let topAnimation = self.createKeyFrameAnimation()
        topAnimation.keyTimes = times
        topAnimation.values = values as [AnyObject]
        
        values = self.fromMenuToCrossAnimationValues(bottomLayer, reverse: reverse)
        let bottomAnimation = self.createKeyFrameAnimation()
        bottomAnimation.keyTimes = times
        bottomAnimation.values = values as [AnyObject]
        
        let middleTransform = CATransform3DMakeScale(0.0, 0.0, 0.0)
        values = [NSValue(CATransform3D: CATransform3DIdentity),
                  NSValue(CATransform3D: CATransform3DIdentity),
                  NSValue(CATransform3D: middleTransform),
                  NSValue(CATransform3D: middleTransform)]
        if reverse {
            values = NSMutableArray(array: values.reverseObjectEnumerator().allObjects)
        }
        
        times = [0.0, 0.5, 0.5 ,1.0]
        let middleAnimation = self.createKeyFrameAnimation()
        middleAnimation.keyTimes = times
        middleAnimation.values = values as [AnyObject]
        
        middleLayer.addAnimation(middleAnimation, forKey: xjAnimationKey)
        topLayer.addAnimation(topAnimation, forKey: xjAnimationKey)
        bottomLayer.addAnimation(bottomAnimation, forKey: xjAnimationKey)
    }
    
    func animationTransitionFromCrossToPlus(reverse: Bool) {
        var times = [0.0, 1.0]
        var rotate = CGFloat(M_PI)
        if reverse {
            times = [1.0, 0.0]
            rotate = -CGFloat(M_PI)
        }
        let topTransform = topLayer.transform
        let topValues = [NSValue(CATransform3D: topTransform), NSValue(CATransform3D: CATransform3DRotate(topTransform, rotate, 0.0, 0.0, 1.0))]
        let topAnimation = self.createKeyFrameAnimation()
        topAnimation.keyTimes = times
        topAnimation.values = topValues
        
        let bottomTransform = bottomLayer.transform
        let bottomValues = [NSValue(CATransform3D: bottomTransform), NSValue(CATransform3D: CATransform3DRotate(bottomTransform, rotate, 0.0, 0.0, 1.0))]
        let bottomAnimation = self.createKeyFrameAnimation()
        bottomAnimation.keyTimes = times
        bottomAnimation.values = bottomValues

        topLayer.addAnimation(topAnimation, forKey: xjAnimationKey)
        bottomLayer.addAnimation(bottomAnimation, forKey: xjAnimationKey)
    }
    
    
    
    func animationTransitionFromPLusToMinus(reverse: Bool) {
        var times = [0.0, 1.0]
        if reverse {
            times = [1.0, 0.0]
        }
        let transform = topLayer.transform
        let values = [NSValue(CATransform3D: transform), NSValue(CATransform3D: CATransform3DRotate(transform, CGFloat(-M_PI), 0.0, 0.0, 1.0))]
        let topAnimation = self.createKeyFrameAnimation()
        topAnimation.keyTimes = times
        topAnimation.values = values
        
        topLayer.addAnimation(topAnimation, forKey: xjAnimationKey)
    }
    
    //MARK: from to 
    func fromMenuToArrowAnimationValues(line: CALayer, reverse: Bool) -> NSArray {
        var values = NSMutableArray()
        let lineMult: CGFloat = line == topLayer ? 1.0 : -1.0
        let yTransform = middleLayer.position.y - line.position.y
        var yShift: CGFloat = 0.0
        if lineCap == .XJAnimationButtonLineCapButt {
            yShift = CGFloat(sqrt(2) * Double(lineHeight / 4.0))
        }
        
        // init
        var transform = CATransform3DIdentity
        values.addObject(NSValue(CATransform3D: transform))
        
        /// YTransform
        transform = CATransform3DTranslate(transform, 0.0, yTransform, 0.0)
        values.addObject(NSValue(CATransform3D: transform))
        
        /// Scale
        let lineShift: CGFloat = lineWidth * (1 - xjScaleForArrow) / 2.0
        var scaleTransform = CATransform3DScale(transform, xjScaleForArrow, 1.0, 1.0)
        scaleTransform = CATransform3DTranslate(scaleTransform, -lineShift, 0.0, 0.0)
        values.addObject(NSValue(CATransform3D: scaleTransform))
        
        /// transform rotate xtranslate scale
        transform = CATransform3DTranslate(transform, -lineShift, 0.0, 0.0);
        let xTransform: CGFloat = lineWidth / 2.0 - lineShift;
        transform = CATransform3DTranslate(transform, -xTransform, 0.0, 0.0)
        transform = CATransform3DRotate(transform, CGFloat(M_PI_4) * lineMult, 0.0, 0.0, -1.0)
        transform = CATransform3DTranslate(transform, xTransform, 0, 0.0)
        transform = CATransform3DScale(transform, xjScaleForArrow, 1.0, 1.0);
        transform = CATransform3DTranslate(transform, 0.0, yShift * lineMult, 0.0);
        values.addObject((NSValue(CATransform3D: transform)))
        
        if reverse {
            values = NSMutableArray(array: values.reverseObjectEnumerator().allObjects)
        }
        return values
    }

    func fromMenuToCrossAnimationValues(line: CALayer, reverse: Bool) -> NSArray {
        var values = NSMutableArray()
        let lineMult: CGFloat = line == topLayer ? 1.0 : -1.0
        let yTransform = middleLayer.position.y - line.position.y
        
        var transform: CATransform3D = CATransform3DIdentity
        values.addObject(NSValue(CATransform3D: transform))
    
        transform = CATransform3DTranslate(transform, 0, yTransform, 0.0)
        values.addObject(NSValue(CATransform3D: transform))
        
        transform = CATransform3DRotate(transform, CGFloat(M_PI_4) * lineMult, 0, 0, 1.0)
        values.addObject(NSValue(CATransform3D: transform))
        
        if reverse {
            values = NSMutableArray(array: values.reverseObjectEnumerator().allObjects)
        }
        return values
    }
    
    /**
     帧动画 Key Animation
     - returns: CAKeyframeAnimation
     */
    func createKeyFrameAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = NSTimeInterval(xjFrameRate * xjAnimationFrames)
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.60, 0.00, 0.40, 1.00)
        return animation
    }
}
