//
//  ZCTradeView.m
//  直销银行
//
//  Created by 塔利班 on 15/4/30.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//

// 自定义Log
#ifdef DEBUG // 调试状态, 打开LOG功能
#define ZCLog(...) NSLog(__VA_ARGS__)
#define ZCFunc ZCLog(@"%s", __func__);
#else // 发布状态, 关闭LOG功能
#define ZCLog(...)
#define ZCFunc
#endif

// 设备判断
/**
 iOS设备宽高比
 4\4s {320, 480}  5s\5c {320, 568}  6 {375, 667}  6+ {414, 736}
 0.66             0.56              0.56          0.56
 */
#define ios7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define ios8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define ios6 ([[UIDevice currentDevice].systemVersion doubleValue] >= 6.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 7.0)
#define ios5 ([[UIDevice currentDevice].systemVersion doubleValue] < 6.0)
#define iphone5  ([UIScreen mainScreen].bounds.size.height == 568)
#define iphone6  ([UIScreen mainScreen].bounds.size.height == 667)
#define iphone6Plus  ([UIScreen mainScreen].bounds.size.height == 736)
#define iphone4  ([UIScreen mainScreen].bounds.size.height == 480)
#define ipadMini2  ([UIScreen mainScreen].bounds.size.height == 1024)

#import "ZCTradeView.h"

#import "UIAlertView+Quick.h"

@interface ZCTradeView () <UIAlertViewDelegate,ZCTradeInputViewDelegate,UITextFieldDelegate,NumberKeyboardDelegate>


/** 蒙板 */
@property (nonatomic, strong) UIButton *cover;
/** 返回密码 */
@property (nonatomic, copy) NSString *passWord;

@end

@implementation ZCTradeView

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:ZCScreenBounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        /** 蒙板 */
        [self setupCover];
        /** 输入框 */
        [self setupInputView];
        /** 响应者 */
        [self setupResponsder];
    }
    return self;
}

/** 蒙板 */
- (void)setupCover
{
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cover];
    self.cover = cover;
    [self.cover setBackgroundColor:[UIColor blackColor]];
    self.cover.alpha = 0.4;
}

/** 输入框 */
- (void)setupInputView
{
    ZCTradeInputView *inputView = [[NSBundle mainBundle] loadNibNamed:@"ZCTradeInputView" owner:nil options:nil][0];
    inputView.delegate = self;
    inputView.layer.masksToBounds = YES;
    inputView.layer.cornerRadius = 5;
    [self addSubview:inputView];
    self.inputView = inputView;
    
    /** 注册取消按钮点击的通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancle) name:ZCTradeInputViewCancleButtonClick object:nil];
}

-(void)tradeInputView:(ZCTradeInputView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtn
{
    if ([_delegate respondsToSelector:@selector(tradeView:cancleBtnClick:)]) {
        [_delegate tradeView:self cancleBtnClick:cancleBtn];
    }
}

/** 响应者 */
- (void)setupResponsder
{
    UITextField *responsder = [[UITextField alloc] init];
    responsder.delegate = self;
    responsder.keyboardType = UIKeyboardTypeNumberPad;
    NumberKeyboard *keyboard = [[NumberKeyboard alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 216)];
    responsder.inputView = keyboard;
    keyboard.delegate = self;
    
    [self addSubview:responsder];
    self.responsder = responsder;
}

#pragma mark ---NumberKeyboardDelegate自定义数字键盘
-(void)numberKeyboardReleaseKeyBoard
{
    [self.responsder resignFirstResponder];
}


static NSString *tempStr = @"";
-(void)numberKeyboardInput:(NSInteger)number
{
    if (number == 12 ) {
        
        if (tempStr.length > 0) {
            
            tempStr = [tempStr substringToIndex:tempStr.length - 1];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeKeyboardDeleteButtonClick object:self];

    }else{
    
        tempStr = [NSString stringWithFormat:@"%@%@",tempStr,[NSString stringWithFormat:@"%ld",(long)number]];
        
        if (tempStr.length == 6) {
            
            
            [self hidenKeyboard:^(BOOL finished) {
                [self removeFromSuperview];
                [self hidenKeyboard:nil];
            }];
            
            // 通知代理\传递密码
            if ([self.delegate respondsToSelector:@selector(finish:)]) {
                [self.delegate finish:tempStr];
            }
            //            // 回调block\传递密码
            if (self.finish) {
                self.finish(tempStr);
            }
            
            tempStr = @"";
            
        }
        
        NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
        userInfoDict[ZCTradeKeyboardNumberKey] = [NSString stringWithFormat:@"%ld",(long)number];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeKeyboardNumberButtonClick object:self userInfo:userInfoDict];
    }
   
}

/** 输入框的取消按钮点击 */
- (void)cancle
{
    [self hidenKeyboard:^(BOOL finished) {
        self.inputView.hidden = YES;
//        [self.countArray removeAllObjects];
        [self removeFromSuperview];
        [self hidenKeyboard:nil];
        [self.inputView setNeedsDisplay];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /** 蒙板 */
    self.cover.frame = self.bounds;
}

/** 键盘弹出 */
- (void)showKeyboard
{
    CGFloat marginTop;
    if (iphone4) {
        marginTop = 42;
    } else if (iphone5) {
        marginTop = 100;
    } else if (iphone6) {
        marginTop = 120;
    } else {
        marginTop = 140;
    }
    
    [self.responsder becomeFirstResponder];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.inputView.transform = CGAffineTransformMakeTranslation(0, marginTop - 30 - self.inputView.y);
    } completion:^(BOOL finished) {
    }];
}

/** 键盘退下 */
- (void)hidenKeyboard:(void (^)(BOOL finished))completion
{
    [self.responsder endEditing:NO];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.inputView.transform = CGAffineTransformIdentity;
    } completion:completion];
}

/** 快速创建 */
+ (instancetype)tradeView
{
    return [[self alloc] init];
}

// 关闭键盘
- (void)hidenKeyboard
{
    [self removeFromSuperview];
    [self hidenKeyboard:nil];
}

- (void)showInView:(UIView *)view
{
    // 浮现
    [view addSubview:self];

    /** 输入框起始frame */
    
    self.inputView.width = ZCScreenWidth * 0.9;
    self.inputView.height = ZCScreenWidth * 0.72;

    self.inputView.y = (self.height - self.inputView.height) * 0.5;
    self.inputView.x = (ZCScreenWidth - self.inputView.width) * 0.5;
    
    /** 弹出键盘 */
    [self showKeyboard];
}

@end
