//
//  Receipt.mm
//  Recika
//
//  Created by liqc on 2018/09/13.
//  Copyright © 2018年 ISP. All rights reserved.
//

#import "Receipt.h"

@implementation Receipt

NSInteger analyzeType;
BOOL isAnalyzing;
NSData *picData;
CGSize picSize;
CGSize ocrSize;

AnalyzerReceiptInfo receiptInfo;

NSInteger longReceiptNum;
NSString* resultText;
NSMutableArray *mReceiptImage;

dispatch_queue_t mainQueue = dispatch_get_main_queue();
dispatch_queue_t subQueue = dispatch_queue_create("recika", 0);

- (void) requestAnalyze: (NSData *)picData {
    dispatch_async(mainQueue, ^{
        dispatch_async(subQueue, ^{
            @autoreleasepool {
                [self execReceiptAnalyzeDividedLong:picData];
            }
        });
    });
}

-(void)execReceiptAnalyzeDividedLong: (NSData *)picData
{
    // JPEGデータからUIImageを作成
    UIImage *picImage = [[UIImage alloc] initWithData:picData];
    picSize.width = picImage.size.width;
    picSize.height = picImage.size.height;
    
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
    ocrSize.width = ocrWidth;
    ocrSize.height = ocrHeight;
    
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
        dispatch_async(mainQueue, ^{
            [self.delegate setImage:receiptImage];
//            [mReceiptImageView setImage:receiptImage];
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
        [self initAnalyzerReceiptInfo:&receiptInfo];
        ReceiptAnalyzer* receiptAnalyzer = [[ReceiptAnalyzer alloc] init];
        ret = [receiptAnalyzer analyzeDividedLongReceiptRGB:(unsigned int*)buffer width:picImage.size.width height:picImage.size.height receipt:&receiptInfo];
        if (ret >= RECEIPT_OK) {
            [receiptAnalyzer addReceiptImageRGB:buffer width:picImage.size.width height:picImage.size.height receiptImage:mReceiptImage];
        }
        // CFDataRef解放
        CFRelease(data);
        if (ret >= RECEIPT_OK) {
            resultText = [Receipt getReceiptResult:&receiptInfo];
            [receiptAnalyzer setDividedLongReceipt];
            longReceiptNum++;
            dispatch_async(mainQueue, ^{
                NSLog(@"%@", resultText);
                [self.delegate success:&receiptInfo];
            });
        } else {
            dispatch_async(mainQueue, ^{
                [self.delegate fail:@"認識できませんでした"];
            });
        }
    }
}

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

@end
