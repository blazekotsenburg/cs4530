//
//  GameView.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/20/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol GameViewDelegate {
    func gameView(backButtonPressedFor gameView: GameView)
    func gameView(_ gameView: GameView, cellTouchedAt row: Int, and col: Int)
    func gameView(_ gameView: GameView, currentPlayerTokenFor row: Int, and col: Int) -> String
    func gameView(_ gameView: GameView, opponentTokenFor row: Int, and col: Int) -> String
}

class GameView: UIView {
    
//    private var boardRect: CGRect
    var homeRect: CGRect
    var opponentRect: CGRect
    
    var homeRectOriginX: CGFloat = 0.0
    var homeRectOriginY: CGFloat = 0.0
    var frameWidth: CGFloat = 0.0
    var opponentLabel: UILabel
    var homeLabel: UILabel
    private var firstLoad: Bool
    private var backButton: UIButton
    
    var delegate: GameViewDelegate?
    
    override init(frame: CGRect) {
        homeRect = CGRect(x: frame.width * 0.5, y: frame.height * 0.3, width: frame.width * 0.8, height: frame.width * 0.8)
        opponentRect = CGRect(x: frame.width * 0.5, y: frame.height * 0.3, width: frame.width * 0.8, height: frame.width * 0.8)
        backButton = UIButton()
        firstLoad = true
        opponentLabel = UILabel()
        homeLabel = UILabel()
        super.init(frame: frame)
        
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
    }
    
    @objc func backButtonPressed() {
        delegate?.gameView(backButtonPressedFor: self)
    }
    
