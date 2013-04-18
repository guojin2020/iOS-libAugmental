//
// Created by Chris Hatton on 15/04/2013.
//
#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <MessageUI/MessageUI.h>

NSString* AFMachineName(void);

void AFReportingExceptionHandler(NSException* exception);

@interface AFExceptionReporter : NSObject <MFMailComposeViewControllerDelegate>

@end