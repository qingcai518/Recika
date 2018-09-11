//
//  CameraController.m
//  SampleReceiptCamera8M
//
//  Created by Admin on 2017/06/06.
//  Copyright © 2017年 ISP. All rights reserved.
//

#import "CameraController.h"

@interface CameraController ()

@end

@implementation CameraController

#pragma mark - For Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"UnwindSegueBackTop"]) {
        // カメラ解放
        [self releaseAVSession];
        [self releaseObjects];
        return;
    }
    if ([segue.identifier isEqualToString:@"SegueShowResult"]) {
        // カメラ解放
        [self releaseAVSession];
        // 解析結果セット
        ResultController *controller = segue.destinationViewController;
        [controller setAnalyzeResult:&mAnalyzerReceiptInfo picSize:mPicSize ocrSize:mOcrSize receiptImage:mReceiptImage];
        if (mReceiptImage != nil) {
            [mReceiptImage removeAllObjects];
        }
        if (mAnalyzeType == ANALYZE_TYPE_LONG) {
            [self cancelReceiptAnalyzeLong];
        }
        return;
    }
}

- (void)backTop {
    [self performSegueWithIdentifier:@"UnwindSegueBackTop" sender:self];
}

- (void)showResult {
    [self performSegueWithIdentifier:@"SegueShowResult" sender:self];
}

#pragma mark - Unwind Segue
- (IBAction)unwindBackCamera:(UIStoryboardSegue *)segue { }

#pragma mark - Func
- (int)getAspectRatioKind:(int)width height:(int)height
{
    if (width * 3 == height * 4 || width * 4 == height * 3) {
        // 4:3
        return ASPECT_RATIO_STANDARD;
    } else if (width * 9 == height * 16 || width * 16 == height * 9) {
        // 16:9
        return ASPECT_RATIO_WIDE;
    } else {
        return ASPECT_RATIO_OTHER;
    }
}

#pragma mark - Receipt Func
+ (NSString *)getReceiptResult:(AnalyzerReceiptInfo *)analyzerReceiptInfo {
    NSMutableString *result = [NSMutableString string];
    // 日時
    [result appendFormat:@"日付: %04d/%02d/%02d %02d:%02d:%02d\n", analyzerReceiptInfo->date.year, analyzerReceiptInfo->date.month, analyzerReceiptInfo->date.day, analyzerReceiptInfo->date.hour, analyzerReceiptInfo->date.minute, analyzerReceiptInfo->date.second];
    // 電話番号
    if (analyzerReceiptInfo->tel != nil) {
        [result appendFormat:@"電話番号: %@\n", analyzerReceiptInfo->tel];
    } else {
        [result appendFormat:@"電話番号: \n"];
    }
    
    // 合計
    [result appendFormat:@"合計金額: ￥%d\n", analyzerReceiptInfo->total];
    // 調整金額
    [result appendFormat:@"調整金額: ￥%d\n", analyzerReceiptInfo->priceAdjustment];
    // 品目
    for (int i = 0; i < analyzerReceiptInfo->cnt; i++) {
        // 品目名 金額
        if (analyzerReceiptInfo->items[i].name != nil) {
            [result appendFormat:@"品目%d: %@ ￥%d\n", (i+1), analyzerReceiptInfo->items[i].name, analyzerReceiptInfo->items[i].price];
        } else {
            [result appendFormat:@"品目%d: ￥%d\n", (i+1), analyzerReceiptInfo->items[i].price];
        }
        // 単価 個数
        [result appendFormat:@"(単価: ￥%d, 個数: %d)\n", analyzerReceiptInfo->items[i].unitPrice, analyzerReceiptInfo->items[i].itemNum];
        // JANコード
        if (analyzerReceiptInfo->items[i].janCode != nil) {
            [result appendFormat:@"(JAN: %@)\n", analyzerReceiptInfo->items[i].janCode];
        }
    }
    
    return result;
}

