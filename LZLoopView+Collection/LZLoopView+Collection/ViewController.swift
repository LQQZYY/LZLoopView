//
//  ViewController.swift
//  LZLoopView+Collection
//
//  Created by Artron_LQQ on 2016/11/17.
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

