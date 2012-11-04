//
// Created by augmental on 03/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AFSKProductCache.h"

@implementation AFSKProductCache
{

}

- (id)initPlaceholderWithPrimaryKey:(int)primaryKeyIn
{
    self = [super initPlaceholderWithPrimaryKey:primaryKeyIn];
    if (self)
    {

    }
    return self;
}

- (void)setContentFromDictionary:(NSDictionary *)dictionary
{
    NSDictionary* newIdsProducts = (NSDictionary *)[dictionary objectForKey:@"idsProducts"];
    if ( newIdsProducts )   idsProducts = [[NSMutableDictionary alloc] initWithDictionary:newIdsProducts];
    if ( !idsProducts )     idsProducts = [[NSMutableDictionary alloc] init];
}

- (void)setPlaceholderValues
{
    idsProducts = [[NSMutableDictionary alloc] init];
}

- (SEL)defaultComparisonSelector { return NULL; }

+ (NSString *)modelName { return NSStringFromClass([AFSKProductCache class]); }

@end