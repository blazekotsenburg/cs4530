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
    func gameView(_ gameView: GameView, tokenFor row: Int, and col: Int) -> String
}

class GameView: UIView {
    
    private var boardRect: CGRect
    
    var delegate: GameViewDelegate?
    
    override init(frame: CGRect) {
        boardRect = CGRect(x: frame.width * 0.5, y: frame.height * 0.3, width: frame.width * 0.8, height: frame.width * 0.8)
        super.init(frame: frame)
        
        backgroundColor = .blue
    }
    
    override func draw(_ rect: CGRect) {
        boardRect = CGRect(x: frame.width * 0.5, y: frame.height * 0.3, width: frame.width * 0.8, height: frame.width * 0.8)
        boardRect.origin.x -= boardRect.width * 0.5
        boardRect.origin.y -= boardRect.height * 0.5
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.addRect(boardRect)
        context.setStrokeColor(UIColor.darkGray.cgColor)
        context.setLineWidth(1.0)
        context.setFillColor(UIColor.darkGray.cgColor)
        context.drawPath(using: .fillStroke)
        
        var heightPercentage: CGFloat = 0.0
        for _ in 0 ... 10 {
            let path: UIBezierPath = UIBezierPath()
            path.move(to: CGPoint(x: boardRect.origin.x, y: boardRect.origin.y + (heightPercentage * boardRect.height)))
            
            let toX = boardRect.origin.x + boardRect.width
            let toY = boardRect.origin.y + (heightPercentage * boardRect.height)
            
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
            path.move(to: CGPoint(x: boardRect.origin.x + (heightPercentage * boardRect.width), y: boardRect.origin.y))
            
            let toX = boardRect.origin.x + (heightPercentage * boardRect.width)
            let toY = boardRect.origin.y + boardRect.height
            
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
                    let cell: String = delegate.gameView(self, tokenFor: row, and: col)
                    let point: CGPoint = CGPoint(x: boardRect.origin.x + 0.1 * boardRect.width, y: boardRect.origin.y + 0.1 * boardRect.height)
                    (cell as NSString).draw(at: point, withAttributes: nil)
                    print(cell)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first?.location(in: self) {
            if boardRect.contains(touch) {
                let col = Int((touch.x - boardRect.origin.x) / (boardRect.width / 10.0))
                let row = Int((touch.y - boardRect.origin.y) / (boardRect.width / 10.0))
                
                delegate?.gameView(self, cellTouchedAt: row, and: col)
//                print(row, col)
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
