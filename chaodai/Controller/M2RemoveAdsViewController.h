//
//  M2RemoveAdsViewController.h
//  chaodai
//
//  Created by Agent Link on 14-6-10.
//  Copyright (c) 2014年 link. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface M2RemoveAdsViewController : UIViewController
<SKProductsRequestDelegate>
{
    SKProductsRequest *myProductRequest;
    SKProduct *myProduct;                
}

@property (weak, nonatomic) IBOutlet UIButton *removeAdsButton;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;
- (IBAction)removeAds:(id)sender;
- (IBAction)restoreIap:(id)sender;

@end
