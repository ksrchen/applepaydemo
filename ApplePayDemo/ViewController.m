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

NSMutableArray * addresss;

- (IBAction)pay:(id)sender {
    
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    request.countryCode = @"US";
    request.currencyCode = @"USD";
    request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
    request.merchantCapabilities = PKMerchantCapabilityEMV | PKMerchantCapability3DS;
    request.merchantIdentifier = @"merchant.com.misty1";
    
   PKPaymentSummaryItem *widget = [PKPaymentSummaryItem summaryItemWithLabel:@"Platinum Fee" amount:[NSDecimalNumber decimalNumberWithString:@"300.00"]];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Grand Total" amount:[NSDecimalNumber decimalNumberWithString:@"300.00"]];
    
    request.paymentSummaryItems = @[widget, total];
    
    PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    paymentPane.delegate = self;
    [self presentViewController:paymentPane animated:TRUE completion:nil];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"My Listings"];
    
    addresss = [[NSMutableArray alloc] initWithCapacity:5];
    
    [addresss addObject:@"2000 Riverside Dr Los Angeles 90039"];
    [addresss addObject:@"Westside Towers, West - 11845 W. Olympic Blvd"];
    [addresss addObject:@"12400 Wilshire Los Angeles, CA"];
    [addresss addObject:@"21766 Wilshire Blvd - Landmark II"];
    [addresss addObject:@"Gateway LA - 12424 Wilshire Blvd"];
    [addresss addObject:@"21800 Oxnard Street, Woodland Hills, CA 91367"];
    [addresss addObject:@"G11990 San Vicente Blvd, Los Angeles, CA 90049"];
    [addresss addObject:@"1901 Avenue of the Stars, Los Angeles, CA 90067"];
    
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
    return [addresss count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    long i = indexPath.row + 1;
    UILabel * label = (UILabel *)[cell viewWithTag:2];
    label.text = [addresss objectAtIndex: i-1];
    
    
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
