//
//  LZLoopViewCell.swift
//  LZLoopView+Collection
//
//  Created by Artron_LQQ on 2016/11/18.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit

class LZLoopViewCell: UICollectionViewCell {
    
    var placeholderImage: UIImage?
    
    var obj: Any? {
        
        didSet {
            
            if obj is UIImage {
                
                let img = obj as! UIImage
                
                self.imageView.image = img
            } else if obj is String {
                
                let str = obj as! String
                
                if str .hasPrefix("http") {
                    
                    self.imageView.cancelCurrentRequest()
                    
                    if let img = self.placeholderImage {
                        
                        self.imageView.imageFromURL(str, placeholder: img)
                    } else {
                        
                        self.imageView.imageFromURL(str, placeholder: UIImage())
                    }
                    
                } else {
                    var img = UIImage(named: str)
                    if img == nil {
                        img = UIImage(contentsOfFile: str)
                    }
                    
                    self.imageView.image = img
                }
            } else if obj is Data {
                
                let data = obj as! Data
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    var imageView: UIImageView = {
       
        let img = UIImageView.init()
        
        return img
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.frame = self.contentView.bounds
        self.contentView.addSubview(self.imageView)
    }
}
