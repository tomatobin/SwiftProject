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
    
    var actualLine = Int(2)
    
    /// 单格的左右间距
    private var gridPadding = CGFloat(5)
    
    /// 单格的宽度及高度
    private var gridWidth = CGFloat(37), gridHeight = CGFloat(38)
    
    /// 格视图数组
    private var gridsView = Array<FPRoomGridView>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildTestData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildTestData()
    }
    
    func buildTestData() {
        for index in 0 ..< 21 {
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
        self.gridsView.removeAll()
        
        let countInLine = self.gridsCountInLine()
        let totalLine = self.gridsLines()
        
        for line in 0 ..< totalLine {
            let yOffset = CGFloat(line) * self.gridHeight + 15 * CGFloat(line + 1)
            var frame = CGRect(x: self.gridPadding, y: yOffset, width: self.gridWidth, height: self.gridHeight)
            
            for index in 0 ..< countInLine {
                var roomIndex = 0
                if line % 2 == 0 {
                    roomIndex = 2*index + line * countInLine //对应第01、03、05等
                } else {
                    roomIndex = (line - 1) * (countInLine - 1) + 2*index + 1 //对应02、04、06等
                }
                if roomIndex >= self.gridInfo.count {
                    continue
                }
                
                let gridView = FPRoomGridView(frame: frame)
                gridView.gridInfo = self.gridInfo[roomIndex]
                gridView.gridInfo.gridDirection = (line % 2 == 0) ? .Down : .Up
                gridView.updateRoomGrid()
                self.addSubview(gridView)
                self.gridsView.append(gridView)
                
                frame = CGRectOffset(frame, self.gridWidth - 1, 0)
            }
        }
    }
    
    /**
     总的行数
     - returns: Int
     */
    func gridsLines () -> Int {
        let countInLine = self.gridsCountInLine()
        let result = Float(self.gridInfo.count) / Float(countInLine)
        
        //刚好可以显示下
        if result == Float(Int(result)) {
            return Int(result)
        }
        
        //显示不完：需要对称2行显示
        return 2*Int(result)
    }
    
    /**
     每行可以显示的格数
     */
    func gridsCountInLine() -> Int {
        let result = (FP_SCREEN_WIDTH - 2*self.gridPadding) / self.gridWidth
        return Int(result + 0.5)
    }

}
