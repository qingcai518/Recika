//
//  CameraController.h
//  SampleReceiptCamera8M
//
//  Created by Admin on 2017/06/06.
//  Copyright © 2017年 ISP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Common.h"
#import "ResultController.h"

@interface CameraController : UIViewController <AVCapturePhotoCaptureDelegate>
{
    __weak IBOutlet UIButton *mButtonBack;
    __weak IBOutlet UIButton *mButtonTorchOff;
    __weak IBOutlet UIButton *mButtonTorchOn;
    __weak IBOutlet UIButton *mButtonShutter;
    __weak IBOutlet UIButton *mButtonGuide;
    __weak IBOutlet UIButton *mButtonNormal;
    __weak IBOutlet UIButton *mButtonLong;
    __weak IBOutlet UIView *mCameraBaseView;
    __weak IBOutlet UIView *mGuideView;

    UIView *mCameraView;
    UIView *mLeftLineView;
    UIView *mRightLineView;
    UIView *mLeftMaskView;
    UIView *mRightMaskView;
    UIView *mLeftMaskLineView;
    UIView *mRightMaskLineView;
    UIImageView *mReceiptImageView;

    NSInteger mAnalyzeType;

    AVCaptureSession *mSession;
    AVCaptureDeviceInput *mVideoInput;
    AVCaptureStillImageOutput *mStillImageOutput;
    AVCapturePhotoOutput *mPhotoOutput;
    
    BOOL mIsAnalyzing;

    NSData *mPicData;
    CGSize mPicSize;
    CGSize mOcrSize;
    AnalyzerReceiptInfo mAnalyzerReceiptInfo;
    NSMutableArray *mReceiptImage;
    
    NSString* mResultText;
    
    NSInteger mLongReceiptNum;
    
    UIAlertController *mMessageAlert;
    UIAlertController *mAnalyzingAlert;
    UIAlertController *mResultAlert;

    UIAlertAction *mNextAction;
    UIAlertAction *mFinishAction;
    UIAlertAction *mCancelAction;
    
    dispatch_queue_t mMainQueue;
    dispatch_queue_t mSubQueue;
}

@end

