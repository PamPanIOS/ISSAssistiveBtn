//
//  ISSAssistiveMenuView.swift
//  CityCloud
//
//  Created by 潘永 on 2017/6/13.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit

final class ISSAssistiveMenuView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    enum ExpandOrientation {
        case up
        case down
    }
    enum TextPosition {
        case left
        case right
    }

    typealias MenuActionBlock = (Int) -> Void

    var menuArray: [UIButton]?
    var titleArray: [UILabel]?
    var expandOri: ExpandOrientation = .up
    var textPos: TextPosition = .left
    var maxLabelWidth: CGFloat = 0


    var menuBlock: MenuActionBlock?

    let kButtonWidth = 60.0 * IPHONE6P_BASE_RATIO
    let kButtonSpace = 20.0 * IPHONE6P_BASE_RATIO
    let kLabelFontSize = 14.0 * IPHONE6P_BASE_RATIO
    let kLabelSpace = 20.0 * IPHONE6P_BASE_RATIO

    init(images: Array<Any>, titles: Array<String>?) {

        super.init(frame: CGRect.zero)
        menuArray = []
        titleArray = []

        self.backgroundColor = UIColor.clear
        self.isHidden = false

        let viewHeight = (CGFloat)(images.count + 1) * kButtonWidth + (CGFloat)(images.count) * kButtonSpace
        var viewWidth = kButtonWidth

        if titles != nil {
            assert(titles?.count == images.count, "文字数组的数量和图片数组的数量不同")
            var string: String = ""
            var labelWidth: CGFloat = 0.0

            var length: Int = 0
            let _ = titles?.reduce(0) {index,title in

                if title.characters.count > length{
                    length = title.characters.count
                    string = title
                }
                return index
            }

            labelWidth = self.getLabWidth(labelStr: string, font: UIFont.systemFont(ofSize: kLabelFontSize), height: kButtonWidth)
            maxLabelWidth = max(labelWidth, 20)
        }

        viewWidth = viewWidth + maxLabelWidth + kLabelSpace
        let bounds = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewWidth, height: viewHeight))
        self.frame = bounds


        //生成BtnList
        for i in 0 ..< images.count {
            let menuBtn = UIButton.init(type: .custom)
            menuBtn.frame = CGRect.init(origin: .zero, size: CGSize.init(width: kButtonWidth, height: kButtonWidth))
            menuBtn.backgroundColor = UIColor.red
            menuBtn.tag = i
            menuBtn.addTarget(self, action: #selector(MenuAction), for: .touchUpInside)
            self.addSubview(menuBtn)

            let imageObj = images[i]

            if imageObj is UIImage {
                menuBtn.setImage(imageObj as? UIImage, for: .normal)
            } else if imageObj is NSData {
                menuBtn.setImage(UIImage.init(data: (imageObj as? Data)!), for: .normal)
            } else if imageObj is String {
                let urlString = imageObj as? String
                menuBtn.setImage(UIImage.init(named: urlString!), for: .normal)
            }

            menuArray?.append(menuBtn)

            if titles != nil {

                let label = UILabel.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: maxLabelWidth, height: kButtonWidth)))
                label.isUserInteractionEnabled = false
                label.backgroundColor = UIColor.clear
                label.textColor = UIColor.black
                label.textAlignment = .right
                label.font = UIFont.systemFont(ofSize: kLabelFontSize)
                label.tag = i
                self.addSubview(label)

                let title = titles?[i]
                if title != nil {
                    label.text = title
                }

                titleArray?.append(label)
            }


        }

    }
    convenience init(images: Array<Any>) {

        self.init(images: images, titles: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {

        let statusLabelText: String = labelStr

        let size = CGSize.init(width: SCREEN_WIDTH - kButtonWidth - kLabelSpace, height: height)

        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)

        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size

        return strSize.width

    }

    func MenuAction(button: UIButton) -> Void {
        if menuBlock != nil {
            menuBlock!(button.tag)
        }
    }

    public func resetFrame(frame: CGRect) -> Void {
        //判断位置在左边还是右边
        if frame.origin.x <= 10 {
            textPos = .right
        } else if frame.origin.x >= SCREEN_WIDTH - kButtonWidth - 10 {
            textPos = .left
        }
        // View应该滑向上方
        if frame.origin.y > self.frame.size.height {

            if textPos == .left {
                self.frame.origin = CGPoint.init(x: SCREEN_WIDTH -  self.frame.size.width, y: frame.origin.y - self.frame.size.height + frame.size.width)
            } else {
                self.frame.origin = CGPoint.init(x: 0, y: frame.origin.y - self.frame.size.height + frame.size.width)
            }
            expandOri = .up
        } else {// View应该滑向下方

            if textPos == .left {
                self.frame.origin = CGPoint.init(x: SCREEN_WIDTH -  self.frame.size.width, y: frame.origin.y)
            } else {
                self.frame.origin = CGPoint.init(x: 0, y: frame.origin.y)
            }
            expandOri = .down
        }


        // 计算出base位置 也就是动画开始的地方
        var basePoint: CGPoint = CGPoint.zero
        var baseX: CGFloat = 0
        var baseY: CGFloat = 0


        if textPos == .left {
            baseX = self.frame.size.width - kButtonWidth / 2
        } else {
            baseX = kButtonWidth / 2
        }

        if expandOri == .up {
            baseY = self.frame.size.height - kButtonWidth / 2
        } else {
            baseY = kButtonWidth / 2
        }

        basePoint = CGPoint.init(x: baseX, y: baseY)

        for textLabel in titleArray! {
            textLabel.alpha = 0.0
        }
        for menuBtn in menuArray! {

            var realCenter = basePoint
            menuBtn.center = realCenter

            var posY = basePoint.y
            let index = menuArray?.index(of: menuBtn)

            if expandOri == .up {
               posY = basePoint.y - (CGFloat)(index! + 1) * (kButtonWidth + kButtonSpace)
            } else {
                posY = basePoint.y + (CGFloat)(index! + 1) * (kButtonWidth + kButtonSpace)
            }

            realCenter.y = posY

            UIView.animate(withDuration: 0.3, delay: 0.05 * (Double)(index!), usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                menuBtn.center = realCenter
            }, completion: nil)


            // 设置label
            guard titleArray != nil && titleArray?.count == menuArray?.count else {
                continue
            }

            let titleLabel = titleArray?[index!]

            if textPos == .left {
                titleLabel?.center = CGPoint.init(x: menuBtn.frame.origin.x - kLabelSpace - maxLabelWidth / 2.0, y: menuBtn.center.y)
                titleLabel?.textAlignment = .right
            } else {
                titleLabel?.center = CGPoint.init(x: menuBtn.frame.origin.x + kButtonWidth + kLabelSpace + maxLabelWidth / 2.0, y: menuBtn.center.y)
                titleLabel?.textAlignment = .left
            }

            // label渐隐
            UIView.animate(withDuration: 0.3, delay: 0.1 + 0.05 * (Double)(index!), options: .curveEaseInOut, animations: {
                titleLabel?.alpha = 1.0
            }, completion: nil)

        }
    }
}
