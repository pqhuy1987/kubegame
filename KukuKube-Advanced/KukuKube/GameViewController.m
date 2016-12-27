//
//  ViewController.m
//  KukuKube
//
//  Created by AmasHub on 5/11/15.
//  Copyright (c) 2015 Huynh Tri Dung. All rights reserved.
// 643929575751306
///TODO:social

#import "GameViewController.h"
#import "CollectionViewCell.h"
#import "URBNAlert.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define COLLECTIONVIEW_WIDTH self.myCollectionView.frame.size.width
#define COLLECTIONVIEW_HEIGHT self.myCollectionView.frame.size.height
#define IMAGEVIEW_WIDTH self.imgView.frame.size.width
#define IMAGEVIEW_HEIGHT self.imgView.frame.size.height

#define MODE self.fromTag
#define CLASSIC 1
#define ARCADE 2
#define MINUS 3
#define EXPERT 4

@interface GameViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    UIColor *color, *colorBtn;
    NSInteger tiles;
    int randomTile, level, countTime, score;
    CGSize cellSize;
    CGFloat cellLineSpacing, alpha,itemSpacing,sizeForCell;
    NSTimer *timer;
    BOOL isPause;
    NSUserDefaults *prefs;
}
@property (strong, nonatomic) AVAudioPlayer *avSoundCorrect, *avSoundFail;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    prefs = [NSUserDefaults standardUserDefaults];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.myCollectionView setCollectionViewLayout:flowLayout];
    
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    self.bannerView.adUnitID = @"ca-app-pub-8525908052820488/6472267457";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[kGADSimulatorID];
    [self.bannerView loadRequest:request];

    NSString *soundCorrect = [NSString stringWithFormat:@"%@/beep-xylo.aif", [[NSBundle mainBundle] resourcePath]];
    NSString *soundFail = [NSString stringWithFormat:@"%@/beep-shinymetal.aif", [[NSBundle mainBundle] resourcePath]];
    // Create audio player object and initialize with URL to sound
    self.avSoundCorrect = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundCorrect] error:nil];
    self.avSoundFail = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundFail] error:nil];
    [_avSoundCorrect prepareToPlay];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Collection view data source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return tiles;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{;
    static NSString *cellIdentifier = @"Cell_Identifier";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (score==0) cell.ImageCell.backgroundColor = self.view.backgroundColor;
    else {
        cell.ImageCell.backgroundColor = color;
        self.view.backgroundColor = color;
    }
    if (indexPath.row== randomTile) {
        self.lblScore.text = [NSString stringWithFormat:@"%d", score];
        cell.ImageCell.alpha = alpha;

    }else {
        cell.ImageCell.alpha = 1.0f;
    }
    [cell.ImageCell.layer setCornerRadius:5];
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    AppDelegate *appDelegate = [[AppDelegate alloc]init];
    self.lblStatus.hidden=NO;
    switch (MODE) {
        case CLASSIC:
            if (indexPath.row == randomTile) {
                [_avSoundCorrect play];
                score ++;
                self.lblStatus.text = @"+1";
                [self fadeInFadeOutLabel];
                [self gameRule];
            }
            else [_avSoundFail play];
            break;
         case ARCADE:
            if (indexPath.row == randomTile) {
                 [_avSoundCorrect play];
                score +=2;
                self.lblStatus.text = @"+2";
                [self fadeInFadeOutLabel];
                [self gameRule];
            }
            else [_avSoundFail play];
            break;
        case MINUS:
            if (indexPath.row == randomTile) {
                 [_avSoundCorrect play];
                score ++;
                self.lblStatus.text = @"+1";
                [self fadeInFadeOutLabel];
                [self gameRule];
            } else {
                if (score>0) {
                    [_avSoundFail play];
                     score --;
                    self.lblStatus.text = @"-1";
                    [self fadeInFadeOutLabel];
                }
            }
            break;
        case EXPERT:
            if (indexPath.row == randomTile) {
                [_avSoundCorrect play];
                score ++;
                self.lblStatus.text = @"+1";
                [self fadeInFadeOutLabel];
                [self gameRule];
            } else {
                if (score>0) {
                    [_avSoundFail play];
                    score --;
                    self.lblStatus.text = @"-1";
                    [self fadeInFadeOutLabel];
                }
            }
            break;
        default:
            break;
    }
    [collectionView reloadData];
}

#pragma mark - Collection view item size & spacing

//- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(1, 1, 1, 1); // top, left, bottom, right
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return itemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return cellLineSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return cellSize;
}

#pragma mark - IBAction

- (IBAction)startGame:(id)sender {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    self.lblInfo.hidden=YES;
    self.vStart.hidden=YES;
    self.vPause.hidden = NO;
    self.myCollectionView.hidden=NO;
    self.imgView.hidden=NO;
    self.btnStart.hidden=YES;
    self.btnStop.hidden=NO;
    
}

