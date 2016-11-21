//
//  LZTimer.swift
//  LZLoopView+Collection
//
//  Created by Artron_LQQ on 2016/11/21.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit

//typealias tempBlock = (Timer) -> Void
private class LZTempTarget: NSObject {
    
    weak var timer: Timer?
    weak var target: AnyObject?
    var selector: Selector?
    
//    var block: tempBlock?
    
    func fire() {
        
        if let tg = self.target {
            
            _ = tg.perform(self.selector)
        } else {
            
            self.timer?.invalidate()
        }
    }
}

class LZTimer {

//    static func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) {
//        
//        let temp = LZTempTarget()
//        
//        temp.block = { timer in
//            
//            block(timer)
//        }
//        
//        let timer: Timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: temp.block!)
//        
//        temp.timer = timer
//        
//        
//    }
    
    static func scheduledTimer(timeInterval interval: TimeInterval, target: Any, selector: Selector, userInfo: Any?, repeats: Bool) -> Timer? {
        
        let temp = LZTempTarget()
        
        temp.target = target as AnyObject?
        temp.selector = selector
        
        let timer = Timer.scheduledTimer(timeInterval: interval, target: temp, selector: #selector(temp.fire), userInfo: userInfo, repeats: repeats)
        
        temp.timer = timer
        
        return temp.timer
    }
}
