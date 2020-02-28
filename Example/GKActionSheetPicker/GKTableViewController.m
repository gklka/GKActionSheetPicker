//
//  GKTableViewController.m
//  
//
//  Created by GK on 15.09.10..
//
//

#import "GKTableViewController.h"
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"

@interface GKTableViewController () <GKActionSheetPickerDelegate>

// You have to have a strong reference for the picker
@property (nonatomic, strong) GKActionSheetPicker *picker;

@property (nonatomic, strong) NSString *basicCellSelectedString;
@property (nonatomic, strong) NSString *tintColorCellSelectedString;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;
@property (nonatomic, strong) NSArray *twoRowsSelectedStrings;
@property (nonatomic, strong) NSDictionary *countryRowSelectedCountryDictionary;

@property (nonatomic, strong) NSNumber *customValuesSelectedNumber;

@end


@implementation GKTableViewController

#pragma mark - <UITableViewDataSource>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            #pragma mark - Basic
            
            // Set the selectable items
            NSArray *items = @[@"Apple", @"Orange", @"Peach", @"Pearl", @"Tomato"];

            // Create the picker
            self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
                // This code will be called when the user taps the "OK" button
                
                self.basicCellSelectedString = (NSString *)selected;
                self.basicCellDetailLabel.text = (NSString *)selected;
            
            } cancelCallback:nil];
            
            // Present it
            [self.picker presentPickerOnView:self.view];
            
            // Set to the previously selected value
            [self.picker selectValue:self.basicCellSelectedString];
            
        } else if (indexPath.row == 1) {
            #pragma mark - Date
            
            self.picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDateAndTime from:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365] to:[NSDate new] interval:60*60*24 selectCallback:^(id selected) {
                
                self.dateCellSelectedDate = (NSDate *)selected;
                self.dateCellDetailLabel.text = [NSString stringWithFormat:@"%@", selected];
                
            } cancelCallback:^{
                //
            }];
            
            // Set the title
            self.picker.title = @"Date";
            
            // Present it
            [self.picker presentPickerOnView:self.view];
            
            // Set to the previously selected value
            [self.picker selectDate:self.dateCellSelectedDate];
            
        } else if (indexPath.row == 2) {
            #pragma mark - Two rows

            // Set the selectable items
            NSArray *components = @[
                                    @[@"Apple", @"Orange", @"Peach", @"Pearl", @"Tomato"],
                                    @[@"Soup", @"Juice", @"Salad"]
                                    ];
            
            // Create the picker
            self.picker = [GKActionSheetPicker multiColumnStringPickerWithComponents:components selectCallback:^(id selected) {
                // This code will be called when the user taps the "OK" button
                
                NSArray *array = (NSArray *)selected;
                self.twoRowsSelectedStrings = array;
                self.twoRowsCellDetailLabel.text = [array componentsJoinedByString:@", "];
                
            } cancelCallback:^{
                // This code will be called when the user taps cancel
            }];
            
            // Dismiss on tapping the dark overlay layer
            self.picker.dismissType = GKActionSheetPickerDismissTypeCancel;

            // Set the title
            self.picker.title = @"Two Rows";

            // Present it
            [self.picker presentPickerOnView:self.view];
            
            // Set to previously selected value
            [self.picker selectValue:self.twoRowsSelectedStrings[0] inComponent:0];
            [self.picker selectValue:self.twoRowsSelectedStrings[1] inComponent:1];
            
            // Usage of -selectIndex:inComponent:
//            [self.picker selectIndex:2 inComponent:0];
//            [self.picker selectIndex:1 inComponent:1];
            
        } else if (indexPath.row == 3) {
            #pragma mark - Shorter syntax

            // Set the selectable items
            NSArray *items = @[@"Apple", @"Orange", @"Peach", @"Pearl", @"Tomato"];
            
            // Create the picker
            self.picker = [GKActionSheetPicker stringPickerWithItems:items];
            
            // Set the title
            self.picker.title = @"Shorter Syntax";
            
            // Callback
            __weak __typeof__(self) weakSelf = self;
            self.picker.selectCallback = ^(NSString *selected) {
                weakSelf.shorterSymbolDetailLabel.text = selected;
            };

            // Present it
            [self.picker presentPickerOnView:self.view];
            
            // Set to the previously selected value
            [self.picker selectValue:self.basicCellSelectedString];
            
        } else if (indexPath.row == 4) {
            #pragma mark - Country picker

            // Create the picker
            self.picker = [GKActionSheetPicker countryPickerWithCallback:^(id selected) {
                self.countryRowSelectedCountryDictionary = (NSDictionary *)selected;
                self.countryDetailLabel.text = [self.countryRowSelectedCountryDictionary objectForKey:@"name"];
            } cancelCallback:nil];
        
            // Set the title
            self.picker.title = @"Country Picker";

            // Present it
            [self.picker presentPickerOnView:self.view];
            
            // Set to the previously selected value
            [self.picker selectCountryByCountryCode:[self.countryRowSelectedCountryDictionary objectForKey:@"ISO3166-1-Alpha-2"]];
        } else if (indexPath.row == 5) {
            #pragma mark - Double line
            
            // Set the selectable items
            NSArray *items = @[@"This is a very long line with Apple, which is good", @"Also long with Orange", @"You should always eat Peach, because it's healthy", @"The best fruit is Pearl", @"The red thing on pizzas is Tomato, which makes it good"];

            // Create the picker
            self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
                // This code will be called when the user taps the "OK" button
                
                self.basicCellSelectedString = (NSString *)selected;
                self.basicCellDetailLabel.text = (NSString *)selected;
            
            } cancelCallback:nil];
            
            // Set double height
            self.picker.doubleLine = YES;
            
            // Present it
            [self.picker presentPickerOnView:self.view];
            
            // Set to the previously selected value
            [self.picker selectValue:self.basicCellSelectedString];
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            #pragma mark - Delegate

            // Set the selectable items
            NSArray *items = @[@"Apple", @"Orange", @"Peach", @"Pearl", @"Tomato"];
            
            // Create the picker
            self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:nil cancelCallback:nil];
            self.picker.delegate = self;
            
            // Set the title
            self.picker.title = @"Delegate";

            // Present it
            [self.picker presentPickerOnView:self.view];

            
        } else if (indexPath.row == 1) {
            #pragma mark - Custom values

            // Set the selectable items
            NSArray *items = @[
                               [GKActionSheetPickerItem pickerItemWithTitle:@"Apple" value:@0],
                               [GKActionSheetPickerItem pickerItemWithTitle:@"Orange" value:@1],
                               [GKActionSheetPickerItem pickerItemWithTitle:@"Peach" value:@2],
                               [GKActionSheetPickerItem pickerItemWithTitle:@"Pearl" value:@3],
                               [GKActionSheetPickerItem pickerItemWithTitle:@"Tomato" value:@4]
                               ];
            
            // Create the picker
            self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
                // This code will be called when the user taps the "OK" button
                
                self.customValuesSelectedNumber = (NSNumber *)selected;
                self.customValuesDetailLabel.text = [NSString stringWithFormat:@"%@", selected];
                
            } cancelCallback:^{
                // This code will be called when the user taps cancel
            }];
            
            // Dismiss on tapping the dark overlay layer
            self.picker.dismissType = GKActionSheetPickerDismissTypeCancel;
            
            // Set the title
            self.picker.title = @"Custom Values";

            // Present it
            [self.picker presentPickerOnView:self.view];
            
            // Set to previously selected value
            [self.picker selectValue:self.customValuesSelectedNumber];
            
        } else if (indexPath.row == 2) {
            #pragma mark - Custom left button

            // Set the selectable items
            NSArray *items = @[@"Apple", @"Orange", @"Peach", @"Pearl", @"Tomato"];
            
            // Create the picker
            self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
            } cancelCallback:^{
                NSLog(@"Something nice. Do you like it?");
            }];
            
            // Do not dismiss on tapping the gray overlay layer
            self.picker.dismissType = GKActionSheetPickerDismissTypeNone;
            
            // Set the title
            self.picker.title = @"Custom Left Button";

            // Left button title
            self.picker.cancelButtonTitle = @"Log me something nice!";
            
            // Present it
            [self.picker presentPickerOnView:self.view];
            
        } else if (indexPath.row == 3) {
            #pragma mark - Tint color

            // Set the selectable items
            NSArray *items = @[@"Apple", @"Orange", @"Peach", @"Pearl", @"Tomato"];
            
            // Create the picker
            self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
                // This code will be called when the user taps the "OK" button
                
                self.tintColorCellSelectedString = (NSString *)selected;
                self.tintColorDetailLabel.text = (NSString *)selected;
                
            } cancelCallback:nil];
            
            self.picker.tintColor = [UIColor redColor];
            
            // Present it
            [self.picker presentPickerOnView:self.view];
            
            // Set to the previously selected value
            [self.picker selectValue:self.tintColorCellSelectedString];
        }
    }
}

#pragma mark - <GKActionSheetPickerDelegate>

- (void)actionSheetPicker:(GKActionSheetPicker *)picker didChangeValue:(id)value {
    self.delegateCellDetailLabel.text = value;
}

@end
