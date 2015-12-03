//
//  NumberKeyboard.m
//  doctorGrey
//
//  Created by Leione on 15/6/23.
//  Copyright (c) 2015年 Leione. All rights reserved.
//

#import "NumberKeyboard.h"
#define kLineWidth 1
#define kNumFont [UIFont systemFontOfSize:27]

@implementation NumberKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216);

//生成0-9
        NSArray *temp = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6",@"7", @"8",@"9",nil];
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:temp];
        resultArray = [NSMutableArray array];
        int i;
        
        int count = temp.count;
        
        for (i = 0; i < count; i ++) {
            int index = arc4random() % (count - i);
            [resultArray addObject:[tempArray objectAtIndex:index]];
            [tempArray removeObjectAtIndex:index];            
        }
//        
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                [self addSubview:button];
            }
        }
        
        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];
        //
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, 0, kLineWidth, 216)];
        line1.backgroundColor = color;
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3 * 2, 0, kLineWidth, 216)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        for (int i=0; i<3; i++)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54*(i+1), [UIScreen mainScreen].bounds.size.width, kLineWidth)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
        
    }
    
    return self;
}

-(UIButton *)creatButtonWithX:(NSInteger) x Y:(NSInteger) y
{
    UIButton *button;
    //
    CGFloat frameX;
    CGFloat frameW;
    switch (y)
    {
        case 0:
            frameX = 0.0;
            frameW = [UIScreen mainScreen].bounds.size.width / 3;
            break;
        case 1:
            frameX = [UIScreen mainScreen].bounds.size.width/3 -1;
            frameW = [UIScreen mainScreen].bounds.size.width / 3 + 4;
            break;
        case 2:
            frameX = [UIScreen mainScreen].bounds.size.width/3 * + 2;
            frameW = [UIScreen mainScreen].bounds.size.width / 3;
            break;
            
        default:
            break;
    }
    CGFloat frameY = 54*x;
    
    //
    button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, frameW, 54)];
    

    
    NSInteger num = y+3*x+1;
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *colorNormal = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
    UIColor *colorHightlighted = [UIColor colorWithRed:186.0/255 green:189.0/255 blue:194.0/255 alpha:1.0];
    
    if (num == 10 || num == 12)
    {
        UIColor *colorTemp = colorNormal;
        colorNormal = colorHightlighted;
        colorHightlighted = colorTemp;
    }
    
    button.backgroundColor = colorNormal;
    CGSize imageSize = CGSizeMake(frameW, 54);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [colorHightlighted set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [button setImage:pressedColorImg forState:UIControlStateHighlighted];
    

    
    
    if (num<10)
    {
        
            UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
            button.tag = [resultArray[num-1] integerValue];
            labelNum.text = [NSString stringWithFormat:@"%ld",(long)button.tag];;
            labelNum.textColor = [UIColor blackColor];
            labelNum.textAlignment = NSTextAlignmentCenter;
            labelNum.font = kNumFont;
            [button addSubview:labelNum];

    }
    else if (num == 12)
    {
        button.tag = num;
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
//        label.text = @"X";
//        label.textColor = [UIColor blackColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        [button addSubview:label];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/6-16, 15, 32, 32)];

        image.image = [UIImage imageNamed:@"delectkeyboard"];
        button.backgroundColor = [UIColor whiteColor];
        [button addSubview:image];
        
    }
    else if (num == 11)
    {
        button.tag = num;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.text = @"0";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kNumFont;
        [button addSubview:label];
    }
    else if (num == 10)
    {
//        [button setBackgroundColor:[UIColor redColor]];
//        button.tag = num;
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
//        label.text = @"确定";
//        label.textColor = [UIColor blackColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        [button addSubview:label];
        button.backgroundColor = [UIColor whiteColor];
    }
    else
    {
//        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(42, 19, 22, 17)];
//        arrow.image = [UIImage imageNamed:@"arrowInKeyboard"];
//        [button addSubview:arrow];

        
    }
    
    return button;
}


-(void)clickButton:(UIButton *)sender
{
   if(sender.tag == 10)
    {
        [self.delegate numberKeyboardReleaseKeyBoard];
    }
    else
    {
        NSInteger num = sender.tag;
        if (sender.tag == 11)
        {
            num = 0;
        }
        [self.delegate numberKeyboardInput:num];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
