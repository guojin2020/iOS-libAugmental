
#import "AFImageCache.h"

@implementation AFImageCache

static NSMutableDictionary* icons;

+(void)initialize
{
	icons = [[NSMutableDictionary alloc] initWithCapacity:1];
}

+(UIImage*)image:(NSString*)imageName
{
	NSAssert(imageName,@"null image name");

	//NSLog(@"Loading image '%@'",imageName);
	UIImage* returnImage = [icons objectForKey:imageName];
	if(returnImage) return returnImage;
	else
	{
		NSString* newImagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
		if(!newImagePath)
		{
			//NSLog(@"No image for name: %@",imageName);
			return nil;
		}
		returnImage = [UIImage imageWithContentsOfFile:newImagePath];
		if(!returnImage)
		{
			//NSLog(@"Bad image for: %@",newImagePath);
			return nil;
		}
		[icons setObject:returnImage forKey:imageName];
		return returnImage;
	}
}

@end
