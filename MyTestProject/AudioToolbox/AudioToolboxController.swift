//
//  AudioToolboxController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/6/30.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit
import AudioToolbox

class AudioToolboxController: FPBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func playAudio(soundName: String){
        var soundId = SystemSoundID()
        let resourcePath = NSBundle.mainBundle().pathForResource(soundName, ofType: "mp3")
        AudioServicesCreateSystemSoundID(NSURL(fileURLWithPath: resourcePath!) , &soundId)
        AudioServicesPlaySystemSound(soundId)
    }
    
    @IBAction func onPlayAction(sender: UIButton) {
        if let identifier = sender.accessibilityIdentifier {
           let dic = ["cow": "cowsound", "cock": "roostersound", "pig": "pigsound"]
            self.playAudio(dic[identifier]!)
        }
    }
}
