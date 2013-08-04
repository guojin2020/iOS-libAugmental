#import "AFTableCell.h"
#import "AFCellSelectionDelegate.h"
#import "AFTableCellBackgroundView.h"
#import "AFCellViewFactory.h"
#import "AFAppDelegate.h"
#import "AFTableSection.h"
#import "AFTable.h"
#import "AFTableViewController.h"
#import "AFThemeManager.h"
#import "AFAssertion.h"
#import "AFLog.h"

#define ENABLE_DEFAULT_BACKGROUND false

static UIColor
        *defaultTextColor			= nil,
        *defaultSecondaryTextColor	= nil,
        *defaultBGColor				= nil;

static UIFont*	defaultTextFont				= nil;
static float_t	defaultTextSize				= -1.0;
static NSString* cellClickedSound			= nil;

@interface AFTableCell ()

- (void)beginObservingWindow;
- (void)endObservingWindow;

- (UITableViewCell *)newCellForTableView:(UITableView *)tableIn
                            templateName:(NSString *)templateNameIn;

@end

@implementation AFTableCell
{
    BOOL observingWindow;
    CGFloat height;
}

-(id)init
{
	if((self=[super init]))
	{
		_fillColor	= [AFTableCellBackgroundView defaultBackgroundColor];
		_labelText	= @"";
		_tableView	= nil;
		height		= -1.0f;
        observingWindow = NO;
        
        [AFThemeManager addObserver:self];
        [self themeChanged];
	}
	return self;
}

-(id)initWithLabelText:(NSString*)labelTextIn
{
	if((self=[self init]))
	{
		_labelText=labelTextIn;
		
		_tableView   = NULL;
		_viewCell = NULL;
		
		if([self conformsToProtocol:@protocol(AFCellSelectionDelegate)])
		{
			_selectionDelegate = (NSObject<AFCellSelectionDelegate>*)self; //Default selection delegate to self if appropriate
		}
	}
	return self;
}

- (void)refresh
{
    AFAssertMainThread();

    [_viewCell setNeedsLayout];
}

-(BOOL)deleteSelected{return NO;}
-(BOOL)allowsDeletion{return NO;}

-(NSString*)titleForDeleteButton{return @"Delete";}

-(UITableViewCell*)viewCellForTableView:(UITableView*)tableIn
{
    AFLogPosition();
	return [self viewCellForTableView:tableIn templateName:nil];
}

-(UINavigationController*) navigationController { return self.parentSection.parentTable.viewController.navigationController; }

-(UITableViewCell*)viewCellForTableView:(UITableView*)tableIn
                           templateName:(NSString*)templateNameIn
{
    AFLogPosition();

	if( !_viewCell || _tableView!=tableIn )
	{
        //Store the table this _viewCell currently belongs to
        _tableView = tableIn;

        _viewCell = [self newCellForTableView:tableIn templateName:templateNameIn];

        [self viewCellDidLoad];
        [self refresh];

        if(_viewCell !=NULL && !observingWindow)
            [self beginObservingWindow];
	}

	return _viewCell;
}

-(UITableViewCell*)newCellForTableView:(UITableView*)tableIn
                          templateName:(NSString*)templateNameIn
{
    UITableViewCell *newCell;

    //Create the _viewCell, either using the supplied template name, or a blank default
    NSString* reuseIdentifier = [[NSNumber numberWithInt:[self hash]] stringValue];

    if(templateNameIn)
    {
        newCell = [[AFCellViewFactory defaultFactory] cellOfKind:templateNameIn forTable:tableIn reuseIdentifier:reuseIdentifier];
    }
    else
    {
        newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        if([_labelText length]>0) _viewCell.textLabel.text = _labelText;
    }

    return newCell;
}

-(CGFloat)heightForTableView:(UITableView*)tableIn
{
	return [self viewCellForTableView:tableIn].frame.size.height;
}

- (void)didDisappear
{
    AFLogPosition();
}

- (void)willAppear
{
    AFLogPosition();
}

-(void)setFillColor:(UIColor*)color
{
	UIColor* oldColor = _fillColor;
	_fillColor = color;
	if(_fillColor!=oldColor) [_viewCell.backgroundView setNeedsDisplay];
}

-(void)accessoryTapped {}

-(void)willBeAdded
{
    AFLogPosition();

    if(_viewCell !=NULL && !observingWindow)
        [self beginObservingWindow];
}

-(void)willBeRemoved
{
    AFLogPosition();

    // Begin KVO observance of cells window, so that we can call willAppear and didDisappear
    if(observingWindow) [self endObservingWindow];
}

-(void)beginObservingWindow
{
    AFAssertMainThread();
    NSAssert(!observingWindow, NSInternalInconsistencyException);
    NSAssert(_viewCell !=NULL, NSInternalInconsistencyException);

    AFLogPosition();

    //AFLog(@"Cell %@ beginObservingWindow, observing window %@", _viewCell, _viewCell.window);

    observingWindow = YES;

    // Begin KVO observance of cells window, so that we can call willAppear and didDisappear
    [_viewCell addObserver:self
                forKeyPath:@"window"
                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionPrior
                   context:NULL];
}

