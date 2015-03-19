
static NSString * const BOUNDRY = @"0xKhTmLbOuNdArY";
static NSString * const FORM_FLE_INPUT = @"uploadedfile";

#import "MyURLConnection.h"
#import "Utils.h"


@implementation MyURLConnection
@synthesize responseHeaderDictionary;
@synthesize statusCode;
@synthesize requestURL;
@synthesize context;
@synthesize callerSelector;

-(id)initWithDelegate:(id<MyURLConnectionDelegate>)_delegate{
	if ((self = [super init]) != NULL){
		delegate = _delegate;
	}
	return self;
}

-(id)initWithURL:(NSString*)_url target:(id)_target succeededCallback:(SEL)_succeededCallback failedCallback:(SEL)_failedCallback{
	if ((self = [super init]) != NULL){
		target = _target;
		url = _url;
		succeededCallback = _succeededCallback;
		failedCallback=_failedCallback;
		usesData = NO;
		context = nil;
		self.requestURL = url;
	}
	return self;
}

-(id)initWithURL:(NSString*)_url target:(id)_target succeededCallback:(SEL)_succeededCallback failedCallback:(SEL)_failedCallback
		 context:(id)_context{
	if ((self = [super init]) != NULL){
		target = _target;
		url = _url;
		succeededCallback = _succeededCallback;
		failedCallback=_failedCallback;
		usesData = NO;
		self.context = _context ;
		self.requestURL = url;
	}
	return self;
}

-(id)initWithURL:(NSString*)_url target:(id)_target succeededCallback:(SEL)_succeededCallback failedCallback:(SEL)_failedCallback 
		usesData:(BOOL)_usesData {
	if ((self = [super init]) != NULL){
		target = _target;
		url = _url;
		succeededCallback = _succeededCallback;
		failedCallback=_failedCallback;
		usesData = _usesData;
		context = nil;
		self.requestURL = url;
        contentLength = 0;
	}
	return self;
}

-(id)initWithURL:(NSString*)_url target:(id)_target succeededCallback:(SEL)_succeededCallback failedCallback:(SEL)_failedCallback 
		usesData:(BOOL)_usesData  context:(id)_context{
	if ((self = [super init]) != NULL){
		target = _target;
		url = _url;
		succeededCallback = _succeededCallback;
		failedCallback=_failedCallback;
		usesData = _usesData;
		self.context = _context ;
		self.requestURL = url;
         contentLength = 0;
	}
	return self;
}



-(void)cancel{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	[theConnection cancel];
    target = nil;
	//[theConnection release];
}


