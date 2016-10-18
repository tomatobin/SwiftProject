//
//  FPRoomSelectView.swift
//  MyTestProject
//
//  Created by jiangbin on 16/10/18.
//  Copyright © 2016年 iblue. All rights reserved.
//

class FPDrawRoomSelectView: UIView {
    
    /// 总数
    var totalCount = Int(30)
    
    /// 单格的宽度及高度
    private var gridWidth = CGFloat(37), gridHeight = CGFloat(38)
    
    /// 单格的左右间距
    private var gridPadding = CGFloat(10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configView() {
        
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let downImage = UIImage(named: "room_down_unselect")
        let upImage = UIImage(named: "room_up_disable")
        let countInLine = self.gridsCountInLine()
        let totalLine = self.gridsLines()
    
        for line in 0 ..< totalLine {
            let yOffset = CGFloat(line) * self.gridHeight + 15 * CGFloat(line + 1)
            var frame = CGRect(x: self.gridPadding, y: yOffset, width: self.gridWidth, height: self.gridHeight)
    
            if line % 2 == 0 { //对应第1行、3、5等
                for _ in 0 ..< countInLine {
                    downImage?.drawInRect(frame)
                    frame = CGRectOffset(frame, self.gridWidth - 1, 0)
                }
            } else {
                for _ in 0 ..< countInLine {
                    upImage?.drawInRect(frame)
                    frame = CGRectOffset(frame, self.gridWidth - 1, 0)
                }
            }
        }
    }
    
    /**
     总的行数
     
     - returns: Int
     */
    func gridsLines () -> Int {
        let countInLine = self.gridsCountInLine()
        let result = self.totalCount / countInLine
        return Int(result)
    }
    
    /**
     每行可以显示的格数
     */
    func gridsCountInLine() -> Int {
        let result = (self.bounds.width - 2*self.gridPadding) / self.gridWidth
        return Int(result)
    }
}