-(void)endObservingWindow
{
    AFAssertMainThread();
    NSAssert(observingWindow, NSInternalInconsistencyException);
    NSAssert(_viewCell !=NULL, NSInternalInconsistencyException);

    AFLogPosition();
    //AFLog(@"Cell %@ endObservingWindow, unobserving window %@", _viewCell, _viewCell.window);

    observingWindow = NO;
    [_viewCell removeObserver:self forKeyPath:@"window"];
}

-(void)wasSelected
{
	[AFAppDelegate playSound:[AFTableCell cellClickedSound]];
	[_selectionDelegate cellSelected:self];
}

-(NSString*)cellTemplateName{return nil;}


#pragma mark Theme Getters begin

+(UIColor*)defaultTextColor
{
    if(!defaultTextColor) defaultTextColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFTableCell class]] colorForKey:THEME_KEY_DEFAULT_TEXT_COLOR];
    return defaultTextColor;
}

+(UIColor*)defaultSecondaryTextColor
{
    if(!defaultSecondaryTextColor) defaultSecondaryTextColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFTableCell class]] colorForKey:THEME_KEY_DEFAULT_SECONDARY_TEXT_COLOR];
    return defaultSecondaryTextColor;
}

+(UIColor*)defaultBGColor
{
    if(!defaultBGColor) defaultBGColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFTableCell class]] colorForKey:THEME_KEY_DEFAULT_BG_COLOR];
    return defaultBGColor?:[UIColor clearColor];
}

+(UIFont*)defaultTextFont
{
    if(!defaultTextFont)
    {
        NSString* fontName = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFTableCell class]] valueForKey:THEME_KEY_DEFAULT_TEXT_FONT];
        defaultTextFont = [UIFont fontWithName:fontName size:[AFTableCell defaultTextSize]];
    }
    return defaultTextFont;
}

+(float_t)defaultTextSize
{
    if(defaultTextSize<0) defaultTextSize = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFTableCell class]] floatForKey:THEME_KEY_DEFAULT_TEXT_SIZE];
    return defaultTextSize;
}

+(NSString*)cellClickedSound
{
	if(!cellClickedSound)cellClickedSound=[[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFTableCell class]] valueForKey:THEME_KEY_CELL_CLICKED_SOUND];
	return cellClickedSound;
}

#pragma mark Theme Getters end


-(void)viewCellDidLoad
{
    height = _viewCell.frame.size.height;
    if(height<=0) height = DEFAULT_CELL_HEIGHT;

    //Apply default settings for the look and feel of all cells, e.g. font colour
    _viewCell.textLabel.opaque           = YES;
    _viewCell.textLabel.backgroundColor  = [UIColor clearColor];

    [self setFillColor:[AFTableCell defaultBGColor]];

    //Apply the default background view, more customisable than the Apple default

#if ENABLE_DEFAULT_BACKGROUND
    UIView* backgroundView  = [[AFTableCellBackgroundView alloc] initWithFrame:CGRectZero usefulTableCell:self];
    _viewCell.backgroundView     = backgroundView;
    [backgroundView release];
#endif
}


#pragma mark KVO observing begin

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
		                change:(NSDictionary *)change
			           context:(void *)context
{
	if(object== _viewCell)
	{
		if([keyPath isEqualToString:@"window"])
		{
			UIWindow
				*oldWindow = [change objectForKey:NSKeyValueChangeOldKey],
				*newWindow = [change objectForKey:NSKeyValueChangeNewKey];

			if((id)oldWindow==[NSNull null]) oldWindow = NULL;
			if((id)newWindow==[NSNull null]) newWindow = NULL;

			if( (oldWindow==NULL) != (newWindow==NULL) )
			{
				if( newWindow!=NULL ) // Appearing
				{
                    AFLogPosition(@"Appearing");
					[self willAppear];
				}
				else // Disappearing
				{
                    AFLogPosition(@"Disappearing");
					[self didDisappear];
				}
			}
		}
	}
}

#pragma mark KVO observing end


#pragma mark AFPThemeable implementation begin

-(void)themeChanged
{
    defaultTextColor = nil;
    defaultTextFont = nil;
	defaultSecondaryTextColor = nil;
    defaultTextSize = -1.0;
}

+(id<AFPThemeable>)themeParentSectionClass{return (id<AFPThemeable>)[AFTable class];}
+(NSString*)themeSectionName{return @"_viewCell";}

+(NSDictionary*)defaultThemeSection
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithFloat:17.0f],	THEME_KEY_DEFAULT_TEXT_SIZE,
    @"000000",							THEME_KEY_DEFAULT_TEXT_COLOR,
	@"444444",							THEME_KEY_DEFAULT_SECONDARY_TEXT_COLOR,
    @"Helvetica",						THEME_KEY_DEFAULT_TEXT_FONT,
    @"FFFFFF",							THEME_KEY_DEFAULT_BG_COLOR,nil];
}

#pragma mark AFPThemeable implementation end

-(void)dealloc
{
    if(observingWindow)
        [self endObservingWindow];
}

//@synthesize selectionDelegate, viewCell, tableView, parentSection, fillColor;

@end
