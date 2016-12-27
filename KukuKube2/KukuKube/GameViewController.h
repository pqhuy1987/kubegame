//
//  ViewController.h
//  KukuKube
//
//  Created by AmasHub on 5/11/15.
//  Copyright (c) 2015 Huynh Tri Dung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface GameViewController : UIViewController
@property (strong, nonatomic) IBOutlet GADBannerView *bannerView;

@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;

#pragma mark - label
@property (strong, nonatomic) IBOutlet UILabel *lblBestScore;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblScore;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblInfo;

@property (strong, nonatomic) IBOutlet UILabel *lblMode;

@property (strong, nonatomic) IBOutlet UIView *vWhite;
@property (strong, nonatomic) IBOutlet UIView *vInfo;
@property (strong, nonatomic) IBOutlet UIView *vStart;
@property (strong, nonatomic) IBOutlet UIView *vPause;

@property (strong, nonatomic) IBOutlet UIButton *btnStart;
@property (strong, nonatomic) IBOutlet UIButton *btnStop;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;



@property (nonatomic) NSInteger fromTag;

@end

