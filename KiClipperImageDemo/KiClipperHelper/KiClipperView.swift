//
//  KiClipperView.swift
//  KiClipperImageDemo
//
//  Created by mbApple on 2017/11/15.
//  Copyright © 2017年 panda誌. All rights reserved.
//

import UIKit

enum ClipperType {
    case Move
    case Stay
}

class KiClipperView: UIView {
    
    public var resultImgSize:CGSize?{
        didSet{
          self.setClipperView()
        }
    }
    public var type:ClipperType = .Move
    public var baseImg:UIImage?{
        didSet{
            guard baseImg != nil else {return}
            var width = baseImg!.size.width
            var height = baseImg!.size.height
            if width != self.frame.size.width {
                width = self.frame.size.width
            }
            height = baseImg!.size.height / baseImg!.size.width * width
            if let clipperView = self.clipperView, height < clipperView.frame.height {
                height = clipperView.frame.height
            } else {
                height = 0
            }
            
            width = baseImg!.size.width / baseImg!.size.height * height
            let img = baseImg!.scaledToSize(newSize: CGSize(width: width, height: height), withScale: true)
            self.baseImgView!.image = img
            self.baseImgView!.frame = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
            correctBackImgView()
        }
    }
    private let minWidth:CGFloat = 60
    private var clipperView: UIImageView?
    
