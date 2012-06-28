
#import "AFBlockEditableObject.h"
#import "AFEditableObserver.h"

@implementation AFBlockEditableObject

-(id)init
{
	if((self = [super init]))
	{
		blockEdit = NO;
		editMade = NO;
	}
	return self;
}

-(void)addObserver:(NSObject<AFEditableObserver>*)observer{[observers addObject:observer];}
-(void)removeObserver:(NSObject<AFEditableObserver>*)observer{[observers removeObject:observer];}
-(void)broadcastChangeToObservers
{
	NSSet* observerCopy = [[NSSet alloc] initWithSet:observers];
	for(NSObject<AFEditableObserver>* observer in observerCopy)[observer editableChanged:self];
	[observerCopy release];
}

-(void)beginBlockEdit
{
	blockEdit=YES;
	editMade=NO;
}

-(void)endBlockEdit
{
	if(blockEdit && editMade) [self broadcastChangeToObservers];
	blockEdit=NO;
	editMade=NO;
}

-(void)editMade
{
	if(blockEdit) editMade=YES;
	else [self broadcastChangeToObservers];
}

@end
