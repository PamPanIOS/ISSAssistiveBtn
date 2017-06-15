//
//  ViewController.swift
//  TestAssistiveBtn
//
//  Created by 潘永 on 2017/6/15.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit

//设备屏幕尺寸
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
//设备缩放比例
public let IPHONE6P_BASE_RATIO = SCREEN_WIDTH / 414.0

class ViewController: UIViewController {

    var assistiveView: ISSAssistiveMenuView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configAssistiveView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configAssistiveView() -> Void {
        weak var __self = self

        // ISSAssistiveMenuView
        assistiveView = ISSAssistiveMenuView.init(images: ["a", "b"], titles: ["aaaaaaaaaaaaaaaaaaaaaaaa", "b"])
        assistiveView.isHidden = true

        // Menu的点击事件，index为menu的button tag
        assistiveView.menuBlock = {index -> Void in
            __self?.assistiveView.isHidden = true
            // Action
            print("clicked " + ["aaaaaaaaaaaaaaaaaaaaaaaa", "b"][index])

        }
        self.view.addSubview(assistiveView)

        // ISSAssistiveBtn
        let btn: ISSAssistiveBtn = ISSAssistiveBtn(type: UIButtonType.custom)
        btn.backgroundColor = UIColor.red

        // ISSAssistiveBtn的点击事件，用来隐藏MenuView
        btn.clickBlock = { Void -> Void in
            if __self?.assistiveView != nil {
                __self?.assistiveView.isHidden = !(__self?.assistiveView.isHidden)!
                __self?.assistiveView.resetFrame(frame: btn.frame)
            } else {
                // Action
            }

        }
        // ISSAssistiveBtn的移动事件，用来隐藏MenuView
        btn.hideMenuBlock = { Void -> Void in
            __self?.assistiveView.isHidden = true
        }

        let frame = UIScreen.main.bounds.size
        btn.frame = CGRect.init(x: frame.width - 60.0 * IPHONE6P_BASE_RATIO, y: frame.height/2, width: 60.0 * IPHONE6P_BASE_RATIO, height: 60.0 * IPHONE6P_BASE_RATIO)
        btn.addSelfByView(parentView: self.view)
    }

}

