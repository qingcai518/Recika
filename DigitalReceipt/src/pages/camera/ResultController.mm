//
//  ResultController.m
//  SampleReceiptCamera8M
//
//  Created by Admin on 2017/06/06.
//  Copyright © 2017年 ISP. All rights reserved.
//

#import "ResultController.h"

@interface ResultController ()

@end

@implementation ResultController

#pragma mark - I/F Func
- (BOOL)setAnalyzeResult:(AnalyzerReceiptInfo *)receipt picSize:(CGSize)picSize ocrSize:(CGSize)ocrSize receiptImage:(NSMutableArray*)receiptImage {
    if (receipt == nil || picSize.width < 1 || picSize.height < 1 || ocrSize.width < 1 || ocrSize.height < 1 || receiptImage == nil) { return FALSE; }
    // 画像サイズ
    mPicSize.width = picSize.width;
    mPicSize.height = picSize.height;
    // 解析サイズ
    mOcrSize.width = ocrSize.width;
    mOcrSize.height = ocrSize.height;
    // 解析結果
    [self copyReceiptInfo:receipt dst:&mAnalyzerReceiptInfo];
    // レシート画像
    mReceiptImage = [[NSMutableArray alloc] init];
    for(int i = 0; i < [receiptImage count]; i++) {
        [mReceiptImage addObject:[receiptImage objectAtIndex:i]];
    }
    return TRUE;
}

#pragma mark - For Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"UnwindSegueBackCamera"]) {
        [self releaseObjects];
        return;
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

    return result;
}

