# ZCActionSheet
仿微信的一个向上弹出的选择框。因为效果很像`UIActionSheet`，姑且命名为`ZCActionSheet`吧。

[![Build Status](https://travis-ci.org/zcill/ZCActionSheet.svg?branch=master)](https://travis-ci.org/zcill/ZCActionSheet)

![ZCActionSheetTest](https://github.com/zcill/ZCActionSheet/blob/master/ScreenShots%2FZCActionSheetTest.gif)
![ZCActionSheetShot](https://github.com/zcill/ZCActionSheet/blob/master/ScreenShots%2FZCActionSheetShot.png)

## Usage
无需初始化，直接调用`showWithItemBlock`类方法，使用`addItemWithLabelText: shouldDismiss:`方法添加按钮即可

```
    [ZCActionSheet showWithItemBlock:^(id<ZCActionSheetItemsProtocol> items) {
        
        [items addItemWithLabelText:@"退出后不回删除任何历史数据，下次登录依然可以使用本帐号" style:ZCActionSheetItemStyleDescription shouldDismiss:YES];
        [items addItemWithLabelText:@"退出登录" style:ZCActionSheetItemStyleDestructive shouldDismiss:YES];
        
    } selectedBlock:^(NSInteger indexPath) {
        NSLog(@"%ld", indexPath);
    }];
```

## TO DO
- [x] ~~ZCActionSheetStyle~~
- [ ] more Extension

## License

ZCActionSheet is available under the MIT license. See the LICENSE file for more info.