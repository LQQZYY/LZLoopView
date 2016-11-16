//
//  UIImageView+cache.swift
//  LZRunLoopView
//
//  Created by Artron_LQQ on 2016/11/15.
//  Copyright © 2016年 Artup. All rights reserved.
//
// 此扩展根据 https://github.com/melvitax/ImageHelper 改写

import UIKit

var __currentSession: URLSession? = nil
extension UIImageView {

    func cancelCurrentRequest() {
        
        if __currentSession != nil {
            
            __currentSession?.invalidateAndCancel()
            __currentSession = nil
        }
    }
    
    func clearAllCache() {
        
        UIImageView.shared.removeAllObjects()
    }
    
    static var shared: NSCache<AnyObject, AnyObject>! {
        struct StaticSharedCache {
            static var shared: NSCache<AnyObject, AnyObject>? = NSCache()
            
            var session: URLSession?
        }
        
        return StaticSharedCache.shared!
    }
    
    
    func imageFromURL(_ url: String, placeholder: UIImage, fadeIn: Bool = true, shouldCacheImage: Bool = true, closure: ((_ image: UIImage?) -> ())? = nil)
    {
        self.image = self.image(fromURL: url, placeholder: placeholder, shouldCacheImage: shouldCacheImage) {
            (image: UIImage?) in
            if image == nil {
                return
            }
            self.image = image
            if fadeIn {
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionFade
                self.layer.add(transition, forKey: nil)
            }
            closure?(image)
        }
    }
    
    private func image(fromURL url: String, placeholder: UIImage, shouldCacheImage: Bool = true, closure: @escaping (_ image: UIImage?) -> ()) -> UIImage? {
        // From Cache
        if shouldCacheImage {
            if let image = UIImageView.shared.object(forKey: url as AnyObject) as? UIImage {
                closure(nil)
                return image
            }
        }
        // Fetch Image
        let session = URLSession(configuration: URLSessionConfiguration.default)
        __currentSession = session
        if let nsURL = URL(string: url) {
            session.dataTask(with: nsURL, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    DispatchQueue.main.async {
                        closure(nil)
                    }
                }
                if let data = data, let image = UIImage(data: data) {
                    if shouldCacheImage {
                        UIImageView.shared.setObject(image, forKey: url as AnyObject)
                    }
                    DispatchQueue.main.async {
                        closure(image)
                    }
                }
                session.finishTasksAndInvalidate()
            }).resume()
        }
        return placeholder
    }

}
