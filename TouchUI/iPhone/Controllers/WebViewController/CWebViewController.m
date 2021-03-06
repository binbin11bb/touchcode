//
//  CWebViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 05/27/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CWebViewController.h"

//#import "CLinkHandler.h"

@interface CWebViewController ()
@property (readwrite, nonatomic, retain) NSURL *currentURL;

@property (readwrite, nonatomic, retain) UIWebView *webView;
@property (readwrite, nonatomic, retain) UIToolbar *toolbar;
@property (readwrite, nonatomic, retain) UIBarButtonItem *backButton;
@property (readwrite, nonatomic, retain) UIBarButtonItem *forwardsButton;
@end

#pragma mark -

@implementation CWebViewController

@synthesize homeURL;
@synthesize initialHTMLString;
@synthesize dontChangeTitle;
@synthesize currentURL;
@synthesize webView;
@synthesize toolbar = outletToolbar;
@synthesize backButton = outletBackButton, forwardsButton = outletForwardsButton;

+ (id)webViewController;
{
CWebViewController *theWebViewController = [[[self alloc] initWithNibName:NULL bundle:NULL] autorelease];
return(theWebViewController);
}

- (void)dealloc
{
self.webView.delegate = NULL;

self.homeURL = NULL;
self.initialHTMLString = NULL;
self.currentURL = NULL;
//
self.webView = NULL;
self.toolbar = NULL;
self.backButton = NULL;
self.forwardsButton = NULL;

//
[super dealloc];
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
[super viewDidLoad];

self.webView.scalesPageToFit = YES;


#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_0
self.webView.dataDetectorTypes = UIDataDetectorTypeLink;
#else
self.webView.detectsPhoneNumbers = NO;
#endif

if (self.initialHTMLString)
	[self loadHTMLString:self.initialHTMLString baseURL:self.homeURL];
else if (self.homeURL)
	[self loadURL:self.homeURL];

self.backButton.enabled = self.webView.canGoBack;
self.forwardsButton.enabled = self.webView.canGoForward;
}

- (void)loadURL:(NSURL *)inURL;
{
NSURLRequest *theRequest = [NSURLRequest requestWithURL:inURL];
[self.webView loadRequest:theRequest];
}

- (void)loadHTMLString:(NSString *)inHTML baseURL:(NSURL *)inBaseURL;
{
self.initialHTMLString = inHTML;
self.homeURL = inBaseURL;
[self.webView loadHTMLString:inHTML baseURL:inBaseURL];
}

#pragma mark -

- (void)updateToolbar
{
self.backButton.enabled = self.webView.canGoBack;
self.forwardsButton.enabled = self.webView.canGoForward;
}

#pragma mark -

- (IBAction)actionBack:(id)inSender
{
[self.webView goBack];
}

- (IBAction)actionForwards:(id)inSender
{
[self.webView goForward];
}

- (IBAction)actionReload:(id)inSender
{
[self.webView reload];
}

- (IBAction)actionHome:(id)inSender
{
if (self.initialHTMLString)
	[self loadHTMLString:self.initialHTMLString baseURL:self.homeURL];
else if (self.homeURL)
	[self loadURL:self.homeURL];
}

- (IBAction)actionUtilityPopup:(id)inSender
{
UIActionSheet *theActionSheet = [[[UIActionSheet  alloc] initWithTitle:NULL delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:NULL otherButtonTitles:@"Open in Safari", @"E-mail Link", NULL] autorelease];
[theActionSheet showFromToolbar:self.toolbar];
}

#pragma mark -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
return(YES);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
if (!self.dontChangeTitle)
	self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];

self.currentURL = [[NSURL URLWithString:[self.webView stringByEvaluatingJavaScriptFromString:@"window.location.href"]] standardizedURL];

[self updateToolbar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
if (buttonIndex == 0)
	{
	[[UIApplication sharedApplication] openURL:self.currentURL];
	}
else if (buttonIndex == 1)
	{
//	NSString *theTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//	NSURL *theLink = [[CLinkHandler instance] makeMailLink:[self.currentURL description] title:theTitle templateName:@"share_page_mail.txt"];
//	[[UIApplication sharedApplication] openURL:theLink];
	}
}

@end
