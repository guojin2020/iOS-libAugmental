
#import <Foundation/Foundation.h>
#import "AFTableCell.h"
#import "AFEventObserver.h"
#import "AFObject.h"

@protocol AFObject_CellViewable;

/**
 * Implements functionality common to all Table cells
 * This is not a complete implementation of a cell and needs to be subclassed for use
 */
@interface AFBaseObjectTableCell : AFTableCell <AFEventObserver>
{
	NSObject<AFObject_CellViewable>* object;
}

-(id)initWithObject:(NSObject<AFObject_CellViewable>*)objectIn;

-(void)setTagReferences;
-(void)refreshFields;

-(NSString*)cellReuseIdentifier;

@property (nonatomic, retain) NSObject<AFObject_CellViewable>* object;

@end
