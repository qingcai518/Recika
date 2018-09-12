//
//  ReceiptAnalyzer.h
//  ReceiptAnalyzer
//
//  Created by ISP on 2015/09/29.
//  Copyright (c) 2015年 ISP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define ITEM_MAX            200     /**< 品目数最大値 */
#define CATEGORY_MAX        10      /**< 分類情報数最大値 */
#define PAYMENT_MAX         6       /**< 支払い数最大値 */

/* レシート解析結果 */
#define RECEIPT_OK              0   /**< レシート解析正常 */
#define RECEIPT_OK_AMAZON       1   /**< レシート解析正常(Amazon) */
#define REGIST_OK               0   /**< レシート登録正常 */
#define SEARCH_OK               0   /**< 補正情報取得成功 */
#define ADD_IMAGE_OK            0   /**< 画像追加成功 */
#define RECEIPT_ANALYZE_ERR     -1  /**< レシート解析失敗 */
#define RECEIPT_OCR_ERR         -2  /**< OCR処理失敗 */
#define RECEIPT_MEM_ERR         -10 /**< メモリエラー */
#define RECEIPT_LOAD_ERR        -11 /**< ライブラリ読み込みエラー */
#define RECEIPT_SYS_ERR         -12 /**< システムエラー */
#define ERR_ILLEGAL_ARGUMENT    -20 /**< 引数不正 */
#define ERR_OVER_RECEIPT_LIMIT  -21 /**< 解析レシート数超過 */
#define ERR_NO_RECEIPT          -22 /**< 解析済みレシートなし */
#define ERR_OUT_OF_AREA         -23 /**< 圏外 */
#define REGIST_NG               -24 /**< レシート登録失敗 */
#define SEARCH_NG               -25 /**< 補正情報取得失敗 */
#define ADD_IMAGE_NG            -26 /**< 画像追加失敗 */
#define ERR_NO_IMAGE            -27 /**< レシート画像なし */
#define ERR_OVER_IMAGE_LIMIT    -28 /**< レシート画像数超過 */

/* 接続先 */
#define PRODUCTION              0   /**< 本番環境 */
#define STAGING                 1   /**< 検証環境 */

#define DEFAULT_TIMEOUT 60.0 /* 通信タイムアウト(デフォルト値) */

/** @brief 日付情報構造体 */
typedef struct tagAnalyzerDateInfo {
    uint16_t year;      /**< 年 */
    uint16_t month;     /**< 月 */
    uint16_t day;       /**< 日 */
    uint16_t hour;      /**< 時 */
    uint16_t minute;    /**< 分 */
    uint16_t second;    /**< 秒 */
} AnalyzerDateInfo;

/** @brief 分類情報構造体 */
typedef struct tagAnalyzerCategoryInfo {
    __unsafe_unretained NSString *largeCategory;        /**< 分類名(大分類) */
    __unsafe_unretained NSString *middleCategory;       /**< 分類名(中分類) */
    __unsafe_unretained NSString *smallCategory;        /**< 分類名(小分類) */
    __unsafe_unretained NSString *detailedCategory;     /**< 分類名(細分類) */
    __unsafe_unretained NSString *largeCategoryCode;    /**< 分類コード(大分類) */
    __unsafe_unretained NSString *middleCategoryCode;   /**< 分類コード(中分類) */
    __unsafe_unretained NSString *smallCategoryCode;    /**< 分類コード(小分類) */
    __unsafe_unretained NSString *detailedCategoryCode; /**< 分類コード(細分類) */
    __unsafe_unretained NSString *name;                 /**< 商品名 */
    __unsafe_unretained NSString *janCode;              /**< JANコード */
} AnalyzerCategoryInfo;

/** @brief 品目構造体 */
typedef struct tagAnalyzerItemInfo {
    __unsafe_unretained NSString *name;                              /**< 名称 */
    int price;                                   /**< 金額 */
    int unitPrice;                               /**< 単価 */
    int itemNum;                                 /**< 個数 */
    __unsafe_unretained NSString *janCode;                           /**< JANコード */
    __unsafe_unretained NSString *searchName;                        /**< 検索結果としてヒットした品目名 */
    size_t cnt;                                  /**< 分類情報数 */
    AnalyzerCategoryInfo category[CATEGORY_MAX]; /**< 分類情報 */
} AnalyzerItemInfo;

/** @brief 支払い構造体 */
typedef struct tagAnalyzerPaymentInfo {
    int price;         /**< 支払い金額(未使用※拡張用) */
    __unsafe_unretained NSString *type;    /**< 支払い種別(現金、クレジット、電子マネー、その他) */
} AnalyzerPaymentInfo;

/** @brief ポイント構造体 */
typedef struct tagAnalyzerPointInfo {
    __unsafe_unretained NSString *cardType;   /**< ポイントカード種別 */
    __unsafe_unretained NSString *cardNum;    /**< ポイントカード番号(下4桁) */
    int availablePoint;   /**< 利用可能ポイント(ポイント残高) */
} AnalyzerPointInfo;

/** @brief レシート解析構造体 */
typedef struct tagAnalyzerReceiptInfo {
    AnalyzerDateInfo date;              /**< 日付 */
    __unsafe_unretained NSString *tel;                      /**< 電話番号 */
    int total;                          /**< 合計金額 */
    size_t cnt;                         /**< 品目数 */
    int priceAdjustment;                /**< 調整金額 */
    AnalyzerItemInfo items[ITEM_MAX];   /**< 品目(nameが0文字は品目無し) */
    AnalyzerPaymentInfo payment[PAYMENT_MAX]; /**< 支払い情報 */
    AnalyzerPointInfo point;            /**< ポイント情報 */
} AnalyzerReceiptInfo;

