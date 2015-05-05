//
//  LoginViewController.m
//  EBT
//
//  Created by ross chen on 8/6/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "LoginViewController.h"
#import "HTTPRequestManager.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Customization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    if ([Utils setting:kLoggedOut]) {
        [Utils removeSettingForKey:kLoggedOut];
        [self hideLoadingView];
        nameField.text = @"";
        passwordField.text = @"";
    }

}

- (void)viewDidLoad
{
    needsNavBar = YES;
    [super viewDidLoad];
    [Utils appDelegate].LoginViewController = self;
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:@"Log In"];
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 25, 0, 0)];
    imageView.image = [UIImage imageNamed:@"2fields"];
    imageView.userInteractionEnabled = YES;
    [self setViewFrame:imageView];
    [self.view addSubview:imageView];
    UITextField* field = [[UITextField alloc] initWithFrame:CGRectMake(20, 3, 225, 44)];
    nameField = field;
    field.placeholder = @"Email Address";
    field.font = [UIFont boldSystemFontOfSize:14];
    field.delegate = self;
    field.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    [imageView addSubview:field];
    
    field = [[UITextField alloc] initWithFrame:CGRectMake(20, 53, 225, 44)];
    field.secureTextEntry = YES;
    passwordField = field;
    field.delegate = self;
    field.placeholder = @"Password";
    field.font = [UIFont boldSystemFontOfSize:13];
    field.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    [imageView addSubview:field];
    
    UIButton *forgotPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgotPassword setTitle:@"Forgot password?" forState:UIControlStateNormal];
    forgotPassword.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgotPassword setTitleColor:kLightBlueColor forState:UIControlStateNormal];
    [forgotPassword addTarget:self action:@selector(forgotPassword) forControlEvents:UIControlEventTouchUpInside];
    forgotPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgotPassword setFrame:CGRectMake(40, 140, 225, 20)];
    [self.view addSubview:forgotPassword];
    
    float lastY = 140;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(200, lastY, 0, 0);
	[button setBackgroundImage:[UIImage imageNamed:@"signinbutton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(signin) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:button];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];

    [button setTitle:@"SIGN IN" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, lastY, 140, 35);
	//[button setBackgroundImage:[UIImage imageNamed:@"signinbutton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(forgotPassword) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Forgot Password" forState:UIControlStateNormal];
    [button setTitleColor:kGrayTextColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[self.view addSubview:button];
    
    NSDictionary* dict = [Utils setting:kLoginInfoDict];
    if (dict) {
        nameField.text = dict[kUsername];
        passwordField.text = dict[kPassword];
        [self requestAuth];
    }
   // @"joe@test.com"
    //@"secret"
    
}

-(void) forgotPassword {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kForgotPasswordURL]];
}

-(void)logout{
    [self hideLoadingView];
    [Utils removeSettingForKey:kLoginInfoDict];
    nameField.text = @"";
    passwordField.text = @"";
    [logoutContentView removeFromSuperview];
    
}

-(void)newToEBT{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kWebsiteURL]];
}


-(void)setupLogoutUI{
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenBounds.size.width, kScreenBounds.size.height)];
    contentView.backgroundColor = kBackgroundColor;
    logoutContentView = contentView;
    
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(40 , 60, 240, 100)];
    label.numberOfLines = 0;
    label.textColor = kGrayTextColor;
    label.text =  @"You do not currently\nhave an active\nMembership.";
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((kScreenBounds.size.width-205)/2, 200, 0, 0);
	[button setBackgroundImage:[UIImage imageNamed:@"graybutton.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(newToEBT) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:button];
    [button setTitle:@"JOIN NOW" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contentView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((kScreenBounds.size.width-205)/2, 260, 0, 0);
	[button setBackgroundImage:[UIImage imageNamed:@"graybutton.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:button];
    [button setTitle:@"LOG OUT" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contentView addSubview:button];
    [self.view addSubview:contentView];
    
}

-(IBAction)requestAuth{
    [self.view findAndResignFirstResonder];
    if (![Utils isTextInputFilled:nameField] || ![Utils isTextInputFilled:passwordField]) {
        [Utils alertMessage:@"Please enter username and password to login."];
        return;
    }
    
    NSString* urlStr = [NSString stringWithFormat:@"%@tokens",kBaseURL];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                          nameField.text ,@"email",
                          passwordField.text,@"password",
                          nil];
    
    HTTPRequestManager *manager = [[HTTPRequestManager alloc] init];
    
    [manager.httpOperation POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"error"]) {
            [Utils alertMessage:[responseObject objectForKey:@"error"]];
        }
        
        NSString* token = [responseObject objectForKey:@"auth_token"];
        [Utils setSettingForKey:kSessionToken withValue:token];
        [Utils setSettingForKey:kUserInfoDict withValue:responseObject];
        NSDictionary* loginDict = @{kUsername:nameField.text,kPassword:passwordField.text};
        [Utils setSettingForKey:kLoginInfoDict withValue:loginDict];
        
        
        if (![responseObject[@"active_subscription"] boolValue]) {
            //[Utils alertMessage:@"Visit ebtgroups.com to enroll by tapping \"NEW TO EBT\"."];
            //[self back];
            [self setupLogoutUI];
            return;
        }
        
        if (![[responseObject objectForKey:kGroup] objectForKey:kID]) {
            [self setupLogoutUI];
            return;
        }
        
        
        [[Utils appDelegate] sendNotificationToken];
        [Utils showSubViewWithName:@"TabBarViewController" withDelegate:self];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [Utils alertMessage:[error localizedDescription]];
    }];
	
    [self showLoadingView];
	
}

-(void)loadingViewHanlder:(int)context{
	//[self hideLoadingView];
}

-(void)signin{
    [self requestAuth];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showController {
    [self.navigationController popToViewController:self animated:YES];
}

@end
