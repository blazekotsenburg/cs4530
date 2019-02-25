//
//  GameView.swift
//  TicTacToe
//
//  Created by Blaze Kotsenburg on 2/20/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol GameViewDelegate {
    func gameView(_ gameView: GameView, tokenFor col: Int, and row: Int) -> String
    func gameView(_ gameView: GameView, cellTouchedAt col: Int, and row: Int)
}

class GameView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    var cells: [[String]] {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
    
    var delegate: GameViewDelegate!
    
    func reloadData() {
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        //TODO: Draw grid
        
        //TODO: Fill each cell with 'X' or 'O' depending on the player who claimed that call, by reading the cells array
        
        //(cells[0][0] as NSString).draw(at: <#T##CGPoint#>, withAttributes: <#T##[NSAttributedString.Key : Any]?#>)
        let token00 = delegate.gameView(self, tokenFor: 0, and: 0)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        
        //TODO:
    }
    
}
