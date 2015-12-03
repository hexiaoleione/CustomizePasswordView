//
//  ZCTradeInputView.m
//  直销银行
//
//  Created by 塔利班 on 15/4/30.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//

#define ZCTradeInputViewNumCount 6

// 快速生成颜色
#define ZCColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

typedef enum {
    ZCTradeInputViewButtonTypeWithCancle = 10000,
    ZCTradeInputViewButtonTypeWithOk = 20000,
}ZCTradeInputViewButtonType;

#import "ZCTradeInputView.h"
#import "NSString+Extension.h"

@interface ZCTradeInputView ()
/** 数字数组 */
@property (nonatomic, strong) NSMutableArray *nums;
/** 确定按钮 */
@property (nonatomic, weak) UIButton *okBtn;
/** 取消按钮 */

@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

//@property (weak, nonatomic) IBOutlet UIImageView *inputView;
//@property (weak, nonatomic) IBOutlet UIImageView *inputView;


@end

@implementation ZCTradeInputView

#pragma mark - LazyLoad

- (NSMutableArray *)nums
{
    if (_nums == nil) {
        _nums = [NSMutableArray array];
    }
    return _nums;
}

#pragma mark - LifeCircle

- (void)awakeFromNib
{
//    self.backgroundColor = [UIColor clearColor];
    /** 注册keyboard通知 */
    [self setupKeyboardNote];
    /** 添加子控件 */
    [self setupSubViews];
    
}


/** 添加子控件 */
- (void)setupSubViews
{

    [self.cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBtn.tag = ZCTradeInputViewButtonTypeWithCancle;
}

/** 注册keyboard通知 */
- (void)setupKeyboardNote
{
    // 删除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delete) name:ZCTradeKeyboardDeleteButtonClick object:nil];
    
    // 数字通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(number:) name:ZCTradeKeyboardNumberButtonClick object:nil];
}

#pragma mark - Layout

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//}

#pragma mark - Private

// 删除
- (void)delete
{
    [self.nums removeLastObject];
    
//    NSLog(@"delete nums %@ ",self.nums);

    [self setNeedsDisplay];
}

// 数字
- (void)number:(NSNotification *)note
{;
    NSDictionary *userInfo = note.userInfo;
    NSString *numObj = userInfo[ZCTradeKeyboardNumberKey];
    if (numObj.length >= ZCTradeInputViewNumCount) return;
    [self.nums addObject:numObj];
//    NSLog(@"数字 nums %@ ",self.nums);
    [self setNeedsDisplay];

}

// 按钮点击
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == ZCTradeInputViewButtonTypeWithCancle) {  // 取消按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputView:cancleBtnClick:)]) {
            [self.delegate tradeInputView:self cancleBtnClick:btn];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeInputViewCancleButtonClick object:self];
    }
}

- (void)drawRect:(CGRect)rect
{
    // 画图
    UIImage *field = [UIImage imageNamed:@"password_in"];
    
    CGFloat h = 50;
    CGFloat x = 10;
    CGFloat y = rect.size.height - h - 10 ;
    CGFloat w = rect.size.width - 20;
    
    [field drawInRect:CGRectMake(x, y, w, h)];
    
    
    // 画点
    UIImage *pointImage = [UIImage imageNamed:@"yuan"];
    
    CGFloat pointW = h / 3;
    
    CGFloat pointH = pointW;
    
    CGFloat pointY = y + h / 2 - pointW / 2;
    
    CGFloat pointX;
    
    CGFloat start = w / 6 / 2;
    
    CGFloat padding = w / 6;
    
    
    for (int i = 0; i < self.nums.count; i++) {
        
        pointX = start + i * padding ;
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
