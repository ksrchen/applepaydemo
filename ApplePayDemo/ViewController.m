//
//  ViewController.m
//  ApplePayDemo
//
//  Created by Kevin Chen on 1/13/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>

@interface ViewController ()
<PKPaymentAuthorizationViewControllerDelegate>
@end

@implementation ViewController
- (IBAction)pay:(id)sender {
    
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    request.countryCode = @"US";
    request.currencyCode = @"USD";
    request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
    request.merchantCapabilities = PKMerchantCapabilityEMV | PKMerchantCapability3DS;
    request.merchantIdentifier = @"merchant.com.misty1";
    
    PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 1" amount:[NSDecimalNumber decimalNumberWithString:@"0.99"]];
    PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 2" amount:[NSDecimalNumber decimalNumberWithString:@"1.00"]];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Grand Total" amount:[NSDecimalNumber decimalNumberWithString:@"1.99"]];
    
    request.paymentSummaryItems = @[widget1, widget2, total];
    
    PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    paymentPane.delegate = self;
    [self presentViewController:paymentPane animated:TRUE completion:nil];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"My Listings"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
    
    PKPaymentToken * token = [payment token];
    
    NSString * tokenString = [[NSString alloc] initWithData:[token paymentData] encoding:NSUTF8StringEncoding];
    
    completion( PKPaymentAuthorizationStatusSuccess);
    
    
}
- (void)paymentAuthorizationViewControllerDidFinish: (PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    long i = indexPath.row + 1;
    UILabel * label = (UILabel *)[cell viewWithTag:2];
    label.text = @"Address";
    
    
    UIImageView * imageView = (UIImageView *) [cell viewWithTag:4];
    NSString * imageName = [NSString stringWithFormat: @"im%ld.jpg", i];
    
    [imageView setImage: [UIImage imageNamed:imageName]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    }

@end
