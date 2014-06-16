//
//  M2ViewController.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2ViewController.h"
#import "M2SettingsViewController.h"

#import "M2Scene.h"
#import "M2GameManager.h"
#import "M2ScoreView.h"
#import "M2Overlay.h"
#import "M2GridView.h"
#import <GameKit/GameKit.h>

@implementation M2ViewController {
    IBOutlet UIButton *_restartButton;
    IBOutlet UIButton *_settingsButton;
    IBOutlet UIButton *_rankingButton;
    IBOutlet UILabel *_targetScore;
    IBOutlet UILabel *_subtitle;
    IBOutlet M2ScoreView *_scoreView;
    IBOutlet M2ScoreView *_bestView;
    
    M2Scene *_scene;
    
    IBOutlet M2Overlay *_overlay;
    IBOutlet UIImageView *_overlayBackground;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateState];
    
    _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)[Settings integerForKey:@"Best Score"]];
    
    int values = [self getScoreValue:(long)[Settings integerForKey:@"Best Score"]];
    
    _bestView.score.text = [self getScoreNmae:values];
    
    _bestView.score0.text = [NSString stringWithFormat:@"%ld", (long)[Settings integerForKey:@"Best Score0"]];
    
    _restartButton.layer.cornerRadius = [GSTATE cornerRadius];
    _restartButton.layer.masksToBounds = YES;
    
    _settingsButton.layer.cornerRadius = [GSTATE cornerRadius];
    _settingsButton.layer.masksToBounds = YES;
    
    _rankingButton.layer.cornerRadius = [GSTATE cornerRadius];
    _rankingButton.layer.masksToBounds = YES;
    
    _overlay.restartGame.layer.cornerRadius = [GSTATE cornerRadius];
    _overlay.restartGame.layer.masksToBounds = YES;
    
    _overlay.hidden = YES;
    _overlayBackground.hidden = YES;
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    M2Scene * scene = [M2Scene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    [self updateScore:0];
    [scene startNewGame];
    
    _scene = scene;
    _scene.delegate = self;
    
    GSTATE.maxscore = 2;
    
    // 在屏幕顶部创建标准尺寸的视图。
    // 在GADAdSize.h中对可用的AdSize常量进行说明。
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    bannerView_.frame = CGRectMake(0, self.view.frame.size.height - bannerView_.frame.size.height, bannerView_.frame.size.width, bannerView_.frame.size.height);
    
    // 指定广告单元ID。
    bannerView_.adUnitID = @"ca-app-pub-1938855001982780/2482709151";
    
    // 告知运行时文件，在将用户转至广告的展示位置之后恢复哪个UIViewController
    // 并将其添加至视图层级结构。
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // 启动一般性请求并在其中加载广告。
    [bannerView_ loadRequest:[GADRequest request]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[GameCenterManager sharedManager] checkGameCenterAvailability];
    [[GameCenterManager sharedManager] localPlayerData];
}

- (void)updateState
{
    [_scoreView updateAppearance];
    [_bestView updateAppearance];
    
    _restartButton.backgroundColor = [GSTATE buttonColor];
    _restartButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    
    _settingsButton.backgroundColor = [GSTATE buttonColor];
    _settingsButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    
    _rankingButton.backgroundColor = [GSTATE buttonColor];
    _rankingButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    
    _targetScore.textColor = [GSTATE buttonColor];
    
    long target = [GSTATE valueForLevel:GSTATE.winningLevel];
    
    if (target > 100000) {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:34];
    } else if (target < 10000) {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:42];
    } else {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:40];
    }
    
    _targetScore.text = [NSString stringWithFormat:@"%ld", target];
    
    _subtitle.textColor = [GSTATE buttonColor];
    _subtitle.font = [UIFont fontWithName:[GSTATE regularFontName] size:14];
    _subtitle.text = [NSString stringWithFormat:@"Join the numbers to get to %ld!", target];
    
    _overlay.message.font = [UIFont fontWithName:[GSTATE boldFontName] size:36];
    _overlay.keepPlaying.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    _overlay.restartGame.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    
    _overlay.message.textColor = [GSTATE buttonColor];
    [_overlay.keepPlaying setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
    //[_overlay.restartGame setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
    _overlay.restartGame.backgroundColor = [GSTATE buttonColor];
    
}