-(void)execReceiptAnalyzeNormal
{
    // JPEGデータからUIImageを作成
    UIImage *picImage = [[UIImage alloc] initWithData:mPicData];
    mPicSize.width = picImage.size.width;
    mPicSize.height = picImage.size.height;

    // 画像サイズ調整
    int size8M = SIZE_8M;
    int wMax = WIDTH_MAX;
    int hMax = HEIGHT_MAX;
    int width = picImage.size.width;
    int height = picImage.size.height;
    int pixelSize = width * height;
    int pictureAspectKind = [self getAspectRatioKind:width height:height];
    int ocrWidth = width;
    int ocrHeight = height;

    if (pixelSize != size8M) {
        if (pictureAspectKind == ASPECT_RATIO_STANDARD) {
            ocrWidth = RECEIPT_8M_HRZ_HEIGHT;
            ocrHeight = RECEIPT_8M_HRZ_WIDTH;
        } else if (pictureAspectKind == ASPECT_RATIO_WIDE) {
            ocrWidth = RECEIPT_4K_HRZ_HEIGHT;
            ocrHeight = RECEIPT_4K_HRZ_WIDTH;
        } else {
            float zoomRate = (float)sqrt((float)((float)size8M / (float)pixelSize));
            if (width > height) {
                float preWidth = (float)width * zoomRate;
                if (preWidth > wMax) {
                    zoomRate = (float)wMax / (float)width;
                }
            } else {
                float preHeight = (float)height * zoomRate;
                if (preHeight > hMax) {
                    zoomRate = (float)hMax / (float)height;
                }
            }
            ocrWidth = (int)((float)width * zoomRate);
            ocrHeight = (int)((float)height * zoomRate);
        }
    }
    mOcrSize.width = ocrWidth;
    mOcrSize.height = ocrHeight;

    int ret;
    @autoreleasepool {
        CGSize ocrSize = CGSizeMake(ocrWidth, ocrHeight);
        UIGraphicsBeginImageContextWithOptions(ocrSize, NO, 1.0f);
        [picImage drawInRect:CGRectMake(0, 0, ocrSize.width, ocrSize.height)];
        picImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        // CGImageを取得
        CGImageRef cgImage = picImage.CGImage;
        // データプロバイダを取得する
        CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
        // ビットマップデータを取得する
        CFDataRef data = CGDataProviderCopyData(dataProvider);
        // CFDataRefが管理してるデータの先頭を返す
        unsigned int *buffer = (unsigned int *) CFDataGetBytePtr(data);
        // 解析
        [self initAnalyzerReceiptInfo:&mAnalyzerReceiptInfo];
        ReceiptAnalyzer* receiptAnalyzer = [[ReceiptAnalyzer alloc] init];
        ret = [receiptAnalyzer receiptAnalyzeRGB:buffer width:picImage.size.width height:picImage.size.height receipt:&mAnalyzerReceiptInfo];
        if (ret >= RECEIPT_OK) {
            NSArray *userid = [NSArray arrayWithObjects:@"SAMPLE_USER", nil];
            [receiptAnalyzer searchCategoryInfo:&mAnalyzerReceiptInfo userid:userid];
            [mReceiptImage removeAllObjects];
            [receiptAnalyzer addReceiptImageRGB:buffer width:picImage.size.width height:picImage.size.height receiptImage:mReceiptImage];
        }
        // CFDataRef解放
        CFRelease(data);
        if (ret >= RECEIPT_OK) {
            dispatch_async(mMainQueue, ^{
                // 画面遷移
                [self dismissAndShowResult];
            });
        } else {
            dispatch_async(mMainQueue, ^{
                [self dismissAndShowMessageAlert:@"認識できませんでした"];
            });
        }
        mIsAnalyzing = FALSE;
    }
}