    private lazy var baseImgView: UIImageView? = {
        let baseImgView = UIImageView()
        self.addSubview(baseImgView)
        self.sendSubviewToBack(baseImgView)
        return baseImgView
    }()
    private lazy var fillLayer: CAShapeLayer? = {
        let fillLayer = CAShapeLayer()
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.5
        self.layer.addSublayer(fillLayer)
        return fillLayer
    }()
    private var panTouch:CGPoint = .zero
    private var scaleDistance:CGFloat = 0 //缩放距离
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubViews()
    }
    //MARK Public
    public func clipImg() -> UIImage {
        let scale = UIScreen.main.scale * (self.baseImgView?.image?.size.width)!/(self.baseImgView?.frame.size.width)!
        let rect = self.convert((self.clipperView?.frame)!, to: self.baseImgView)
        let rect2 = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        let cgImg = self.baseImgView?.image?.cgImage?.cropping(to: rect2)
        let clippedImg = UIImage.init(cgImage: cgImg!)
        return clippedImg
    }

    private func loadSubViews() {
        self.layer.contentsGravity = CALayerContentsGravity.resizeAspect
    }
    
    private func setClipperView() {
        let kscWidth = UIScreen.main.bounds.size.width
        let kscHeight = UIScreen.main.bounds.size.height - 64
        var width = kscWidth
        var height = kscHeight
        if let resultImgSize = self.resultImgSize {
            if resultImgSize.width > resultImgSize.height / height * width {
                height = kscWidth / resultImgSize.width * resultImgSize.height
            }else{
                width = kscHeight / resultImgSize.height * resultImgSize.width
            }
        }
        let y = (kscHeight - height)/2
        let x = (kscWidth - width)/2
        clipperView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        clipperView?.layer.borderColor = UIColor.white.cgColor
        clipperView?.layer.borderWidth = 2
        self.addSubview(clipperView!)
        
        correctFillLayer()
    }
    
    //MARK Touches  (注意问题::::)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let allTouches = event?.allTouches, allTouches.count == 1 else {return}
        panTouch = allTouches.first!.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.willChangeValue(forKey: "crop")
        guard let allTouches = event?.allTouches else {
            return
        }
        switch allTouches.count {
        case 1:
            let touchCurrent = allTouches.first!.location(in: self)
            let x = touchCurrent.x - panTouch.x
            let y = touchCurrent.y - panTouch.y
            switch type {
            case .Move:
                self.baseImgView!.center = CGPoint(x: self.baseImgView!.center.x + x, y: self.baseImgView!.center.y + y)
               break
            case .Stay:
                self.clipperView?.center = CGPoint(x: self.clipperView!.center.x + x, y: self.clipperView!.center.y + y)
                break
            }
         panTouch = touchCurrent
         break
        case 2:
            switch type {
            case .Move:
                self.scaleView(self.baseImgView!, touches: (allTouches as NSSet).allObjects)
                break
            case .Stay:
                self.scaleView(self.clipperView!, touches: (allTouches as NSSet).allObjects)
                break
            }
            break
        default:
            break
        }
        correctFillLayer()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .Move:
            correctBackImgView()
            break
        case .Stay:
            correctClipperView()
            break
        }
    }
    
    //MARK Correct
    private func correctBackImgView(){
        guard self.clipperView != nil, self.baseImgView != nil else {return}
        var x = self.baseImgView!.frame.origin.x
        var y = self.baseImgView!.frame.origin.y
        var height = self.baseImgView!.frame.size.height
        var width = self.baseImgView!.frame.size.width
        
        if width < self.clipperView!.frame.size.width {
            width = self.clipperView!.frame.size.width
            height = width / self.baseImgView!.frame.size.width * height
        }
        if height < self.clipperView!.frame.size.height {
            height = self.clipperView!.frame.size.height
            width = height / self.baseImgView!.frame.size.height * width
        }
        
        if x > self.clipperView!.frame.origin.x {
            x = self.clipperView!.frame.origin.x
        } else if x < (self.clipperView!.frame.origin.x + self.clipperView!.frame.size.width - width){
            x = self.clipperView!.frame.origin.x + self.clipperView!.frame.size.width - width
        }
        
        if y > self.clipperView!.frame.origin.y {
            y = self.clipperView!.frame.origin.y
        } else if y < self.clipperView!.frame.origin.y + self.clipperView!.frame.size.height - height {
            y = self.clipperView!.frame.origin.y + self.clipperView!.frame.size.height - height
        }
        
        self.baseImgView?.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func correctClipperView(){
        guard self.clipperView != nil, self.baseImgView != nil else {return}
        var width = self.clipperView!.frame.size.width
        var height:CGFloat = 0.0
        if width < minWidth {
            width = minWidth
        }
        if width > UIScreen.main.bounds.size.width {
            width = UIScreen.main.bounds.size.width
        }
        height = width / self.resultImgSize!.width * self.resultImgSize!.height
        var x = self.clipperView!.frame.origin.x
        var y = self.clipperView!.frame.origin.y
        if x < self.baseImgView!.frame.origin.x {
            x = self.baseImgView!.frame.origin.x
        }
        if x > UIScreen.main.bounds.size.width - width {
            x = UIScreen.main.bounds.size.width - width
        }
        if y < self.baseImgView!.frame.origin.y {
            y = self.baseImgView!.frame.origin.y
        }
        let tempy = self.baseImgView!.frame.origin.y + self.baseImgView!.frame.size.height - self.clipperView!.frame.size.height
        if y > tempy{
            y = self.baseImgView!.frame.origin.y + self.baseImgView!.frame.size.height - self.clipperView!.frame.size.height
        }
        self.clipperView?.frame = CGRect(x: x, y: y, width: width, height: height)
        correctFillLayer()
    }

    private func correctFillLayer() {
        let path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: 0)
        let circlePath = UIBezierPath.init(roundedRect: (clipperView?.frame)!, cornerRadius: 0)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        self.fillLayer?.path = path.cgPath
    }
    
    //MARK Correct
    private func scaleView(_ view:UIView,touches:Array<Any>){
        let touch1 = (touches[0] as AnyObject).location(in: self)
        let touch2 = (touches[1] as AnyObject).location(in: self)
        let distance = self.distanceBetweenTwoPoints(touch1, toPoint: touch2)
        if scaleDistance > 0 {
            var imgFrame = view.frame
            if distance > scaleDistance + 2{
                imgFrame.size.width += 10
                scaleDistance  = distance
            }
            if distance < scaleDistance - 2 {
                imgFrame.size.width -= 10
                scaleDistance = distance
            }
            if type == .Stay{ //图片不动
                imgFrame.size.height = view.frame.height * imgFrame.width / view.frame.width
                let mainWidth = UIScreen.main.bounds.width
                let imgWidth = imgFrame.width > mainWidth ? mainWidth : imgFrame.width
                let imgHeight = imgWidth * resultImgSize!.height / (resultImgSize!.width == 0 ? 1 : resultImgSize!.width)
                let addwidth = imgWidth - view.frame.width
                let addheight = imgHeight - view.frame.height
                if imgHeight != 0 && imgWidth != 0{
                    view.frame = CGRect(x:imgFrame.origin.x - addwidth/2.0, y: imgFrame.origin.y - addheight/2.0, width: imgWidth, height: imgHeight)
                }
            }else{ //图片移动
                imgFrame.size.height = view.frame.height * imgFrame.size.width / view.frame.width
                let addwidth = imgFrame.size.width - view.frame.size.width
                let addheight = imgFrame.size.height - view.frame.size.height
                let cripWidth = imgFrame.size.width - clipperView!.frame.width
                let cripHeight = imgFrame.size.height - clipperView!.frame.height
                
                if imgFrame.size.width != 0 && imgFrame.size.height != 0 && cripWidth > -5 && cripHeight > -5 {
                    view.frame = CGRect(x:imgFrame.origin.x - addwidth/2.0, y: imgFrame.origin.y - addheight/2.0, width: imgFrame.width, height: imgFrame.height)
                }
            }
        }else{
            scaleDistance = distance
        }
    }
    
    private func distanceBetweenTwoPoints(_ fromPoint:CGPoint,toPoint:CGPoint) -> CGFloat {
        let x = toPoint.x - fromPoint.x
        let y = toPoint.y - fromPoint.y
        return CGFloat(sqrtf(Float(x * x + y * y)))
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

extension UIImage{
    func scaledToSize(newSize:CGSize,withScale:Bool) -> UIImage {
        var scale:CGFloat = 1
        if withScale {
            scale = UIScreen.main.scale
        }
        let mynewSize = CGSize(width: newSize.width * scale, height: newSize.height * scale)
        UIGraphicsBeginImageContextWithOptions(mynewSize, false, 0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: mynewSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}
