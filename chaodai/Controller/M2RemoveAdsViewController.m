//
//  M2RemoveAdsViewController.m
//  chaodai
//
//  Created by Agent Link on 14-6-10.
//  Copyright (c) 2014年 link. All rights reserved.
//

#import "M2RemoveAdsViewController.h"
#import "SVProgressHUD.h"

@interface M2RemoveAdsViewController ()

@end

@implementation M2RemoveAdsViewController

#define PRODUCTID @"com.lin.chaodai.removead"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myProduct = nil;
    myProductRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:PRODUCTID]];
    myProductRequest.delegate = self;
    [myProductRequest start];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)removeAds:(id)sender {
    
    if ([SKPaymentQueue canMakePayments] == NO) {
		UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Confirm Your In-App Purchase"
                                   message:@"In_App Unavailable"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
		[alert show];
        
		return;
	}
    
	SKPayment *payment = [SKPayment paymentWithProduct:myProduct];
    
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction)restoreIap:(id)sender {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

// SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
	if (response == nil) {
		NSLog(@"didReceiveResponse response == nil");
        
		return;
	}
    
    
	for (NSString *identifier in response.invalidProductIdentifiers) {
		NSLog(@"invalidProductIdentifiers: %@", identifier);
	}
    
	for (SKProduct *product in response.products) {
		NSLog(@"Product: %@ %@ %@ %d",
		      product.productIdentifier,
		      product.localizedTitle,
		      product.localizedDescription,
		      [product.price intValue]);
        
		myProduct = product;
	}
    
	if (myProduct == nil) {
		NSLog(@"myProduct == nil");
        
		return;
	}
    
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:myProduct.priceLocale];
	NSString *localedPrice = [numberFormatter stringFromNumber:myProduct.price];
    
}


@end