-(void)execReceiptAnalyzeDividedLong
{
    // JPEGデータからUIImageを作成
    UIImage *picImage = [[UIImage alloc] initWithData:mPicData];
    mPicSize.width = picImage.size.width;
    mPicSize.height = picImage.size.height;
    
    // 画像サイズ調整
    int size8M = SIZE_8M;
    int wMax = WIDTH_MAX;
    int hMax = HEIGHT_MAX;
    int width = picImage.size.width;
    int height = picImage.size.height;
    int pixelSize = width * height;
    int pictureAspectKind = [self getAspectRatioKind:width height:height];
    int ocrWidth = width;
    int ocrHeight = height;
    
    if (pixelSize != size8M) {
        if (pictureAspectKind == ASPECT_RATIO_STANDARD) {
            ocrWidth = RECEIPT_8M_HRZ_HEIGHT;
            ocrHeight = RECEIPT_8M_HRZ_WIDTH;
        } else if (pictureAspectKind == ASPECT_RATIO_WIDE) {
            ocrWidth = RECEIPT_4K_HRZ_HEIGHT;
            ocrHeight = RECEIPT_4K_HRZ_WIDTH;
        } else {
            float zoomRate = (float)sqrt((float)((float)size8M / (float)pixelSize));
            if (width > height) {
                float preWidth = (float)width * zoomRate;
                if (preWidth > wMax) {
                    zoomRate = (float)wMax / (float)width;
                }
            } else {
                float preHeight = (float)height * zoomRate;
                if (preHeight > hMax) {
                    zoomRate = (float)hMax / (float)height;
                }
            }
            ocrWidth = (int)((float)width * zoomRate);
            ocrHeight = (int)((float)height * zoomRate);
        }
    }
    mOcrSize.width = ocrWidth;
    mOcrSize.height = ocrHeight;
    
    int ret;
    @autoreleasepool {
        UIImage *receiptImage;
        float bottomRate = RECEIPT_CUT_BOTTOM_DIVIDE_RATE
        CGRect receiptFrame = CGRectMake(0, 0, ocrWidth, ocrHeight / bottomRate);
        CGRect drawFrame = CGRectMake(0, -ocrHeight * (bottomRate - 1) / bottomRate, ocrWidth, ocrHeight);
        UIGraphicsBeginImageContext(receiptFrame.size);
        [picImage drawInRect:drawFrame];
        receiptImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(mMainQueue, ^{
            [mReceiptImageView setImage:receiptImage];
        });
        
        CGSize ocrSize = CGSizeMake(ocrWidth, ocrHeight);
        UIGraphicsBeginImageContextWithOptions(ocrSize, NO, 1.0f);
        [picImage drawInRect:CGRectMake(0, 0, ocrSize.width, ocrSize.height)];
        // 左右カット
        float cutRate = RECEIPT_CUT_SIDE_DIVIDE_RATE;
        int cutWidth = ocrWidth / cutRate;
        CGRect leftMaskFrame = CGRectMake(0, 0, cutWidth, ocrHeight);
        CGRect rightMaskFrame = CGRectMake(ocrWidth - cutWidth, 0, cutWidth, ocrHeight);
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        CGContextFillRect(contextRef, leftMaskFrame);
        CGContextFillRect(contextRef, rightMaskFrame);
        picImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        // カット画像をカメラロールに保存する場合
//        UIImageWriteToSavedPhotosAlbum(picImage, self, nil, nil);
        
        // CGImageを取得
        CGImageRef cgImage = picImage.CGImage;
        // データプロバイダを取得する
        CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
        // ビットマップデータを取得する
        CFDataRef data = CGDataProviderCopyData(dataProvider);
        // CFDataRefが管理してるデータの先頭を返す
        unsigned int *buffer = (unsigned int *) CFDataGetBytePtr(data);
        // 解析
        [self initAnalyzerReceiptInfo:&mAnalyzerReceiptInfo];
        ReceiptAnalyzer* receiptAnalyzer = [[ReceiptAnalyzer alloc] init];
        ret = [receiptAnalyzer analyzeDividedLongReceiptRGB:(unsigned int*)buffer width:picImage.size.width height:picImage.size.height receipt:&mAnalyzerReceiptInfo];
        if (ret >= RECEIPT_OK) {
            [receiptAnalyzer addReceiptImageRGB:buffer width:picImage.size.width height:picImage.size.height receiptImage:mReceiptImage];
        }
        // CFDataRef解放
        CFRelease(data);
        if (ret >= RECEIPT_OK) {
            mResultText = [CameraController getReceiptResult:&mAnalyzerReceiptInfo];
            [receiptAnalyzer setDividedLongReceipt];
            mLongReceiptNum++;
            dispatch_async(mMainQueue, ^{
                [self dismissAndShowResultAlert:[NSString stringWithFormat:@"%d枚目を解析", (int)mLongReceiptNum] message:[NSString stringWithFormat:@"%@", mResultText]];
            });
        } else {
            dispatch_async(mMainQueue, ^{
                [self dismissAndShowMessageAlert:@"認識できませんでした"];
            });
        }
        mIsAnalyzing = FALSE;
    }
}

