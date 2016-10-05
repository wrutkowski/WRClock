//
//  WRClock.swift
//  WRClockExample
//
//  Created by Wojciech Rutkowski on 04/10/2016.
//  Copyright © 2016 Wojciech Rutkowski. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

open class WRClock: UIView {
    var clockSize: CGFloat = 400
    var outerCircleWidth: CGFloat = 4
    var innerMarksMargin: CGFloat = 4
    var quadrantMarkLengthRatio: CGFloat = 0.05
    var quadrantMarkWidth: CGFloat = 2
    var fiveMinutesMarkLengthRatio: CGFloat = 0.03
    var fiveMinutesMarkWidth: CGFloat = 2
    var minuteMarkLengthRatio: CGFloat = 0.02
    var minuteMarkWidth: CGFloat = 1
    var hourHandLengthRatio: CGFloat = 0.2
    var hourHandWidth: CGFloat = 4
    var minuteHandLengthRatio: CGFloat = 0.35
    var minuteHandWidth: CGFloat = 2
    var secondHandLengthRatio: CGFloat = 0.42
    var secondHandWidth: CGFloat = 1
    var color: UIColor = UIColor.white
    
    var quadrantMarkLength: CGFloat { return clockSize * quadrantMarkLengthRatio }
    var fiveMinutesMarkLength: CGFloat { return clockSize * fiveMinutesMarkLengthRatio }
    var minuteMarkLength: CGFloat { return clockSize * minuteMarkLengthRatio }
    var hourHandLength: CGFloat { return clockSize * hourHandLengthRatio }
    var minuteHandLength: CGFloat { return clockSize * minuteHandLengthRatio }
    var secondHandLength: CGFloat { return clockSize * secondHandLengthRatio }
    
    var clockFaceImage: UIImage {
        let rect = CGRect(x: outerCircleWidth / 2, y: outerCircleWidth / 2, width: clockSize - outerCircleWidth, height: clockSize - outerCircleWidth)
        
        UIGraphicsBeginImageContext(CGSize(width: clockSize, height: clockSize))
        var context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(outerCircleWidth)
        context.addEllipse(in: rect)
        context.drawPath(using: .stroke)
        
        context.translateBy(x: clockSize / 2, y: clockSize / 2)
        for x in 0..<60 {
            let startPoint = CGPoint(x: 0, y: clockSize / 2 - outerCircleWidth - innerMarksMargin)
            var endPoint = startPoint
            let width: CGFloat
            
            switch x {
            case _ where x % 15 == 0:
                endPoint.y -= quadrantMarkLength
                width = quadrantMarkWidth
            case _ where x % 5 == 0:
                endPoint.y -= fiveMinutesMarkLength
                width = fiveMinutesMarkWidth
            default:
                endPoint.y -= minuteMarkLength
                width = minuteMarkWidth
            }
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.setLineWidth(width)
            context.drawPath(using: .stroke)
            context.rotate(by: CGFloat(6).degreesToRadians)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    fileprivate var timer: Timer?
    
    fileprivate var clockFace = UIImageView()
    fileprivate var hourHand = WRClockHand()
    fileprivate var minuteHand = WRClockHand()
    fileprivate var secondHand = WRClockHand()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        clockSize = min(frame.size.width, frame.size.height)
        addSubview(clockFace)
        addSubview(hourHand)
        addSubview(minuteHand)
        addSubview(secondHand)
    }
    
    open override func draw(_ rect: CGRect) {
        clockSize = min(rect.width, rect.height)
        clockFace.frame = rect
        clockFace.image = clockFaceImage
        hourHand.frame = CGRect(x: (clockSize - hourHandWidth) / 2, y: clockSize / 2, width: hourHandWidth, height: hourHandLength)
        hourHand.backgroundColor = color
        minuteHand.frame = CGRect(x: (clockSize - minuteHandWidth) / 2, y: clockSize / 2, width: minuteHandWidth, height: minuteHandLength)
        minuteHand.backgroundColor = color
        secondHand.frame = CGRect(x: (clockSize - secondHandWidth) / 2, y: clockSize / 2, width: secondHandWidth, height: secondHandLength)
        secondHand.backgroundColor = color
        
        if timer == nil {
            tick()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        }
    }
    
    @objc fileprivate func tick() {
        let date = Date()
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let second = components.second!
        let h: Float = Float(hour % 12) + Float(minute) / 60 + Float(second) / 3600
        let m: Float = Float(minute) + Float(second) / 60
        hourHand.update(to: CGFloat(h * 30))
        minuteHand.update(to: CGFloat(m * 6))
        secondHand.update(to: CGFloat(second * 6))
    }
}

open class WRClockHand: UIView {
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        layer.anchorPoint = CGPoint(x: 0.5, y: 0)
    }
    
    open func update(to angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, (angle - 180).degreesToRadians, 0, 0, 1)
        layer.transform = transform
    }
}