- (NSString *)getScoreNmae:(int)value{
    NSString *Name = @"";
    switch (value) {
        case 0:{
            Name =@" ";
            break;
        }
            
        case 1:{
            Name =@"夏";
            break;
        }
            
        case 2:{
            Name =@"商";
            break;
        }
            
        case 3: {
            Name =@"周";
            break;
        }
            
        case 4: {
            Name =@"秦";
            break;
        }
        case 5:{
            Name =@"汉";
            break;
        }
            
        case 6:{
            Name =@"三国";
            break;
        }
            
        case 7: {
            Name =@"晋";
            break;
        }
            
        case 8: {
            Name =@"南北朝";
            break;
        }
        case 9:{
            Name =@"隋";
            break;
        }
            
        case 10:{
            Name =@"唐";
            break;
        }
            
        case 11:{
            Name =@"五代";
            break;
        }
            
        case 12: {
            Name =@"宋";
            break;
        }
            
        case 13: {
            Name =@"元";
            break;
        }
            
        case 14: {
            Name =@"明";
            break;
        }
            
        case 15: {
            Name =@"清";
            break;
        }
            
        case 16: {
            Name =@"天朝";
            break;
        }
            
        case 17: {
            Name =@"天才";
            break;
        }
    }
    
    return Name;
}

- (void)updateScore:(NSInteger)score
{
    int values = [self getScoreValue:GSTATE.maxscore];
    
    _scoreView.score.text = [NSString stringWithFormat:@"%ld", (long)GSTATE.maxscore];
    
    _scoreView.score.text = [self getScoreNmae:values];
    
    if ([Settings integerForKey:@"Best Score"] < GSTATE.maxscore) {
        [Settings setInteger:GSTATE.maxscore forKey:@"Best Score"];
        _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)GSTATE.maxscore];
        _bestView.score.text = [self getScoreNmae:values];
    }
    
    _scoreView.score0.text = [NSString stringWithFormat:@"%ld", (long)score];
    if ([Settings integerForKey:@"Best Score0"] < score) {
        [Settings setInteger:score forKey:@"Best Score0"];
        _bestView.score0.text = [NSString stringWithFormat:@"%ld", (long)score];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pause Sprite Kit. Otherwise the dismissal of the modal view would lag.
    ((SKView *)self.view).paused = NO;
}


- (IBAction)restart:(id)sender
{
    [[GameCenterManager sharedManager] saveAndReportScore:[_bestView.score0.text intValue] leaderboard:@"chaodai" sortOrder:GameCenterSortOrderHighToLow];
    
    [self hideOverlay];
    [self updateScore:0];
    GSTATE.maxscore = 2;
    [_scene startNewGame];
}


- (IBAction)keepPlaying:(id)sender
{
    [self hideOverlay];
}

- (IBAction)ranking:(id)sender {
    
    [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];
}


- (IBAction)done:(UIStoryboardSegue *)segue
{
    ((SKView *)self.view).paused = NO;
    if (GSTATE.needRefresh) {
        GSTATE.maxscore = 2;
        [GSTATE loadGlobalState];
        [self updateState];
        [self updateScore:0];
        [_scene startNewGame];
    }
}

- (int)getScoreValue:(long)m{
    
    int i = 0;
    while (m > 1) {
        i ++;
        m >>= 1;
    }
    
    return i;
}

