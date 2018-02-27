//
//  MainView.swift
//  GPUImageTest
//
//  Created by 叶文宇 on 2018/2/1.
//  Copyright © 2018年 叶文宇. All rights reserved.
//

import UIKit
import Photos

class MainView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    fileprivate var cameraView : GPUImageView?
    fileprivate var filterScrollView : BaseScrollView?
    fileprivate var cameraScrollView : BaseScrollView?
    fileprivate var startCameraButton : BaseButton?
    
    
    fileprivate var filterArray : Array<GPUImageFilter?>?
    fileprivate var cameraArray : Array<GPUImageVideoCamera?>?
    fileprivate var currentCamera : AnyObject?
    fileprivate var currentFilter : AnyObject?
    fileprivate var movieWriter : GPUImageMovieWriter?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
    
}

//初始化视图
extension MainView{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let sizeScale = CGPoint.init(x: 1, y: 2.0/3)
        let elseViewScale = CGPoint.init(x: 1, y: (1-sizeScale.y)/3)
        var cameraSizeScale = sizeScale;
        cameraSizeScale.y += elseViewScale.y*2
        
        cameraView?.sizeAdjust(fromView: self, andScale: cameraSizeScale)
        
        filterScrollView?.sizeAdjust(fromView: self, andScale: elseViewScale)
        cameraScrollView?.sizeEqual(toView: filterScrollView)
        startCameraButton?.squareSize(withLength: (cameraScrollView?.frame.size.height)!)
        
        filterScrollView?.setFrameOrigin(CGPoint.init(x: 0, y: self.bounds.size.height*sizeScale.y))
        cameraScrollView?.posDownAdjust(fromView: filterScrollView, andOffset: CGPoint.zero)
        startCameraButton?.posDownAdjust(fromView: cameraScrollView, andOffset: CGPoint.zero, isCenter: true)
        
        
    }
    fileprivate func initView(){
        cameraView = GPUImageView.init(frame: CGRect.zero)
        self.addSubview(cameraView!)
        self.initFilterScrollview()
        self.initCameraScrollview()
        startCameraButton = BaseButton.createButton(CGRect.zero, name: "照相", andAction: #selector(startCameraButtonAction(button:)), andTarget: self) as? BaseButton
        self.addSubview(startCameraButton!)
        
        self.layoutSubviews()
    }
    private func initFilterScrollview(){
        let filterNames = ["默认","哈哈镜","怀旧"]
        let filterId = [0,1,2]
        filterScrollView = BaseScrollView.init(frame: CGRect.zero, andnameArray: filterNames, andIdArray: filterId)
        filterScrollView?.currentAlpha = 0.1;
        filterScrollView?.tag = 0
        filterScrollView?.baseScrollViewDelegate = self
        self.addSubview(filterScrollView!)
        self.initFilters()
    }
    private func initCameraScrollview(){
        let cameraNames = ["照相","录像"]
        let Ids = [0,1]
        cameraScrollView = BaseScrollView.init(frame: CGRect.zero, andnameArray: cameraNames, andIdArray: Ids)
        cameraScrollView?.currentAlpha = 0.1;
        cameraScrollView?.tag = 1
        cameraScrollView?.baseScrollViewDelegate = self
        self.addSubview(cameraScrollView!)
        self.initCameras()
    }
}