    override func draw(_ rect: CGRect) {
        
        if firstLoad {
            frameWidth = frame.width
        }
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        opponentRect = CGRect(x: 0.0, y: 0.0, width: frameWidth * 0.7, height: frameWidth * 0.7)
        opponentRect.origin.x = frameWidth / 2 - opponentRect.width / 2
        opponentRect.origin.y = 50.0
        
        opponentLabel.frame = CGRect(x: opponentRect.origin.x, y: opponentRect.origin.y - 20, width: frameWidth * 0.7, height: 20)
        opponentLabel.text = "Opponent's Board"
        opponentLabel.font = UIFont(name: "Avenir", size: 18)
        opponentLabel.textAlignment = .center
        opponentLabel.textColor = .white
        addSubview(opponentLabel)
        
        backButton.frame = CGRect(x: 12.0, y: 12.0, width: 80.0, height: 20.0)
        backButton.setTitle("← Back", for: .normal)
        backButton.titleLabel!.font = UIFont(name: "Avenir", size: 18)
        addSubview(backButton)
        
        if firstLoad {
            firstLoad = false
            homeRectOriginX = opponentRect.origin.x
            homeRectOriginY = opponentRect.origin.y + opponentRect.height + opponentRect.height * 0.1
        }
//        58 green:0.93 blue:0.91
        context.addRect(opponentRect)
        context.setStrokeColor(UIColor(red: 0.50, green: 0.80, blue: 0.77, alpha: 1.0).cgColor)
        context.setLineWidth(1.0)
        context.setFillColor(UIColor(red: 0.50, green: 0.80, blue: 0.77, alpha: 1.0).cgColor)
        context.drawPath(using: .fillStroke)

        homeRect = CGRect(x: 0.0, y: 0.0, width: frameWidth * 0.7, height: frameWidth * 0.7)
//        homeRect.origin.x = frameWidth / 2 - homeRect.width / 2
//        homeRect.origin.y = opponentRect.origin.y + opponentRect.height + opponentRect.height * 0.08
        homeRect.origin.x = homeRectOriginX
        homeRect.origin.y = homeRectOriginY
        
        homeLabel.frame = CGRect(x: homeRect.origin.x, y: homeRect.origin.y - 20, width: frameWidth * 0.7, height: 20)
        homeLabel.text = "Your Board"
        homeLabel.font = UIFont(name: "Avenir", size: 18)
        homeLabel.textAlignment = .center
        homeLabel.textColor = .white
        addSubview(homeLabel)
        
        //Opponentboard
        context.addRect(homeRect)
        context.setStrokeColor(UIColor(red: 0.50, green: 0.80, blue: 0.77, alpha: 1.0).cgColor)
        context.setLineWidth(1.0)
        context.setFillColor(UIColor(red: 0.50, green: 0.80, blue: 0.77, alpha: 1.0).cgColor)
        context.drawPath(using: .fillStroke)
        
        var heightPercentage: CGFloat = 0.0

        for _ in 0 ... 10 {
            let path: UIBezierPath = UIBezierPath()
            path.move(to: CGPoint(x: homeRectOriginX, y: homeRectOriginY + (heightPercentage * homeRect.height)))
            
            let toX = homeRectOriginX + homeRect.width
            let toY = homeRectOriginY + (heightPercentage * homeRect.height)
            
            path.addLine(to: CGPoint(x: toX, y: toY))
            path.lineWidth = 1.0
            path.lineCapStyle = .round
            UIColor(red: 0.22, green: 0.64, blue: 0.98, alpha: 1.0).setStroke()
            path.stroke()
            path.close()
            heightPercentage += 0.1
        }
        
        heightPercentage = 0.0
        
        for _ in 0 ... 10 {
            let path: UIBezierPath = UIBezierPath()
            path.move(to: CGPoint(x: homeRectOriginX + (heightPercentage * homeRect.width), y: homeRectOriginY))
            
            let toX = homeRectOriginX + (heightPercentage * homeRect.width)
            let toY = homeRectOriginY + homeRect.height
            
            path.addLine(to: CGPoint(x: toX, y: toY))
            path.lineWidth = 1.0
            path.lineCapStyle = .round
            UIColor(red: 0.22, green: 0.64, blue: 0.98, alpha: 1.0).setStroke()
            path.stroke()
            path.close()
            heightPercentage += 0.1
        }
        
        heightPercentage = 0.0
        //Opponentboard
        for _ in 0 ... 10 {
            let path: UIBezierPath = UIBezierPath()
            path.move(to: CGPoint(x: opponentRect.origin.x, y: opponentRect.origin.y + (heightPercentage * opponentRect.height)))

            let toX = opponentRect.origin.x + opponentRect.width
            let toY = opponentRect.origin.y + (heightPercentage * opponentRect.height)

            path.addLine(to: CGPoint(x: toX, y: toY))
            path.lineWidth = 1.0
            path.lineCapStyle = .round
            UIColor(red: 0.22, green: 0.64, blue: 0.98, alpha: 1.0).setStroke()
            path.stroke()
            path.close()
            heightPercentage += 0.1
        }
        
        heightPercentage = 0.0
        //Opponentboard
        for _ in 0 ... 10 {
            let path: UIBezierPath = UIBezierPath()
            path.move(to: CGPoint(x: opponentRect.origin.x + (heightPercentage * opponentRect.width), y: opponentRect.origin.y))

            let toX = opponentRect.origin.x + (heightPercentage * opponentRect.width)
            let toY = opponentRect.origin.y + opponentRect.height

            path.addLine(to: CGPoint(x: toX, y: toY))
            path.lineWidth = 1.0
            path.lineCapStyle = .round
            UIColor(red: 0.22, green: 0.64, blue: 0.98, alpha: 1.0).setStroke()
            path.stroke()
            path.close()
            heightPercentage += 0.1
        }
        
        if let delegate = delegate {
            for col in 0 ..< 10 {
                for row in 0 ..< 10 {
                    let cell: String = delegate.gameView(self, currentPlayerTokenFor: row, and: col)
                    
                    let x: CGFloat = (CGFloat(col) + 0.25) * 0.1 * homeRect.width + homeRectOriginX
                    let y: CGFloat = (CGFloat(row) + 0.25) * 0.1 * homeRect.height + homeRectOriginY
                    let point: CGPoint = CGPoint(x: x, y: y)

                    (cell as NSString).draw(at: point, withAttributes: nil)
                }
            }
            
            for col in 0 ..< 10 {
                for row in 0 ..< 10 {
                    let cell: String = delegate.gameView(self, opponentTokenFor: row, and: col)
                    
                    let x: CGFloat = (CGFloat(col) + 0.25) * 0.1 * opponentRect.width + opponentRect.origin.x
                    let y: CGFloat = (CGFloat(row) + 0.25) * 0.1 * opponentRect.height + opponentRect.origin.y
                    let point: CGPoint = CGPoint(x: x, y: y)

                    (cell as NSString).draw(at: point, withAttributes: nil)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first?.location(in: self) {
            if opponentRect.contains(touch) {
                let col = Int((touch.x - opponentRect.origin.x) / (opponentRect.width / 10.0))
                let row = Int((touch.y - opponentRect.origin.y) / (opponentRect.width / 10.0))
                
                delegate?.gameView(self, cellTouchedAt: row, and: col)
            }
        }
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
