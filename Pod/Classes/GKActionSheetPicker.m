//
//  GKActionSheetPicker.m
//  
//
//  Created by GK on 15.09.10..
//
//

#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"

#define AnimationDuration 0.3f
#define PickerHeight 260.f
#define PickerViewHeight 216.f
#define ToolbarHeight 44.f

typedef NS_ENUM(NSUInteger, GKActionSheetPickerType) {
    GKActionSheetPickerTypeString,
    GKActionSheetPickerTypeMultiColumnString,
    GKActionSheetPickerTypeDate
};

@interface GKActionSheetPicker () <UIPickerViewDataSource, UIPickerViewDelegate, UIToolbarDelegate>

@property (nonatomic) GKActionSheetPickerType pickerType;

//! Used when `pickerType` is `GKActionSheetPickerTypeMultiColumnString`. Stores NSArrays of `GKActionSheetPickerItem` objects
@property (nonatomic, strong) NSArray *components;
@property (nonatomic, strong) NSArray *selections;

//! Used when `pickerType` is `GKActionSheetPickerTypeString`. Stores `GKActionSheetPickerItem` objects
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) id selection;

//! Used when `pickerType` is `GKActionSheetPickerTypeDate`
@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic) BOOL isOpen;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *overlayLayerView;
@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *selectButton;

@property (nonatomic, strong) UITapGestureRecognizer *layerTapRecognizer;

@end


@implementation GKActionSheetPicker

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.pickerType = GKActionSheetPickerTypeString;
        self.isOpen = NO;
        self.dismissType = GKActionSheetPickerDismissTypeNone;
        self.cancelButtonEnabled = YES;
    }
    
    return self;
}

+ (instancetype)stringPickerWithItems:(NSArray *)items selectCallback:(GKActionSheetPickerSelectCallback)selectCallback cancelCallback:(GKActionSheetPickerCancelCallback)cancelCallback
{
    GKActionSheetPicker *picker = [GKActionSheetPicker new];

    picker.pickerType = GKActionSheetPickerTypeString;
    
    NSMutableArray *parsedItems = [NSMutableArray new];
    
    for (id object in items) {
        GKActionSheetPickerItem *item;
        
        if ([object isKindOfClass:[NSString class]]) {
            item = [GKActionSheetPickerItem pickerItemWithTitle:object value:object];
        } else if ([object isKindOfClass:[GKActionSheetPickerItem class]]) {
            item = object;
        }
        
        if (item) {
            [parsedItems addObject:item];
        }
    }
    
    picker.items = parsedItems;
    
    picker.selectCallback = selectCallback;
    picker.cancelCallback = cancelCallback;
    
    return picker;
}

+ (instancetype)multiColumnStringPickerWithComponents:(NSArray *)components selectCallback:(GKActionSheetPickerSelectCallback)selectCallback cancelCallback:(GKActionSheetPickerCancelCallback)cancelCallback
{
    GKActionSheetPicker *picker = [GKActionSheetPicker new];
    
    picker.pickerType = GKActionSheetPickerTypeMultiColumnString;
    
    NSMutableArray *parsedComponents = [NSMutableArray new];
    
    for (NSArray *items in components) {
        NSMutableArray *parsedItems = [NSMutableArray new];
        
        for (id object in items) {
            GKActionSheetPickerItem *item;
            
            if ([object isKindOfClass:[NSString class]]) {
                item = [GKActionSheetPickerItem pickerItemWithTitle:object value:object];
            } else if ([object isKindOfClass:[GKActionSheetPickerItem class]]) {
                item = object;
            }
            
            if (item) {
                [parsedItems addObject:item];
            }
        }
        
        [parsedComponents addObject:parsedItems];
    }
    
    picker.components = parsedComponents;
    
    picker.selectCallback = selectCallback;
    picker.cancelCallback = cancelCallback;
    
    return picker;
}

+ (instancetype)datePickerWithMode:(UIDatePickerMode)datePickerMode from:(NSDate *)minimumDate to:(NSDate *)maximumDate interval:(NSInteger)minuteInterval selectCallback:(GKActionSheetPickerSelectCallback)selectCallback cancelCallback:(GKActionSheetPickerCancelCallback)cancelCallback;
{
    GKActionSheetPicker *picker = [GKActionSheetPicker new];
    
    NSAssert(YES, @"Not yet implemented");
    
    return picker;
}

#pragma mark - Accessors

- (UIColor *)overlayLayerColor
{
    if (!_overlayLayerColor) {
        _overlayLayerColor = [UIColor colorWithWhite:0 alpha:0.25f];
    }
    
    return _overlayLayerColor;
}

- (UIView *)overlayLayerView
{
    if (!_overlayLayerView) {
        _overlayLayerView = [UIView new];
        _overlayLayerView.userInteractionEnabled = YES;
        _overlayLayerView.backgroundColor = self.overlayLayerColor;
    }
    
    return _overlayLayerView;
}

