//
//  ClockView.swift
//  Project2
//
//  Created by Blaze Kotsenburg on 2/2/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//
// CS4530

import UIKit

class ClockView: UIControl {
    
    private var timeInterval: TimeInterval!
    private var timeZone:     TimeZone!
    private var startDate:    Date?
    private var calendar:     Calendar!
    private var timeZoneMap:  [Int : String]?
    private var startAngle:   CGFloat!
    private var startAmPm:    Int8!
    private var quadrant:     Int8!
    private var amOrPm:       Int8! // 1 when am, 0 when pm
    private var rotations:    Int = 0
    private var direction:    Int = 0
    private var minuteHandAngle : CGFloat = 0.0
    private var secondHandAngle : CGFloat = 0.0
    
    private var faceRect: CGRect   = CGRect.zero
    private var hourHand: CGRect   = CGRect.zero
    private var _angle:   CGFloat  = 0.0
    private var timeZoneLabel: String!
    
    private var angleTimer: Timer?
    private var secondAndMinuteTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        timeInterval = 0
        startDate = Date()
        calendar = Calendar.current

        timeZoneMap = [0 :   "Greenwich Mean",
                       1 :   "European Central",
                       2 :   "Eastern European",
                       3 :   "Eastern Africa",
                       4 :   "Near East",
                       5 :   "Pakistan Lahore",
                       6 :   "Bangladesh Standard",
                       7 :   "Vietnam Standard",
                       8 :   "China Taiwan",
                       9 :   "Japan Standard",
                       10 :  "Australia Eastern",
                       11 :  "Solomon Standard",
                       12 :  "New Zealand Standard",
                       -11 : "Midway Islands",
                       -10 : "Hawaii Standard",
                       -9 :  "Alaska Standard",
                       -8 :  "Pacific Standard",
                       -7 :  "Mountain Standard",
                       -6 :  "Central Standard",
                       -5 :  "Eastern Standard",
                       -4 :  "Puerto Rico/US Virgin Islands",
                       -3 :  "Argentina Standard",
                       -2 :  "Greenland Summer",
                       -1:   "Central African"]
        
        timeZone = TimeZone(abbreviation: "GMT")
        timeZoneLabel = timeZoneMap![0]

        let tz = calendar.dateComponents(in: timeZone, from: Date())
        
        if let hour = tz.hour {
            angle = CGFloat(hour % 12) * ((30 * .pi) / 180)
        }
        calibrateAngle()
        
