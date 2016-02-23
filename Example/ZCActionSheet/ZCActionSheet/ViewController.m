//
//  ViewController.m
//  ZCActionSheet
//
//  Created by 朱立焜 on 16/2/23.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ViewController.h"
#import "ZCActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)buttonClick:(UIButton *)sender {
    
    [ZCActionSheet showWithItemBlock:^(id<ZCActionSheetItemsProtocol> items) {
        
        [items addItemWithLabelText:@"退出后不回删除任何历史数据，下次登录依然可以使用本帐号" style:ZCActionSheetItemStyleDescription shouldDismiss:YES];
        [items addItemWithLabelText:@"退出登录" style:ZCActionSheetItemStyleDestructive shouldDismiss:YES];
        
    } selectedBlock:^(NSInteger indexPath) {
        NSLog(@"%ld", indexPath);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