- (UIView *)pickerContainerView
{
    if (!_pickerContainerView) {
        _pickerContainerView = [UIView new];
        _pickerContainerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _pickerContainerView;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [UIPickerView new];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    
    return _pickerView;
}

- (UIToolbar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [UIToolbar new];
        _toolBar.delegate = self;
    }
    
    return _toolBar;
}

- (GKActionSheetPickerCancelCallback)cancelCallback
{
    if (!_cancelCallback) {
        _cancelCallback = ^{};
    }
    
    return _cancelCallback;
}

- (GKActionSheetPickerSelectCallback)selectCallback
{
    if (!_selectCallback) {
        _selectCallback = ^(id selection) {};
    }
    
    return _selectCallback;
}

- (NSString *)cancelButtonTitle
{
    if (!_cancelButtonTitle) {
        _cancelButtonTitle = @"Cancel";
    }
    
    return _cancelButtonTitle;
}

- (NSString *)selectButtonTitle
{
    if (!_selectButtonTitle) {
        _selectButtonTitle = @"OK";
    }
    
    return _selectButtonTitle;
}

- (UIBarButtonItem *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIBarButtonItem alloc] initWithTitle:self.cancelButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
        _cancelButton.imageInsets = UIEdgeInsetsMake(0, 20.f, 0, 20.f);
    }
    
    return _cancelButton;
}

- (UIBarButtonItem *)selectButton
{
    if (!_selectButton) {
        _selectButton = [[UIBarButtonItem alloc] initWithTitle:self.selectButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(selectButtonPressed:)];
    }
    
    return _selectButton;
}

#pragma mark - Functions

- (void)presentPickerOnView:(UIView *)view
{
    CGRect hostFrame = view.window.frame;
    
    NSLog(@"Frame: %@", NSStringFromCGRect(hostFrame));
    
    // Add overlay
    self.overlayLayerView.alpha = 0;
    self.overlayLayerView.frame = hostFrame;
    self.overlayLayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [view.window addSubview:self.overlayLayerView];
    
    // Add click handler to overlay
    if (self.dismissType == GKActionSheetPickerDismissTypeSelect) {
        self.layerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectButtonPressed:)];
        [self.overlayLayerView addGestureRecognizer:self.layerTapRecognizer];
    } else if (self.dismissType == GKActionSheetPickerDismissTypeCancel) {
        self.layerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonPressed:)];
        [self.overlayLayerView addGestureRecognizer:self.layerTapRecognizer];
    }
    
    // Add picker container
    CGRect pickerContainerSourceFrame = CGRectMake(0,
                                                   hostFrame.size.height,
                                                   hostFrame.size.width,
                                                   PickerHeight);
    CGRect pickerContainerDestinationFrame = CGRectMake(0,
                                                   hostFrame.size.height - PickerHeight,
                                                   hostFrame.size.width,
                                                   PickerHeight);
    self.pickerContainerView.frame = pickerContainerSourceFrame;
    [view.window addSubview:self.pickerContainerView];
    
    // Add toolbar
    self.toolBar.frame = CGRectMake(0, 0, hostFrame.size.width, ToolbarHeight);
    [self.pickerContainerView addSubview:self.toolBar];

    // Toolbar spacer
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 15.f;

    // Add buttons
    NSMutableArray *toolBarItems = [NSMutableArray new];
    
    if (self.cancelButtonEnabled) {
        [self.cancelButton setTitle:self.cancelButtonTitle];
        [toolBarItems addObject:spacer];
        [toolBarItems addObject:self.cancelButton];
    }
    
    [toolBarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    
    [self.selectButton setTitle:self.selectButtonTitle];
    [toolBarItems addObject:self.selectButton];
    [toolBarItems addObject:spacer];
    
    [self.toolBar setItems:toolBarItems animated:NO];
    
    // Add picker
    self.pickerView.frame = CGRectMake(0, ToolbarHeight, hostFrame.size.width, PickerViewHeight);
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.pickerContainerView addSubview:self.pickerView];
    
    // Show overlay
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.overlayLayerView.alpha = 1.f;
    } completion:^(BOOL finished) {
        //
    }];
    
    [UIView animateWithDuration:AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.pickerContainerView.frame = pickerContainerDestinationFrame;
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)dismissPickerView
{
    CGRect pickerContainerDestinationFrame = CGRectMake(0,
                                                        self.pickerContainerView.frame.origin.y + PickerHeight,
                                                        self.pickerContainerView.frame.size.width,
                                                        PickerHeight);

    [UIView animateWithDuration:AnimationDuration animations:^{
        self.overlayLayerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.overlayLayerView removeFromSuperview];
        [self.overlayLayerView removeGestureRecognizer:[self.overlayLayerView.gestureRecognizers firstObject]];
    }];
    
    [UIView animateWithDuration:AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.pickerContainerView.frame = pickerContainerDestinationFrame;
    } completion:^(BOOL finished) {
        [self.pickerContainerView removeFromSuperview];
    }];
}

