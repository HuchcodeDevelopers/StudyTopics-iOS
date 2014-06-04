//
//  IAPTestViewController.h
//  IAPTest
//
//  Created by Mark Cyril Anthony Heruela on 6/2/14.
//  Copyright (c) 2014 HuchCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#include "IAPPurchaseViewController.h"

@interface IAPTestViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *level2Button;
- (IBAction)purchaseItem:(id)sender;

@property (strong, nonatomic) IAPPurchaseViewController *purchaseController;
-(void)enabledLevel2;

@end
