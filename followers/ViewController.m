//
//  ViewController.m
//  followers
//
//  Created by Chris Lowe on 8/26/12.
//  Copyright (c) 2012 Hashtag Studios. All rights reserved.
//

#import "ViewController.h"
#import <Twitter/Twitter.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestUsers];
}

- (void)requestUsers {
    // Do any additional setup after loading the view, typically from a nib.
    
    //  First, we create a dictionary to hold our request parameters
    //    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //    [params setObject:@"chrisintx" forKey:@"screen_name"];
    //    [params setObject:@"5" forKey:@"count"];
    //    [params setObject:@"1" forKey:@"include_entities"];
    //    [params setObject:@"1" forKey:@"include_rts"];
    
    //  Next, we create an URL that points to the target endpoint
    NSURL *url =
    [NSURL URLWithString:@"https://api.twitter.com/1/friends/ids.json?cursor=-1&screen_name=chrisintx"];
    
    //  Now we can create our request.  Note that we are performing a GET request.
    TWRequest *request = [[TWRequest alloc] initWithURL:url
                                             parameters:nil
                                          requestMethod:TWRequestMethodGET];
    
    //  Perform our request
    [request performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         
         if (responseData) {
             //  Use the NSJSONSerialization class to parse the returned JSON
             NSError *jsonError;
             NSDictionary *timeline =
             [NSJSONSerialization JSONObjectWithData:responseData
                                             options:NSJSONReadingMutableLeaves
                                               error:&jsonError];
             
             if (timeline) {
                 // We have an object that we can parse
                 NSLog(@"%@", timeline);
                 [self requestBiosWithUsers:[timeline objectForKey:@"ids"]];
             }
             else {
                 // Inspect the contents of jsonError
                 NSLog(@"ERORR: %@", jsonError);
             }
         }
     }];
}

- (void)requestBiosWithUsers:(NSArray *)timeline {
    
    NSString *timelineString = @"";
    for (int i = 0; i < 99; i++) {
        timelineString = [NSString stringWithFormat:@"%@,%@", timelineString, [timeline objectAtIndex:i]];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setObject:timelineString forKey:@"screen_name"];
//    [params setObject:@"5" forKey:@"count"];

    [params setObject:@"true" forKey:@"include_entities"];
    [params setObject:timelineString forKey:@"user_id"];
//    [params setObject:@"1" forKey:@"include_rts"];
    
    //  Next, we create an URL that points to the target endpoint
    NSURL *url =
    [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/users/lookup.json"]];
    
    //  Now we can create our request.  Note that we are performing a GET request.
    TWRequest *request = [[TWRequest alloc] initWithURL:url
                                             parameters:params
                                          requestMethod:TWRequestMethodPOST];
    
    //  Perform our request
    [request performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         
         if (responseData) {
             //  Use the NSJSONSerialization class to parse the returned JSON
             NSError *jsonError;
             NSArray *timeline =
             [NSJSONSerialization JSONObjectWithData:responseData
                                             options:NSJSONReadingMutableLeaves
                                               error:&jsonError];
             
             if (timeline) {
                 // We have an object that we can parse
                 NSLog(@"%i", [timeline count]);
             }
             else {
                 // Inspect the contents of jsonError
                 NSLog(@"%@", jsonError);
             }
         }
     }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