- (IBAction)stopGame:(id)sender {
    [timer invalidate];
  
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Game is paused" message:@""];
    uac.alertStyler.blurTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    [uac addAction:[URBNAlertAction actionWithTitle:@"Continue" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }]];
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Quit" actionType:URBNAlertActionTypeDestructive actionCompleted:^(URBNAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [uac show];
    
}

#pragma mark - Private methods

- (void)initView {
    [self initValue];
    self.btnStart.layer.cornerRadius = 5;
    self.btnStop.layer.cornerRadius = 5;
    self.vWhite.layer.cornerRadius = 5;
    self.vInfo.layer.cornerRadius = 5;
    self.imgView.layer.cornerRadius = 5;
    self.myCollectionView.layer.cornerRadius=5;
    
    self.vStart.layer.cornerRadius = 5;
    self.vPause.layer.cornerRadius = 5;
    
    [self.vStart setCenter:self.view.center];

    if (IS_IPHONE_4_OR_LESS) {
        self.vWhite.bounds = CGRectMake(0,0, 265, 90);
        self.vInfo.bounds = CGRectMake(0, 0, 255, 80);
        [self.imgView setCenter:CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height / 2)+10)];
        [self.myCollectionView setCenter:CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height / 2)+10)];
        
        self.myCollectionView.bounds = CGRectMake(0,0, 255, 255);
        self.imgView.bounds = CGRectMake(0, 0, 265, 265);
    }
    else {
        [self.imgView setCenter:self.view.center];
        [self.myCollectionView setCenter:self.view.center];
        self.myCollectionView.bounds = CGRectMake(0,0, COLLECTIONVIEW_WIDTH, COLLECTIONVIEW_WIDTH);
        self.imgView.bounds = CGRectMake(0, 0, IMAGEVIEW_WIDTH, IMAGEVIEW_WIDTH);
    }
    self.lblStatus.hidden = YES;
    self.btnStart.backgroundColor = colorBtn;
    self.btnStop.backgroundColor = colorBtn;
    self.myCollectionView.hidden = YES;
    self.vPause.hidden=YES;
    self.imgView.hidden=YES;
    self.btnStop.hidden=YES;
}

- (void)fadeInFadeOutLabel {
    [self.lblStatus setAlpha:0.0f];
    //fade in
    [UIView animateWithDuration:0.25f animations:^{
        [self.lblStatus setAlpha:1.0f];
    } completion:^(BOOL finished) {
        //fade out
        [UIView animateWithDuration:0.25f animations:^{
            [self.lblStatus setAlpha:0.0f];
        } completion:nil];
    }];
}

- (void)gameRule {
    if (level <10) {
        switch (MODE) {
            case ARCADE:
                switch (score) {
                    case 2:
                        level =3;
                        break;
                    case 6:
                        level =4;
                        alpha = 0.6f;
                        break;
                    case 10:
                        level =5;
                        alpha = 0.65f;
                        break;
                    case 14:
                        level =6;
                        alpha = 0.7f;
                        break;
                    case 18:
                        level =7;
                        break;
                    case 22:
                        level =8;
                        alpha = 0.75f;
                        break;
                    case 26:
                        level =9;
                        break;
                    case 30:
                        level =10;
                        alpha = 0.76f;
                        break;
                    case 36:
                        break;
                    case 42:
                        alpha = 0.77f;
                        break;
                    default:
                        break;
                }
                break;
            case EXPERT:
                switch (score) {
                    case 1:
                        level =5;
                        break;
                    case 2:
                        level =6;
                        alpha = 0.6f;
                        break;
                    case 5:
                        level =7;
                        alpha = 0.7f;
                        break;
                    case 7:
                        level =8;
                        alpha = 0.75f;
                        break;
                    case 10:
                        level =9;
                        alpha = 0.77f;
                        break;
                    case 12:
                        level =10;
                        alpha = 0.78f;
                        break;
                    case 15:
                        alpha = 0.8f;
                        break;
                    default:
                        break;
                }
                break;
            default:
                switch (score) {
                    case 1:
                        level =3;
                        break;
                    case 3:
                        level =4;
                        alpha = 0.6f;
                        break;
                    case 5:
                        level =5;
                        alpha = 0.65f;
                        break;
                    case 7:
                        level =6;
                        alpha = 0.7f;
                        break;
                    case 9:
                        level =7;
                        break;
                    case 12:
                        level =8;
                        alpha = 0.75f;
                        break;
                    case 15:
                        level =9;
                        break;
                    case 17:
                        level =10;
                        alpha = 0.76f;
                        break;
                    case 25:
                        break;
                    case 30:
                        alpha = 0.77f;
                        break;
                    default:
                        break;
                }
                break;
        }
    }else
        level = 10;
    [self randomColor];
}

