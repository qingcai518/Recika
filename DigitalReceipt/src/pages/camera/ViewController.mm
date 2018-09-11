//
//  ViewController.m
//  SampleReceiptCamera8M
//
//  Created by Admin on 2017/06/06.
//  Copyright © 2017年 ISP. All rights reserved.
//

#import "ViewController.h"
#import "ReceiptAnalyzer/ReceiptAnalyzer.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Unwind Segue
- (IBAction)unwindBackTop:(UIStoryboardSegue *)segue { }

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    mButtonCamera.imageView.contentMode = UIViewContentModeScaleAspectFit;
    ReceiptAnalyzer* receiptAnalyzer = [[ReceiptAnalyzer alloc] init];
    // バージョン情報
    int major, minor, revision;
    [receiptAnalyzer getEngineVersion:&major minor:&minor revision:&revision];
    int sysMajor, sysMinor, sysRevision;
    [receiptAnalyzer getSystemVersion:&sysMajor minor:&sysMinor revision:&sysRevision];
    int env = [receiptAnalyzer getConnectionEnvironment];
    if (env == PRODUCTION) {
        [mLabelTitle setText:[NSString stringWithFormat:@"レシート解析 Ver.%d.%d.%d\n商品特定 Ver.%d.%d.%d, 接続先 Env.PRODUCTION", major, minor, revision, sysMajor, sysMinor, sysRevision]];
    } else if (env == STAGING) {
        [mLabelTitle setText:[NSString stringWithFormat:@"レシート解析 Ver.%d.%d.%d\n商品特定 Ver.%d.%d.%d, 接続先 Env.STAGING", major, minor, revision, sysMajor, sysMinor, sysRevision]];
    } else {
        [mLabelTitle setText:[NSString stringWithFormat:@"レシート解析 Ver.%d.%d.%d\n商品特定 Ver.%d.%d.%d, 接続先 Env.%d", major, minor, revision, sysMajor, sysMinor, sysRevision, env]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