- (void)endGame:(BOOL)won
{
    _overlay.hidden = NO;
    _overlay.alpha = 0;
    _overlayBackground.hidden = NO;
    _overlayBackground.alpha = 0;
    int value = [self getScoreValue:GSTATE.maxscore] - 3;
    
    if (!won) {
        _overlay.keepPlaying.hidden = YES;
        switch (value) {
            case 0:{
                _overlay.message.text = @"连秦始皇都见不到了T.T";
                break;
            }
                
            case 2:{
                _overlay.message.text = @"曹贼你还我大汉江山！";
                break;
            }
                
            case 1: {
                _overlay.message.text = @"都是赵高害得我！";
                break;
            }
                
            case 3: {
                _overlay.message.text = @"司马老儿果然奸诈！";
                break;
            }
            case 4:{
                _overlay.message.text = @"江山难坐啊！";
                break;
            }
                
            case 5:{
                _overlay.message.text = @"隋朝天下一统，可惜看不到了！";
                break;
            }
                
            case 6: {
                _overlay.message.text = @"毁在杨广手里了……";
                break;
            }
                
            case 7: {
                _overlay.message.text = @"安史之乱亡我大唐……";
                break;
            }
            case 8:{
                _overlay.message.text = @"赵匡胤黄袍加身，兵不血刃啊！";
                break;
            }
                
            case 9:{
                _overlay.message.text = @"元人铁蹄果然厉害！";
                break;
            }
                
            case 10: {
                _overlay.message.text = @"还是朱元璋厉害……";
                break;
            }
                
            case 11: {
                _overlay.message.text = @"天地会的弟兄们，反清复明啊！";
                break;
            }
                
            case 12: {
                _overlay.message.text = @"连辛亥革命的黎明都没等到……";
                break;
            }
                
            case 13: {
                _overlay.message.text = @"看不到天朝的太阳了 = =";
                break;
            }
        }
        NSLog(@"%ld",GSTATE.maxscore);
        NSLog(@"%i",value);
        //_overlay.message.text = @"Game Over";
    } else {
        _overlay.keepPlaying.hidden = NO;
        _overlay.message.text = @"中华人民共和国万岁！";
    }
    
    // Fake the overlay background as a mask on the board.
    _overlayBackground.image = [M2GridView gridImageWithOverlay];
    
    // Center the overlay in the board.
    CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - GSTATE.verticalOffset;
    NSInteger side = GSTATE.dimension * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
    _overlay.center = CGPointMake(GSTATE.horizontalOffset + side / 2, verticalOffset - side / 2);
    
    [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _overlay.alpha = 1;
        _overlayBackground.alpha = 1;
    } completion:^(BOOL finished) {
        // Freeze the current game.
        ((SKView *)self.view).paused = YES;
    }];
    
    GSTATE.maxscore = 2;
}


- (void)hideOverlay
{
    ((SKView *)self.view).paused = NO;
    if (!_overlay.hidden) {
        [UIView animateWithDuration:0.5 animations:^{
            _overlay.alpha = 0;
            _overlayBackground.alpha = 0;
        } completion:^(BOOL finished) {
            _overlay.hidden = YES;
            _overlayBackground.hidden = YES;
        }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%s", __FUNCTION__);
    
    [self startAudio];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%s", __FUNCTION__);
    
    // SpriteKit uses AVAudioSession for [SKAction playSoundFileNamed:]
    // AVAudioSession cannot be active while the application is in the background,
    // so we have to stop it when going in to background
    // and reactivate it when entering foreground.
    // This prevents audio crash.
    [self stopAudio];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"%s", __FUNCTION__);
    
    [self startAudio];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%s", __FUNCTION__);
    
    [self stopAudio];
}

static BOOL isAudioSessionActive = NO;

- (void)startAudio {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    
    if (audioSession.otherAudioPlaying) {
        [audioSession setCategory: AVAudioSessionCategoryAmbient error:&error];
    } else {
        [audioSession setCategory: AVAudioSessionCategorySoloAmbient error:&error];
    }
    
    if (!error) {
        [audioSession setActive:YES error:&error];
        isAudioSessionActive = YES;
    }
    
    NSLog(@"%s AVAudioSession Category: %@ Error: %@", __FUNCTION__, [audioSession category], error);
}

- (void)stopAudio {
    // Prevent background apps from duplicate entering if terminating an app.
    if (!isAudioSessionActive) return;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    
    [audioSession setActive:NO error:&error];
    
    NSLog(@"%s AVAudioSession Error: %@", __FUNCTION__, error);
    
    if (error) {
        // It's not enough to setActive:NO
        // We have to deactivate it effectively (without that error),
        // so try again (and again... until success).
        [self stopAudio];
    } else {
        isAudioSessionActive = NO;
    }
}
@end
