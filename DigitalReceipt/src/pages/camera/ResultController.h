//
//  ResultController.h
//  SampleReceiptCamera8M
//
//  Created by Admin on 2017/06/06.
//  Copyright © 2017年 ISP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "ReceiptAnalyzer/ReceiptAnalyzer.h"
#import "ExTextView.h"

@interface ResultController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UIButton *mButtonBack;
    __weak IBOutlet UIButton *mButtonRegist;
    __weak IBOutlet ExTextView *mResultText;
    __weak IBOutlet UITableView *mResultListTable;

    CGSize mPicSize;
    CGSize mOcrSize;
    AnalyzerReceiptInfo mAnalyzerReceiptInfo;
    NSMutableArray *mReceiptImage;

    UIAlertController *mDetailAlert;
    UIAlertController *mMessageAlert;
    UIAlertController *mRegistingAlert;

    dispatch_queue_t mMainQueue;
    dispatch_queue_t mSubQueue;
}
- (BOOL)setAnalyzeResult:(AnalyzerReceiptInfo *)receipt picSize:(CGSize)picSize ocrSize:(CGSize)ocrSize receiptImage:(NSMutableArray*)receiptImage;

@end

