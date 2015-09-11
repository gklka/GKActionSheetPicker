//
//  GKTableViewController.m
//  
//
//  Created by GK on 15.09.10..
//
//

#import "GKTableViewController.h"
#import "GKActionSheetPicker.h"

@interface GKTableViewController ()

// You have to have a strong reference for the picker
@property (nonatomic, strong) GKActionSheetPicker *picker;

@property (nonatomic, strong) NSString *basicCellSelectedString;
@property (nonatomic, strong) NSString *dateCellSelectedString;
@property (nonatomic, strong) NSString *twoRowsSelectedString;

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

    if (indexPath.row == 0) {
        // Basic
        
        // Set the selectable items
        NSArray *items = @[@"Apple", @"Orange", @"Peach", @"Pearl", @"Tomato"];

        // Create the picker
        self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
            // This code will be called when the user taps the "OK" button
            
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
            self.twoRowsCellDetailLabel.text = [array componentsJoinedByString:@", "];
            
        } cancelCallback:^{
            // This code will be called when the user taps cancel
        }];
        
        // Dismiss on tapping the dark overlay layer
        self.picker.dismissType = GKActionSheetPickerDismissTypeCancel;
        
        // Present it
        [self.picker presentPickerOnView:self.view];
    }
}


@end