-(void)execReceiptAnalyzeLong
{
    dispatch_async(mMainQueue, ^{
        [self showAnalyzingAlert:@"解析中..."];
        dispatch_async(mSubQueue, ^{
            int ret;
            @autoreleasepool {
                // 解析
                [self initAnalyzerReceiptInfo:&mAnalyzerReceiptInfo];
                ReceiptAnalyzer* receiptAnalyzer = [[ReceiptAnalyzer alloc] init];
                ret = [receiptAnalyzer analyzeLongReceipt:&mAnalyzerReceiptInfo];
                if (ret >= RECEIPT_OK) {
                    NSArray *userid = [NSArray arrayWithObjects:@"SAMPLE_USER", nil];
                    [receiptAnalyzer searchCategoryInfo:&mAnalyzerReceiptInfo userid:userid];
                    dispatch_async(mMainQueue, ^{
                        // 画面遷移
                        [self dismissAndShowResult];
                    });
                } else {
                    dispatch_async(mMainQueue, ^{
                        [self dismissAndShowMessageAlert:@"認識できませんでした"];
                    });
                }
            }
        });
    });
}

-(void)initAnalyzerReceiptInfo:(AnalyzerReceiptInfo *)analyzerReceiptInfo
{
    if (analyzerReceiptInfo == nil) { return; }
    analyzerReceiptInfo->tel = nil;
    for (int i = 0; i < analyzerReceiptInfo->cnt; i++) {
        analyzerReceiptInfo->items[i].name = nil;
        analyzerReceiptInfo->items[i].janCode = nil;
        analyzerReceiptInfo->items[i].searchName = nil;
        for (int j = 0; j < analyzerReceiptInfo->items[i].cnt; j++) {
            analyzerReceiptInfo->items[i].category[j].largeCategory = nil;
            analyzerReceiptInfo->items[i].category[j].middleCategory = nil;
            analyzerReceiptInfo->items[i].category[j].smallCategory = nil;
            analyzerReceiptInfo->items[i].category[j].detailedCategory = nil;
            analyzerReceiptInfo->items[i].category[j].largeCategoryCode = nil;
            analyzerReceiptInfo->items[i].category[j].middleCategoryCode = nil;
            analyzerReceiptInfo->items[i].category[j].smallCategoryCode = nil;
            analyzerReceiptInfo->items[i].category[j].detailedCategoryCode = nil;
            analyzerReceiptInfo->items[i].category[j].name = nil;
            analyzerReceiptInfo->items[i].category[j].janCode = nil;
        }
    }
    memset(analyzerReceiptInfo, 0, sizeof(AnalyzerReceiptInfo));
}

- (void)releaseObjects {
    [self initAnalyzerReceiptInfo:&mAnalyzerReceiptInfo];
    if (mReceiptImage != nil) {
        [mReceiptImage removeAllObjects];
    }
}

-(void)cancelReceiptAnalyzeLong
{
    ReceiptAnalyzer* receiptAnalyzer = [[ReceiptAnalyzer alloc] init];
    [receiptAnalyzer cancelLongAnalyze];
    [receiptAnalyzer initLongReceipt];
    if (mReceiptImage != nil) {
        [mReceiptImage removeAllObjects];
    }
    mLongReceiptNum = 0;
    if (mReceiptImageView != nil) {
        [mReceiptImageView setAlpha:0.0f];
    }
}

