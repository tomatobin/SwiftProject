//
//  AudioServicesController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/6/30.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit
import AudioToolbox

class AudioServicesController: FPBaseController {

    @IBOutlet weak var btnCow: UIButton!
    @IBOutlet weak var btnCock: UIButton!
    @IBOutlet weak var btnPig: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        btnCow.layer.cornerRadius = 60
        btnCock.layer.cornerRadius = 60
        btnPig.layer.cornerRadius = 60
        
        btnCow.layer.masksToBounds = true
        btnCock.layer.masksToBounds = true
        btnPig.layer.masksToBounds = true
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
            self.startAnimation(sender)
            
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            //                sender.layer.removeAllAnimations()
            //            }
        }
    }
    
    func startAnimation(view: UIView){
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double(arc4random()%2 + 1) *  M_PI / 6
        animation.duration = 2
        animation.repeatCount = 1
        animation.autoreverses = false
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.beginTime = CACurrentMediaTime();
        view.layer.addAnimation(animation, forKey: "rotate")
    }
}
