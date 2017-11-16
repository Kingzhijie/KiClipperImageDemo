//
//  KiViewController.swift
//  KiClipperImageDemo
//
//  Created by mbApple on 2017/11/15.
//  Copyright © 2017年 panda誌. All rights reserved.
//

import UIKit

class KiViewController: UIViewController {
    //MARK Public
    public func creatLeftBtnWithTitle(title:String) {
        if leftBtn == nil {
            leftBtn = UIButton(type: .custom)
            leftBtn?.frame = CGRect(x: 20, y: 20, width: TITLE_BAR_HEIGHT, height: TITLE_BAR_HEIGHT)
            leftBtn?.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            leftBtn?.contentHorizontalAlignment = .left
            leftBtn?.setTitle(title, for: .normal)
            leftBtn?.setTitleColor(UIColor.init(red: 0.118, green: 0.133, blue: 0.153, alpha: 1.0), for: .normal)
            leftBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            leftBtn?.addTarget(self, action: #selector(leftBtnTUI(btn:)), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn!)
        }
    }
    public func creaRightBtnWithTitle(title:String) {
        if rightBtn == nil {
            rightBtn = UIButton(type: .custom)
            rightBtn?.setTitleColor(UIColor.init(red: 0.118, green: 0.133, blue: 0.153, alpha: 1.0), for: .normal)
            rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            rightBtn?.addTarget(self, action: #selector(rightBtnTUI(btn:)), for: .touchUpInside)
            rightBtn?.layer.cornerRadius = 8
        }
        rightBtn?.sizeToFit()
        rightBtn?.setTitle(title, for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn!)
    }
    @objc public func leftBtnTUI(btn:UIButton) {
        
    }
    @objc public func rightBtnTUI(btn:UIButton) {
        
    }
    
    //MARK private
    private let TITLE_BAR_HEIGHT:Int = 44
    private var rightBtn:UIButton?
    private var leftBtn:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubViews()
        // Do any additional setup after loading the view.
    }
    
    private func loadSubViews() {
       self.hidesBottomBarWhenPushed = true
        if #available(iOS 11.0, *) {
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
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

extension UIBarButtonItem{
    class func barItemWithTarget(_ target:Any?,action:Selector,controlEvents:UIControlEvents,img:UIImage) -> UIBarButtonItem {
        let customBtn = UIButton(frame: CGRect(origin: CGPoint.zero, size: img.size))
        let center = customBtn.center
        let extendEdge = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
        customBtn.frame = CGRect(x: 0, y: 0, width: customBtn.frame.size.width + extendEdge.left + extendEdge.right, height: customBtn.frame.size.height + extendEdge.top + extendEdge.bottom)
        customBtn.center = center
        customBtn.imageEdgeInsets = extendEdge
        customBtn.addTarget(target, action: action, for: controlEvents)
        customBtn.setImage(img, for: .normal)
        return UIBarButtonItem(customView: customBtn)
    }
}
