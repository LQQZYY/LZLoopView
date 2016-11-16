//
//  ViewController.swift
//  LZRunLoopView
//
//  Created by Artron_LQQ on 2016/11/14.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 40)
        button.setTitle("单个loopView", for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(button)
        
        
        let button1 = UIButton(type: .custom)
        button1.frame = CGRect(x: 100, y: 200, width: 200, height: 40)
        button1.setTitle("多个loopView", for: .normal)
        button1.backgroundColor = UIColor.red
        button1.addTarget(self, action: #selector(moreBtnClick), for: .touchUpInside)
        self.view.addSubview(button1)
    }

    func moreBtnClick() {
        let more = MoreViewController()
        
        self.present(more, animated: true, completion: nil)
    }
    func btnClick() {
        
        let test = TestViewController()
        
        self.present(test, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

