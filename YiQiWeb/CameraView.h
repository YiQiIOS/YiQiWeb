//
//  CameraView.h
//  YiQiWeb
//
//  Created by BK on 14/11/25.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Redraw.h"
#import "ZBarSDK.h"
@interface CameraView : UIViewController<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBarReaderDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    NSString *webUrl;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;

@end
