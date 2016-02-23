//
//  ZCActionSheet.m
//  ZCActionSheet
//
//  Created by 朱立焜 on 16/2/23.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCActionSheet.h"

static NSString *const kSelectionCellName = @"kSelectionCellName";
//static NSString *const kSelectionCellImageName = @"kSelectionCellImageName";
static NSString *const kSelectionCellTagKey = @"kSelectionCellTagKey";
static NSString *const kSelectionShouldDismissKey = @"kSelectionShouldDismissKey";

#define kColorWithHex(hex) [UIColor colorWithRed:((hex>>16)&0xFF)/255.0f green:((hex>>8)&0xFF)/255.0f blue:(hex&0xFF)/255.0f alpha:1.0f]
#define kColorWithRed(R, G, B) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:1]

#pragma mark - ZCActionSheetItems

@interface ZCActionSheetItems : NSObject<ZCActionSheetItemsProtocol>

@property (nonatomic, strong) NSMutableArray *itemsArray;

- (NSInteger)count;

@end

@implementation ZCActionSheetItems

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemsArray = [NSMutableArray array];
    }
    return self;
}

- (void)addItemWithLabelText:(NSString *)labelText shouldDismiss:(BOOL)shouldDismiss {
    if ([labelText isKindOfClass:[NSString class]]) {
        NSDictionary *itemDic = [NSDictionary dictionaryWithObjectsAndKeys:labelText, kSelectionCellName,
                                 [NSNumber numberWithBool:shouldDismiss], kSelectionShouldDismissKey, nil];
        [self.itemsArray addObject:itemDic];
    }
}

- (NSInteger)count {
    return self.itemsArray.count;
}

@end


#pragma mark - ZCActionSheetCell

@interface ZCActionSheetCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSDictionary *infoDictionary;

@end

@implementation ZCActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:[UIColor colorWithRed:1.000 green:0.155 blue:0.276 alpha:1.000]];
        self.label = label;
        [self.contentView addSubview:label];
        
        UIView *lineView = [[UIView alloc] init];
        self.lineView = lineView;
        lineView.backgroundColor = kColorWithHex(0xd2d5d9);
        [self.contentView addSubview:lineView];
        
        // super class's selectedBackgroundView override
        UIView *selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = selectedBackgroundView;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelW = self.bounds.size.width;
    CGFloat labelH = self.bounds.size.height;
    self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);

    CGFloat lineX = 0;
    CGFloat lineW = self.bounds.size.width - lineX;
    CGFloat lineH = 0.5;
    CGFloat lineY = self.bounds.size.height - lineH;
    self.lineView.frame = CGRectMake(lineX, lineY, lineW, lineH);
}

- (void)setInfoDictionary:(NSDictionary *)infoDictionary {
    _infoDictionary = infoDictionary;
    
    NSString *nameStr = infoDictionary[kSelectionCellName];
    self.label.text = [nameStr description];
}

@end

#pragma mark - ZCActionSheetCancelCell

@interface ZCActionSheetCancelCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;

@end

@implementation ZCActionSheetCancelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"取消";
        [self.contentView addSubview:label];
        self.label = label;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        [label setTextColor:[UIColor blackColor]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelH = self.bounds.size.height;
    CGFloat labelW = self.bounds.size.width;
    
    self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);
}

@end

#pragma mark - ZCActionSheetView

@interface ZCActionSheet()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *selectionTableView;
@property (nonatomic, strong) ZCActionSheetItems *items;
@property (nonatomic, copy) void (^selectedBlock)(NSInteger indexPath);

@end

@implementation ZCActionSheet

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.frame = keyWindow.bounds;
        
        UIView *gesView = [[UIView alloc] initWithFrame:self.bounds];
        gesView.backgroundColor = [UIColor clearColor];
        [gesView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)]];
        [self addSubview:gesView];
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addSubview:self.selectionTableView];
        
    }
    return self;
}

#pragma mark - Actions

- (void)dismissView {
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        CGRect selectionTableViewFrame = self.selectionTableView.frame;
        selectionTableViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.selectionTableView.frame = selectionTableViewFrame;
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

#pragma mark - Public
+ (void)showWithItemBlock:(void (^)(id<ZCActionSheetItemsProtocol>))itemBlock selectedBlock:(void (^)(NSInteger))selectedBlock {
    
    ZCActionSheet *actionSheetView = [[ZCActionSheet alloc] initWithFrame:CGRectZero];
    [actionSheetView showWithItemsBlock:itemBlock selectedBlock:selectedBlock];
    
}

- (void)showWithItemsBlock:(void (^)(id <ZCActionSheetItemsProtocol> item))itemsBlock selectedBlock:(void (^)(NSInteger indexPath))selectedBlock {
    
    self.selectedBlock = selectedBlock;
    itemsBlock(self.items);
    
    // 设置tableView的高度
    CGFloat tableVeiwHeight = (self.items.count + 1) * kZCActionSheetCellHeight + 5;
    self.selectionTableView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, tableVeiwHeight);
    
    self.selectionTableView.scrollEnabled = NO;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect selectionTableViewFrame = self.selectionTableView.frame;
        selectionTableViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - tableVeiwHeight;
        self.selectionTableView.frame = selectionTableViewFrame;
    }];
    
}

#pragma mark - getter

- (ZCActionSheetItems *)items {
    if (!_items) {
        _items = [[ZCActionSheetItems alloc] init];
    }
    return _items;
}

- (UITableView *)selectionTableView {
    if (!_selectionTableView) {
        _selectionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _selectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _selectionTableView.dataSource = self;
        _selectionTableView.delegate = self;
    }
    return _selectionTableView;
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.items.count;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ZCActionSheetCellIdentifier = @"ZCActionSheetCell";
    static NSString *ZCActionSheetCancelCellIdentifier = @"ZCActionSheetCancelCell";
    
    UITableViewCell *aCell;
    
    switch (indexPath.section) {
        case 0:{
            ZCActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:ZCActionSheetCellIdentifier];
            if (!cell) {
                cell = [[ZCActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZCActionSheetCellIdentifier];
            }
            if (self.items.count > indexPath.row) {
                cell.infoDictionary = self.items.itemsArray[indexPath.row];
            }
            
            aCell = cell;
            break;
        }
        case 1:{
            ZCActionSheetCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:ZCActionSheetCancelCellIdentifier];
            if (!cell) {
                cell = [[ZCActionSheetCancelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZCActionSheetCancelCellIdentifier];
            }
            
            aCell = cell;
            break;
        }
        default:
            break;
    }
    
    if (!aCell) {
        aCell = [[UITableViewCell alloc] init];
    }
    
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kZCActionSheetCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 4;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.selectionTableView) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.section == 0) {
            self.selectedBlock(indexPath.row);
            if (self.items.itemsArray.count > indexPath.row) {
                BOOL shouldDismiss = [[self.items.itemsArray[indexPath.row] objectForKey:kSelectionShouldDismissKey] boolValue];
                if (shouldDismiss) {
                    [self dismissView];
                }
            }
        } else {
            [self dismissView];
        }
    }
}

@end