//按钮事件
extension MainView{
    @objc fileprivate func startCameraButtonAction(button:BaseButton){
        
        //定格一张图片 保存到相册
        if(button.name == "照相"){
           
            self.currentCamera?.capturePhotoAsPNGProcessedUp(toFilter: self.currentFilter as! GPUImageOutput, withCompletionHandler: { (processedPNG, error1) in
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: UIImage.init(data: processedPNG!)!)
                }, completionHandler: { (success, error2) in
                    
                })
            })
        }else if(button.name == "录像"){
            self.recordTheVideoAction(button: button)
        }
    }
    private func recordTheVideoAction(button:BaseButton){
        button.isDown = !button.isDown
        
        let moviePath = YeFileManager.gethPath(PathDirectory.DocumentsDirectory)+"/Movie4.m4v"
        
        let movieUrl = URL.init(fileURLWithPath: moviePath)
        if(button.isDown){
            button.titleLabel?.text = "停止"
            print("开始录像")
            movieWriter = GPUImageMovieWriter.init(movieURL: movieUrl, size: CGSize.init(width: 480, height: 640))
            
            movieWriter?.encodingLiveVideo = true
            self.currentFilter?.addTarget(movieWriter)
            (self.currentCamera as! GPUImageVideoCamera).audioEncodingTarget = movieWriter
            movieWriter?.startRecording()
            
        }else{
            button.titleLabel?.text = "录像"
            print("停止录像")
            self.currentFilter?.removeTarget(movieWriter)
            (self.currentCamera as! GPUImageVideoCamera).audioEncodingTarget = nil
            movieWriter?.finishRecording()
            
            if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)){
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: movieUrl)
                }, completionHandler: { (success, error2) in
                    let currentController = BaseViewController.getCurrentViewController()
                   YeFileManager.deleteFile(atPath: moviePath)
                    let titleText = "提示"
                    var message = "保存成功"
                    if(!success){
                        
                        message = "保存失败"
                    }
                    let alertView = UIAlertController.init(title: titleText, message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alertView.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
                    
                    currentController?.present(alertView, animated: true, completion: nil)
                })
                
            }
            
        }
    }
}
//代理事件
extension MainView:BaseScrollViewDelegate{
    func baseScrollViewSegmentBtnSelectAction(_ button: BaseButton!, andView view: Any!) {
        
        let tag = (view as! BaseScrollView).tag
        let index = button.targetIndex
        if(tag == 0){
            selectFilter(index: index)
        }else if(tag == 1){
            selectCamera(index: index)
            self.startCameraButton?.titleLabel?.text = button.titleLabel?.text
            self.startCameraButton?.name = button.titleLabel?.text
        }
    }
    private func selectFilter(index:Int){
        self.currentFilter?.removeAllTargets()
        self.currentCamera?.removeAllTargets()
        
        let filter = filterArray![index]
        self.currentCamera?.addTarget(filter)
        filter?.addTarget(self.cameraView)
        self.currentFilter = filter
    }
    private func selectCamera(index:Int){
        //self.currentFilter?.removeAllTargets()
        self.currentCamera?.removeAllTargets()
        (self.currentCamera as! GPUImageVideoCamera).stopCapture()
        let camera = cameraArray![index]
        if(self.currentFilter != nil){
            camera?.addTarget(self.currentFilter as! GPUImageInput)
        }else{
            camera?.addTarget(self.cameraView)
        }
        camera?.startCapture()
        self.currentCamera = camera
        
    }
}
//滤镜和相机初始化
extension MainView{
    
    fileprivate func initFilters(){
        
        self.filterArray = Array.init()
        //正常
        let normalFilter = GPUImageFilter.init()
        self.filterArray?.append(normalFilter)
        //哈哈镜效果
        let stretchDistortionFilter = GPUImageStretchDistortionFilter.init()
        self.filterArray?.append(stretchDistortionFilter)
        //怀旧
        let sepiaFilter = GPUImageSepiaFilter.init()
        self.filterArray?.append(sepiaFilter)
    }
    fileprivate func initCameras(){
        
        self.cameraArray = Array.init()
        let stillCamera = GPUImageStillCamera.init(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: AVCaptureDevicePosition.front)
        self.cameraArray?.append(stillCamera)
        let videoCamera = GPUImageVideoCamera.init(sessionPreset: AVCaptureSessionPreset640x480, cameraPosition: AVCaptureDevicePosition.front)
        videoCamera?.outputImageOrientation = UIInterfaceOrientation.portrait
        self.cameraArray?.append(videoCamera)
        
        self.currentFilter = filterArray![0]
        stillCamera?.addTarget(self.currentFilter as! GPUImageInput)
        self.currentFilter?.addTarget(self.cameraView)
        stillCamera?.outputImageOrientation = UIInterfaceOrientation.portrait
        self.cameraView?.backgroundColor = UIColor.red
        self.cameraView?.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
        stillCamera?.startCapture()
        self.currentCamera = stillCamera
        
    }
}
