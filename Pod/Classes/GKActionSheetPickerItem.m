//
//  GKActionSheetPickerItem.m
//  
//
//  Created by GK on 15.09.10..
//
//

#import "GKActionSheetPickerItem.h"

@implementation GKActionSheetPickerItem

+ (instancetype)pickerItemWithTitle:(NSString *)title value:(id)value
{
    GKActionSheetPickerItem *pickerItem = [GKActionSheetPickerItem new];
    
    pickerItem.title = title;
    pickerItem.value = value;
    
    return pickerItem;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@", [super description], self.title];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[GKActionSheetPickerItem class]]) return NO;
    GKActionSheetPickerItem *other = (GKActionSheetPickerItem *)object;
    return [self.value isEqual:other.value];
}

@end
