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

public class WRClockImage {
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

    var color: CGColor = UIColor.white.cgColor
    var clockFace: CGImage?

    var quadrantMarkLength: CGFloat { return clockSize * quadrantMarkLengthRatio }
    var fiveMinutesMarkLength: CGFloat { return clockSize * fiveMinutesMarkLengthRatio }
    var minuteMarkLength: CGFloat { return clockSize * minuteMarkLengthRatio }
    var hourHandLength: CGFloat { return clockSize * hourHandLengthRatio }
    var minuteHandLength: CGFloat { return clockSize * minuteHandLengthRatio }
    var secondHandLength: CGFloat { return clockSize * secondHandLengthRatio }
    
    var clockFaceImage: UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: clockSize, height: clockSize))
        let rect = CGRect(x: outerCircleWidth / 2, y: outerCircleWidth / 2, width: clockSize - outerCircleWidth, height: clockSize - outerCircleWidth)
        
        return renderer.image { context in
            context.cgContext.setStrokeColor(color)
            context.cgContext.setLineWidth(outerCircleWidth)
            context.cgContext.addEllipse(in: rect)
            context.cgContext.drawPath(using: .stroke)
            
            context.cgContext.translateBy(x: clockSize / 2, y: clockSize / 2)
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
                context.cgContext.move(to: startPoint)
                context.cgContext.addLine(to: endPoint)
                context.cgContext.setLineWidth(width)
                context.cgContext.drawPath(using: .stroke)
                context.cgContext.rotate(by: CGFloat(6).degreesToRadians)
            }
        }
        
    }
    
    func drawClock() -> UIImage {
        
        
        let date = Date()
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let second = components.second!
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: clockSize, height: clockSize))
        let rect = CGRect(x: outerCircleWidth / 2, y: outerCircleWidth / 2, width: clockSize - outerCircleWidth, height: clockSize - outerCircleWidth)
        
        if clockFace == nil {
            let clockFaceImage = renderer.image { context in
                context.cgContext.setStrokeColor(color)
                context.cgContext.setLineWidth(outerCircleWidth)
                context.cgContext.addEllipse(in: rect)
                context.cgContext.drawPath(using: .stroke)
                
                context.cgContext.translateBy(x: clockSize / 2, y: clockSize / 2)
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
                    context.cgContext.move(to: startPoint)
                    context.cgContext.addLine(to: endPoint)
                    context.cgContext.setLineWidth(width)
                    context.cgContext.drawPath(using: .stroke)
                    context.cgContext.rotate(by: CGFloat(6).degreesToRadians)
                }
            }
            clockFace = clockFaceImage.cgImage!
        }
        
        let clock = renderer.image { context in
            context.cgContext.setStrokeColor(color)
            context.cgContext.setLineWidth(outerCircleWidth)
            
            context.cgContext.draw(clockFace!, in: rect)
            
            context.cgContext.translateBy(x: clockSize / 2, y: clockSize / 2)
            
            // hour
            let h: Float = Float(hour % 12) + Float(minute) / 60 + Float(second) / 3600
            context.cgContext.rotate(by: CGFloat(h * 30).degreesToRadians)
            context.cgContext.move(to: CGPoint.zero)
            context.cgContext.addLine(to: CGPoint(x: 0, y: -hourHandLength))
            context.cgContext.setLineWidth(hourHandWidth)
            context.cgContext.drawPath(using: .stroke)
            context.cgContext.rotate(by: CGFloat(-h * 30).degreesToRadians)
            
            // minute
            let m: Float = Float(minute) + Float(second) / 60
            context.cgContext.rotate(by: CGFloat(m * 6).degreesToRadians)
            context.cgContext.move(to: CGPoint.zero)
            context.cgContext.addLine(to: CGPoint(x: 0, y: -minuteHandLength))
            context.cgContext.setLineWidth(minuteHandWidth)
            context.cgContext.drawPath(using: .stroke)
            context.cgContext.rotate(by: CGFloat(-m * 6).degreesToRadians)
            
            // second
            context.cgContext.rotate(by: CGFloat(second * 6).degreesToRadians)
            context.cgContext.move(to: CGPoint.zero)
            context.cgContext.addLine(to: CGPoint(x: 0, y: -secondHandLength))
            context.cgContext.setLineWidth(secondHandWidth)
            context.cgContext.drawPath(using: .stroke)
        }
        return clock
    }
}

public class WRClockHand: UIView {
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(length: CGFloat, width: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: length))
        backgroundColor = UIColor.white
    }
    
    public func update(to angle: CGFloat) {
        let transformTranslate = CGAffineTransform(translationX: frame.size.width / 2, y: frame.size.height / 2)
        transform = transformTranslate.rotated(by: (angle - 180).degreesToRadians)
    }
}

public class WRClock: UIView {
    private let wrClockImage = WRClockImage()
    private var timer: Timer?
    
    private var clockFace = UIImageView()
    private var hourHand: WRClockHand!
    private var minuteHand: WRClockHand!
    private var secondHand: WRClockHand!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        wrClockImage.clockSize = min(frame.size.width, frame.size.height)
        hourHand = WRClockHand(length: wrClockImage.hourHandLength, width: wrClockImage.hourHandWidth)
        minuteHand = WRClockHand(length: wrClockImage.minuteHandLength, width: wrClockImage.minuteHandWidth)
        secondHand = WRClockHand(length: wrClockImage.secondHandLength, width: wrClockImage.secondHandWidth)
        addSubview(clockFace)
        addSubview(hourHand)
        addSubview(minuteHand)
        addSubview(secondHand)
    }
    
    public override func draw(_ rect: CGRect) {
        wrClockImage.clockSize = min(rect.width, rect.height)
        clockFace.frame = rect
        clockFace.image = wrClockImage.clockFaceImage
        hourHand.frame = CGRect(x: wrClockImage.clockSize / 2, y: wrClockImage.clockSize / 2, width: wrClockImage.hourHandWidth, height: wrClockImage.hourHandLength)
        minuteHand.frame = CGRect(x: wrClockImage.clockSize / 2, y: wrClockImage.clockSize / 2, width: wrClockImage.minuteHandWidth, height: wrClockImage.minuteHandLength)
        secondHand.frame = CGRect(x: wrClockImage.clockSize / 2, y: wrClockImage.clockSize / 2, width: wrClockImage.secondHandWidth, height: wrClockImage.secondHandLength)
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
                self?.tick()
            })
        }
    }
    
    private func tick() {
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
