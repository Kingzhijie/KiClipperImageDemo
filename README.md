# KiClipperImageDemo
	###图片裁剪工具类###
	##工具提供四种方式: 获取图片##
	1. 直接获取图片
	2. 直接获取图片, 并使用系统的编辑功能
	3. 自定义裁剪图片, 设置好裁剪框的尺寸, 图片可以自由拖动和缩放
	4. 自定义裁剪图片, 图片不移动, 自由拖动或者缩放裁剪框

	使用方法 : 使用单例工具类 KiClipperHelper

	   KiClipperHelper.sharedInstance.nav = navigationController  //获取当前导航
       KiClipperHelper.sharedInstance.clippedImgSize = size  // 传入, 自定义的裁剪尺寸 (不需要裁剪, 可以不传)
       //获取图片成功的回调  img 即为目标图片
       KiClipperHelper.sharedInstance.clippedImageHandler = {[weak self]img in
          self?.clippedImageView?.image = img
      }

      ##参数说明: ##
    public var clippedImageHandler:clippedImageHandlerBlock? //裁剪结束回调
    public var systemEditing = false // 系统方式获取图片时, 是否允许系统编辑裁剪
    public var isSystemType = false //是否系统方式获取图片
    public var clippedImgSize:CGSize?  //自定义裁剪的尺寸
    public weak var nav:UINavigationController? //当前导航
    public var clipperType:ClipperType = .Move //裁剪框移动类型 (move图片移动, stay裁剪框移动)
    ###方法说明###
    //制定获取图片的方式, 相册或者相机
    public func photoWithSourceType(type:UIImagePickerControllerSourceType)
    //代理方法 , 获取图片后的回调方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])