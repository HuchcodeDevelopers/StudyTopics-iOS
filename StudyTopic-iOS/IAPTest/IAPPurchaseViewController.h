//
//  IAPPurchaseViewController.h
//  IAPTest
//
//  Created by Mark Cyril Anthony Heruela on 6/2/14.
//  Copyright (c) 2014 HuchCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface IAPPurchaseViewController : UIViewController <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (strong, nonatomic) SKProduct *product;
@property (strong, nonatomic) NSString *productID;

@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@property (strong, nonatomic) IBOutlet UITextView *productDescription;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;

- (IBAction)buyProduct:(id)sender;
- (void)getProductInfo:(UIViewController *)viewController;

//- (void)restoreCompletedTransactions;

@end
