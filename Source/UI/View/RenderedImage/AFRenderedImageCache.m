//
// Created by Chris Hatton on 20/04/2013.
//
#import <CoreGraphics/CoreGraphics.h>
#import "AFRenderedImageCache.h"
#import "AFPImageRenderer.h"
#import "AFThemeManager.h"

@interface AFRenderedImageCache ()

@property (nonatomic,readonly) NSMutableDictionary* rendererCaches;

- (void)purgeCache;

@end

static AFRenderedImageCache *sharedInstance;

@implementation AFRenderedImageCache

+(AFRenderedImageCache *)sharedInstance
{
	return sharedInstance ?: (sharedInstance = [AFRenderedImageCache new]);
}

-(id)init
{
	self = [super init];
	if(self)
	{
		_rendererCaches = [NSMutableDictionary new];

		[[NSNotificationCenter defaultCenter] addObserver:self
		                                         selector:@selector(purgeCache)
				                                     name:UIApplicationDidReceiveMemoryWarningNotification
					                               object:nil];
	}
	return self;
}

-(void)purgeCache
{
	for(NSMutableDictionary *sizes in _rendererCaches) [sizes removeAllObjects];
	[_rendererCaches removeAllObjects];
}

-(UIImage*)imageFromRenderer:(id <AFPImageRenderer>)renderer withSize:(CGSize)size
{
	NSAssert(renderer, NSInvalidArgumentException);
	NSAssert( size.width>0 && size.height>0, NSInvalidArgumentException );

	size = CGSizeMake(roundf(size.width), roundf(size.height));

	NSValue *rendererKey = [NSValue valueWithNonretainedObject:renderer];

	NSMutableDictionary *sizes = [_rendererCaches objectForKey:rendererKey];

	if(!sizes)
	{
		sizes = [NSMutableDictionary new];
		[_rendererCaches setObject:sizes forKey:rendererKey];
	}

	NSValue *sizeKey = [NSValue valueWithCGSize:size];
	UIImage* image = [sizes objectForKey:sizeKey];

	if(!image)
	{
		image = [renderer newImageForSize:size];
		[sizes setObject:image forKey:sizeKey];
		[image release];
	}

	return image;
}

-(void)dealloc
{
	[_rendererCaches release];
	[super dealloc];
}

- (void)purgeSizeCacheForRenderer:(id <AFPImageRenderer>)renderer
{
	NSMutableDictionary *sizes = [_rendererCaches objectForKey:renderer];
	[sizes removeAllObjects];
}

@end