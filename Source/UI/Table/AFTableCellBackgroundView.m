
#import "AFTableCellBackgroundView.h"
#import "AFThemeManager.h"

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight);

static UIColor* defaultBackgroundColor = nil;
static UIColor* defaultBorderColor = nil;
static float defaultRounding = -1;
static float defaultBorderWidth = -1;

@implementation AFTableCellBackgroundView

+(UIColor*)defaultBackgroundColor
{
    if(!defaultBackgroundColor) defaultBackgroundColor = [[[AFThemeManager themeSectionForClass:[AFTableCellBackgroundView class]] colorForKey:THEME_KEY_DEFAULT_BG_COLOR] retain];
    return defaultBackgroundColor;
}

+(UIColor*)defaultBorderColor
{
    if(!defaultBorderColor) defaultBorderColor = [[[AFThemeManager themeSectionForClass:[AFTableCellBackgroundView class]] colorForKey:THEME_KEY_DEFAULT_BORDER_COLOR] retain];
    return defaultBorderColor;
}

+(float)defaultRounding
{
	if(defaultRounding<0) defaultRounding = [[[AFThemeManager themeSectionForClass:[AFTableCellBackgroundView class]] valueForKey:THEME_KEY_ROUNDING] floatValue];
    return defaultRounding;
}

+(float)defaultBorderWidth
{
	if(defaultBorderWidth<0) defaultBorderWidth = [[[AFThemeManager themeSectionForClass:[AFTableCellBackgroundView class]] valueForKey:THEME_KEY_BORDER_WIDTH] floatValue];
    return defaultBorderWidth;
}

-(id)initWithFrame:(CGRect)frame usefulTableCell:(AFTableCell*)usefulCellIn
{
    if((self = [super initWithFrame:frame]))
	{
        cell = [usefulCellIn retain];
		position = TableCellBackgroundViewPositionSingle;
        
        [AFThemeManager addObserver:self];
        [self themeChanged];
    }
    return self;
}

-(void)drawRect:(CGRect)rect 
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [[cell fillColor] CGColor]);
    CGContextSetStrokeColorWithColor(c, [[AFTableCellBackgroundView defaultBorderColor] CGColor]);
    CGContextSetLineWidth(c, [AFTableCellBackgroundView defaultBorderWidth]);
	
    if(position == TableCellBackgroundViewPositionTop)
	{
		
        CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
        CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
        minx = minx + 1;
        miny = miny + 1;
		
        maxx = maxx - 1;
        maxy = maxy ;
		
        CGContextMoveToPoint(c, minx, maxy);
        CGContextAddArcToPoint(c, minx, miny, midx, miny, [AFTableCellBackgroundView defaultRounding]);
        CGContextAddArcToPoint(c, maxx, miny, maxx, maxy, [AFTableCellBackgroundView defaultRounding ]);
        CGContextAddLineToPoint(c, maxx, maxy);
		
        // Close the path
        CGContextClosePath(c);
        // Fill & stroke the path
        CGContextDrawPath(c, kCGPathFillStroke);                
        return;
    }
	else if (position == TableCellBackgroundViewPositionBottom)
	{
		
        CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
        CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
        minx = minx + 1;
        miny = miny ;
		
        maxx = maxx - 1;
        maxy = maxy - 1;
		
        CGContextMoveToPoint(c, minx, miny);
        CGContextAddArcToPoint(c, minx, maxy, midx, maxy, [AFTableCellBackgroundView defaultRounding]);
        CGContextAddArcToPoint(c, maxx, maxy, maxx, miny, [AFTableCellBackgroundView defaultRounding]);
        CGContextAddLineToPoint(c, maxx, miny);
        // Close the path
        CGContextClosePath(c);
        // Fill & stroke the path
        CGContextDrawPath(c, kCGPathFillStroke);        
        return;
    }
	else if (position == TableCellBackgroundViewPositionMiddle)
	{
        CGFloat minx = CGRectGetMinX(rect) , maxx = CGRectGetMaxX(rect) ;
        CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
        minx = minx + 1;
        miny = miny;
		
        maxx = maxx - 1;
        maxy = maxy;
		
        CGContextMoveToPoint(c, minx, miny);
        CGContextAddLineToPoint(c, maxx, miny);
        CGContextAddLineToPoint(c, maxx, maxy);
        CGContextAddLineToPoint(c, minx, maxy);
		
        CGContextClosePath(c);
        // Fill & stroke the path
        CGContextDrawPath(c, kCGPathFillStroke);        
        return;
    }
	else if (position == TableCellBackgroundViewPositionSingle)
	{
        CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
        CGFloat miny = CGRectGetMinY(rect) , midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
        minx = minx + 1;
        miny = miny + 1;
		
        maxx = maxx - 1;
        maxy = maxy - 1;
		
        CGContextMoveToPoint(c, minx, midy);
        CGContextAddArcToPoint(c, minx, miny, midx, miny, [AFTableCellBackgroundView defaultRounding]);
        CGContextAddArcToPoint(c, maxx, miny, maxx, midy, [AFTableCellBackgroundView defaultRounding]);
        CGContextAddArcToPoint(c, maxx, maxy, midx, maxy, [AFTableCellBackgroundView defaultRounding]);
        CGContextAddArcToPoint(c, minx, maxy, minx, midy, [AFTableCellBackgroundView defaultRounding]);
		
        // Close the path
        CGContextClosePath(c);
        // Fill & stroke the path
        CGContextDrawPath(c, kCGPathFillStroke);                
        return;         
	}
}

-(BOOL)isOpaque{return NO;}

//==========================>> Themeable

-(void)themeChanged
{
    //This means they will be re-evaluated from getters
    defaultBackgroundColor  = nil; 
    defaultBorderColor      = nil;
}

+(Class<AFThemeable>)themeParentSectionClass{return [AFTableCell class];}
+(NSString*)themeSectionName{return nil;}

+(NSDictionary*)defaultThemeSection
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithFloat:6.0f],	THEME_KEY_ROUNDING,
    @"FFFFFF",							THEME_KEY_DEFAULT_BG_COLOR,
    @"B85430",							THEME_KEY_DEFAULT_BORDER_COLOR,
	[NSNumber numberWithFloat:1.25f],	THEME_KEY_BORDER_WIDTH,
	nil];
}

//==========================>> Dealloc

-(void)dealloc
{
    [cell release];
    [super dealloc];
}

@synthesize position, cell;

@end

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight)
{
    float fw, fh;
	
    if (ovalWidth == 0 || ovalHeight == 0)
	{
        CGContextAddRect(context, rect);
        return;
    }
	
    CGContextSaveGState(context);
	
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
	
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
	
    CGContextRestoreGState(context);
}
