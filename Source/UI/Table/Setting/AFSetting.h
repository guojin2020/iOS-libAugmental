#import "AFValidatable.h"

@protocol AFValidator;

@protocol AFSetting <AFValidatable>

/**
 Any AFSetting must have a unique NSString key, returned by this method.
 A settings identity string may be used to identify it within a table or during serialisation.
 **/
- (NSString *)identity;

/**
 This method provides a common selector for the UI controls on the UIViewCells of all AFSetting
 implementations.
 
 This should be implemented to call setValue: with the new value implied by the UI control state.
 **/
- (void)controlValueChanged:(id)sender;

/**
 Update the appearance of the UIViewCell managed by this AFSetting implementation,
 based on the AFSettings current state. Most often, this will somehow display the
 settings 'value'.
 **/
- (void)updateControlCell;

@property(nonatomic, retain) NSObject <NSCoding>    *value;
@property(nonatomic, retain) NSObject <AFValidator> *validator;
@property(nonatomic, readonly) BOOL valid;

@end
