//
//  MainViewViewController.h
//  KukuKube
//
//  Created by AmasHub on 5/19/15.
//  Copyright (c) 2015 Huynh Tri Dung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface MainViewViewController : UIViewController

@property (strong, nonatomic) IBOutlet GADBannerView *bannerView;

@property (strong, nonatomic) IBOutlet UIButton *btnNormal;
@property (strong, nonatomic) IBOutlet UIButton *btnIntermediate;
@property (strong, nonatomic) IBOutlet UIButton *btnAdvanced;
@property (strong, nonatomic) IBOutlet UIButton *btnExpert;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;


@end