-(NSString*)urlByAddingSessionTokenToURL:(NSString*)_url{
    if ([url rangeOfString:@"/tokens"].location != NSNotFound) {
        return _url;
    }
    if ([url rangeOfString:@"?"].location != NSNotFound) {
		_url = [_url stringByAppendingFormat:@"&auth_token=%@",
				[Utils setting:kSessionToken ]];
	}
	else {
		_url = [_url stringByAppendingFormat:@"?auth_token=%@",
				[Utils setting:kSessionToken ]];
	}
    return _url;
}
-(void)getWithoutToken{
	// create the request
	
	//NSString* aURL = [self urlByAddingSessionTokenToURL:requestURL];
     NSString* aURL = requestURL;
    
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:aURL]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
	
	
	// create the connection with the request and start loading the data
	theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		receivedData=[NSMutableData data];
	} else {
		// inform the user that the download could not be made
	}
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)get{
	// create the request
	
	NSString* aURL = [self urlByAddingSessionTokenToURL:requestURL];
   // NSString* aURL = requestURL;

	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:aURL]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	
	
	// create the connection with the request and start loading the data	
	theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		receivedData=[NSMutableData data];
	} else {
		// inform the user that the download could not be made
	}
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)post{
	// create the request
	
	//NSString *url = [delegate getURL];		
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"POST"];
	
	// create the connection with the request and start loading the data	
	theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		receivedData=[NSMutableData data];
	} else {
		// inform the user that the download could not be made
	}
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)post:(NSMutableDictionary*) fields
{
	
    NSURLRequest *theRequest = [self postRequestWithURL:[NSURL URLWithString:url]
												boundry:BOUNDRY
												 fields:fields];   	
    
	// create the connection with the request and start loading the data	
	NSURLConnection *_theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (_theConnection) {
		receivedData=[NSMutableData data];
	} else {
		// inform the user that the download could not be made
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)postRawJSONString:(NSString*) jsonString
{
	
    NSURLRequest *theRequest = [self postRequestWithURL:[NSURL URLWithString:url]
									  withRawJSONString:jsonString];	
    
	// create the connection with the request and start loading the data	
	NSURLConnection *_theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (_theConnection) {
		receivedData=[NSMutableData data];
	} else {
		// inform the user that the download could not be made
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (NSURLRequest *)postRequestWithURL: (NSURL *)_url withRawJSONString:(NSString*) jsonString
{
	NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:_url];
    [urlRequest setHTTPMethod:@"POST"];   
	[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[urlRequest setValue:[NSString stringWithFormat:@"%d",[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPBody:jsonData];	
    return urlRequest;
}


- (void)upload:(NSMutableDictionary*) fields filePath:(NSString*)filePath
{
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	
    if (!data) {       
        return;
    }
    if ([data length] == 0) {       
        return;
    }
	
	[self upload: fields fileData:data];
	
}

- (void)upload:(NSMutableDictionary*) fields fileData:(NSData*)data
{
	
    NSURLRequest *theRequest = [self uploadRequestWithURL:[NSURL URLWithString:url]
												  boundry:BOUNDRY
												   fields:fields
													 data:data];   	
	
	
	// create the connection with the request and start loading the data	
	NSURLConnection *_theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (_theConnection) {
		receivedData=[NSMutableData data];
	} else {
		// inform the user that the download could not be made
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)upload:(NSMutableDictionary*) fields  fileDataList:(NSArray*)dataList
{
	
    NSURLRequest *theRequest = [self uploadRequestWithURL:[NSURL URLWithString:url]
												  boundry:BOUNDRY
												   fields:fields													 
											 fileDataList:(NSArray*)dataList];   	
	
	
	// create the connection with the request and start loading the data	
	NSURLConnection *_theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (_theConnection) {
		receivedData=[NSMutableData data];
	} else {
		// inform the user that the download could not be made
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}





- (NSURLRequest *)postRequestWithURL: (NSURL *)_url       
                             boundry: (NSString *)boundry
							  fields:(NSMutableDictionary*) fields
//  data: (NSData *)data     

{
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:_url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:
     [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry]
	 //[NSString stringWithFormat:@"form-data; boundary=%@", boundry]
	 
      forHTTPHeaderField:@"Content-Type"];
	
    NSMutableData *postData =[[NSMutableData alloc] init]; //=   [NSMutableData dataWithCapacity:[data length] + 512];	
	
	//add fields data	
	NSArray* keys = [fields allKeys];
	for(NSString* key in keys){
        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[[NSString stringWithFormat:@"%@\r\n", [fields objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
    [postData appendData:	 
     [[NSString stringWithFormat:@"--%@--\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
	
    [urlRequest setHTTPBody:postData];
	
    return urlRequest;
}

- (NSURLRequest *)uploadRequestWithURL: (NSURL *)theUrl        // IN
							   boundry: (NSString *)boundry // IN
								fields:fields
								  data: (NSData *)data      // IN

{
    // from http://www.cocoadev.com/index.pl?HTTPFileUpload
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:theUrl
							cachePolicy:NSURLRequestUseProtocolCachePolicy
						timeoutInterval:60.0*5];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:
     [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry]
      forHTTPHeaderField:@"Content-Type"];
	
    NSMutableData *postData =[[NSMutableData alloc] init]; //=   [NSMutableData dataWithCapacity:[data length] + 512];	
	
	//add fields data	
	NSArray* keys = [fields allKeys];
	for(NSString* key in keys){
        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[[NSString stringWithFormat:@"%@\r\n", [fields objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	
	[postData appendData: [[NSString stringWithFormat:@"--%@\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
	//NSLog([NSString stringWithFormat:
	//	   @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n", FORM_FLE_INPUT,FORM_FLE_INPUT]);
	[postData appendData:
	 [[NSString stringWithFormat:
	   @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n", FORM_FLE_INPUT,@"Photo.jpg"]
	  dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:data];
	[postData appendData: [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	
    [postData appendData:	 
     [[NSString stringWithFormat:@"--%@--\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
	
    [urlRequest setHTTPBody:postData];
	
	
	
    return urlRequest;
}

- (NSURLRequest *)uploadRequestWithURL: (NSURL *)theUrl        // IN
							   boundry: (NSString *)boundry // IN
								fields:fields								
						  fileDataList:(NSArray*)dataList      // IN

{
    // from http://www.cocoadev.com/index.pl?HTTPFileUpload
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:theUrl
							cachePolicy:NSURLRequestUseProtocolCachePolicy
						timeoutInterval:60.0*5];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:
     [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry]
      forHTTPHeaderField:@"Content-Type"];
	
    NSMutableData *postData =[[NSMutableData alloc] init]; //=   [NSMutableData dataWithCapacity:[data length] + 512];	
	
	//add fields data	
	NSArray* keys = [fields allKeys];
	for(NSString* key in keys){
        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[[NSString stringWithFormat:@"%@\r\n", [fields objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	int i=0;
	for(NSData* data in dataList){
		[postData appendData: [[NSString stringWithFormat:@"--%@\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
	//NSLog([NSString stringWithFormat:
		//	   @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n", FORM_FLE_INPUT,FORM_FLE_INPUT]);
		NSString* name;
		if(i==0){
			name = FORM_FLE_INPUT;
		}
		else {
			name = @"photo2";
		}		
		NSString* fileName = [NSString stringWithFormat:@"%@.png",name];
			[postData appendData:
		 [[NSString stringWithFormat:
		   @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n", name,fileName]
		  dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:data];
		[postData appendData: [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		i += 1;
	}
	
	
    [postData appendData:	 
     [[NSString stringWithFormat:@"--%@--\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
	
    [urlRequest setHTTPBody:postData];
	
	
	
    return urlRequest;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [receivedData appendData:data];
   /* float progress = 0;
    if (contentLength > 0) {        
        progress =   (float) [receivedData length] / contentLength;
        [target setProgress:progress];

    }*/
  
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere	
	
	//[delegate useResult:receivedData responseHeaders:responseHeaderDictionary];	
	if(usesData){
		[target performSelector:succeededCallback withObject:receivedData withObject:self];
	}	
	else{
		//NSString *content = [[[NSString alloc]initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSASCIIStringEncoding] autorelease];
		NSString *content = [[NSString alloc]initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
		 if(!content)
			content = [[NSString alloc]initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSASCIIStringEncoding];
		
		//test data
		//NSFileManager* fm = [NSFileManager defaultManager];
		//NSString* path = [[Utils appDocDir] stringByAppendingPathComponent:@"debugmultipart"];
		/*[[lines lastObject] writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];*/
		//[fm createFileAtPath:path contents:receivedData attributes:nil];
		
		//NSLog(@"Succeeded! Received %d bytes of data:%@",[receivedData length], content);	
		
		
			if([target respondsToSelector:succeededCallback])
				[target performSelector:succeededCallback withObject:content withObject:self];
		
		
		
	}
	
	//[target succeededCallback:content myURLConnection:self];
    // release the connection, and the data object
	connection = nil;
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	//optional check if response is a httpresponse
	//if([response respondsToSelector:@selector(statusCode)]){
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	statusCode = [httpResponse statusCode];
    contentLength = 0;
    if (statusCode == 200) {
        contentLength = [response expectedContentLength];
    }
	NSDictionary *httpResponseHeaderFields = [httpResponse  allHeaderFields];
	//NSLog(@"Connection did receive response: %@",  httpResponseHeaderFields);
	responseHeaderDictionary = httpResponseHeaderFields;
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
	connection = nil;
    // receivedData is declared as a method instance elsewhere
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
	//[delegate requestDidFailWithError:error];
	//[target failedCallback:error myURLConnection:self];
	[target performSelector:failedCallback withObject:error withObject:self];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
}

//Used for self trusted certificate untill certificate situation gets fixed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
	if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential;
        newCredential = [NSURLCredential credentialWithUser:@"feed_iphone"
												   password:@"J5wXbXpE"
												persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        // inform the user that the user name and password
        // in the preferences are incorrect
        //[self showPreferencesCredentialsAreIncorrectPanel:self];
    }
}




@end
