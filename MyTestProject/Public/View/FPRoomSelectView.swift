//
//  FPRoomSelectView.swift
//  MyTestProject
//
//  Created by jiangbin on 16/10/18.
//  Copyright © 2016年 iblue. All rights reserved.
//

class FPRoomSelectView: UIView {
    
    /// Room格数组
    var gridInfo = Array<FPRoomGridInfo>()
    
    /// 单格的左右间距
    private var gridPadding = CGFloat(10)
    
    /// 单格的宽度及高度
    private var gridWidth = CGFloat(37), gridHeight = CGFloat(38)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildTestData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildTestData()
    }
    
    func buildTestData() {
        for index in 0 ..< 18 {
            let gridInfo = FPRoomGridInfo()
            gridInfo.number = index + 1
            self.gridInfo.append(gridInfo)
        }
        
        var gridInfo = FPRoomGridInfo()
        gridInfo.gridDirection = .Down
        gridInfo.gridType = .Elevator
        self.gridInfo.insert(gridInfo, atIndex: 10)
        
        gridInfo = FPRoomGridInfo()
        gridInfo.gridDirection = .Up
        gridInfo.gridType = .Elevator
        self.gridInfo.insert(gridInfo, atIndex: 11)
    }
    
    func updateView() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        let countInLine = self.gridsCountInLine()
        let totalLine = self.gridsLines()
        
        for line in 0 ..< totalLine {
            let yOffset = CGFloat(line) * self.gridHeight + 15 * CGFloat(line + 1)
            var frame = CGRect(x: 0, y: yOffset, width: self.gridWidth, height: self.gridHeight)
            
            if line % 2 == 0 { //对应第1行、3、5等
                for index in 0 ..< countInLine {
                    let roomIndex = 2*index
                    frame = CGRectOffset(frame, self.gridWidth - 1, 0)
                    let gridView = FPRoomGridView(frame: frame)
                    gridView.gridInfo = self.gridInfo[roomIndex]
                    gridView.gridInfo.gridDirection = .Down
                    gridView.gridInfo.gridState = .Selected
                    gridView.updateRoomGrid()
                    self.addSubview(gridView)
                }
            } else {
                for index in 0 ..< countInLine {
                    let roomIndex = 2*index + 1
                    frame = CGRectOffset(frame, self.gridWidth - 1, 0)
                    let gridView = FPRoomGridView(frame: frame)
                    gridView.gridInfo = self.gridInfo[roomIndex]
                    gridView.gridInfo.gridDirection = .Up
                    gridView.updateRoomGrid()
                    self.addSubview(gridView)
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
        let result = self.gridInfo.count / countInLine
        return Int(result)
    }
    
    /**
     每行可以显示的格数
     */
    func gridsCountInLine() -> Int {
        let result = (FP_SCREEN_WIDTH - 2*self.gridPadding) / self.gridWidth
        return Int(result)
    }

}
