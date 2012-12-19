#import <Foundation/Foundation.h>
#import "AFTableCell.h"
#import "AFObject.h"

@protocol AFCellViewable;

/**
 * Implements functionality common to all Table cells
 * This is not a complete implementation of a cell and needs to be subclassed for use
 */
@interface AFObjectTableCell : AFTableCell
{
    AFObject<AFCellViewable> *object;
}

- (id)initWithObject:(AFObject <AFCellViewable> *)objectIn;

- (void)setTagReferences;

- (void)refreshFields;

-(void)handleObjectFieldUpdated:(AFObject*)objectIn;

- (NSString *)cellReuseIdentifier;

@property(nonatomic, retain) AFObject <AFCellViewable> *object;

- (UITableViewCell *)viewCellForTableView:(UITableView *)tableIn;


@end