        amOrPm = tz.hour! <= 12 ? 1 : 0
        startAngle = angle
        updateQuadrant()
        
        Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true, block: {
            timer in
            self.setNeedsDisplay()
        })
        
        angleTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: {
            timer in
            self.angle += (1/2400) * (.pi / 180)
        })
        
        secondAndMinuteTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: {
            timer in
            self.minuteHandAngle += 1/200 * (.pi / 180)
            self.secondHandAngle += 0.3 * (.pi / 180)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateQuadrant() {
        let degrees = angle * (180 / .pi)
        switch degrees {
        case 0.0 ... 90.0:
            if quadrant == 2 {
                amOrPm ^= 1
            }
            quadrant = 1
            break
        case 90.001 ... 180.0:
            quadrant = 4
            break
        case 180.001 ... 270.0:
            quadrant = 3
        default:
            if quadrant == 1 {
                amOrPm ^= 1
            }
            quadrant = 2
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        faceRect = CGRect(x: bounds.width * 0.05, y: bounds.height * 0.5 - bounds.width * 0.5 + 1.0, width: (bounds.width * 0.9) - 1.0, height: (bounds.width *  0.9) - 1.0)
        faceRect.origin.y = (bounds.height - faceRect.height) / 2.0
        
        let radius: CGFloat = (faceRect.width - 2.0) / 2.0 //mess around with these values later (used to be + 15.0)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        context.addEllipse(in: faceRect)
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(2.0)
        context.setFillColor(UIColor.darkGray.cgColor)
        context.drawPath(using: .fillStroke)
        
        let toRads: CGFloat = .pi / 180
        let phaseChange: CGFloat = .pi / 2
        
        for theta in stride(from: 360, to: 0, by: -30) {
            
            var height: CGFloat = 14.0
            if theta % 90 == 0 {
                height = 20.0
            }
            
            let x = cos(CGFloat(theta) * toRads) * (radius - 1) + faceRect.midX
            let y = sin(CGFloat(theta) * toRads) * (radius - 1) + faceRect.midY
            
            var xDirection: CGFloat = 1.0
            var yDirection: CGFloat = 1.0
            if x < 0 {
                xDirection *= -1.0
            }
            if y < 0 {
                yDirection *= -1.0
            }
            
            let path: UIBezierPath = UIBezierPath()
            path.move(to: CGPoint(x: x, y: y))
            
            let toX = cos(CGFloat(theta) * toRads) * (radius - height * xDirection) + faceRect.midX
            let toY = sin(CGFloat(theta) * toRads) * (radius - height * yDirection) + faceRect.midY
            
            path.addLine(to: CGPoint(x: toX, y: toY))
            path.lineWidth = 2.0
            path.lineCapStyle = .round
            UIColor.black.setStroke()
            path.stroke()
            path.close()
        }
        
        let hX = cos(CGFloat(angle - phaseChange)) * (radius * 0.55) + faceRect.midX
        let hY = sin(CGFloat(angle - phaseChange)) * (radius * 0.55) + faceRect.midY
        
        let hourPath: UIBezierPath = UIBezierPath()
        hourPath.move(to: CGPoint(x: hX, y: hY))
        
        let toX = faceRect.midX
        let toY = faceRect.midY
        
        hourPath.addLine(to: CGPoint(x: toX, y: toY))
        hourPath.lineWidth = 4.0
        hourPath.lineCapStyle = .square
        UIColor.lightGray.setStroke()
        hourPath.stroke()
        hourPath.close()
        
        let x = cos(CGFloat(minuteHandAngle - phaseChange)) * (radius * 0.75) + faceRect.midX
        let y = sin(CGFloat(minuteHandAngle - phaseChange)) * (radius * 0.75) + faceRect.midY
        
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: x, y: y))
        
        path.addLine(to: CGPoint(x: toX, y: toY))
        path.lineWidth = 2.0
        path.lineCapStyle = .square
        UIColor.white.setStroke()
        path.stroke()
        path.close()
        
        let sX = cos(CGFloat(secondHandAngle - phaseChange)) * (radius * 0.7) + faceRect.midX
        let sY = sin(CGFloat(secondHandAngle - phaseChange)) * (radius * 0.7) + faceRect.midY
        
        let secondPath: UIBezierPath = UIBezierPath()
        secondPath.move(to: CGPoint(x: sX, y: sY))
        
        secondPath.addLine(to: CGPoint(x: toX, y: toY))
        secondPath.lineWidth = 2.0
        secondPath.lineCapStyle = .square
        UIColor.red.setStroke()
        secondPath.stroke()
        secondPath.close()
        
        var midFaceDot: CGRect = CGRect(x: 0.0, y: 0.0, width: radius * 0.1, height: radius * 0.1)
        midFaceDot.origin.x = faceRect.midX - midFaceDot.width / 2
        midFaceDot.origin.y = faceRect.midY - midFaceDot.height / 2
        context.addEllipse(in: midFaceDot)
        context.setFillColor(UIColor.red.cgColor)
        context.drawPath(using: .fill)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        startAngle = angle
        startAmPm = amOrPm
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        angleTimer?.invalidate()
        let touch: UITouch = touches.first!
        let touchPoint = touch.location(in: self)
        let point: CGPoint = CGPoint(x: touchPoint.x - faceRect.midX, y: touchPoint.y - faceRect.midY)
        angle = atan2(point.y, point.x) + .pi / 2 // add phase change to make 12:00 at pi/2
        let prevQuadrant: Int8 = quadrant
        updateQuadrant()
        if prevQuadrant == 1 && quadrant == 4 {
            direction += 1
        }
        else if prevQuadrant == 4 && quadrant == 1 {
            direction -= 1
        }
        else if prevQuadrant > quadrant {
            direction += 1
        }
        else if prevQuadrant < quadrant {
            direction -= 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var angleInDegrees: CGFloat = (180 * angle) / .pi // current angle converted from radians to degrees
        
        var startAngleInDegrees: CGFloat = (180 * startAngle) / .pi

        if startAngleInDegrees < 0 {
            startAngleInDegrees = 270 + (90 + startAngleInDegrees)
        }
        if angleInDegrees < 0 {
            angleInDegrees = 270 + (90 + angleInDegrees)
        }
        
        let currHour: Int = Int(round(angleInDegrees) / 30) == 0 ? 12 : Int(round(angleInDegrees) / 30)
        let startHour: Int = Int(round(startAngleInDegrees) / 30) == 0 ? 12 : Int(round(startAngleInDegrees) / 30)
        
        if currHour == startHour && direction == 0 {
            let minToAngle:   CGFloat = CGFloat(Calendar.current.component(.minute, from: Date()) * 6) / 360.0 * 15 // convert current minute to angle that should be added to hour hand position
            let secToDegrees: CGFloat = CGFloat(Calendar.current.component(.minute, from: Date()) * 60) / 3600.0 * 15 // convert cu
            angle = (CGFloat(startHour * 30) + minToAngle + secToDegrees) * (.pi / 180)
            return
        }
        
        var diffInSeconds: Double = 0.0
        
        if amOrPm == startAmPm {
            if startHour == 12 { // the maximum hours forward it can go is 11 before it passes into different time of day
                diffInSeconds = Double(currHour * 3600)
            }
            else if currHour == 12 && startHour < 12 { // moved in a counterclockwise direction, need to subtract
                diffInSeconds = (12 - (Double(currHour - startHour))) * -3600
            }
            else if startHour >= currHour { // In same am/pm, if start > curr, then direction is counter clockwise
                diffInSeconds = Double(startHour - currHour) * -3600
            }
            else { // start < curr, so increase time in clockwise direction
                diffInSeconds = Double(currHour - startHour) * 3600
            }
        }
        else { // time of day is not equal between startHour and currHour
            if direction > 0 { // rotating in a clockwise direction
                if currHour == 12 && startHour < 12{ // when currHour = 12 && startHour < 12, rotation to right is less than 12 hour difference but different time of day (covers start = 1)
                    diffInSeconds = Double(12 - startHour) * 3600
                }
                else if currHour >= startHour { // rotated 12 or more hours in a clockwise direction
                    diffInSeconds = (12 + Double(currHour - startHour)) * 3600
                }
                else {  // clockwise direction greater than 12 hour difference
                    diffInSeconds = (12 - Double(startHour - currHour)) * 3600
                }
            }
            else { // rotating in a counter clockwise direction
                if startHour == 12 && currHour < 12 { // when startHour = 12 && currHour < 12, rotation to right is less than 12 hour difference but different time of day (covers start = 1)
                    diffInSeconds = Double(12 - currHour) * -3600
                }
                else if currHour >= startHour { // counter clockwise rotation of less than or equal to 12 hours
                    diffInSeconds = (12 - (Double(currHour - startHour))) * -3600
                }
                else { // counter clockwise direction greater than 12 hour difference
                    diffInSeconds = (12 + Double(startHour - currHour)) * -3600
                }
            }
        }
        
        timeInterval = detectRolloverInSeconds(timeInterval: timeInterval + diffInSeconds)
        direction = 0
        
        angleTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: {
            timer in
            self.angle += (1/2400) * (.pi / 180)
        })
        
        if timeInterval < 0 {
            if let zoneString = timeZoneMap![((Int(abs(timeInterval))) / 3600) * -1], let gmtString = TimeZone(secondsFromGMT: Int(timeInterval))?.abbreviation() {
                timeZoneLabel = gmtString + ": " + zoneString
            }
        }
        else {
            if let zoneString = timeZoneMap![((Int(abs(timeInterval))) / 3600)], let gmtString = TimeZone(secondsFromGMT: Int(timeInterval))?.abbreviation() {
                timeZoneLabel = gmtString + ": " + zoneString
            }
        }
    
        self.sendActions(for: .valueChanged)
    }
    
    private func calibrateAngle() {
        // Calculate the angle of the hour hand
        var degrees = (180 * angle) / .pi
        if degrees < 0 {
            degrees = 270 + (90 + degrees)
        }
        let hours: Int = Int((round(CGFloat(degrees) / 30)))
        let minToAngle:   CGFloat = (CGFloat(Calendar.current.component(.minute, from: Date()) * 6) / 360.0) * 15 // convert current minute to angle that should be added to hour hand position
        let secToDegrees: CGFloat = CGFloat(Calendar.current.component(.minute, from: Date()) * 60) / 3600.0 * 15 // convert current second to angle that should be added to hour hand position
        
        // Calculate the angle of the minute hand
        let minutes: CGFloat = CGFloat((Calendar.current.component(.minute, from: Date())))
        let seconds: CGFloat = CGFloat((Calendar.current.component(.second, from: Date())))
        
        angle = (CGFloat(hours * 30) + minToAngle + secToDegrees) * (.pi / 180)
        minuteHandAngle = (minutes * 6) * (.pi / 180)
        secondHandAngle = (seconds * 6) * (.pi / 180)
    }
    
    private func detectRolloverInSeconds(timeInterval: TimeInterval) -> TimeInterval {
        
        var remainder = 0

        if timeInterval > 0 {
            if timeInterval > 12 * 3600 {
                remainder = Int(timeInterval) % (12 * 3600)
                remainder = Int(timeInterval) / 3600
                remainder %= 13
                let offset = (11 - remainder) * -1
                return TimeInterval(offset * 3600)
            }
        }
        else {
            if timeInterval < -11 * 3600 {
                remainder = Int(timeInterval) % (11 * 3600)
                remainder = Int(abs(timeInterval)) / 3600
                remainder %= 12
                let offset = (12 - remainder)
                return TimeInterval(offset * 3600)
            }
        }
        return timeInterval
    }
    
    func getTimeZoneLabel() -> String {
        return timeZoneLabel
    }
    
    var angle: CGFloat {
        get {
            return _angle
        }
        set {
            _angle = newValue
            setNeedsDisplay()
        }
    }
}
