//
//  UIImageView+Store.swift
//  FPSwift
//
//  Created by iblue on 16/10/26.
//  Copyright © 2016年 iblue. All rights reserved.
//

import SDWebImage

extension UIImageView: SDWebImageManagerDelegate {
    
    /**
     使用网络图片设置ImageView
     
     - parameter imageUrl:    图片的地址
     - parameter placeHolder: 默认的图片
     - parameter saveToDisk:  是否保存到硬盘，默认不保存
     */
    func fp_setImageWithUrl(_ imageUrl: String?, placeHolder: UIImage!, saveToDisk: Bool = Bool(false)) {
        
        if imageUrl == nil {
            if placeHolder != nil {
                DispatchQueue.main.async(execute: {
                    self.image = placeHolder
                })
            }
            
            return
        }
        
        
        self.sd_setImage(with: URL(string: imageUrl!), placeholderImage: placeHolder, options: .retryFailed, completed: {(image, error,  cacheType, url) in
            if saveToDisk == true, cacheType != .disk {
                SDImageCache.shared().store(image, forKey: imageUrl!, toDisk: true)
            }
        })
    }
    
    
    /// 使用网络图片设置ImageView，并进行压缩处理
    ///
    /// - Parameters:
    ///   - imageUrl: 图片的地址
    ///   - placeHolder: 默认的图片
    ///   - shouldTransformImage: 是否进行压缩处理
    func fp_setImageWithUrl(_ imageUrl: String?, placeHolder: UIImage!, shouldTransformImage: Bool, saveToDisk: Bool = false) {
        if imageUrl == nil {
            if placeHolder != nil {
                DispatchQueue.main.async(execute: {
                    self.image = placeHolder
                })
            }
            
            return
        }
        
        SDWebImageManager.shared().delegate = self
        self.sd_setImage(with: URL(string: imageUrl!), placeholderImage: placeHolder, options: .retryFailed, completed: {(image, error,  cacheType, url) in
            
            if let originImage = image {
                var size = originImage.size
                let maxWidth = CGFloat(414) //以6p的宽度，进行压缩保存
                let scaleFactor = maxWidth / size.width
                if shouldTransformImage && scaleFactor < 1.0 {
                    size.width = maxWidth
                    size.height = size.height * scaleFactor
                    self.image = originImage.fp_imageByScalingToSize(size)
                }

                if saveToDisk == true, cacheType != .disk {
                    SDImageCache.shared().store(self.image, forKey: imageUrl!, toDisk: true)
                }
            }
        })
    }
    
    public func imageManager(_ imageManager: SDWebImageManager!, transformDownloadedImage image: UIImage!, with imageURL: URL!) -> UIImage! {
        var size = image.size
        let maxWidth = CGFloat(414) //以6p的宽度，进行压缩保存
        let scaleFactor = maxWidth / size.width
        if scaleFactor < 1.0 {
            size.width = maxWidth
            size.height = size.height * scaleFactor
            let compressedImage = image.fp_imageByScalingToSize(size)
            print("Compressed Image:\(size)")
            return compressedImage
        }
        
        return image
    }
}
