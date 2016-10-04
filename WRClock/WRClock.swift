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
    let outerCircleWidth: CGFloat = 4
    let innerMarksMargin: CGFloat = 4
    var quadrantMarkLengthRatio: CGFloat = 0.05
    let quadrantMarkWidth: CGFloat = 2
    let fiveMinutesMarkLengthRatio: CGFloat = 0.03
    let fiveMinutesMarkWidth: CGFloat = 2
    let minuteMarkLengthRatio: CGFloat = 0.02
    let minuteMarkWidth: CGFloat = 1
    let hourHandLengthRatio: CGFloat = 0.2
    let hourHandWidth: CGFloat = 4
    let minuteHandLengthRatio: CGFloat = 0.35
    let minuteHandWidth: CGFloat = 2
    let secondHandLengthRatio: CGFloat = 0.42
    let secondHandWidth: CGFloat = 1

    let color: CGColor = UIColor.white.cgColor
    var clockFace: CGImage?

    func drawClock() -> UIImage {
        let quadrantMarkLength = clockSize * quadrantMarkLengthRatio
        let fiveMinutesMarkLength = clockSize * fiveMinutesMarkLengthRatio
        let minuteMarkLength = clockSize * minuteMarkLengthRatio
        let hourHandLength = clockSize * hourHandLengthRatio
        let minuteHandLength = clockSize * minuteHandLengthRatio
        let secondHandLength = clockSize * secondHandLengthRatio
        
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

public class WRClock: UIView {
    private let wrClockImage = WRClockImage()
    private var timer: Timer?
    
    public override func draw(_ rect: CGRect) {
        wrClockImage.clockSize = min(rect.width, rect.height)
        wrClockImage.drawClock().draw(in: rect)
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
                self?.setNeedsDisplay()
            })
        }
    }
    
    
}
