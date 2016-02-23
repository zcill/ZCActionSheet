//
//  ZCActionSheet.h
//  ZCActionSheet
//
//  Created by 朱立焜 on 16/2/23.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kZCActionSheetCellHeight 50

@protocol ZCActionSheetItemsProtocol <NSObject>

@required
- (void)addItemWithLabelText:(NSString *)labelText shouldDismiss:(BOOL)shouldDismiss;

@end

@interface ZCActionSheet : UIView

+ (void)showWithItemBlock:(void (^)(id <ZCActionSheetItemsProtocol> items))itemBlock selectedBlock:(void (^)(NSInteger indexPath))selectedBlock;

@end