@interface ReceiptAnalyzer : NSObject

/**
 * レシート解析
 *
 * @param[in] img 画像データ(Y8)
 * @param[in] width 画像幅
 * @param[in] height 画像高さ
 * @param[out] receipt レシート解析結果
 * @return 処理結果
 */
- (int)receiptAnalyze:(char *)img width:(int)width height:(int)height receipt:(AnalyzerReceiptInfo *)receipt;

/**
 * レシート解析
 *
 * @param[in] img 画像データ(RGB)
 * @param[in] width 画像幅
 * @param[in] height 画像高さ
 * @param[out] receipt レシート解析結果
 * @return 処理結果
 */
- (int)receiptAnalyzeRGB:(unsigned int *)img width:(int)width height:(int)height receipt:(AnalyzerReceiptInfo *)receipt;

/**
 * 品目補正
 *
 * @param[in, out] receipt レシート解析結果および補正結果
 * @param[in] userid ユーザーID
 * @return 処理結果
 */
- (int)searchCategoryInfo:(AnalyzerReceiptInfo *)receipt userid:(NSArray *)userid;

/**
 * 品目補正
 *
 * @param[in, out] receipt レシート解析結果および補正結果
 * @param[in] userid ユーザーID
 * @param[in] timeout タイムアウト(秒)
 * @return 処理結果
 */
- (int)searchCategoryInfo:(AnalyzerReceiptInfo *)receipt userid:(NSArray *)userid timeout:(NSTimeInterval)timeout;

/**
 * 画像追加
 *
 * @param[in] img 画像データ(Y8)
 * @param[in] width 画像幅
 * @param[in] height 画像高さ
 * @param[in, out] receiptImage サーバ登録用レシート画像
 * @return 処理結果
 */
- (int)addReceiptImage:(char *)img width:(int)width height:(int)height receiptImage:(NSMutableArray*)receiptImage;

/**
 * 画像追加
 *
 * @param[in] img 画像データ(RGB)
 * @param[in] width 画像幅
 * @param[in] height 画像高さ
 * @param[in, out] receiptImage サーバ登録用レシート画像
 * @return 処理結果
 */
- (int)addReceiptImageRGB:(unsigned int *)img width:(int)width height:(int)height receiptImage:(NSMutableArray*)receiptImage;

/**
 * レシート登録
 *
 * @param[in] receipt レシート解析結果
 * @param[in] receiptImage サーバ登録用レシート画像
 * @param[in] userid ユーザーID
 * @return 処理結果
 */
- (int)receiptRegist:(AnalyzerReceiptInfo *)receipt receiptImage:(NSMutableArray*)receiptImage userid:(NSArray *)userid;

/**
 * レシート登録
 *
 * @param[in] receipt レシート解析結果
 * @param[in] receiptImage サーバ登録用レシート画像
 * @param[in] userid ユーザーID
 * @param[in] timeout タイムアウト(秒)
 * @return 処理結果
 */
- (int)receiptRegist:(AnalyzerReceiptInfo *)receipt receiptImage:(NSMutableArray*)receiptImage userid:(NSArray *)userid timeout:(NSTimeInterval)timeout;

/**
 * 長尺レシート解析
 * 初期化
 *
 * @return 常に0
 */
- (int)initLongReceipt;

/**
 * 長尺レシート解析
 * レシート分割解析結果設定
 *
 * @return 処理結果(0:成功、0未満：失敗)
 */
- (int)setDividedLongReceipt;

/**
 * 長尺レシート解析
 * レシート分割解析
 *
 * @param[in] img 画像データ(Y8)
 * @param[in] width 画像幅
 * @param[in] height 画像高さ
 * @param[out] receipt レシート解析結果
 * @return 処理結果
 */
- (int)analyzeDividedLongReceipt:(char *)img width:(int)width height:(int)height receipt:(AnalyzerReceiptInfo *)receipt;

/**
 * 長尺レシート解析
 * レシート分割解析
 *
 * @param[in] img 画像データ(RGB)
 * @param[in] width 画像幅
 * @param[in] height 画像高さ
 * @param[out] receipt レシート解析結果
 * @return 処理結果
 */
- (int)analyzeDividedLongReceiptRGB:(unsigned int *)img width:(int)width height:(int)height receipt:(AnalyzerReceiptInfo *)receipt;

/**
 * 長尺レシート解析
 * 長尺レシート解析
 *
 * @param[out] receipt レシート解析結果
 * @return 処理結果
 */
- (int)analyzeLongReceipt:(AnalyzerReceiptInfo *)receipt;

/**
 * 長尺レシート解析
 * 長尺レシート解析中止
 *
 * @return 常に0
 */
- (int)cancelLongAnalyze;

/**
 * レシート解析
 * エンジン バージョン取得
 *
 * @param[out] major メジャーバージョン
 * @param[out] minor マイナーバージョン
 * @param[out] revision リビジョンバージョン
 */
- (void)getEngineVersion:(int *)major minor:(int *)minor revision:(int *)revision;

/**
 * 接続先取得
 *
 * @return 接続先
 */
- (int)getConnectionEnvironment;

/**
 * エラー詳細情報取得
 *
 * @return エラー詳細情報
 */
- (NSString *)getLastErrDetail;

/**
 * システム バージョン取得
 *
 * @param[out] major メジャーバージョン
 * @param[out] minor マイナーバージョン
 * @param[out] revision リビジョンバージョン
 */
- (void)getSystemVersion:(int *)major minor:(int *)minor revision:(int *)revision;

/**
 * システムタイプ取得
 *
 * @return システムタイプ
 */
- (int)getSystemType;

@end