- (void)initValue {
    NSString *time = nil;
    switch (MODE) {
        case CLASSIC:
            self.lblMode.text =@"Mode: Classic";
            colorBtn = [UIColor colorWithRed:1 green:0.905 blue:0.419 alpha:1];
            time = @"60";
            countTime = 59;
            level= 2;
            self.lblInfo.text=@"Find different kubes in 60 seconds.";
            [self showBestScoreInInitValueWithMode:@"BestClassic"];
            break;
        case ARCADE:
            self.lblMode.text =@"Mode: Arcade";
            colorBtn = [UIColor colorWithRed:1 green:0.432 blue:0.366 alpha:1];
            time = @"30";
            countTime = 29;
            level= 2;
            self.lblInfo.text=@"30 seconds. Get double the points.";
            [self showBestScoreInInitValueWithMode:@"BestArcade"];
            break;
        case MINUS:
            self.lblMode.text =@"Mode: Minus";
            colorBtn = [UIColor colorWithRed:0.58 green:0.591 blue:0.986 alpha:1];
            time = @"60";
            countTime = 59;
            level= 2;
            self.lblInfo.text=@"Each wrong kube lost 1 point.";
            [self showBestScoreInInitValueWithMode:@"BestMinus"];
            break;
        case EXPERT:
            self.lblMode.text =@"Mode: Expert";
            colorBtn = [UIColor colorWithRed:0.374 green:0.839 blue:0.884 alpha:1];
            time = @"30";
            countTime = 29;
            level = 5;
            self.lblInfo.text=@"30 seconds for the ultimate test.";
            [self showBestScoreInInitValueWithMode:@"BestExpert"];
            break;
        default:
            break;
    }
    score = 0;
    alpha = 0.5f;
    [self randomColor];
    self.lblTime.text = [NSString stringWithFormat:@"Time: %@",time];
}

- (void)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    [self setSizeforTile];
}

- (void)setSizeforTile {
    tiles = (NSInteger)pow(level, 2);
    randomTile = arc4random() % tiles;
    sizeForCell=0.0;
    switch (level) {
        case 2:
            if (IS_IPHONE_4_OR_LESS) [self setCollectionViewCellDetail:125 withItemSpacing:5];
            if (IS_IPHONE_5) [self setCollectionViewCellDetail:150 withItemSpacing:10];
            if (IS_IPHONE_6) [self setCollectionViewCellDetail:180 withItemSpacing:5];
            if (IS_IPHONE_6P) [self setCollectionViewCellDetail:200 withItemSpacing:4];
            break;
        case 3:
            if (IS_IPHONE_4_OR_LESS) [self setCollectionViewCellDetail:82 withItemSpacing:4.5];
            if (IS_IPHONE_5) [self setCollectionViewCellDetail:100 withItemSpacing:5];
            if (IS_IPHONE_6) [self setCollectionViewCellDetail:120 withItemSpacing:2.5];
            if (IS_IPHONE_6P) [self setCollectionViewCellDetail:133 withItemSpacing:2.5];
            break;
        case 4:
            if (IS_IPHONE_4_OR_LESS) [self setCollectionViewCellDetail:61.5 withItemSpacing:3];
            if (IS_IPHONE_5) [self setCollectionViewCellDetail:76 withItemSpacing:2];
            if (IS_IPHONE_6) [self setCollectionViewCellDetail:89 withItemSpacing:3];
            if (IS_IPHONE_6P) [self setCollectionViewCellDetail:99 withItemSpacing:2.5];
            break;
        case 5:
            if (IS_IPHONE_4_OR_LESS) [self setCollectionViewCellDetail:49 withItemSpacing:2.5];
            if (IS_IPHONE_5) [self setCollectionViewCellDetail:60 withItemSpacing:2];
            if (IS_IPHONE_6) [self setCollectionViewCellDetail:70 withItemSpacing:3];
            if (IS_IPHONE_6P) [self setCollectionViewCellDetail:78 withItemSpacing:3.5];
            break;
        case 6:
            if (IS_IPHONE_4_OR_LESS) [self setCollectionViewCellDetail:41 withItemSpacing:1.8];
            if (IS_IPHONE_5) [self setCollectionViewCellDetail:49 withItemSpacing:3];
            if (IS_IPHONE_6) [self setCollectionViewCellDetail:58 withItemSpacing:3.2];
            if (IS_IPHONE_6P) [self setCollectionViewCellDetail:65 withItemSpacing:2.8];
            break;
        case 7:
            if (IS_IPHONE_4_OR_LESS) [self setCollectionViewCellDetail:35.5 withItemSpacing:1];
            if (IS_IPHONE_5) [self setCollectionViewCellDetail:41.5 withItemSpacing:3];
            if (IS_IPHONE_6) [self setCollectionViewCellDetail:50 withItemSpacing:2.5];
            if (IS_IPHONE_6P) [self setCollectionViewCellDetail:56 withItemSpacing:2];
            break;
        case 8:
            if (IS_IPHONE_4_OR_LESS) [self setCollectionViewCellDetail:31 withItemSpacing:1];
            if (IS_IPHONE_5) [self setCollectionViewCellDetail:36 withItemSpacing:3];
            if (IS_IPHONE_6) [self setCollectionViewCellDetail:42.5 withItemSpacing:3];
            if (IS_IPHONE_6P) [self setCollectionViewCellDetail:48 withItemSpacing:2.2];
            break;
        case 9:
            if (IS_IPHONE_4_OR_LESS) [self setCollectionViewCellDetail:27.5 withItemSpacing:0.9];
            if (IS_IPHONE_5) [self setCollectionViewCellDetail:32 withItemSpacing:2.75];
            if (IS_IPHONE_6) [self setCollectionViewCellDetail:38 withItemSpacing:2.8];
            if (IS_IPHONE_6P) [self setCollectionViewCellDetail:43 withItemSpacing:2.1];
            break;
        case 10:
            if (IS_IPHONE_4_OR_LESS) [self setCollectionViewCellDetail:24.5 withItemSpacing:0.9];
            if (IS_IPHONE_5) [self setCollectionViewCellDetail:28.5 withItemSpacing:2.75];
            if (IS_IPHONE_6) [self setCollectionViewCellDetail:35 withItemSpacing:1.6];
            if (IS_IPHONE_6P) [self setCollectionViewCellDetail:39 withItemSpacing:1.5];
            break;
        default:
            break;
    }
    cellSize = CGSizeMake(sizeForCell, sizeForCell);
//    NSLog(@"%d-%.1f-%.1f",level, sizeForCell, cellLineSpacing);
}

