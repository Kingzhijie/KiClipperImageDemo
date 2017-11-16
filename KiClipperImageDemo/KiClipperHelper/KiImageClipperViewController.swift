//
//  KiImageClipperViewController.swift
//  KiClipperImageDemo
//
//  Created by mbApple on 2017/11/15.
//  Copyright © 2017年 panda誌. All rights reserved.
//

import UIKit
typealias cancelClippedHandlerBlock = ()->Void
typealias successClippedHandlerBlock = (_ clippedImage:UIImage)->Void
class KiImageClipperViewController: KiViewController {
    //MARK Public
    public var cancelClippedHandler:cancelClippedHandlerBlock?
    public var successClippedHandler:successClippedHandlerBlock?
    public func setBaseImg(_ baseImg:UIImage,resultImgSize:CGSize,type:ClipperType) {
        clipperView = KiClipperView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64))
        clipperView?.resultImgSize = resultImgSize
        clipperView?.baseImg = baseImg
        clipperView?.type = type
        self.view.addSubview(clipperView!)
    }

    //MARK Private
    private var clipperView:KiClipperView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择图片"
        view.backgroundColor = .black
        self.creatLeftBtnWithTitle(title: "取消")
        self.creaRightBtnWithTitle(title: "确认")
        // Do any additional setup after loading the view.
    }
    
    override func leftBtnTUI(btn: UIButton) {
        if cancelClippedHandler != nil {
            cancelClippedHandler!()
        }
    }
    
    override func rightBtnTUI(btn: UIButton) {
        let clippedImg = self.clipperView?.clipImg()
        if successClippedHandler != nil {
            successClippedHandler!(clippedImg ?? UIImage())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
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
