//
//  ISSAssistiveBtn.swift
//  CityCloud
//
//  Created by 潘永 on 2017/6/13.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit

class ISSAssistiveBtn: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    typealias HideMenuViewBlock = () -> Void
    typealias ClickBlock = () -> Void

    private var parent: UIView?
    private var panG: UIPanGestureRecognizer?
    var hideMenuBlock: HideMenuViewBlock?
    var clickBlock: ClickBlock?


    func addSelfByView(parentView: UIView) -> Void {

        parent = parentView
        if parentView.subviews.contains(self) {
            self.removeFromSuperview()
        }
        parentView.addSubview(self)

        if panG == nil {

            panG = UIPanGestureRecognizer.init(target: self, action: #selector(ISSAssistiveBtn.changePosition))
        }

        if self.gestureRecognizers != nil && (self.gestureRecognizers?.contains(panG!))! {

        } else {
            self.addGestureRecognizer(panG!)
        }

        self.addTarget(self, action: #selector(clickAction), for: .touchUpInside)

    }
    func clickAction() -> Void {
        if clickBlock != nil {
            clickBlock!()
        }
    }
    @objc private func changePosition(recognizer: UIPanGestureRecognizer) -> Void{

        if hideMenuBlock != nil {
            hideMenuBlock!()
        }
        let point = recognizer.translation(in: parent)

        let width: CGFloat = (parent?.bounds.size.width)!
        let height: CGFloat = (parent?.bounds.size.height)!

        var  originalFrame = self.frame

        if originalFrame.origin.x >= 0 && originalFrame.origin.x + originalFrame.size.width <= width {
            originalFrame.origin.x += point.x
        }
        if (originalFrame.origin.y >= 0 && originalFrame.origin.y+originalFrame.size.height <= height) {
            originalFrame.origin.y += point.y
        }

        self.frame = originalFrame
        recognizer.setTranslation(CGPoint.zero, in: parent)

        if panG?.state == UIGestureRecognizerState.began {
            self.isEnabled = false
        } else if panG?.state == UIGestureRecognizerState.changed {

            var frame = self.frame

            if (frame.origin.x < 0) {
                frame.origin.x = 0
            } else if (frame.origin.x + frame.size.width > width) {
                frame.origin.x = width - frame.size.width
            }

            if (frame.origin.y < 0) {
                frame.origin.y = 0
            } else if (frame.origin.y + frame.size.height > height) {
                frame.origin.y = height - frame.size.height
            }
            
            self.frame = frame;


        } else {

            var frame = self.frame

            if (self.center.x <= width / 2.0){
                frame.origin.x = 0
            }else
            {
                frame.origin.x = width - frame.size.width
            }

            if (frame.origin.y < 0) {
                frame.origin.y = 0
            } else if (frame.origin.y + frame.size.height > height) {
                frame.origin.y = height - frame.size.height
            }

            UIView.animate(withDuration: 0.3, animations: { 
                self.frame = frame
            })

            self.isEnabled = true

        }

        
    }
}
