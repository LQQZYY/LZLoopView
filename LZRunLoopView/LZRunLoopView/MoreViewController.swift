//
//  MoreViewController.swift
//  LZRunLoopView
//
//  Created by Artron_LQQ on 2016/11/16.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.green
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 20, y: 40, width: 40, height: 40)
        button.setTitle("X", for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(button)
        
        
        let arr = ["http://d.hiphotos.baidu.com/image/pic/item/0ff41bd5ad6eddc42223e3f13bdbb6fd536633f7.jpg",
                   "http://tupian.enterdesk.com/2012/1015/zyz/03/5.jpg",
                   "http://img.web07.cn/UpImg/Desk/201301/12/desk230393121053551.jpg",
                   "http://wallpaper.160.com/Wallpaper/Image/1280_960/1280_960_37227.jpg"]
        
        //
        let run = LZLoopView.loopView(withFrame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 150), dataSource: arr, interval: 2, didSelected: { index in
            
            print("selected: \(index)")
        }, didScrolled: { index in
            
            print("scrollEnd: \(index)")
        })
        
        run.titles = ["这是第一个视图的标题", "这是第二个视图的标题这是第二个视图的标题这是第二个视图的标题这是第二个视图的标题", "这是第三个标题", "这是第四个标题这是第四个标题这是第四个标题这是第四个标题这是第四个标题这是第四个标题这是第四个标题这是第四个标题这是第四个标题这是第四个标题这是第四个标题这是第四个标题这是第四个标题"]
        
        self.view.addSubview(run)
        
        
        let run1 = LZLoopView.init(WithDatasource: arr, interval: 2)
        
        run1.frame = CGRect(x: 0, y: 260, width: self.view.bounds.width, height: 100)
        
        run1.didSelected { (index) in
            
            print("selected: \(index)")
        }
        
        run1.didScrolled { (index) in
            
            print("scrollEnd: \(index)")
        }
        self.view.addSubview(run1)
        
        
        let run2 = LZLoopView()
            run2.frame = CGRect(x: 0, y: 370, width: self.view.bounds.width, height: 100)
            run2.interval = 2.0
        run2.dataSource = arr
        run2.addSubTitles(run.titles!, isHasBackground: true)
        self.view.addSubview(run2)
    }

    func btnClick() {
        
        LZLoopView.invalidateAllTimer()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
