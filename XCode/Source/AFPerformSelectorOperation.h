
#import <Foundation/Foundation.h>

@interface AFPerformSelectorOperation : NSOperation
{
	id target;
	SEL selector;
	id object;
}

-(id)initWithTarget:(id)targetIn selector:(SEL)selectorIn object:(id)objectIn;

+(NSOperationQueue*)backgroundOperationQueue;

@end

@interface NSObject (AFPerformSelectorOperation)

-(NSOperation*)performSelectorOnCommonBackgroundThread:(SEL)selector withObject:(id)object;

@end