- (void)copyReceiptInfo:(AnalyzerReceiptInfo *)src dst:(AnalyzerReceiptInfo *)dst {
    [self initAnalyzerReceiptInfo:dst];
    // 日時
    dst->date.year = src->date.year;
    dst->date.month = src->date.month;
    dst->date.day = src->date.day;
    dst->date.hour = src->date.hour;
    dst->date.minute = src->date.minute;
    dst->date.second = src->date.second;
    // 電話番号
    if (src->tel != nil) {
        dst->tel = [NSString stringWithFormat:@"%@", src->tel];
    }
    // 合計
    dst->total = src->total;
    // 調整金額
    dst->priceAdjustment = src->priceAdjustment;
    // 品目数
    dst->cnt = src->cnt;
    // 品目
    for (int i = 0; i < dst->cnt; i++) {
        // 品目名
        if (src->items[i].name != nil) {
            dst->items[i].name = [NSString stringWithFormat:@"%@", src->items[i].name];
        }
        // 金額
        dst->items[i].price = src->items[i].price;
        // 単価
        dst->items[i].unitPrice = src->items[i].unitPrice;
        // 個数
        dst->items[i].itemNum = src->items[i].itemNum;
        // JANコード
        if (src->items[i].janCode != nil) {
            dst->items[i].janCode = [NSString stringWithFormat:@"%@", src->items[i].janCode];
        }

        // 補正品目名
        if(src->items[i].searchName != nil) {
            dst->items[i].searchName = [NSString stringWithFormat:@"%@", src->items[i].searchName];
        }
        // 分類情報数
        dst->items[i].cnt = src->items[i].cnt;
        // 分類情報
        for (int j = 0; j < dst->items[i].cnt; j++) {
            // 分類名(大分類)
            if (src->items[i].category[j].largeCategory != nil) {
                dst->items[i].category[j].largeCategory = [NSString stringWithFormat:@"%@", src->items[i].category[j].largeCategory];
            }
            // 分類名(中分類)
            if (src->items[i].category[j].middleCategory != nil) {
                dst->items[i].category[j].middleCategory = [NSString stringWithFormat:@"%@", src->items[i].category[j].middleCategory];
            }
            // 分類名(小分類)
            if (src->items[i].category[j].smallCategory != nil) {
                dst->items[i].category[j].smallCategory = [NSString stringWithFormat:@"%@", src->items[i].category[j].smallCategory];
            }
            // 分類名(細分類)
            if (src->items[i].category[j].detailedCategory != nil) {
                dst->items[i].category[j].detailedCategory = [NSString stringWithFormat:@"%@", src->items[i].category[j].detailedCategory];
            }
            // 分類コード(大分類)
            if (src->items[i].category[j].largeCategoryCode != nil) {
                dst->items[i].category[j].largeCategoryCode = [NSString stringWithFormat:@"%@", src->items[i].category[j].largeCategoryCode];
            }
            // 分類コード(中分類)
            if (src->items[i].category[j].middleCategoryCode != nil) {
                dst->items[i].category[j].middleCategoryCode = [NSString stringWithFormat:@"%@", src->items[i].category[j].middleCategoryCode];
            }
            // 分類コード(小分類)
            if (src->items[i].category[j].smallCategoryCode != nil) {
                dst->items[i].category[j].smallCategoryCode = [NSString stringWithFormat:@"%@", src->items[i].category[j].smallCategoryCode];
            }
            // 分類コード(細分類)
            if (src->items[i].category[j].detailedCategoryCode != nil) {
                dst->items[i].category[j].detailedCategoryCode = [NSString stringWithFormat:@"%@", src->items[i].category[j].detailedCategoryCode];
            }
            // 商品名
            if (src->items[i].category[j].name != nil) {
                dst->items[i].category[j].name = [NSString stringWithFormat:@"%@", src->items[i].category[j].name];
            }
            // JANコード
            if (src->items[i].category[j].janCode != nil) {
                dst->items[i].category[j].janCode = [NSString stringWithFormat:@"%@", src->items[i].category[j].janCode];
            }
        }
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

- (void)releaseObjects {
    [self initAnalyzerReceiptInfo:&mAnalyzerReceiptInfo];
    if (mReceiptImage != nil) {
        [mReceiptImage removeAllObjects];
    }
}

-(void)execReceiptRegist
{
    dispatch_async(mMainQueue, ^{
        [self showRegistingAlert:@"登録中..."];
        dispatch_async(mSubQueue, ^{
            int ret;
            @autoreleasepool {
                // レシート登録
                ReceiptAnalyzer* receiptAnalyzer = [[ReceiptAnalyzer alloc] init];
                NSArray *userid = [NSArray arrayWithObjects:@"SAMPLE_USER", nil];
                ret = [receiptAnalyzer receiptRegist:&mAnalyzerReceiptInfo receiptImage:mReceiptImage userid:userid];
                dispatch_async(mMainQueue, ^{
                    if (ret == REGIST_OK) {
                        [self dismissAndShowMessageAlert:@"登録しました"];
                    } else if (ret == REGIST_NG) {
                        [self dismissAndShowMessageAlert:[NSString stringWithFormat:@"登録できませんでした\n%@", [receiptAnalyzer getLastErrDetail]]];
                    } else {
                        [self dismissAndShowMessageAlert:@"登録できませんでした"];
                    }
                });
            }
        });
    });
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

- (void) showRegistingAlert:(NSString*)message {
    if (mRegistingAlert == nil) {
        mRegistingAlert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    } else {
        mRegistingAlert.message = message;
    }
    [self presentViewController:mRegistingAlert animated:YES completion:nil];
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

- (void) showDetailAlert:(NSString*)title message:(NSString*)message {
    if (mDetailAlert == nil) {
        mDetailAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    } else {
        mDetailAlert.message = message;
    }
    [self presentViewController:mDetailAlert animated:YES
                     completion:^{
                         mDetailAlert.view.superview.userInteractionEnabled = TRUE;
                         [mDetailAlert.view.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)]];
                     }
     ];
}

#pragma mark - list functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return mAnalyzerReceiptInfo.cnt;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    UILabel* itemName = (UILabel *)[cell viewWithTag:1];
    UILabel* itemPrice = (UILabel *)[cell viewWithTag:2];

    itemName.text = [NSString stringWithFormat:@"%@", mAnalyzerReceiptInfo.items[indexPath.row].name];
    if (mAnalyzerReceiptInfo.items[indexPath.row].price < 0) {
        itemPrice.text = [NSString stringWithFormat:@"%d", mAnalyzerReceiptInfo.items[indexPath.row].price];
    } else {
        itemPrice.text = [NSString stringWithFormat:@"￥%d", mAnalyzerReceiptInfo.items[indexPath.row].price];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSMutableString *detail = [NSMutableString string];
    // 品目
    [detail appendFormat:@"品目: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].name];
    // 金額 単価 個数
    [detail appendFormat:@"金額: %d(単価: %d, 個数: %d)\n", mAnalyzerReceiptInfo.items[indexPath.row].price, mAnalyzerReceiptInfo.items[indexPath.row].unitPrice, mAnalyzerReceiptInfo.items[indexPath.row].itemNum];
    // JANコード
    if (mAnalyzerReceiptInfo.items[indexPath.row].janCode != nil) {
        if ([mAnalyzerReceiptInfo.items[indexPath.row].janCode compare:@""] != NSOrderedSame) {
            [detail appendFormat:@"JAN: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].janCode];
        }
    }
    // 補正品目名
    if(mAnalyzerReceiptInfo.items[indexPath.row].searchName != nil) {
        if ([mAnalyzerReceiptInfo.items[indexPath.row].searchName compare:@""] != NSOrderedSame) {
            [detail appendFormat:@"補正: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].searchName];
        }
    }
    // 分類情報
    for (int i = 0; i < mAnalyzerReceiptInfo.items[indexPath.row].cnt; i++) {
        [detail appendFormat:@"\n---- 分類情報%d ----\n", (i + 1)];
        // 商品名
        if (mAnalyzerReceiptInfo.items[indexPath.row].category[i].name != nil) {
            if ([mAnalyzerReceiptInfo.items[indexPath.row].category[i].name compare:@""] != NSOrderedSame) {
                [detail appendFormat:@"商品名: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].name];
            }
        }
        // JANコード
        if (mAnalyzerReceiptInfo.items[indexPath.row].category[i].janCode != nil) {
            if ([mAnalyzerReceiptInfo.items[indexPath.row].category[i].janCode compare:@""] != NSOrderedSame) {
                [detail appendFormat:@"JAN: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].janCode];
            }
        }
        // 大分類
        if (mAnalyzerReceiptInfo.items[indexPath.row].category[i].largeCategory != nil) {
            if ([mAnalyzerReceiptInfo.items[indexPath.row].category[i].largeCategory compare:@""] != NSOrderedSame) {
                if (mAnalyzerReceiptInfo.items[indexPath.row].category[i].largeCategoryCode == nil) {
                    [detail appendFormat:@"-- 大分類 --\n分類名: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].largeCategory];
                } else if ([mAnalyzerReceiptInfo.items[indexPath.row].category[i].largeCategoryCode compare:@""] == NSOrderedSame) {
                    [detail appendFormat:@"-- 大分類 --\n分類名: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].largeCategory];
                } else {
                    [detail appendFormat:@"-- 大分類 --\n分類名: %@\n分類コード: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].largeCategory, mAnalyzerReceiptInfo.items[indexPath.row].category[i].largeCategoryCode];
                }
            }
        }
        // 中分類
        if (mAnalyzerReceiptInfo.items[indexPath.row].category[i].middleCategory != nil) {
            if ([mAnalyzerReceiptInfo.items[indexPath.row].category[i].middleCategory compare:@""] != NSOrderedSame) {
                if (mAnalyzerReceiptInfo.items[indexPath.row].category[i].middleCategoryCode == nil) {
                    [detail appendFormat:@"-- 中分類 --\n分類名: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].middleCategory];
                } else if ([mAnalyzerReceiptInfo.items[indexPath.row].category[i].middleCategoryCode compare:@""] == NSOrderedSame) {
                    [detail appendFormat:@"-- 中分類 --\n分類名: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].middleCategory];
                } else {
                    [detail appendFormat:@"-- 中分類 --\n分類名: %@\n分類コード: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].middleCategory, mAnalyzerReceiptInfo.items[indexPath.row].category[i].middleCategoryCode];
                }
            }
        }
        // 小分類
        if (mAnalyzerReceiptInfo.items[indexPath.row].category[i].smallCategory != nil) {
            if ([mAnalyzerReceiptInfo.items[indexPath.row].category[i].smallCategory compare:@""] != NSOrderedSame) {
                if (mAnalyzerReceiptInfo.items[indexPath.row].category[i].smallCategoryCode == nil) {
                    [detail appendFormat:@"-- 小分類 --\n分類名: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].smallCategory];
                } else if ([mAnalyzerReceiptInfo.items[indexPath.row].category[i].smallCategoryCode compare:@""] == NSOrderedSame) {
                    [detail appendFormat:@"-- 小分類 --\n分類名: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].smallCategory];
                } else {
                    [detail appendFormat:@"-- 小分類 --\n分類名: %@\n分類コード: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].smallCategory, mAnalyzerReceiptInfo.items[indexPath.row].category[i].smallCategoryCode];
                }
            }
        }
        // 細分類
        if (mAnalyzerReceiptInfo.items[indexPath.row].category[i].detailedCategory != nil) {
            if ([mAnalyzerReceiptInfo.items[indexPath.row].category[i].detailedCategory compare:@""] != NSOrderedSame) {
                if (mAnalyzerReceiptInfo.items[indexPath.row].category[i].detailedCategoryCode == nil) {
                    [detail appendFormat:@"-- 細分類 --\n分類名: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].detailedCategory];
                } else if ([mAnalyzerReceiptInfo.items[indexPath.row].category[i].detailedCategoryCode compare:@""] == NSOrderedSame) {
                    [detail appendFormat:@"-- 細分類 --\n分類名: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].detailedCategory];
                } else {
                    [detail appendFormat:@"-- 細分類 --\n分類名: %@\n分類コード: %@\n", mAnalyzerReceiptInfo.items[indexPath.row].category[i].detailedCategory, mAnalyzerReceiptInfo.items[indexPath.row].category[i].detailedCategoryCode];
                }
            }
        }
    }
    [self showDetailAlert:[NSString stringWithFormat:@"詳細"] message:[NSString stringWithFormat:@"%@", detail]];
}

#pragma mark - Button Func
- (IBAction)clickRegist:(id)sender {
    [self execReceiptRegist];
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    mButtonBack.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    mButtonRegist.layer.cornerRadius = 20;
    mButtonRegist.layer.borderWidth = 3;
    mButtonRegist.layer.borderColor = UIColor.whiteColor.CGColor;

    mResultListTable.delegate = self;
    mResultListTable.dataSource = self;

    mMainQueue = dispatch_get_main_queue();
    mSubQueue = dispatch_queue_create("jp.co.isp21.samplereceiptcamera8m", 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 解析結果表示
    NSString *result;
    if (mReceiptImage != nil) {
        result = [NSString stringWithFormat:@"撮影サイズ W: %d, H: %d\n解析サイズ W: %d, H: %d\nレシート枚数: %d枚\n\n%@\n", (int)mPicSize.width, (int)mPicSize.height, (int)mOcrSize.width, (int)mOcrSize.height, (int)[mReceiptImage count], [ResultController getReceiptResult:&mAnalyzerReceiptInfo]];
    } else {
        result = [NSString stringWithFormat:@"撮影サイズ W: %d, H: %d\n解析サイズ W: %d, H: %d\nレシート枚数: 0枚\n\n%@\n", (int)mPicSize.width, (int)mPicSize.height, (int)mOcrSize.width, (int)mOcrSize.height, [ResultController getReceiptResult:&mAnalyzerReceiptInfo]];
    }
    
    [mResultText setText:result];
    [mResultText setEditable:FALSE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
