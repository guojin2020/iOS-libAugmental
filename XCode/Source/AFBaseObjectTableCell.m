

#import "AFBaseObjectTableCell.h"
#import "AFCellViewFactory.h"
#import "AFObject_CellViewable.h"
#import "AFObject.h"
#import "AFEventManager.h"
#import "AFEventObserver.h"

@implementation AFBaseObjectTableCell

-(id)initWithObject:(NSObject<AFObject_CellViewable>*)objectIn
{
	if((self = [self init]))
	{
		self.object = objectIn;
	}
	return self;
}

-(void)setTagReferences{[self doesNotRecognizeSelector:_cmd];}
-(void)refreshFields{[self doesNotRecognizeSelector:_cmd];}

-(void)eventOccurred:(event)type source:(NSObject*)source
{
	if(type==(event)OBJECT_FIELD_UPDATED)[self refreshFields];
}

-(NSString*)cellReuseIdentifier
{
	return [NSString stringWithFormat:@"%@%i",NSStringFromClass([object class]),object.primaryKey];
}

-(void)dealloc
{
	[object.eventManager removeObserver:self];
	[object release];
	[cell release];
	[super dealloc];
}

-(void)setObject:(NSObject <AFObject_CellViewable>*)objectIn
{
	NSObject<AFObject_CellViewable>* oldObject = object;
	object = [objectIn retain];
	[object.eventManager addObserver:self];
	[oldObject.eventManager removeObserver:self];
	[oldObject release];
}

@synthesize object;
@dynamic cell;

@end
