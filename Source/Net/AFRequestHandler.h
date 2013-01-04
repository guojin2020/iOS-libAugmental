#import "AFRequest.h"

@protocol AFRequestHandler

/**
 *	Public method which submits an AFRequest for the receiver to handle.
 *	This method does not guarantee that the request is handled immediately, and
 *	the receiver may decline to handle the request by returning NO.
 *	A return value of YES indicates the receiver will handle the request.
 */
- (BOOL)handleRequest:(AFRequest*)request;

/**
 *	Private method, implementing how requests will be acted upon by this AFRequestHandler.
 *	Implementing code should act upon the request immediately.
 */
- (BOOL)actionRequest:(AFRequest*)request;

/**
 *	Public method used to inform the receiver that a particular request has been cancelled.
 *	Useful if this AFRequestHandler has been queueing a request somehow; so that it may
 *	be discarded from the queue.
 */
- (void)requestCancelled:(AFRequest*)request;

@end
