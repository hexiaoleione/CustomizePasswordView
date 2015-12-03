//
//  NumberKeyboard.h
//  doctorGrey
//
//  Created by Leione on 15/6/23.
//  Copyright (c) 2015年 Leione. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberKeyboardDelegate <NSObject>


/**传递点击数字*/
- (void) numberKeyboardInput:(NSInteger) number;

/**回收键盘*/
- (void) numberKeyboardReleaseKeyBoard;
@end

@interface NumberKeyboard : UIView
//{
//    NSArray *arrLetter;
//}
{
    NSMutableArray *resultArray;
}
@property (nonatomic,assign) id<NumberKeyboardDelegate> delegate;
@end
