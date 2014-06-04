//
//  IAPPurchaseViewController.m
//  IAPTest
//
//  Created by Mark Cyril Anthony Heruela on 6/2/14.
//  Copyright (c) 2014 HuchCode. All rights reserved.
//

#import "IAPPurchaseViewController.h"
#import "IAPTestViewController.h"

@interface IAPPurchaseViewController ()
@property (strong, nonatomic) IAPTestViewController *homeViewController;
@end

@implementation IAPPurchaseViewController

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
    // Do any additional setup after loading the view from its nib.
    _buyButton.enabled = NO;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Restore" style:UIBarButtonItemStyleBordered target:self action:@selector(restoreTapped:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buyProduct:(id)sender {
    SKPayment *payment = [SKPayment paymentWithProduct:_product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)getProductInfo:(IAPTestViewController *)viewController
{
    _homeViewController = viewController;
    if ([SKPaymentQueue canMakePayments])
    {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:self.productID]];
        request.delegate = self;
        [request start];
    }
    else
    {
        _productDescription.text = @"Please enable In App Purchase in Settings";
    }
}

#pragma mark -
#pragma mark SKProductRequestDelegate
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    if (products.count != 0)
    {
        _product = products[0];
        _buyButton.enabled = YES;
        _productTitle.text = _product.localizedTitle;
        _productDescription.text = _product.localizedDescription;
    }
    else
    {
        _productTitle.text = @"Product not found";
    }
    products = response.invalidProductIdentifiers;
    for (SKProduct *product in products) {
        NSLog(@"Product not found: %@", product);
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self unlockFeature];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"%@", transaction.error);
                NSLog(@"Transaction Failed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

-(void)unlockFeature
{
    _buyButton.enabled = NO;
    [_buyButton setTitle:@"Purchased" forState:UIControlStateDisabled];
    [_homeViewController enabledLevel2];
}

//-(void)restoreCompletedTransactions
//{
//    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
//}
//
//-(void)restoreTapped:(id)sender
//{
//    [self restoreCompletedTransactions];
//    [self unlockFeature];
//}

@end
