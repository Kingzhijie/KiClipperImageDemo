//
//  ViewController.swift
//  KiClipperImageDemo
//
//  Created by mbApple on 2017/11/15.
//  Copyright © 2017年 panda誌. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIActionSheetDelegate {
    
    lazy var clippedImageView: UIImageView? = {
        let clippedImageView = UIImageView(frame: CGRect(x: 20, y: 300, width: 300, height: 100))
        clippedImageView.backgroundColor = .red
        return clippedImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(self.clippedImageView!)
        let button = UIButton(type: .custom)
        button.backgroundColor = .red
        button.setTitle("不裁剪", for: .normal)
        button.frame = CGRect(x: 10, y: 100, width: 60, height: 60)
        button.addTarget(self, action:#selector(action1), for: .touchUpInside)
        button.sizeToFit()
        self.view.addSubview(button)
        
        let button2 = UIButton(type: .custom)
        button2.backgroundColor = .red
        button2.setTitle("系统裁剪", for: .normal)
        button2.frame = CGRect(x: 200, y: 100, width: 60, height: 60)
        button2.addTarget(self, action:#selector(action2), for: .touchUpInside)
        button2.sizeToFit()
        self.view.addSubview(button2)
        
        let button3 = UIButton(type: .custom)
        button3.backgroundColor = .red
        button3.setTitle("图片移动,裁剪框不移动", for: .normal)
        button3.frame = CGRect(x: 10, y: 200, width: 60, height: 60)
        button3.addTarget(self, action:#selector(action3), for: .touchUpInside)
        button3.sizeToFit()
        self.view.addSubview(button3)
        
        let button4 = UIButton(type: .custom)
        button4.backgroundColor = .red
        button4.setTitle("裁剪框移动,图片不动", for: .normal)
        button4.frame = CGRect(x: 250, y: 200, width: 60, height: 60)
        button4.addTarget(self, action:#selector(action4), for: .touchUpInside)
        button4.sizeToFit()
        self.view.addSubview(button4)
        
       KiClipperHelper.sharedInstance.nav = navigationController
       KiClipperHelper.sharedInstance.clippedImgSize = self.clippedImageView?.frame.size
       KiClipperHelper.sharedInstance.clippedImageHandler = {[weak self]img in
          self?.clippedImageView?.image = img
      }
        
    }
    
    @objc func action1() {  //直接系统方法获取图片, 不裁剪, 获取原图
        KiClipperHelper.sharedInstance.systemEditing = false
        KiClipperHelper.sharedInstance.isSystemType = true
        takePhoto()
    }
    @objc func action2() { //直接系统方法获取图片, 默认系统尺寸, 裁剪图片
        KiClipperHelper.sharedInstance.systemEditing = true
        KiClipperHelper.sharedInstance.isSystemType = true
        takePhoto()
    }
    @objc func action3() { //自定义裁剪图片, 图片移动, 裁剪框不移动
        KiClipperHelper.sharedInstance.clipperType = .Move
        KiClipperHelper.sharedInstance.systemEditing = false
        KiClipperHelper.sharedInstance.isSystemType = false
        takePhoto()
    }
    @objc func action4() { //自定义裁剪图片, 图片不移动, 裁剪框移动, 及自定义等比缩放大小
        KiClipperHelper.sharedInstance.clipperType = .Stay
        KiClipperHelper.sharedInstance.systemEditing = false
        KiClipperHelper.sharedInstance.isSystemType = false
        takePhoto()
    }
    
    func takePhoto() {
        let sheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "相册", "拍照")
        sheet.show(in: UIApplication.shared.keyWindow!)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int){
        DispatchQueue.main.async {
            if buttonIndex == 0 {
                //取消
            }else if buttonIndex == 1 {
                KiClipperHelper.sharedInstance.photoWithSourceType(type: .photoLibrary)
            }else if buttonIndex == 2 {
//                KiClipperHelper.sharedInstance.photoWithSourceType(type: .camera) //模拟机不支持相机
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

