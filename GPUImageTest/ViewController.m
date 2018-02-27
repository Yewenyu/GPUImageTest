//
//  ViewController.m
//  GPUImageTest
//
//  Created by 叶文宇 on 2018/2/1.
//  Copyright © 2018年 叶文宇. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
#import "Swift.h"

@interface ViewController ()

@property (weak,nonatomic)IBOutlet MainView *mainView;
@property (weak, nonatomic) IBOutlet GPUImageView *mGPUImageView;
@property (nonatomic , strong) GPUImageVideoCamera *mGPUVideoCamera;
@property (nonatomic,strong)GPUImageStillCamera *mGPUStillCamera;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    GPUImageSepiaFilter* filter = [[GPUImageSepiaFilter alloc] init];
//    //哈哈镜效果
//    GPUImageStretchDistortionFilter *stretchDistortionFilter = [[GPUImageStretchDistortionFilter alloc] init];
//    self.mGPUVideoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
//    self.mGPUImageView.fillMode = kGPUImageFillModeStretch;//kGPUImageFillModePreserveAspectRatioAndFill;
//    [self.mGPUVideoCamera addTarget:stretchDistortionFilter];
//    [stretchDistortionFilter addTarget:self.mGPUImageView];
//    [self.mGPUVideoCamera addTarget:self.mGPUImageView];
//    [self.mGPUVideoCamera startCameraCapture];
    
//    self.mGPUStillCamera = [[GPUImageStillCamera alloc]initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
//    self.mGPUStillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    [self.mGPUStillCamera addTarget:stretchDistortionFilter];
//    [stretchDistortionFilter addTarget:self.mGPUImageView];
//    [self.mGPUStillCamera startCameraCapture];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    self.mGPUVideoCamera.outputImageOrientation = orientation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
