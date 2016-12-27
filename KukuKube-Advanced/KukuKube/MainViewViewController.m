//
//  MainViewViewController.m
//  KukuKube
//
//  Created by AmasHub on 5/19/15.
//  Copyright (c) 2015 Huynh Tri Dung. All rights reserved.
//

#import "MainViewViewController.h"
#import "GameViewController.h"
#import <Social/Social.h>
@interface MainViewViewController ()
@end

@implementation MainViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnAdvanced.layer.cornerRadius = 5;
    self.btnNormal.layer.cornerRadius = 5;
    self.btnIntermediate.layer.cornerRadius = 5;
    self.btnExpert.layer.cornerRadius = 5;
    self.viewContainer.layer.cornerRadius = 5;
    
//    self.bannerView.adUnitID = @"ca-app-pub-8525908052820488/6472267457";
//    self.bannerView.rootViewController = self;
//    GADRequest *request = [GADRequest request];
//    // Requests test ads on devices you specify. Your test device ID is printed to the console when
//    // an ad request is made. GADBannerView automatically returns test ads when running on a
//    // simulator.
//    request.testDevices = @[ kGADSimulatorID ];
//    [self.bannerView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//- (IBAction)fb:(id)sender {
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//        SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        [fbPostSheet setInitialText:@"This is a Facebook post!"];
//        [self presentViewController:fbPostSheet animated:YES completion:nil];
//    } else {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Sorry"
//                                  message:@"You can't post right now, make sure your device has an internet connection and you have at least one facebook account setup"
//                                  delegate:self
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
//    }
//}
//- (IBAction)tw:(id)sender {
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
//        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//        [tweetSheet setInitialText:@"This is a tweet!"];
//        [self presentViewController:tweetSheet animated:YES completion:nil];
//    }
//    else
//    {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Sorry"
//                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
//                                  delegate:self
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
//    }
//}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
    GameViewController *gameView = [segue destinationViewController];
    gameView.fromTag = sender.tag;
}

@end