- (BOOL) setAnalyzeType:(NSInteger)type {
    if (type != ANALYZE_TYPE_NORMAL && type != ANALYZE_TYPE_LONG) { return FALSE; }
    mAnalyzeType = type;
    if (mReceiptImage != nil) {
        [mReceiptImage removeAllObjects];
    }
    mLongReceiptNum = 0;
    if (mReceiptImageView != nil) {
        [mReceiptImageView setAlpha:0.0f];
    }
    ReceiptAnalyzer* receiptAnalyzer = [[ReceiptAnalyzer alloc] init];
    if (type == ANALYZE_TYPE_NORMAL) {
        [mButtonNormal setAlpha:0.0f];
        [mButtonLong setAlpha:1.0f];
        if (mLeftLineView != nil) {
            [mLeftLineView setAlpha:1.0f];
        }
        if (mRightLineView != nil) {
            [mRightLineView setAlpha:1.0f];
        }
        if (mLeftMaskView != nil) {
            [mLeftMaskView setAlpha:0.0f];
        }
        if (mRightMaskView != nil) {
            [mRightMaskView setAlpha:0.0f];
        }
        if (mLeftMaskLineView != nil) {
            [mLeftMaskLineView setAlpha:0.0f];
        }
        if (mRightMaskLineView != nil) {
            [mRightMaskLineView setAlpha:0.0f];
        }
        [receiptAnalyzer cancelLongAnalyze];
        return TRUE;
    }
    if (type == ANALYZE_TYPE_LONG) {
        [mButtonNormal setAlpha:1.0f];
        [mButtonLong setAlpha:0.0f];
        if (mLeftLineView != nil) {
            [mLeftLineView setAlpha:0.0f];
        }
        if (mRightLineView != nil) {
            [mRightLineView setAlpha:0.0f];
        }
        if (mLeftMaskView != nil) {
            [mLeftMaskView setAlpha:1.0f];
        }
        if (mRightMaskView != nil) {
            [mRightMaskView setAlpha:1.0f];
        }
        if (mLeftMaskLineView != nil) {
            [mLeftMaskLineView setAlpha:1.0f];
        }
        if (mRightMaskLineView != nil) {
            [mRightMaskLineView setAlpha:1.0f];
        }
        [receiptAnalyzer initLongReceipt];
        return TRUE;
    }
    return TRUE;
}

#pragma mark - Alert Func
- (void) dismissAlert {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) dismissAndShowMessageAlert:(NSString*)message {
    [self dismissViewControllerAnimated: YES completion: ^{
        [self showMessageAlert:message];
    }];
}

- (void) dismissAndShowResultAlert:(NSString*)title message:(NSString*)message {
    [self dismissViewControllerAnimated: YES completion: ^{
        [self showResultAlert:title message:message];
    }];
}

- (void) dismissAndShowResult {
    [self dismissViewControllerAnimated: YES completion: ^{
        [self showResult];
    }];
}

- (void) showAnalyzingAlert:(NSString*)message {
    if (mAnalyzingAlert == nil) {
        mAnalyzingAlert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    } else {
        mAnalyzingAlert.message = message;
    }
    [self presentViewController:mAnalyzingAlert animated:YES completion:nil];
}

- (void) showMessageAlert:(NSString*)message {
    if (mMessageAlert == nil) {
        mMessageAlert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    } else {
        mMessageAlert.message = message;
    }
    [self presentViewController:mMessageAlert animated:YES
                     completion:^{
                         mMessageAlert.view.superview.userInteractionEnabled = TRUE;
                         [mMessageAlert.view.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)]];
                     }
     ];
}

- (void) showResultAlert:(NSString*)title message:(NSString*)message {
    if (mResultAlert == nil) {
        mResultAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    } else {
        mResultAlert.title = title;
        mResultAlert.message = message;
    }
    if (mNextAction == nil) {
        mNextAction = [UIAlertAction actionWithTitle:@"続けて撮影" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            dispatch_async(mMainQueue, ^{
                if (mReceiptImageView != nil) {
                    [mReceiptImageView setAlpha:0.5f];
                }
            });
        }];
        [mResultAlert addAction:mNextAction];
    }
    if (mFinishAction == nil) {
        mFinishAction = [UIAlertAction actionWithTitle:@"解析結果を表示" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self execReceiptAnalyzeLong]; }];
        [mResultAlert addAction:mFinishAction];
    }
    if (mCancelAction == nil) {
        mCancelAction = [UIAlertAction actionWithTitle:@"最初から撮影" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self cancelReceiptAnalyzeLong]; }];
        [mResultAlert addAction:mCancelAction];
    }
    [self presentViewController:mResultAlert animated:YES completion:nil];
}