- (void)selectValue:(id)value
{
    NSAssert(self.pickerType == GKActionSheetPickerTypeString, @"-selectValue: can be used only when picker is initialized with -stringPickerWithItems:selectCallback:cancelCallback:");

    NSUInteger index = 0;
    NSUInteger i = 0;
    for (GKActionSheetPickerItem *item in self.items) {
        if ([item.value isEqual:value]) {
            index = i;
        }
        
        i += 1;
    }
    
    [self.pickerView selectRow:index inComponent:0 animated:NO];
}

- (void)selectValues:(NSArray *)values
{
    NSUInteger i=0;
    for (id value in values) {
        [self selectValue:value inComponent:i];
        i += 1;
    }
}

- (void)selectValue:(id)value inComponent:(NSUInteger)component
{
    NSAssert(self.pickerType == GKActionSheetPickerTypeMultiColumnString, @"-selectValue: can be used only when picker is initialized with -multiColumnStringPickerWithComponents:selectCallback:cancelCallback:");
    
    NSUInteger index = 0;
    NSUInteger i = 0;
    for (GKActionSheetPickerItem *item in [self.components objectAtIndex:component]) {
        if ([item.value isEqual:value]) {
            index = i;
        }
        
        i += 1;
    }
    
    [self.pickerView selectRow:index inComponent:component animated:NO];
}

#pragma mark - <UIPickerViewDataSource>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerType == GKActionSheetPickerTypeString) {
        
        return 1;
        
    } else if (self.pickerType == GKActionSheetPickerTypeMultiColumnString) {
        
        return self.components.count;
    }
    
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerType == GKActionSheetPickerTypeString) {
        
        return self.items.count;
        
    } else if (self.pickerType == GKActionSheetPickerTypeMultiColumnString) {
        
        NSArray *componentArray = [self.components objectAtIndex:component];
        return componentArray.count;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickerType == GKActionSheetPickerTypeString) {
        
        GKActionSheetPickerItem *item = [self.items objectAtIndex:row];
        return item.title;
        
    } else if (self.pickerType == GKActionSheetPickerTypeMultiColumnString) {
        
        NSArray *componentArray = [self.components objectAtIndex:component];
        GKActionSheetPickerItem *item = [componentArray objectAtIndex:row];
        return item.title;
    }
    
    return nil;
}

#pragma mark - <UIPickerViewDelegate>

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self updateSelection];
    
    if (self.pickerType == GKActionSheetPickerTypeString) {
        
        if ([self.delegate respondsToSelector:@selector(actionSheetPicker:didChangeValue:)]) {
            [self.delegate actionSheetPicker:self didChangeValue:self.selection];
        }
        
    } else if (self.pickerType == GKActionSheetPickerTypeMultiColumnString) {
        
        if ([self.delegate respondsToSelector:@selector(actionSheetPicker:didChangeValue:)]) {
            [self.delegate actionSheetPicker:self didChangeValue:self.selections];
        }
    }
}

#pragma mark - <UIToolbarDelegat>

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    if (bar == self.toolBar) {
        return UIBarPositionTop;
    }
    
    return UIBarPositionAny;
}

#pragma mark - GUI actions

- (void)selectButtonPressed:(UIGestureRecognizer *)gestureRecognizer
{
    [self updateSelection];
    
    if (self.pickerType == GKActionSheetPickerTypeString) {
        
        if ([self.delegate respondsToSelector:@selector(actionSheetPicker:didSelectValue:)]) {
            [self.delegate actionSheetPicker:self didSelectValue:self.selection];
        }
        
       self.selectCallback(self.selection);
        
    } else if (self.pickerType == GKActionSheetPickerTypeMultiColumnString) {
        
        if ([self.delegate respondsToSelector:@selector(actionSheetPicker:didSelectValue:)]) {
            [self.delegate actionSheetPicker:self didSelectValue:self.selections];
        }
        
        self.selectCallback(self.selections);
    }

    [self dismissPickerView];
}

- (void)cancelButtonPressed:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(actionSheetPickerDidCancel:)]) {
        [self.delegate actionSheetPickerDidCancel:self];
    }
    
    self.cancelCallback();
    
    [self dismissPickerView];
}

#pragma mark - Helper

- (void)updateSelection
{
    if (self.pickerType == GKActionSheetPickerTypeString) {
        
        NSUInteger index = [self.pickerView selectedRowInComponent:0];
        GKActionSheetPickerItem *item = [self.items objectAtIndex:index];
        self.selection = item.value;
        
    } else if (self.pickerType == GKActionSheetPickerTypeMultiColumnString) {

        NSMutableArray *selections = [NSMutableArray new];
        
        for (NSUInteger i=0; i<self.components.count; i++) {
            NSUInteger index = [self.pickerView selectedRowInComponent:i];
            NSArray *component = [self.components objectAtIndex:i];
            GKActionSheetPickerItem *item = [component objectAtIndex:index];
            [selections addObject:item.value];
        }
        
        self.selections = selections;

    } else if (self.pickerType == GKActionSheetPickerTypeDate) {
        // TODO
    }
}

@end
