//
//  Receipt.h
//  Recika
//
//  Created by liqc on 2018/09/13.
//  Copyright © 2018年 ISP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ReceiptAnalyzer/ReceiptAnalyzer.h"
#import "Common.h"

@protocol ReceiptDelegate <NSObject>

- (void)success: (AnalyzerReceiptInfo *)receiptInfo;

- (void)fail: (NSString *)msg;

- (void) setImage: (UIImage *) receiptImage;

@end

@interface Receipt : NSObject
@property (weak, nonatomic) id<ReceiptDelegate> delegate;
- (void) requestAnalyze: (NSData *)picData;
@end
