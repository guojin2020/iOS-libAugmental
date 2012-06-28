
#import "AFObject.h"

@protocol AFWriteableObject <AFObject>

-(NSMutableDictionary*)setDictionaryFromContent:(NSMutableDictionary*)dictionaryIn;
-(void)willBeDeleted;

@end
