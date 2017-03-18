//
//  UIImage+Extension.swift
//  FPSwift
//
//  Created by iblue on 16/10/15.
//  Copyright © 2016年 iblue. All rights reserved.
//

import Foundation

extension UIImage {
    
    func fp_imageByScalingToSize(_ targetSize: CGSize) -> UIImage {
        var newImage: UIImage
    
        // this is actually the interesting part:
        UIGraphicsBeginImageContext(targetSize)
        
        let thumbnailRect = CGRect(origin: CGPoint.zero, size: targetSize)
        self.draw(in: thumbnailRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return newImage
    }
}