- (void)countDown {
    if(countTime > 0 ) {
        self.lblTime.text = [NSString stringWithFormat:@"Time: %@",[[NSNumber numberWithInt:countTime] stringValue]];
        countTime --;
    }
    else{
        [timer invalidate];
        switch (MODE) {
            case CLASSIC:
                [self setUserDefaultWithMode:@"BestClassic"];
                break;
            case ARCADE:
                [self setUserDefaultWithMode:@"BestArcade"];
                break;
            case MINUS:
                [self setUserDefaultWithMode:@"BestMinus"];
                break;
            case EXPERT:
                [self setUserDefaultWithMode:@"BestExpert"];
                break;
            default:
                break;
        }
    }
}

- (void)showBestScoreInInitValueWithMode:(NSString*)mode {
    if (![prefs stringForKey:mode]) {
        self.lblBestScore.text=@"Best score: 0";
    }
    else self.lblBestScore.text = [NSString stringWithFormat:@"Best score: %@",[prefs stringForKey:mode]];
}

- (void)setUserDefaultWithMode:(NSString *)mode {
    NSString *currentBestScore, *title, *message = nil;
    currentBestScore= [prefs stringForKey:mode];
    if ([self.lblScore.text isEqualToString:@"0"]) {
        title = @"Ops! ";
        message = @"Have you try your best?";
    }else {
        if (![prefs stringForKey:mode]) {
            [prefs setObject:self.lblScore.text forKey:mode];
//            newBestScore = currentBestScore;
            title = @"Congratulations!";
            message = [NSString stringWithFormat:@"New record play: %@ points",currentBestScore];
        }
        if ([self.lblScore.text intValue] > [currentBestScore intValue]) {
            [prefs setObject:self.lblScore.text forKey:mode];
//            newBestScore = [prefs stringForKey:mode];
            message = [NSString stringWithFormat:@"New record play: %@ points",[prefs stringForKey:mode]];
            title = @"Congratulations!";
        }
        else {
//            newBestScore = currentBestScore;
            message = [NSString stringWithFormat:@"Score: %@ points\nBest score: %@ points",self.lblScore.text, currentBestScore];
            title = @"Try again next time!";
        }
    }
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:title message:message];
    uac.alertStyler.blurTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    [uac addAction:[URBNAlertAction actionWithTitle:@"Replay" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
        [self initValue];
        [self.myCollectionView reloadData];
        [self startGame:nil];
    }]];
    [uac addAction:[URBNAlertAction actionWithTitle:@"Home" actionType:URBNAlertActionTypeDestructive actionCompleted:^(URBNAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [uac show];
    [prefs synchronize];
}

- (void)setCollectionViewCellDetail:(CGFloat)itemCellSize withItemSpacing:(CGFloat)itemCellSpacing {
    sizeForCell = itemCellSize;
    cellLineSpacing=itemCellSpacing;
    itemSpacing = itemCellSpacing;
}

@end
