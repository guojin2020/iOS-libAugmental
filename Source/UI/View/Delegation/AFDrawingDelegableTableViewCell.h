//
// Created by Chris Hatton on 25/11/2012
// Contact: christopherhattonuk@gmail.com
//

#import <Foundation/Foundation.h>

@protocol AFDrawingDelegate;

@interface AFDrawingDelegableTableViewCell : UITableViewCell
{
	id<AFDrawingDelegate> delegate;
}

@property (nonatomic, retain) id<AFDrawingDelegate> delegate;

@end