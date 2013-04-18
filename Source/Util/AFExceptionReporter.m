//
// Created by Chris Hatton on 15/04/2013.
//
#import "AFExceptionReporter.h"

#import "MKBlockAdditions.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "AFAssertion.h"
#import "AFDispatch.h"

NSString* AFMachineName()
{
	struct utsname systemInfo;
	uname(&systemInfo);

	return [NSString stringWithCString:systemInfo.machine
	                          encoding:NSUTF8StringEncoding];
}

void AFReportingExceptionHandler(NSException* exception)
{
	UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
	UINavigationController *navController = rootViewController.navigationController;

	[navController popToRootViewControllerAnimated:YES];

	DismissBlock dismissHandler = ^(int buttonIndex)
	{
		AFCAssertMainThread();

		NSString
				*subject            = @"Pocket Trainer Crash Report",
				*recipients         = @"support@pocket-innovation.com",
				*deviceDescription  = AFMachineName(),
				*messageFormat      = @"Device description\n\n%@\n\n\nCrash info\n\n%@",
				*messageBody        = [NSString stringWithFormat:messageFormat, deviceDescription, [exception callStackSymbols], nil];

		MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
		AFExceptionReporter *reporter = [AFExceptionReporter new];
		mailComposer.mailComposeDelegate = reporter;
		[reporter release];
		[mailComposer setToRecipients:@[recipients]];
		[mailComposer setSubject:subject];
		[mailComposer setMessageBody:messageBody isHTML:NO];
		[navController presentModalViewController:mailComposer animated:YES];
		[mailComposer release];
	};

	void (^showAlertBlock)() = ^
	{
		UIAlertView *errorAlert = [UIAlertView alertViewWithTitle:@"Sorry, something went wrong"
		                                                  message:@"Would you like to report this to PocketPT to help us fix this problem? No personal information will be sent."
			                                    cancelButtonTitle:@"No"
								                otherButtonTitles:@[@"Yes"]
												        onDismiss:dismissHandler
														 onCancel:NULL];
		[errorAlert show];
		[errorAlert release];
	};

	if([NSThread isMainThread]) showAlertBlock();
	else AFMainDispatch( showAlertBlock );
}

@implementation AFExceptionReporter

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
				        error:(NSError *)error
{
	UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
	UINavigationController *navController = rootViewController.navigationController;

	void (^dismissBlock)() = ^
	{
		switch( result )
		{
			case MFMailComposeResultSent:
				[UIAlertView alertViewWithTitle:@"Thank you"
				                        message:@"Your report has helped us to improve the next version of Pocket Trainer"
					          cancelButtonTitle:@"OK"];
				break;

			case MFMailComposeResultCancelled:
			case MFMailComposeResultSaved:
			case MFMailComposeResultFailed:
				break;
		}

		[navController dismissModalViewControllerAnimated:YES];
	};

	if([NSThread isMainThread]) dismissBlock();
	else AFMainDispatch( dismissBlock );
}

@end