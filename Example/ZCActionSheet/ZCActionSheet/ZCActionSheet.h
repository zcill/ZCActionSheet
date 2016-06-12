//
//  ZCActionSheet.h
//  ZCActionSheet
//
//  Created by 朱立焜 on 16/2/23.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kZCActionSheetCellHeight 50
typedef NS_ENUM(NSUInteger, ZCActionSheetItemStyle) {
    ZCActionSheetItemStyleDefault = 0,
    ZCActionSheetItemStyleDestructive,
    ZCActionSheetItemStyleDescription,
};

@protocol ZCActionSheetItemsProtocol <NSObject>

@required
/**
 *  添加一个按钮
 *
 *  @param labelText     按钮的文字
 *  @param style         
 *  @param shouldDismiss <#shouldDismiss description#>
 */
- (void)addItemWithLabelText:(NSString *)labelText style:(ZCActionSheetItemStyle)style shouldDismiss:(BOOL)shouldDismiss;

@end

@interface ZCActionSheet : UIView

+ (void)showWithItemBlock:(void (^)(id <ZCActionSheetItemsProtocol> items))itemBlock selectedBlock:(void (^)(NSInteger indexPath))selectedBlock;

@end
