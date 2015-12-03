//
//  ViewController.m
//  CustomizePasswordView
//
//  Created by Leione on 15/12/3.
//  Copyright © 2015年 Leione. All rights reserved.
//

#import "ViewController.h"
#import "ZCTradeView.h"

@interface ViewController ()<ZCTradeViewDelegate>
@property (nonatomic,strong) ZCTradeView *zctView;
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)inputPassword:(UIButton *)sender
{
    __block ViewController *blockSelf = self;
    
    self.zctView = [ZCTradeView tradeView];
    
    [self.zctView showInView:self.view.window];
    self.zctView.delegate = self;
    self.zctView.inputView.aimLabel.text = @"信用卡还款";
    self.zctView.inputView.amountLabel.text = @"￥888.00";
    self.zctView.inputView.bankLabel.text = @"6223002271530022357";
    
    self.zctView.finish = ^(NSString *passWord){
        
        blockSelf.passwordLabel.text = [NSString stringWithFormat:@"输入的密码是:%@",passWord];
            
    };

}

@end