#pragma mark - Camera Func
- (void)initAVSession
{
    // セッションの作成
    mSession = [[AVCaptureSession alloc] init];
    // カメラサイズ設定
    mSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    // カメラ取得
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // カメラを入力デバイスとして取得
    mVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:nil];
    // セッションに入力デバイスを設定
    [mSession addInput:mVideoInput];
    // セッションに出力を設定
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max)
    {
        // iOS10以降
        mPhotoOutput = [[AVCapturePhotoOutput alloc] init];
        [mSession addOutput:mPhotoOutput];
    } else {
        // iOS9以前
        mStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        [mSession addOutput:mStillImageOutput];
    }
    // セッションからプレビューレイヤーを取得
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:mSession];
    captureVideoPreviewLayer.frame = mCameraView.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    // プレビュー設定
    [mCameraView.layer addSublayer:captureVideoPreviewLayer];
    
    [mSession startRunning];
}

- (void)releaseAVSession
{
    [mSession stopRunning];
    [mSession removeInput:mVideoInput];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max)
    {
        // iOS10以降
        [mSession removeOutput:mPhotoOutput];
        mPhotoOutput = nil;
    } else {
        // iOS9以前
        [mSession removeOutput:mStillImageOutput];
        mStillImageOutput = nil;
    }
    mVideoInput = nil;
    mSession = nil;
}

- (void) checkFlash {
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([camera torchMode] == AVCaptureTorchModeOn) {
        [mButtonTorchOff setAlpha:0.0f];
        [mButtonTorchOn setAlpha:1.0f];
    } else {
        [mButtonTorchOff setAlpha:1.0f];
        [mButtonTorchOn setAlpha:0.0f];
    }
}

- (void) toggleFlash {
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camera lockForConfiguration:nil];
    if ([camera torchMode] == AVCaptureTorchModeOn) {
        [camera setTorchMode:AVCaptureTorchModeOff];
    } else {
        [camera setTorchMode:AVCaptureTorchModeOn];
    }
    [camera unlockForConfiguration];
    [self checkFlash];
}

