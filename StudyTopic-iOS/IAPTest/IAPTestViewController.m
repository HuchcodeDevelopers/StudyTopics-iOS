//
//  IAPTestViewController.m
//  IAPTest
//
//  Created by Mark Cyril Anthony Heruela on 6/2/14.
//  Copyright (c) 2014 HuchCode. All rights reserved.
//

#import "IAPTestViewController.h"

@interface IAPTestViewController ()

@end

@implementation IAPTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _purchaseController = [[IAPPurchaseViewController alloc]init];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:_purchaseController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)purchaseItem:(id)sender {
    _purchaseController.productID = @"com.huchcode.IAPTest.Item1";
    [self.navigationController pushViewController:_purchaseController animated:YES];
    [_purchaseController getProductInfo:self];
}

-(void)enabledLevel2
{
    _level2Button.enabled = YES;
}

@end
