
#import <UIKit/UIKit.h>

@protocol MyURLConnectionDelegate <NSObject>

-(void)useResult:(NSData*)result responseHeaders:(NSDictionary*)headerDictionary ;
-(void)requestDidFailWithError:(NSError *)error;
-(NSString*)getURL;
-(void)setProgress:(float)progress;

@end





@interface MyURLConnection : NSObject {
	NSMutableData* receivedData;
	NSMutableArray* items;
	id<MyURLConnectionDelegate> delegate;
	id target;
	SEL succeededCallback;
	SEL failedCallback;
	NSString *url;
	bool usesData;
	NSURLConnection *theConnection;
    long long contentLength;
}

-(id)initWithURL:(NSString*)_url target:(id)_target succeededCallback:(SEL)_succeededCallback failedCallback:(SEL)_failedCallback;

-(id)initWithURL:(NSString*)_url target:(id)_target succeededCallback:(SEL)_succeededCallback failedCallback:(SEL)_failedCallback
		 context:(id)_context;
-(id)initWithURL:(NSString*)_url target:(id)_target succeededCallback:(SEL)_succeededCallback failedCallback:(SEL)_failedCallback 
		usesData:(BOOL)_usesData;
-(id)initWithURL:(NSString*)_url target:(id)_target succeededCallback:(SEL)_succeededCallback failedCallback:(SEL)_failedCallback 
		usesData:(BOOL)_usesData  context:(id)_context;
-(void)get;
-(void)cancel;
- (void)postRawJSONString:(NSString*) jsonString;
- (void)post:(NSMutableDictionary*) fields;
- (void)upload:(NSMutableDictionary*) fields fileData:(NSData*)data;
- (NSURLRequest *)uploadRequestWithURL: (NSURL *)theUrl  
							   boundry: (NSString *)boundry 
								fields:fields
								  data: (NSData *)data    ;
- (NSURLRequest *)postRequestWithURL: (NSURL *)url       
                             boundry: (NSString *)boundry
							  fields:(NSMutableDictionary*) fields;
-(id)initWithDelegate:(id<MyURLConnectionDelegate>)_delegate;
-(void)getWithoutToken;
@property(nonatomic,strong) NSDictionary* responseHeaderDictionary;
@property NSInteger statusCode;
@property(nonatomic,strong) NSString* requestURL;
@property(nonatomic,strong) id context;
@property SEL callerSelector;

@end
