//
//  ZCTradeView.h
//  直销银行
//
//  Created by 塔利班 on 15/4/30.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//  交易密码视图\负责整个项目的交易密码输入



#import <UIKit/UIKit.h>
#import "ZCTradeInputView.h"
#import "NumberKeyboard.h"

@class ZCTradeView;

@protocol ZCTradeViewDelegate <NSObject>

@optional
/** 输入完成点击确定按钮 */
- (NSString *)finish:(NSString *)pwd;

/** 点击取消按钮 */
-(void)tradeView:(ZCTradeView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtnClick;

@end

@interface ZCTradeView : UIView

/** 响应者 */
@property (nonatomic, strong) UITextField *responsder;

@property (nonatomic, weak) id<ZCTradeViewDelegate> delegate;
/** 输入框 */
@property (nonatomic, strong) ZCTradeInputView *inputView;
/** 完成的回调block */
@property (nonatomic, copy) void (^finish) (NSString *passWord);

/** 快速创建 */
+ (instancetype)tradeView;

/** 弹出 */
- (void)showInView:(UIView *)view;

/** 键盘退下 */
- (void)hidenKeyboard;

@end
