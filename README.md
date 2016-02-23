# ZCActionSheet
仿微信的一个向上弹出的选择框。因为效果很像`UIActionSheet`，姑且命名为`ZCActionSheet`吧。

![ZCActionSheetTest](https://github.com/zcill/ZCActionSheet/blob/master/ScreenShots%2FZCActionSheetTest.gif)

## Usage
无需初始化，直接调用`showWithItemBlock`类方法，使用`addItemWithLabelText: shouldDismiss:`方法添加按钮即可

```
    [ZCActionSheet showWithItemBlock:^(id<ZCActionSheetItemsProtocol> items) {
        
        [items addItemWithLabelText:@"退出登录" shouldDismiss:YES];
        
    } selectedBlock:^(NSInteger indexPath) {
        NSLog(@"%ld", indexPath);
    }];
```

## TO DO
- [ ] ZCActionSheetStyle
- [ ] more Extension

## License

ZCActionSheet is available under the MIT license. See the LICENSE file for more info.