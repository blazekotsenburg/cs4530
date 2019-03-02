//
//  GameView.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/20/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol GameViewDelegate {
//    func gameView(_ gameView: GameView, tokenFor player: BattleShip.Token, at row: Int, and col: Int) -> BattleShip.Token
//    func gameView(_ gameView: GameView, cellChangedAt row: Int, and col: Int)
    func gameView(_ gameView: GameView, cellTouchedAt row: Int, and col: Int)
    func gameView(_ gameView: GameView, currentPlayerTokenFor row: Int, and col: Int) -> String
    func gameView(_ gameView: GameView, opponentTokenFor row: Int, and col: Int) -> String
}

class GameView: UIView {
    
//    private var boardRect: CGRect
    private var homeRect: CGRect
    private var opponentRect: CGRect
    
    var delegate: GameViewDelegate?
    
    override init(frame: CGRect) {
//        boardRect = CGRect(x: frame.width * 0.5, y: frame.height * 0.3, width: frame.width * 0.8, height: frame.width * 0.8)
        homeRect = CGRect(x: frame.width * 0.5, y: frame.height * 0.3, width: frame.width * 0.8, height: frame.width * 0.8)
        opponentRect = CGRect(x: frame.width * 0.5, y: frame.height * 0.3, width: frame.width * 0.8, height: frame.width * 0.8)
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
    }
    
    override func draw(_ rect: CGRect) {
//        let boardWidth = frame.width * 0.6
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        opponentRect = CGRect(x: 0.0, y: 0.0, width: frame.width * 0.7, height: frame.width * 0.7)
        opponentRect.origin.x = frame.width / 2 - opponentRect.width / 2
        opponentRect.origin.y = 35.0
    
        context.addRect(opponentRect)
        context.setStrokeColor(UIColor.darkGray.cgColor)
        context.setLineWidth(1.0)
        context.setFillColor(UIColor.darkGray.cgColor)
        context.drawPath(using: .fillStroke)

        homeRect = CGRect(x: 0.0, y: 0.0, width: frame.width * 0.7, height: frame.width * 0.7)
        homeRect.origin.x = frame.width / 2 - homeRect.width / 2
        homeRect.origin.y = opponentRect.origin.y + opponentRect.height + opponentRect.height * 0.1
        //Opponentboard
        context.addRect(homeRect)
        context.setStrokeColor(UIColor.darkGray.cgColor)
        context.setLineWidth(1.0)
        context.setFillColor(UIColor.darkGray.cgColor)
        context.drawPath(using: .fillStroke)
        
        var heightPercentage: CGFloat = 0.0

        for _ in 0 ... 10 {
            let path: UIBezierPath = UIBezierPath()
            path.move(to: CGPoint(x: homeRect.origin.x, y: homeRect.origin.y + (heightPercentage * homeRect.height)))
            
            let toX = homeRect.origin.x + homeRect.width
            let toY = homeRect.origin.y + (heightPercentage * homeRect.height)
            
            path.addLine(to: CGPoint(x: toX, y: toY))
            path.lineWidth = 1.0
            path.lineCapStyle = .round
            UIColor.lightGray.setStroke()
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
            UIColor.lightGray.setStroke()
            path.stroke()
            path.close()
            heightPercentage += 0.1
        }
        
        heightPercentage = 0.0
        
        for _ in 0 ... 10 {
            let path: UIBezierPath = UIBezierPath()
            path.move(to: CGPoint(x: homeRect.origin.x + (heightPercentage * homeRect.width), y: homeRect.origin.y))
            
            let toX = homeRect.origin.x + (heightPercentage * homeRect.width)
            let toY = homeRect.origin.y + homeRect.height
            
            path.addLine(to: CGPoint(x: toX, y: toY))
            path.lineWidth = 1.0
            path.lineCapStyle = .round
            UIColor.lightGray.setStroke()
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
            UIColor.lightGray.setStroke()
            path.stroke()
            path.close()
            heightPercentage += 0.1
        }
        
        if let delegate = delegate {
            for col in 0 ..< 10 {
                for row in 0 ..< 10 {
                    let cell: String = delegate.gameView(self, currentPlayerTokenFor: row, and: col)
                    
                    let x: CGFloat = (CGFloat(col) + 0.25) * 0.1 * homeRect.width + homeRect.origin.x
                    let y: CGFloat = (CGFloat(row) + 0.25) * 0.1 * homeRect.height + homeRect.origin.y
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
