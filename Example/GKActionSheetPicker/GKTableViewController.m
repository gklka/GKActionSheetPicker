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
@property (nonatomic, strong) NSDate *dateCellSelectedDate;
@property (nonatomic, strong) NSArray *twoRowsSelectedStrings;

@property (nonatomic, strong) NSNumber *customValuesSelectedNumber;

@end


@implementation GKTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // Basic
            
            // Set the selectable items
            NSArray *items = @[@"Apple", @"Orange", @"Peach", @"Pearl", @"Tomato"];

            // Create the picker
            self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
                // This code will be called when the user taps the "OK" button
                
                self.basicCellSelectedString = (NSString *)selected;
                self.basicCellDetailLabel.text = (NSString *)selected;
            
            } cancelCallback:^{
                // This code will be called when the user taps cancel
            }];
            
            // Dismiss on tapping the dark overlay layer
            self.picker.dismissType = GKActionSheetPickerDismissTypeCancel;

            // Present it
            [self.picker presentPickerOnView:self.view];
            
            // Set to the previously selected value
            [self.picker selectValue:self.basicCellSelectedString];

        } else if (indexPath.row == 1) {
            // Date
            
            self.picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365] to:[NSDate new] interval:60*60*24 selectCallback:^(id selected) {
                
                self.dateCellSelectedDate = (NSDate *)selected;
                self.dateCellDetailLabel.text = [NSString stringWithFormat:@"%@", selected];
                
            } cancelCallback:^{
                //
            }];
            
            // Present it
            [self.picker presentPickerOnView:self.view];
            
            // Set to the previously selected value
            [self.picker selectDate:self.dateCellSelectedDate];
            
        } else if (indexPath.row == 2) {
            // Two rows

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

            // Present it
            [self.picker presentPickerOnView:self.view];
            
            // Set to previously selected value
            [self.picker selectValue:self.twoRowsSelectedStrings[0] inComponent:0];
            [self.picker selectValue:self.twoRowsSelectedStrings[1] inComponent:1];
            
            // Usage of -selectIndex:inComponent:
//            [self.picker selectIndex:2 inComponent:0];
//            [self.picker selectIndex:1 inComponent:1];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // Delegate
            
            // Set the selectable items
            NSArray *items = @[@"Apple", @"Orange", @"Peach", @"Pearl", @"Tomato"];
            
            // Create the picker
            self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:nil cancelCallback:nil];
            self.picker.delegate = self;
            
            // Present it
            [self.picker presentPickerOnView:self.view];

            
        } else if (indexPath.row == 1) {
            // Custom Values
            
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
            
            // Present it
            [self.picker presentPickerOnView:self.view];
            
            // Set to previously selected value
            [self.picker selectValue:self.customValuesSelectedNumber];
        }
    }
}

#pragma mark - <GKActionSheetPickerDelegate>

- (void)actionSheetPicker:(GKActionSheetPicker *)picker didChangeValue:(id)value
{
    self.delegateCellDetailLabel.text = value;
}

@end
