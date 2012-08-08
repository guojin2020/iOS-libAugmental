
/*
#import <Foundation/Foundation.h>

@protocol AFEditableObserver;

@interface AFBlockEditableObject : NSObject
{
	NSMutableSet* observers;
	BOOL blockEdit;
	BOOL editMade;
}

-(void)addObserver:(NSObject<AFEditableObserver>*)observer;
-(void)removeObserver:(NSObject<AFEditableObserver>*)observer;
-(void)broadcastChangeToObservers;

-(void)beginBlockEdit;
-(void)endBlockEdit;

-(void)editMade;

@end
*/