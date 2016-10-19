//
//  CustomWidgetsController.swift
//  MyTestProject
//
//  Created by iblue on 16/10/16.
//  Copyright © 2016年 iblue. All rights reserved.
//

class CustomWidgetsController: FPBaseController {

    @IBOutlet weak var starsView: FPStarsView!
    @IBOutlet weak var roomSelectView: FPRoomSelectView!
    @IBOutlet weak var panoTopView: LCPanoTopView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initStarsView()
        self.initRoomSelectView()
        self.initPanoTopView()
    }
    
    func initStarsView () {
        self.starsView.backgroundColor = UIColor.whiteColor()
        let score = rand() % 6
        self.starsView.setScore(Int(score), animated: true)
    }
    
    func initRoomSelectView () {
        self.roomSelectView.backgroundColor = UIColor.fp_mainBlueColor()
        self.roomSelectView.updateView()
    }
    
    func initPanoTopView() {
        self.panoTopView.backgroundColor = UIColor.whiteColor()
        self.panoTopView.disableButton(.Left)
    }
}
