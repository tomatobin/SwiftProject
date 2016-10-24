//
//  FPRoomSelectView.swift
//  MyTestProject
//
//  Created by jiangbin on 16/10/18.
//  Copyright © 2016年 iblue. All rights reserved.
//  增加不同类型的适配

enum FPRoomCompositeType {
    case Strip //两排
    case Square //方形
}

class FPRoomSelectView: UIScrollView {
    
    /// Room格数组
    var gridInfo = Array<FPRoomGridInfo>()
    
    var actualLine = Int(2)
    
    /// 单格的左右间距
    private var gridPadding = CGFloat(5)
    
    /// 单格的宽度、高度、上下间距
    private var gridWidth = CGFloat(37), gridHeight = CGFloat(38), verticalGap = CGFloat(15)
    
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
        for index in 0 ..< 8 { //21
            let gridInfo = FPRoomGridInfo()
            gridInfo.number = index + 1
            self.gridInfo.append(gridInfo)
        }
        
        var gridInfo = FPRoomGridInfo()
        gridInfo.gridDirection = .Down
        gridInfo.gridType = .Elevator
        self.gridInfo.insert(gridInfo, atIndex: 4) //10
        
        gridInfo = FPRoomGridInfo()
        gridInfo.gridDirection = .Up
        gridInfo.gridType = .Elevator
        self.gridInfo.insert(gridInfo, atIndex: 5) //11
    }
    
    /**
     更新视图：目前只实现了两排的显示
     
     - parameter type: 房间分布类型
     */
    func updateView(type: FPRoomCompositeType) {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        self.layoutIfNeeded() //调用获取高度
        self.gridsView.removeAll()
        self.contentSize = self.stripContentSize()
        self.backgroundColor = UIColor.greenColor()
        
        let countInLine = self.gridsCountInLine()
        let totalLine = self.gridsLines(type)
        
        let height = CGFloat(totalLine) * self.gridHeight + CGFloat(totalLine - 1) * verticalGap
        var yOrigin = (self.bounds.height - height) / 2.0
    
        
        for line in 0 ..< totalLine {
            var frame = CGRect(x: self.xOrigin(type), y: yOrigin, width: self.gridWidth, height: self.gridHeight)
            
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
            
            yOrigin += self.gridHeight + verticalGap
        }
    }
    
    //MARK: Calculate
    
    /**

     计算两排的尺寸
     - returns: CGSize
     */
    func stripContentSize() -> CGSize {
        let width = gridWidth * CGFloat(self.gridsCountInLine()) + gridPadding
        return CGSize(width: width, height: self.bounds.height)
    }
    
    /**
     总的行数
     - returns: Int
     */
    func gridsLines(type: FPRoomCompositeType) -> Int {
        if type == .Strip {
            return 2
        }
        
        return 2
    }
    
    func xOrigin(type: FPRoomCompositeType) -> CGFloat {
        if type == .Strip {
            let stripWith = CGFloat(self.gridsCountInLine()) * gridWidth
            if stripWith > self.bounds.width {
                return self.gridPadding
            }
            
            return (self.bounds.width - stripWith) / 2.0
        }
        
        return self.gridPadding
    }
    
    /**
     每行可以显示的格数
     */
    func gridsCountInLine() -> Int {
        let result = self.gridInfo.count / 2
        if result % 2 == 0 {
            return result //偶数个，一行显示一半
        }
        
        return Int(result) + 1 //奇数个
    }

}
