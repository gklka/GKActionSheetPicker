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
@property (weak, nonatomic) IBOutlet UILabel *delegateCellDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *customValuesDetailLabel;

@end