- (void) startCamera {
    // フラグ初期化
    mIsAnalyzing = FALSE;
    // ライト状態チェック
    [self checkFlash];
    // プレビュー調整
    if (mCameraView == nil) {
        CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
        CGRect cameraFrame = CGRectMake(0, 0, applicationFrame.size.width, applicationFrame.size.width * 4.0f / 3.0f);
        mCameraView = [[UIView alloc]initWithFrame:cameraFrame];
        [mCameraBaseView addSubview:mCameraView];
        [mCameraBaseView sendSubviewToBack:mCameraView];
    }
    // マスク調整
    float cutRate = RECEIPT_CUT_SIDE_DIVIDE_RATE;
    float bottomRate = RECEIPT_CUT_BOTTOM_DIVIDE_RATE
    float maskWidth = mCameraView.frame.size.width / cutRate;
    float maskHeight = mCameraView.frame.size.height;
    float maskLineWidth = MASK_LINE_WIDTH;
    float maskLineHeight = maskHeight;
    float receitLinePosX = RECEIPT_LINE_POS_X;
    if (mReceiptImageView == nil) {
        CGRect receiptImageFrame = CGRectMake(0, 0, mCameraView.frame.size.width, mCameraView.frame.size.height / bottomRate);
        mReceiptImageView = [[UIImageView alloc]initWithFrame:receiptImageFrame];
        mReceiptImageView.contentMode = UIViewContentModeScaleAspectFit;
        [mCameraBaseView addSubview:mReceiptImageView];
        [mCameraBaseView bringSubviewToFront:mReceiptImageView];
        [mReceiptImageView setAlpha:0.0f];
    }
    if (mLeftMaskView == nil) {
        CGRect leftMaskFrame = CGRectMake(0, 0, maskWidth, maskHeight);
        mLeftMaskView = [[UIView alloc]initWithFrame:leftMaskFrame];
        [mLeftMaskView setBackgroundColor:[UIColor lightGrayColor]];
        [mCameraBaseView addSubview:mLeftMaskView];
        [mCameraBaseView bringSubviewToFront:mLeftMaskView];
    }
    if (mRightMaskView == nil) {
        CGRect rightMaskFrame = CGRectMake(mCameraView.frame.size.width - maskWidth, 0, maskWidth, maskHeight);
        mRightMaskView = [[UIView alloc]initWithFrame:rightMaskFrame];
        [mRightMaskView setBackgroundColor:[UIColor lightGrayColor]];
        [mCameraBaseView addSubview:mRightMaskView];
        [mCameraBaseView bringSubviewToFront:mRightMaskView];
    }
    if (mLeftMaskLineView == nil) {
        CGRect leftMaskLineFrame = CGRectMake(maskWidth - maskLineWidth, 0, maskLineWidth, maskLineHeight);
        mLeftMaskLineView = [[UIView alloc]initWithFrame:leftMaskLineFrame];
        [mLeftMaskLineView setBackgroundColor:[UIColor redColor]];
        [mCameraBaseView addSubview:mLeftMaskLineView];
        [mCameraBaseView bringSubviewToFront:mLeftMaskLineView];
    }
    if (mRightMaskLineView == nil) {
        CGRect rightMaskLineFrame = CGRectMake(mCameraView.frame.size.width - maskWidth, 0, maskLineWidth, maskLineHeight);
        mRightMaskLineView = [[UIView alloc]initWithFrame:rightMaskLineFrame];
        [mRightMaskLineView setBackgroundColor:[UIColor redColor]];
        [mCameraBaseView addSubview:mRightMaskLineView];
        [mCameraBaseView bringSubviewToFront:mRightMaskLineView];
    }
    if (mLeftLineView == nil) {
        CGRect leftLineFrame = CGRectMake(receitLinePosX, 0, maskLineWidth, maskLineHeight);
        mLeftLineView = [[UIView alloc]initWithFrame:leftLineFrame];
        [mLeftLineView setBackgroundColor:[UIColor redColor]];
        [mCameraBaseView addSubview:mLeftLineView];
        [mCameraBaseView bringSubviewToFront:mLeftLineView];
    }
    if (mRightLineView == nil) {
        CGRect rightLineFrame = CGRectMake(mCameraView.frame.size.width - receitLinePosX, 0, maskLineWidth, maskLineHeight);
        mRightLineView = [[UIView alloc]initWithFrame:rightLineFrame];
        [mRightLineView setBackgroundColor:[UIColor redColor]];
        [mCameraBaseView addSubview:mRightLineView];
        [mCameraBaseView bringSubviewToFront:mRightLineView];
    }
    if (mAnalyzeType == ANALYZE_TYPE_NORMAL) {
        [mLeftLineView setAlpha:1.0f];
        [mRightLineView setAlpha:1.0f];
        [mLeftMaskView setAlpha:0.0f];
        [mRightMaskView setAlpha:0.0f];
        [mLeftMaskLineView setAlpha:0.0f];
        [mRightMaskLineView setAlpha:0.0f];
    } else {
        [mLeftLineView setAlpha:0.0f];
        [mRightLineView setAlpha:0.0f];
        [mLeftMaskView setAlpha:1.0f];
        [mRightMaskView setAlpha:1.0f];
        [mLeftMaskLineView setAlpha:1.0f];
        [mRightMaskLineView setAlpha:1.0f];
    }
    // カメラスタート
    [self initAVSession];
}

- (void) requestAnalyze {
    dispatch_async(mMainQueue, ^{
        if (mReceiptImageView != nil) {
            [mReceiptImageView setAlpha:0.0f];
        }
        [self showAnalyzingAlert:@"解析中..."];
        dispatch_async(mSubQueue, ^{
            if (mAnalyzeType == ANALYZE_TYPE_NORMAL) {
                @autoreleasepool {
                    [self execReceiptAnalyzeNormal];
                }
            } else {
                @autoreleasepool {
                    [self execReceiptAnalyzeDividedLong];
                }
            }
        });
    });
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error
{
    // 入力された画像データからJPEGフォーマットとしてデータを取得
    mPicData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    [self requestAnalyze];
}

#pragma mark - Button Func
- (IBAction)clickShutter:(id)sender {
    // 連打抑止
    if (mIsAnalyzing) { return; }
    mIsAnalyzing = TRUE;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max)
    {
        // iOS10以降
        AVCapturePhotoSettings *photoSettings = [[AVCapturePhotoSettings alloc] init];
        [photoSettings setFlashMode:AVCaptureFlashModeOff];
        [photoSettings setHighResolutionPhotoEnabled:FALSE];
        if ([mPhotoOutput isStillImageStabilizationSupported]) {
            [photoSettings setAutoStillImageStabilizationEnabled:TRUE];
        }
        [mPhotoOutput capturePhotoWithSettings:photoSettings delegate:self];
    } else {
        // iOS9以前
        AVCaptureConnection *connection = [mStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        [mStillImageOutput
         captureStillImageAsynchronouslyFromConnection:connection
         completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
             // 入力された画像データからJPEGフォーマットとしてデータを取得
             mPicData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
             [self requestAnalyze];
         }];
    }
}

