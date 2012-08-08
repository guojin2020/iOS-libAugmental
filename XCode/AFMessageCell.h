
#import <Foundation/Foundation.h>
#import "AFTableCell.h"

@interface AFMessageCell : AFTableCell
{
	UILabel* messageLabel;
}

-(void)refreshFields;

@end
