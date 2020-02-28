//
//  GKTableViewController.h
//  
//
//  Created by GK on 15.09.10..
//
//

#import <UIKit/UIKit.h>

@interface GKTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *basicCellDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCellDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoRowsCellDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *shorterSymbolDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *doubleLineDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *delegateCellDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *customValuesDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *customLeftButtonDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *tintColorDetailLabel;

@end