- (IBAction)clickGuide:(id)sender {
    [UIView animateWithDuration:0.3f animations:^{
        [mGuideView setAlpha:1.0f];
    }];
}

- (IBAction)clickNormal:(id)sender {
    [self setAnalyzeType:ANALYZE_TYPE_NORMAL];
}

- (IBAction)clickLong:(id)sender {
    [self setAnalyzeType:ANALYZE_TYPE_LONG];
}

- (IBAction)clickBack:(id)sender {
    [self backTop];
}

- (IBAction)clickTorch:(id)sender {
    [self toggleFlash];
}

- (void)tapGuide {
    [UIView animateWithDuration:0.3f animations:^{
        [mGuideView setAlpha:0.0f];
    }];
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    mButtonBack.imageView.contentMode = UIViewContentModeScaleAspectFit;
    mButtonTorchOn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    mButtonTorchOff.imageView.contentMode = UIViewContentModeScaleAspectFit;
    mButtonShutter.imageView.contentMode = UIViewContentModeScaleAspectFit;
    mButtonShutter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    mButtonShutter.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    mButtonShutter.layer.cornerRadius = 20;
    mButtonShutter.layer.borderWidth = 3;
    mButtonShutter.layer.borderColor = UIColor.whiteColor.CGColor;

    mButtonGuide.imageView.contentMode = UIViewContentModeScaleAspectFit;
    mButtonGuide.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    mButtonGuide.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    mButtonGuide.layer.cornerRadius = 20;
    mButtonGuide.layer.borderWidth = 3;
    mButtonGuide.layer.borderColor = UIColor.whiteColor.CGColor;

    mButtonNormal.imageView.contentMode = UIViewContentModeScaleAspectFit;
    mButtonNormal.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    mButtonNormal.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    mButtonNormal.layer.cornerRadius = 20;
    mButtonNormal.layer.borderWidth = 3;
    mButtonNormal.layer.borderColor = UIColor.whiteColor.CGColor;

    mButtonLong.imageView.contentMode = UIViewContentModeScaleAspectFit;
    mButtonLong.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    mButtonLong.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    mButtonLong.layer.cornerRadius = 20;
    mButtonLong.layer.borderWidth = 3;
    mButtonLong.layer.borderColor = UIColor.whiteColor.CGColor;

    [mGuideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGuide)]];

    // ライト非対応チェック
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(![camera isTorchAvailable]) {
        [mButtonTorchOn setEnabled:FALSE];
        [mButtonTorchOn setAlpha:0.0f];
        [mButtonTorchOff setEnabled:FALSE];
        [mButtonTorchOff setAlpha:0.0f];
    }
    // ライト状態チェック
    [self checkFlash];

    // 通常解析
    mAnalyzeType = ANALYZE_TYPE_NORMAL;

    // 通知受信の設定
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    [nc addObserver:self selector:@selector(applicationWillEnterForeground) name:@"applicationWillEnterForeground" object:nil];

    mReceiptImage = [[NSMutableArray alloc] init];
    mMainQueue = dispatch_get_main_queue();
    mSubQueue = dispatch_queue_create("jp.co.isp21.samplereceiptcamera8m", 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
    // カメラスタート
    [self startCamera];
}

- (void)applicationDidEnterBackground {
    // カメラ解放
    [self releaseAVSession];
}

- (void)applicationWillEnterForeground {
    // カメラスタート
    [self startCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
