
#import "AFRequestStates.h"

@protocol AFRequestObserver; //Forward declaration to legalize the cyclic dependency

/**
 The AFRequest protocol defines methods to support a request/response data transaction between the local system
 and a remote server. It provides callback methods to inform the concrete request object when fulfilment of the request
 has reached key stages, and also to feed it data resulting from the request. The AFRequest protocol also requires
 that the request implementation provide methods to add and remove observers, other objects that may be informed about the
 ongoing state of the request.
 
 Currently there are several implementations of AFRequest, which are all processed by AFSession.
 */
@protocol AFRequest

-(NSMutableURLRequest*)willSendURLRequest:(NSMutableURLRequest*)requestIn;

/**
 This is called by AFSession when the HTTP request has been made to the server, and a response header has been
 returned back just prior to receipt of any body data.
 */
-(void)willReceiveWithHeaders:(NSDictionary*)headers responseCode:(int)responseCode;

/**
 Called by AFSession to feed actual response data back to the implementation. There may be one or more calls to this method
 depending on how data is packetised by the underlying transport system. Data should be appended to a buffer and not considered
 final until didFinish: is called.
 
 The most common implementation of this (as in AFBaseRequest) is to append the data to a byte buffer and send a broadcast
 to observers to update them on the progress of data transfer.
 */
-(void)received:(NSData*)dataIn;

/**
 A call to this method indicates to the implementing request that all data is now received.
 
 The implementation of this method should do whatever is required with the completed data e.g. save it to disk or
 update a UI component.
 */
-(void)didFinish;

-(void)didFail:(NSError*)error;
-(void)cancel;
-(void)addObserver:(NSObject<AFRequestObserver>*)newObserver;
-(void)removeObserver:(NSObject<AFRequestObserver>*)oldObserver;

-(NSString*)actionDescription;

@property (nonatomic, readonly) int attempts;
@property (nonatomic, readonly) BOOL requiresLogin;
@property (nonatomic, retain) NSURL* URL;
@property (nonatomic, retain) NSURLConnection* connection;
@property (nonatomic) requestState state;

@end
