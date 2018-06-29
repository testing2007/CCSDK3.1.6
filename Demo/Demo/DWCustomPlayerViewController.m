#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

#import "DWCustomPlayerViewController.h"
#import "DWOfflineViewController.h"
#import "DWGestureButton.h"
#import "DWPlayerMenuView.h"
#import "DWTableView.h"
#import "DWTools.h"
#import "DWMediaSubtitle.h"
#import "Reachability.h"

#import "DWDownloadViewController.h"

#import "DWPlayerView.h"
#import "DWGIFViewController.h"

#import "DWAudioPlayer.h"
#import "DWBottomView.h"
#import "DWAudioPlayView.h"

#import "DWVideoMarkModel.h"
#import "MJExtension.h"
//vr
#import "DWVRLibrary.h"
#import "CustomDirectorFactory.h"
#import "DWToastView.h"
#import "DWMarkView.h"
//问答
#import "DWAnswerModel.h"
#import "DWQuestionModel.h"
#import "DWFeedBackView.h"
#import "DWQuestionView.h"
#import "DWSubtitleModel.h"



static const CGFloat seconds =0.25;
static const CGFloat viewHeight =4.5;




enum {
    DWPlayerScreenSizeModeFill=1,
    DWPlayerScreenSizeMode100,
    DWPlayerScreenSizeMode75,
    DWPlayerScreenSizeMode50
};
typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};

typedef NSInteger DWPLayerScreenSizeMode;

@interface DWCustomPlayerViewController () <UIGestureRecognizerDelegate,DWGestureViewDelegate,UIAlertViewDelegate,DWVideoPlayerDelegate,DWBottomViewDelegate,DWAudioPlayViewDelegate,DWAudioPlayerDelegate>
{
    NSMutableArray *_signArray;
    
    UIButton *detailBtn;//了解详情
    
    UIButton *closeBtn;//关闭广告
}
@property (strong, nonatomic) UIAlertView *alert;
@property (strong, nonatomic) UILabel *tipLabel;


@property (assign, nonatomic) Direction direction;
@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGFloat startVB;
@property (assign, nonatomic) CGFloat startVideoRate;
@property (strong, nonatomic) MPVolumeView *volumeView;//控制音量的view
@property (strong, nonatomic) UISlider* volumeViewSlider;//控制音量
@property (assign, nonatomic) CGFloat currentRate;//当期视频播放的进度

@property (strong, nonatomic)UIView *headerView;
@property (strong, nonatomic)UIView *footerView;
//@property (strong, nonatomic)DWGestureView *overlayView;
@property (strong,nonatomic)UIView *overlayView;

@property (strong, nonatomic)UITapGestureRecognizer *signelTap;
@property (strong, nonatomic)UILabel *videoStatusLabel;
@property (strong, nonatomic)UIButton *lockButton;
@property (assign, nonatomic)BOOL isLock;
@property (strong, nonatomic)UIButton *BigPauseButton;

@property (strong, nonatomic)UIButton *backButton;
@property (strong, nonatomic)UIButton *screenSizeButton;
@property (assign, nonatomic)NSInteger currentScreenSizeStatus;
@property (strong, nonatomic)UIButton *downloadButton;
@property (strong, nonatomic)UIButton *menuButton;
@property (strong, nonatomic)UIButton *subtitleButton;
@property (assign, nonatomic)NSInteger currentSubtitleStatus;
@property (strong, nonatomic)DWTableView *subtitleTable;
@property (strong, nonatomic)UILabel *movieSubtitleLabel;
@property (strong, nonatomic)DWMediaSubtitle *mediaSubtitle;
@property (strong, nonatomic)UIView *menuView;
@property (strong, nonatomic)UIView *restView;
@property (strong, nonatomic)UITapGestureRecognizer *restviewTap;
@property (strong, nonatomic)UILabel *subtitleLabel;
@property (strong, nonatomic)UISwitch *subtitelSwitch;
@property (strong, nonatomic)UILabel *screenSizeLabel;
@property (strong, nonatomic)UIButton *screenSizeFull;
@property (strong, nonatomic)UIButton *screenSize100;
@property (strong, nonatomic)UIButton *screenSize75;
@property (strong, nonatomic)UIButton *screenSize50;

@property (strong, nonatomic)UIButton *switchScrBtn;
@property (assign, nonatomic)BOOL isFullscreen;
@property (strong, nonatomic)UIButton *selectvideoButton;
@property (strong, nonatomic)DWTableView *selectvideoTable;
@property (strong, nonatomic)UIButton *qualityButton;
@property (assign, nonatomic)NSInteger currentQualityStatus;
@property (strong, nonatomic)DWTableView *qualityTable;
@property (strong, nonatomic)NSMutableArray *qualityDescription;
@property (strong, nonatomic)NSString *currentQuality;
@property (assign, nonatomic)BOOL isSwitchquality;
@property (assign, nonatomic)NSTimeInterval switchTime;
@property (strong, nonatomic)UIButton *playbackButton;//播放
@property (assign, nonatomic)BOOL pausebuttonClick;
@property (strong, nonatomic)UIButton *playbackrateButton;
@property(nonatomic) float currentPlaybackRate;
@property (strong, nonatomic)UIButton *lastButton;
@property (strong, nonatomic)UIButton *nextButton;
@property (strong, nonatomic)UISlider *durationSlider;
@property (strong, nonatomic)UILabel *currentPlaybackTimeLabel;
@property (strong, nonatomic)UILabel *durationLabel;


@property (strong,nonatomic)DWPlayerView *playerView;


@property (strong, nonatomic)NSDictionary *playUrls;
@property (strong, nonatomic)NSDictionary *currentPlayUrl;



@property (assign, nonatomic)BOOL hiddenAll;
@property (assign, nonatomic)NSInteger hiddenDelaySeconds;
@property(nonatomic,strong)NSDictionary *playPosition;

@property (strong, nonatomic)DWAdInfo *adInfo;
@property (strong, nonatomic)NSString *type;
@property (assign, nonatomic)int adNum;
@property (strong, nonatomic)NSString *materialUrl;
@property (strong, nonatomic)NSString *clickUrl;
@property (strong, nonatomic)UIView *adView;
@property (strong, nonatomic)UIImageView *materialView;
@property (strong, nonatomic)UIImage *materialImg;
@property (retain, nonatomic)UILabel *timeLabel;
@property (assign, nonatomic)NSInteger secondsCountDown;
@property (strong, nonatomic)NSTimer *countDownTimer;
@property (assign, nonatomic)BOOL adPlay;

@property (nonatomic) Reachability *internetReachability;
@property (assign, nonatomic)NSInteger loadSecond;
@property (assign, nonatomic)BOOL isPlayable;
@property (assign, nonatomic)BOOL isDowning;

@property (nonatomic, strong) DWVRLibrary* vrLibrary;

@property (nonatomic,strong)UIView *videoBackgroundView;



@property (nonatomic,assign)NSInteger vrmode;

@property (nonatomic,strong)UIButton *vrInteractiveBtn;//交互按钮
@property (nonatomic,strong)UIButton *vrDisplayBtn;//分屏
@property (nonatomic,strong)UIView *vrView;

@property (nonatomic,assign)DWModeInteractive interative;//交互模式
@property (nonatomic,assign)DWModeDisplay display;//单双屏

@property (nonatomic,strong)UISlider *voiceSlider;//音量调节
@property (nonatomic,strong)UIButton *voiceBtn;//音量按钮
@property (nonatomic,assign)float voiceValue;

@property (nonatomic,strong)DWVRConfiguration *config;

@property (nonatomic,assign)NSInteger videoIndex;//视频下标

@property (nonatomic,assign)NSInteger qualityIndex;

@property (nonatomic,assign)BOOL isSwitchVideo;//是否切换了资源

@property (nonatomic,assign)NSInteger skipTime;//跳过时间

@property (nonatomic,assign)BOOL isClose;

@property (nonatomic,assign)BOOL isRepeat;

@property(nonatomic,assign)float palyTime;

@property (nonatomic,assign)BOOL isBackGround;//从后台回来

@property (nonatomic,assign)float speed;

@property (nonatomic,assign)BOOL isSlidering;//滑动条是否在滑动

@property (nonatomic,strong)UIView *gifView;
@property (nonatomic,strong)UIButton *gifBtn;
@property (nonatomic,strong)UIButton *gifCancelBtn;//GIF取消按钮
@property (nonatomic,strong)NSTimer *gifTimer;//GIF定时器
@property (nonatomic,assign)CGFloat clipTime;//截取的视频时间
@property (nonatomic,assign)NSInteger gifStartTime;//制作GIF的起始时间
@property (nonatomic,assign)NSInteger gifTotalTime;//制作GIF的总时间


@property (nonatomic,assign)BOOL isGIF;
@property (nonatomic,assign)BOOL isFirstClick;

@property (nonatomic,copy)NSDictionary *gifDictionary;

@property (nonatomic,strong)DWToastView *toastView;

@property (nonatomic,strong)NSURL *videoURL;

@property (nonatomic,strong)DWBottomView *bottomView;

@property (nonatomic,strong)DWAudioPlayView *audioView;

@property (nonatomic,strong)DWAudioPlayer *audioPlayer;

@property (nonatomic,assign)CGFloat currentPlayTime;//当前播放时间 用于音视频切换

@property (nonatomic,strong)NSDictionary *audioDic;//音频字典

@property (nonatomic,assign)BOOL isChangePlay;//是否切换了音频播放

@property (nonatomic,assign)BOOL isNext;//是否变换了播放资源

@property (nonatomic,copy)NSString *currentPlayType;//当前播放类型 视频or音频

@property (nonatomic,strong)NSMutableArray *videomarkArray;//打点数组
@property (nonatomic,strong)DWMarkView *markView;//打点视图
@property (nonatomic,strong)NSMutableArray *markButtonArray;//按钮的数组 取坐标
@property (nonatomic,strong)UIImageView *arrowImageView;//箭头
@property (nonatomic,assign)CGFloat markScrubtime;

@property (nonatomic,strong)NSMutableDictionary *videoquestionsDic;//问答字典
@property (nonatomic,strong)DWQuestionView *questionView;//问题显示
@property (nonatomic,strong)DWFeedBackView *feedBackView;//回答正确或错误
@property (nonatomic,strong)NSMutableArray *questionModelArray;
@property (nonatomic,copy)NSDictionary *subtitleDic;//字幕
@property (nonatomic,strong)DWSubtitleModel *subtitleModel;

@end

@implementation DWCustomPlayerViewController

/*此页面仅为示例 测试使用
 *大家要根据SDK公开的API 结合自身项目需求 灵活处理
 
 */

- (void)dealloc{

    NSLog(@"%@销毁了",[self description]);

}

+ (instancetype)sharedInstance{
    
    static id sharedInstance =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance =[[self alloc] init];
    });
    return sharedInstance;
    
}

- (NSMutableArray *)questionModelArray{
    if (!_questionModelArray) {
        
        _questionModelArray =[NSMutableArray array];
    }
    
    return _questionModelArray;
}

- (NSMutableArray *)videomarkArray{
    
    if (!_videomarkArray) {
        
        _videomarkArray =[NSMutableArray array];
    }
    
    return _videomarkArray;
}

- (NSMutableDictionary *)videoquestionsDic{
    
    if (!_videoquestionsDic) {
        
        _videoquestionsDic =[NSMutableDictionary dictionary];
    }
    
    return _videoquestionsDic;
}

- (DWQuestionView *)questionView{
    
    if (!_questionView) {
        
        _questionView =[[DWQuestionView alloc]initWithFrame:CGRectMake((ScreenWidth-300)/2, (ScreenHeight-620/2)/2,300, 620/2)];
        [self.view addSubview:_questionView];
        
        
    }
    
    return _questionView;
}



- (DWMarkView *)markView{
    
    if (!_markView) {
        
        _markView =[[DWMarkView alloc]init];
        _markView.backgroundColor =[DWTools colorWithHexString:@"#1e1f21"];
      //  _markView.backgroundColor =[UIColor clearColor];
        _markView.alpha =0.69;
        _markView.layer.cornerRadius =15;
        _markView.layer.masksToBounds =YES;
        [self.overlayView addSubview:_markView];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(markViewTapAction:)];
        
        [_markView addGestureRecognizer:tap];
        
    }
    
    return _markView;
}

- (UIImageView *)arrowImageView{
    
    if (!_arrowImageView) {
        
        _arrowImageView =[[UIImageView alloc]init];
        _arrowImageView.image =[UIImage imageNamed:@"arrow"];
       // _arrowImageView.backgroundColor =[UIColor clearColor];
        [self.overlayView addSubview:_arrowImageView];
    }
    
    return _arrowImageView;
}

- (NSMutableArray *)markButtonArray{

    if (!_markButtonArray) {
        
        _markButtonArray =[NSMutableArray array];
    }

    return _markButtonArray;
}

- (void)loadPlayer{
    
    // _qualityDescription = @[@"普通", @"清晰", @"高清"];
    
      //播放器所在的视图初始化 添加 播放／暂停的观察
        self.playerView =[[DWPlayerView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight/2-50)];
        //设置userID key
        self.playerView.userId =DWACCOUNT_USERID;
        self.playerView.key =DWACCOUNT_APIKEY;
        
        // self.playerView.videoGravity =AVLayerVideoGravityResizeAspect;
        self.playerView.delegate =self;
        
        // 设置playerView的drmServerPort 用于drm加密视频的播放
         self.playerView.drmServerPort = DWAPPDELEGATE.drmServer.listenPort;
        _currentQuality = [_qualityDescription objectAtIndex:0];
        
        //创建音频播放器
        self.audioPlayer =[[DWAudioPlayer alloc]init];
        self.audioPlayer.delegate =self;
}


# pragma mark - 页面视图

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadSubviews];
    
}

- (void)loadSubviews{
    
    
    //加载音视频播放器
    [self loadPlayer];
    
    _speed =1.0;
    
    _videoIndex =0;
    _qualityIndex =103;
    self.currentQuality  =@"清晰";
    
    _voiceValue =0.5f;
    
    
    _signArray = [NSMutableArray new];
    for (int i=0; i<4; i++) {
        [_signArray addObject:@"0"];
    }
    
 
    
    
    
    //加载背景
    self.videoBackgroundView = [[UIView alloc] init];
    [self.view addSubview:self.videoBackgroundView];
    self.view.backgroundColor =[UIColor colorWithWhite:0 alpha:0.8];
    
    
    // 初始化播放器覆盖视图，它作为所有空间的父视图。
    //    self.overlayView = [[DWGestureView alloc] initWithFrame:self.view.bounds];
    //    self.overlayView.touchDelegate = self;
    self.overlayView =[[UIView alloc]initWithFrame:self.view.bounds];
    
    // 初始化子视图
    [self loadFooterView];
    [self loadHeaderView];
    
    //只是为了解决以前的问题 事实上VR视图可以放在任意view上
    [self loadVRView];
    
    //vr初始化设置
    _interative =DWModeInteractiveMotion;
    _display =DWModeDisplayNormal;
    
    
    [self.overlayView addSubview:self.playerView];
    
    
    self.videoStatusLabel = [[UILabel alloc] init];
    self.tipLabel = [[UILabel alloc]init];
    
    [self onDeviceOrientationChange];
    
    self.signelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelTap:)];
    self.signelTap.numberOfTapsRequired = 1;
    self.signelTap.delegate = self;
    [self.overlayView addGestureRecognizer:self.signelTap];
    
    //底部控制view
    _bottomView =[[DWBottomView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.overlayView.frame),ScreenWidth, 39)];
    _bottomView.delegate =self;
    [self.view addSubview:_bottomView];
    
    //音频播放view
    _audioView =[[DWAudioPlayView alloc]initWithFrame:self.overlayView.frame];
    _audioView.hidden =YES;
    _audioView.delegate =self;
    [self.view addSubview:_audioView];
    
   
    
    
    
}

- (void)playVideoOrAudio{
    
    if (self.videoId) {
        if (_playMode) {
            // 获取广告信息
            _type = @"1";
            [self startRequestAdInfo];
        }
        else{
            //播放网络视频
            [self loadPlayUrls];
        }
        
    } else if (self.localPath) {
        // 播放本地视频
        [self playLocalVideo];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"没有可以播放的视频"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self hiddenAllView];
    });
    
    
}

//根据mediatype决定显示哪个view
- (void)showMediatypeView{
    
    
    if (![self.playerView.mediatype isEqualToString:@"0"]) {
        
        self.bottomView.hidden =YES;
        //说明是视频
        if (!self.playerView.mediatype || [self.playerView.mediatype isEqualToString:@"1"]) {
            
            self.audioView.hidden =YES;
            
        }else{
            //说明是音频
            self.audioView.hidden =NO;
            [self.view bringSubviewToFront:self.audioView];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    if ([_internetReachability currentReachabilityStatus] == ReachableViaWWAN) {
        self.alert = [[UIAlertView alloc]initWithTitle:@"当前为移动网络，是否继续播放？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [self.alert show];
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    
    //回到前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    
    //耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    //中断的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
    [self.playerView addObserver:self forKeyPath:@"playing" options:NSKeyValueObservingOptionNew context:nil];
    
    
    //说明播放的是同一个videoId
    if ([self.videoId isEqualToString:self.playerView.videoId]) {
        
        return;
    }
    
    [self playVideoOrAudio];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    // 显示 状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // 显示 navigationController
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
    
}

//中断事件
- (void)handleInterruption:(NSNotification *)notification{
    
    NSDictionary *info = notification.userInfo;
        //一个中断状态类型
        AVAudioSessionInterruptionType type =[info[AVAudioSessionInterruptionTypeKey] integerValue];
    
        //判断开始中断还是中断已经结束
        if (type == AVAudioSessionInterruptionTypeBegan) {
            //停止播放
            if (self.audioPlayer.isAudioPlaying) {
                
                _currentPlayType =@"音频";
               [self.audioPlayer audioPause];
                
                
            }else if (self.playerView.playing){
                
                _currentPlayType =@"视频";
               [self.playerView pause];
                
            }
            
            
        }else {
            //如果中断结束会附带一个KEY值，表明是否应该恢复音频
            AVAudioSessionInterruptionOptions options =[info[AVAudioSessionInterruptionOptionKey] integerValue];
            if (options == AVAudioSessionInterruptionOptionShouldResume) {
                //恢复播放
                if ([_currentPlayType isEqualToString:@"音频"]) {

                    [self.audioPlayer audioPlay];

                }else if ([_currentPlayType isEqualToString:@"视频"]){

                    [self.playerView play];
                }



            }
            
 }
    
}

//耳机插入、拔出事件
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            //判断为耳机接口
            AVAudioSessionRouteDescription *previousRoute =interuptionDict[AVAudioSessionRouteChangePreviousRouteKey];
            
            AVAudioSessionPortDescription *previousOutput =previousRoute.outputs[0];
            NSString *portType =previousOutput.portType;
            
            if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
                
                
                // 拔掉耳机继续播放
                if (self.audioPlayer.isAudioPlaying) {
                    
                    [self.audioPlayer audioPlay];
                }
                
                if (self.playerView.playing) {
                    
                    [self.playerView play];
                }
                
                
            }
            
    }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            
            break;
    }
}

//进入后台
- (void)appDidEnterBackground{

//  if ([self.playerView.mediatype isEqualToString:@"0"] && self.playerView.playing) {
//
//        [self.bottomView audioPlay:self.bottomView.audioBtn];
//
//        return;
//    }
//
//    if (self.playerView.playing) {
//
//        [self.playerView pause];
//    }
    
    
    
}


//后台进入前台
- (void)appWillEnterForegroundNotification{
   
    
    if (self.playerView.playing){

        [self.playerView play];
    }
    

}


# pragma mark 处理网络状态改变

- (void)networkStateChange
{
    NetworkStatus status = [_internetReachability currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            NSLog(@"没有网络");
            [self loadTipLabelview:NO];
            self.tipLabel.text = @"当前无任何网络";
            
            break;
            
        case ReachableViaWiFi:
            NSLog(@"Wi-Fi");
            [self loadTipLabelview:NO];
            self.tipLabel.text = @"切换到wi-fi网络";
           
            break;
            
        case ReachableViaWWAN:
            NSLog(@"运营商网络");
            {
                if (self.playerView.playing) {
                      [self.playerView pause];
                }
                
                if (self.audioPlayer.isAudioPlaying) {
                    
                    [self.audioPlayer audioPause];
                }
                
              
                self.alert = [[UIAlertView alloc]initWithTitle:@"当前为移动网络，是否继续播放？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [self.alert show];
            }
            break;
            
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        

        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    if (buttonIndex == 1) {
        
        if (self.playerView.playing) {
            
            [self.playerView play];
        }
        
        if (self.audioPlayer.isAudioPlaying) {
            
            [self.audioPlayer audioPlay];
        }
        
        
    }
}

# pragma mark - 广告层
-(void)loadAdview
{
    _materialUrl = [[_adInfo.ad objectAtIndex:_adNum] objectForKey:@"material"];
    _clickUrl = [[_adInfo.ad objectAtIndex:_adNum] objectForKey:@"clickurl"];

    
    [_adView removeFromSuperview];
    _adView = [[UIView alloc]init];
    _adView.frame = self.overlayView.frame;
    _adView.backgroundColor = [UIColor clearColor];
    
    [_materialView removeFromSuperview];
    _materialView = [[UIImageView alloc]init];
    
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(_adView.bounds.origin.x+10, 20, 35, 35);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"player-back-button.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_adView addSubview:backBtn];
    
    UIButton *scrBtn = [[UIButton alloc]init];
    scrBtn.frame = CGRectMake(_adView.bounds.size.width - 40, _adView.bounds.size.height - 40, 30, 30);
    scrBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    scrBtn.selected = self.switchScrBtn.selected;
    [scrBtn setImage:[UIImage imageNamed:@"fullscreen.png"] forState:UIControlStateNormal];
    [scrBtn setImage:[UIImage imageNamed:@"nonfullscreen.png"] forState:UIControlStateSelected];
    [scrBtn addTarget:self action:@selector(switchScreenAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [_adView addSubview:scrBtn];
    
    //了解详情
    detailBtn = [[UIButton alloc]init];
    detailBtn.frame = CGRectMake(_adView.bounds.size.width - 120, _adView.bounds.size.height - 40, 70, 30);
    [detailBtn setTitle:@"了解详情" forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    detailBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    [detailBtn addTarget:self action:@selector(detailBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_adView.bounds.size.width - 117, 20, 30, 30)];
    _timeLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    closeBtn = [[UIButton alloc]init];
    closeBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [closeBtn sizeToFit];
   
    //暂停广告 立即响应
    if ([_type isEqualToString:@"2"]) {
        
        _isClose =YES;
    }
    
    
    [_adView addSubview:closeBtn];
    
    
    UIButton *playBtn = [[UIButton alloc]init];
    playBtn.frame = CGRectMake(_adView.bounds.origin.x + 10, _adView.bounds.size.height - 40, 30, 30);
    playBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    [playBtn setImage:[UIImage imageNamed:@"player-playbutton"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playbackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[_materialUrl lowercaseString] rangeOfString:@".mp4"].location == NSNotFound) {
        //片头图片保证旋转时刷新frame
        if (self.isFullscreen) {
            _materialView.center = _overlayView.center;
            _materialView.frame = _overlayView.frame;
            _materialView.backgroundColor = [UIColor clearColor];
            _materialView.transform = CGAffineTransformMakeScale(0.6, 0.6);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *img = [DWTools imageCompressForSize:_materialImg targetSize:_materialView.layer.preferredFrameSize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_materialView setImage:img];
                });
            });
        }
        else{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *img = [DWTools imageCompressForSize:_materialImg targetSize:self.adView.layer.preferredFrameSize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.adView.layer.contents = (id)img.CGImage;
                });
            });
        }
    }
    
    //暂停广告
    if ([_type isEqualToString:@"2"]) {
        if (!_isFullscreen) {
            _materialView.center = _overlayView.center;
            _materialView.frame = CGRectMake(0, 58, _overlayView.frame.size.width, _overlayView.frame.size.height - 122);
            closeBtn.frame = CGRectMake(_materialView.bounds.size.width - 30, 0, 30, 30);
            _materialView.backgroundColor = [UIColor clearColor];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *img = [DWTools imageCompressForSize:_materialImg targetSize:_materialView.layer.preferredFrameSize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_materialView setImage:img];
                });
            });
        }
        _materialView.userInteractionEnabled=YES;
        
        //暂停广告添加点击手势
       // NSString *clickUrl = [[_adInfo.ad objectAtIndex:_adNum] objectForKey:@"clickurl"];
        if (![_clickUrl isEqualToString:@""] && _adInfo.canClick) {
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailBtn:)];
            [_materialView addGestureRecognizer:singleTap];
        }
        
        [_overlayView addSubview:_materialView];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"close@3x"] forState:UIControlStateNormal];
        if (_isFullscreen) {
            closeBtn.frame = CGRectMake(_materialView.bounds.size.width - 45, 5, 40, 40);
        }
        [_materialView addSubview:closeBtn];
    }
    
    if ([_type isEqualToString:@"1"]) {
        //片头广告显示倒计时和了解详情
        [self.playerView addSubview:_adView];
        [_adView addSubview:_timeLabel];
        [_adView addSubview:detailBtn];
        if (self.isFullscreen) {
            [_adView setBackgroundColor:[UIColor clearColor]];
            [_adView addSubview:_materialView];
        }
        [_adView addSubview:_materialView];
       
        
        if (_adInfo.canSkip ){
            
        }
        else{
            //不显示关闭按钮时 倒计时框位置改变
            _timeLabel.frame = CGRectMake(_adView.bounds.size.width - 45, 20, 25, 25);
            closeBtn.hidden =YES;
        }
    }
    
    if ([_clickUrl isEqualToString:@""]) {
        //了解详情
        detailBtn.hidden =YES;
        
    }
    
    if (_adInfo.canClick && ![_clickUrl isEqualToString:@""]) {
        
        //可以点击广告画面进行跳转时
        UITapGestureRecognizer *TapGesture = [[UITapGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(detailBtn:)];
        [self.adView addGestureRecognizer:TapGesture];
    }

}

-(void)playAdmovie
{
    _materialUrl = [[_adInfo.ad objectAtIndex:_adNum] objectForKey:@"material"];
    _clickUrl = [[_adInfo.ad objectAtIndex:_adNum] objectForKey:@"clickurl"];
    
    _adPlay = YES;
    NSRange range;
    NSString *lowMateurl = [_materialUrl lowercaseString];
    range = [lowMateurl rangeOfString:@".mp4"];
    if (range.location == NSNotFound) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            _materialImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_materialUrl]]];
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                self.adView.layer.contents = (id)_materialImg.CGImage;
            });
        });
    }else{
        
       
        
        [self.playerView setURL:[NSURL URLWithString:_materialUrl] withCustomId:nil];
     
        [self.playerView play];
        
        
    }
}
-(void)detailBtn:(UIButton *)button
{//点击进入详情
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_clickUrl]];
}
-(void)closeBtn:(UIButton *)button
{
    if (!_isClose) return;
    
    //关闭广告按钮
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    _adPlay = NO;
    if ([_type isEqualToString:@"1"]) {
        [self.adView setHidden:YES];
        [self.overlayView setHidden:NO];
      
        [self loadPlayUrls];
    }
    else{
        [_materialView setHidden:YES];
    }
}
- (void)addcountdownTimer
{//广告倒计时
    _secondsCountDown = _adInfo.time;
 //跳过时间
    _skipTime = _adInfo.skiptime;
    _skipTime =0;
   
    //广告视图
    [self loadAdview];
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
    [self.overlayView setHidden:YES];
}

- (void)timeFireMethod
{
    _timeLabel.text = [NSString stringWithFormat:@"%lds",(long)_secondsCountDown];
    _secondsCountDown--;
    
    [self btnSkipTime];
    _skipTime --;
    
    if(_secondsCountDown==-1){
        [_countDownTimer invalidate];
        _countDownTimer = nil;
      //  [self.playerView resetPlayer];
        _adPlay = NO;
        [self loadPlayUrls];
        NSLog(@"计时器销毁");
        [self.adView setHidden:YES];
        [self.overlayView setHidden:NO];
    }
}


- (void)btnSkipTime{

   
    //是否可以跳过。1代表可以，0代表不可以
    if (_adInfo.canSkip ){
        
        if (_skipTime <= 0) {
            
            [closeBtn setTitle:@"关闭广告" forState:UIControlStateNormal];
            //  closeBtn.frame = CGRectMake(_adView.bounds.size.width - 80, 20, 70, 30);
            closeBtn.frame =CGRectMake(ScreenWidth-80, 20, 70, 30);
            
            _timeLabel.frame =CGRectMake(ScreenWidth - 117, 20, 30, 30);
            closeBtn.hidden =NO;
            _isClose =YES;
            
        }else if (_skipTime >0){
            
            [closeBtn setTitle:[NSString stringWithFormat:@"%lds后可关闭广告",_skipTime] forState:UIControlStateNormal];
            closeBtn.frame = CGRectMake(ScreenWidth - 130, 20, 120, 30);
            _timeLabel.frame =CGRectMake(ScreenWidth- 130-5-30, 20, 30, 30);
            
            
            
        }
        
        
    }
    
    
    
            
    



}
- (void)startRequestAdInfo
{
    _adInfo = [[DWAdInfo alloc]initWithUserId:DWACCOUNT_USERID andVideoId:self.videoId type:_type];
    [_adInfo start];
    
    if ([_type isEqualToString:@"2"]) {
        //暂停广告
        __weak DWCustomPlayerViewController *blockslf = self;
        _adInfo.finishBlock = ^(NSDictionary *response){
            _materialUrl = [[_adInfo.ad objectAtIndex:0] objectForKey:@"material"];
            _clickUrl = [[_adInfo.ad objectAtIndex:0] objectForKey:@"clickurl"];
            blockslf.materialImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:blockslf.materialUrl]]];
            [blockslf.materialView setHidden:NO];
            [blockslf loadAdview];
        };
    }
    
    
    if ([_type isEqualToString:@"1"]) {
        //片头广告
        __weak DWCustomPlayerViewController *blockself = self;
        _adInfo.finishBlock = ^(NSDictionary *response){
            [blockself addcountdownTimer];
            _adNum = 0;
            [blockself playAdmovie];
        };
    }
}

#pragma mark-----vrView-----
- (void)loadVRView{

    self.vrView =[[UIView alloc]initWithFrame:self.overlayView.frame];
    self.vrView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.8];
    [self.overlayView addSubview:self.vrView];
    
}


# pragma mark - headerView
- (void)loadHeaderView
{
    self.headerView = [[UIView alloc]init];
    
    self.headerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    
    [self.overlayView addSubview:self.headerView];
    logdebug(@"headerView frame: %@", NSStringFromCGRect(self.headerView.frame));
    
    // 返回按钮及视频标题
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //下载按钮
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //菜单按钮
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
}
# pragma mark 下载
-(void)loadDownloadButton
{
    CGRect frame = CGRectZero;
    frame.size.width = 40;
    frame.size.height = 40;
    frame.origin.x = self.headerView.frame.size.width - 50;
    frame.origin.y = self.backButton.frame.origin.y;
    self.downloadButton.frame = frame;
    
    self.downloadButton.backgroundColor = [UIColor clearColor];
    [self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.downloadButton setImage:[UIImage imageNamed:@"download_ic"] forState:UIControlStateNormal];
    [self.downloadButton addTarget:self action:@selector(downloadButtonAction:)
              forControlEvents:UIControlEventTouchUpInside];
    self.downloadButton.showsTouchWhenHighlighted = YES;
    [self.overlayView addSubview:self.downloadButton];
}
-(void)downloadButtonAction:(UIButton *)button
{

 
 //下载
       // 获取下载地址
        DWPlayInfo *playinfo = [[DWPlayInfo alloc] initWithUserId:DWACCOUNT_USERID andVideoId:self.videoId key:DWACCOUNT_APIKEY hlsSupport:@"0"];
        
        playinfo.mediatype =@"1";
        //网络请求超时时间
        playinfo.timeoutSeconds =20;
        playinfo.errorBlock = ^(NSError *error){
            
            
        };
        
        playinfo.finishBlock = ^(NSDictionary *response){
            
            NSDictionary *playUrls =[DWUtils parsePlayInfoResponse:response];
            
            if (!playUrls) {
                //说明 网络资源暂时不可用
            }
            
           //获取PlayInfo 配对url 推送offlineview
            NSArray *videos = [playUrls valueForKey:@"definitions"];
            
            //注意 自己根据数据处理
            NSDictionary *videoInfo = videos[0];
            
            //字典转模型
            DWOfflineModel *model =[[DWOfflineModel alloc]init];
            model.definition =[videoInfo objectForKey:@"definition"];
            model.desp =[videoInfo objectForKey:@"desp"];
            model.playurl =[videoInfo objectForKey:@"playurl"];
            model.videoId =self.videoId;
            model.token =[playUrls objectForKey:@"token"];
 
            //路径
            // 开始下载
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            
            
            /* 注意：
             若你所下载的 videoId 未启用视频加密功能，则保存的文件扩展名[必须]是 mp4，否则无法播放。
             若你所下载的 videoId 启用了视频加密功能，则保存的文件扩展名[必须]是 pcm，否则无法播放。
             */
            
            NSString *type;
            if ([model.playurl containsString:@"mp4?"]) {
                
                type =@"mp4";
            }else if([model.playurl containsString:@"pcm?"]){
                
                type =@"pcm";
            }
            
            NSString *videoPath;
            if (!model.definition) {
                
                videoPath = [NSString stringWithFormat:@"%@/%@.%@", documentDirectory, model.videoId,type];
            } else {
                
                videoPath = [NSString stringWithFormat:@"%@/%@-%@.%@", documentDirectory, model.videoId, model.definition,type];
            }
            
            model.videoPath =videoPath;
            DWDownloadViewController *viewCtrl =[DWDownloadViewController sharedInstance];
          //  DWDownloadViewController *viewCtrl =[[DWDownloadViewController alloc]init];
            BOOL repeat =[self cleanRepeatModel:model];
            if (repeat){
                
                [self loadTipLabelview:NO];
                self.tipLabel.text = @"该视频已经下载";
                
                
                return;
            }
            
            [viewCtrl startDownloadWith:model videoPath:model.videoPath isBegin:YES];
            
            
        };
        [playinfo start];
        
}





- (BOOL )cleanRepeatModel:(DWOfflineModel *)model{
    
    
    
    _isRepeat =NO;
    
    NSMutableArray *downingArray =[[[NSUserDefaults standardUserDefaults] objectForKey:@"downingArray"] mutableCopy];
    NSMutableArray *finishDicArray =[[[NSUserDefaults standardUserDefaults] objectForKey:@"finishDicArray"] mutableCopy];
    
    //先看完成的数组里有没有 再看正在下载的
    [finishDicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *str1 =[NSString stringWithFormat:@"%@",[obj objectForKey:@"videoId"]];
        NSString *str2 =[NSString stringWithFormat:@"%@",[obj objectForKey:@"definition"]];
        
        NSString *str3 =[NSString stringWithFormat:@"%@",model.videoId];
        NSString *str4 =[NSString stringWithFormat:@"%@",model.definition];
        
        
        if ([str1 isEqualToString:str3] && [str2 isEqualToString:str4] ){
            
            _isRepeat =YES;
        }
        
        
    }];
    
    if (_isRepeat) return _isRepeat;
    
    [downingArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *str1 =[NSString stringWithFormat:@"%@",[obj objectForKey:@"videoId"]];
        NSString *str2 =[NSString stringWithFormat:@"%@",[obj objectForKey:@"definition"]];
        
        NSString *str3 =[NSString stringWithFormat:@"%@",model.videoId];
        NSString *str4 =[NSString stringWithFormat:@"%@",model.definition];
        
        if ([str1 isEqualToString:str3] && [str2 isEqualToString:str4]){
            
            _isRepeat =YES;
            
        }
        
        
    }];
    
    
    
    return _isRepeat;
    
}

# pragma mark 菜单 ...
-(void)loadMenuButton
{
    CGRect frame = CGRectZero;
    frame.size.width = 40;
    frame.size.height = 40;
    frame.origin.x = self.headerView.frame.size.width - 100;
    frame.origin.y = self.backButton.frame.origin.y;
    self.menuButton.frame = frame;
    
    self.menuButton.backgroundColor = [UIColor clearColor];
    [self.menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.menuButton setImage:[UIImage imageNamed:@"more_ic"] forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(menuButtonAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.menuButton];
    self.menuButton.hidden = self.backButton.hidden;
    
}
-(void)menuButtonAction:(UIButton *)button
{
    CGRect frame = CGRectZero;
    frame.origin.x = self.overlayView.frame.size.width * 1 / 2;
    frame.origin.y = 0;
    frame.size.width = self.overlayView.frame.size.width / 2;
    frame.size.height = self.overlayView.frame.size.height;
    self.menuView = [[UIView alloc]initWithFrame:frame];
    self.menuView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
    [self.overlayView addSubview:self.menuView];
    
    self.restView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.overlayView.frame.size.width * 1 / 2, self.overlayView.frame.size.height)];
    self.restView.backgroundColor = [UIColor clearColor];
    [self.overlayView addSubview:self.restView];
    self.restviewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRestviewTap:)];
    self.restviewTap.numberOfTapsRequired = 1;
    self.restviewTap.delegate = self;
    [self.restView addGestureRecognizer:self.restviewTap];

    [self hiddenAllView];
    [self loadSubtitleView];
    [self loadScreenSizeView];
    [self.overlayView removeGestureRecognizer:self.signelTap];
}
-(void)handleRestviewTap:(UIGestureRecognizer*)gestureRecognizer{
    [self.restView removeFromSuperview];
    [self.menuView removeFromSuperview];
    [self showBasicViews];
    [self.overlayView addGestureRecognizer:self.signelTap];

}

# pragma mark 返回按钮及视频标题
- (void)loadBackButton
{
    CGRect frame;
    frame.origin.x = 16;
    frame.origin.y = self.headerView.frame.origin.y + 4;
    frame.size.width = 100;
    frame.size.height = 30;
    self.backButton.frame = frame;
    
    self.backButton.backgroundColor = [UIColor clearColor];
    [self.backButton setTitle:@"  视频标题" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"player-back-button"] forState:UIControlStateNormal];
    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.backButton addTarget:self action:@selector(backButtonAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.backButton];
}

- (void)backButtonAction:(UIButton *)button
{
    if (self.isFullscreen == YES) {
        self.menuView.hidden =YES;
        [self SmallScreenFrameChanges];
        self.isFullscreen = NO;
    }else{
        
        logdebug(@"stop movie");
        
        if (!_adPlay) {
            [self saveNsUserDefaults];
        }
        
        /**
         停止视频播放统计 播放页面关闭时务必调用removeTimer方法
         注意：播放页面关闭时 如需释放资源 调用方式如下{
                                                [playerView removeTimer];
                                                [playerView resetPlayer];
         
         }
         
         
         如无需释放播放资源 调用方式如下{
                                    [playerView removeTimer];
                                    [playerView pause];
         
         }
         */
     //  [self.playerView removeTimer];
     //  [self.playerView pause];
      
        [self.playerView removeTimer];
        [self.playerView resetPlayer];
        
        self.secondsCountDown = -1;
        
       //移除通知及观察者
       [self removeAllObserver];
        
       [self.navigationController popViewControllerAnimated:YES];
        
        
        
    }
}

# pragma mark 字幕
-(void)loadSubtitleView
{
    CGRect frame = CGRectZero;
    frame.origin.x = 30;
    frame.origin.y = 30;
    frame.size.width = 50;
    frame.size.height = 30;
    self.subtitleLabel = [[UILabel alloc]initWithFrame:frame];
    self.subtitleLabel.text = @"字幕:";
    self.subtitleLabel.font = [UIFont systemFontOfSize:14];
    self.subtitleLabel.textColor = [UIColor whiteColor];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.menuView addSubview:self.subtitleLabel];
    
    frame.origin.x = self.subtitleLabel.frame.origin.x + 50 + 50;
    self.subtitelSwitch = [[UISwitch alloc]initWithFrame:frame];
    if (self.movieSubtitleLabel) {
        [self.subtitelSwitch setOn:!self.movieSubtitleLabel.hidden];
    }
    [self.subtitelSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.menuView addSubview:self.subtitelSwitch];
    [self.subtitelSwitch setOnTintColor:[UIColor orangeColor]];
    [self.subtitelSwitch setThumbTintColor:[UIColor whiteColor]];
    [self.subtitelSwitch setTintColor:[UIColor grayColor]];
    
}
-(void)switchChanged:(UISwitch *)subtitelSwitch
{
    if (self.subtitelSwitch.on == YES) {
        if (!self.movieSubtitleLabel) {
            [self loadMovieSubtitle];
        }
        self.movieSubtitleLabel.hidden = NO;
    }
    else{
        self.movieSubtitleLabel.hidden = YES;
    }
}
- (BOOL)loadMovieSubtitle
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"example.utf8" ofType:@"srt"];
//    self.mediaSubtitle = [[DWMediaSubtitle alloc] initWithSRTPath:path];
//    if (![self.mediaSubtitle parse]) {
//        loginfo(@"path parse failed: %@", [self.mediaSubtitle.error localizedDescription]);
//        return NO;
//    }
    
    //字幕
    self.subtitleDic =[self.playUrls objectForKey:@"subtitleDic"];
    if (self.subtitleDic) {
        
    self.subtitleModel =[DWSubtitleModel mj_objectWithKeyValues:self.subtitleDic];
    self.mediaSubtitle =[[DWMediaSubtitle alloc]init];
    [self.mediaSubtitle requestSTRURL:[NSURL URLWithString:self.subtitleModel.url] didComplete:^(NSError *error, NSMutableDictionary *dictionary) {
        
            
      dispatch_async(dispatch_get_main_queue(), ^{
               
        if (!error) {
                    
                self.movieSubtitleLabel =[[UILabel alloc]init];
                NSArray *fontsArray =[UIFont familyNames];
                if ([fontsArray containsObject:self.subtitleModel.font]) {

                 self.movieSubtitleLabel.font = [UIFont fontWithName:self.subtitleModel.font size:self.subtitleModel.size/2];

               }else{
            
                self.movieSubtitleLabel.font = [UIFont systemFontOfSize:self.subtitleModel.size/2];
               }
                self.movieSubtitleLabel.textAlignment = NSTextAlignmentCenter;
                self.movieSubtitleLabel.numberOfLines =0;
                self.movieSubtitleLabel.textColor = [DWTools colorWithHexString:self.subtitleModel.color];
               self.movieSubtitleLabel.shadowColor =[DWTools colorWithHexString:self.subtitleModel.surroundColor];
              self.movieSubtitleLabel.shadowOffset =CGSizeMake(1, -1);
              //  self.movieSubtitleLabel.backgroundColor = [UIColor clearColor];
                [self.overlayView addSubview:self.movieSubtitleLabel];
                
            }else{
                
                NSLog(@"%@",error.localizedDescription);
            }
          
                
        });
            
        }];

}
 
    
    return YES;
}

#pragma mark 画面尺寸
-(void)loadScreenSizeView
{
    CGRect frame = CGRectZero;
    frame.origin.x = 10;
    frame.origin.y = 80;
    frame.size.width = 70;
    frame.size.height = 30;
    self.screenSizeLabel = [[UILabel alloc]initWithFrame:frame];
    self.screenSizeLabel.text =@"画面尺寸:";
    self.screenSizeLabel.font = [UIFont systemFontOfSize:14];
    self.screenSizeLabel.textColor = [UIColor whiteColor];
    self.screenSizeLabel.textAlignment = NSTextAlignmentCenter;
    [self.menuView addSubview:self.screenSizeLabel];
    
    frame.origin.x = self.screenSizeLabel.frame.origin.x + 70;
    self.screenSizeFull = [[UIButton alloc]initWithFrame:frame];
    [self.screenSizeFull setTitle:@"满屏" forState:UIControlStateNormal];
    self.screenSizeFull.titleLabel.font = [UIFont systemFontOfSize:14];
    self.screenSizeFull.tag = 100;
    if ([_signArray[_screenSizeFull.tag-100] isEqualToString:@"1"]) {
        [self.screenSizeFull setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }else{
        [self.screenSizeFull setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [self.screenSizeFull addTarget:self action:@selector(screenSizeChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:self.screenSizeFull];
    
    frame.origin.x = self.screenSizeFull.frame.origin.x + 50;
    self.screenSize100 = [[UIButton alloc]initWithFrame:frame];
    [self.screenSize100 setTitle:@"100%" forState:UIControlStateNormal];
    self.screenSize100.titleLabel.font = [UIFont systemFontOfSize:14];
    self.screenSize100.tag = 101;
    if ([_signArray[_screenSize100.tag-100] isEqualToString:@"1"]) {
        [self.screenSize100 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }else{
        [self.screenSize100 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [self.screenSize100 addTarget:self action:@selector(screenSizeChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:self.screenSize100];
    
    frame.origin.x = self.screenSize100.frame.origin.x + 50;
    self.screenSize75 = [[UIButton alloc]initWithFrame:frame];
    [self.screenSize75 setTitle:@"75%" forState:UIControlStateNormal];
    self.screenSize75.titleLabel.font = [UIFont systemFontOfSize:14];
    self.screenSize75.tag = 102;
    if ([_signArray[_screenSize75.tag-100] isEqualToString:@"1"]) {
        [self.screenSize75 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }else{
        [self.screenSize75 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [self.screenSize75 addTarget:self action:@selector(screenSizeChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:self.screenSize75];
    
    frame.origin.x = self.screenSize75.frame.origin.x + 50;
    self.screenSize50 = [[UIButton alloc]initWithFrame:frame];
    [self.screenSize50 setTitle:@"50%" forState:UIControlStateNormal];
    self.screenSize50.titleLabel.font = [UIFont systemFontOfSize:14];
    self.screenSize50.tag = 103;
    if ([_signArray[_screenSize50.tag-100] isEqualToString:@"1"]) {
        [self.screenSize50 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }else{
        [self.screenSize50 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [self.screenSize50 addTarget:self action:@selector(screenSizeChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:self.screenSize50];

}
-(void)screenSizeChange:(UIButton *)btn
{
    for (int i=0; i<4; i++) {
        if (i==btn.tag-100) {
            _signArray[btn.tag - 100] = @"1";
        }else{
            _signArray[i] = @"0";
        }
    }
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    if (btn.tag == 100) {
        [self switchScreenSizeMode:DWPlayerScreenSizeModeFill];
        [self.screenSize50 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.screenSize75 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.screenSize100 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (btn.tag == 101) {
        [self switchScreenSizeMode:DWPlayerScreenSizeMode100];
        [self.screenSizeFull setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.screenSize75 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.screenSize50 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    if (btn.tag == 102) {
        [self switchScreenSizeMode:DWPlayerScreenSizeMode75];
        [self.screenSize50 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.screenSize100 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.screenSizeFull setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    if (btn.tag == 103) {
        [self switchScreenSizeMode:DWPlayerScreenSizeMode50];
        [self.screenSize100 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.screenSize75 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.screenSizeFull setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
- (void)switchScreenSizeMode:(DWPLayerScreenSizeMode)screenSizeMode
{
    
    switch (screenSizeMode) {
        case DWPlayerScreenSizeModeFill:
            
           
            
            if (_vrmode ==1 && _isFullscreen) {
                
                self.vrView.frame =self.videoBackgroundView.bounds;
            }else{
            
                self.playerView.frame = self.videoBackgroundView.bounds;
            }
            

            break;

        case DWPlayerScreenSizeMode100:
           
            
            if (_vrmode ==1 && _isFullscreen) {
                
                self.vrView.frame =self.videoBackgroundView.bounds;
            }else{
                
                self.playerView.frame = self.videoBackgroundView.bounds;
            }
          
            break;

        case DWPlayerScreenSizeMode75:
          
            
            if (_vrmode ==1 && _isFullscreen) {
                
                self.vrView.frame =[self getScreentSizeWithRefrenceFrame:self.videoBackgroundView.bounds andScaling:0.75f];
                
            }else{
                
                self.playerView.frame = [self getScreentSizeWithRefrenceFrame:self.videoBackgroundView.bounds andScaling:0.75f];
            }

          
            
            
            
            break;

        case DWPlayerScreenSizeMode50:
            
            
            if (_vrmode ==1 && _isFullscreen) {
                
                self.vrView.frame =[self getScreentSizeWithRefrenceFrame:self.videoBackgroundView.bounds andScaling:0.5f];
                
            }else{
                
               self.playerView.frame = [self getScreentSizeWithRefrenceFrame:self.videoBackgroundView.bounds andScaling:0.5f];
            }
           

           
            break;
            
        default:
            break;
    }
}
- (CGRect)getScreentSizeWithRefrenceFrame:(CGRect)frame andScaling:(float)scaling
{
    if (scaling == 1) {
        return frame;
    }
    
    NSInteger n = 1/(1 - scaling);
    frame.origin.x += roundf(frame.size.width/n/2);
    frame.origin.y += roundf(frame.size.height/n/2);
    frame.size.width -= roundf(frame.size.width/n);
    frame.size.height -= roundf(frame.size.height/n);
    
    return frame;
}
# pragma mark - footerView

- (void)loadFooterView
{
    self.footerView = [[UIView alloc]init];
    self.footerView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2];
    [self.overlayView addSubview:self.footerView];
    logdebug(@"footerView: %@", NSStringFromCGRect(self.footerView.frame));

    // 播放按钮
    self.playbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 当前播放时间
    self.currentPlaybackTimeLabel = [[UILabel alloc] init];

    // 画面尺寸
    self.screenSizeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    // 视频总时间
    self.durationLabel = [[UILabel alloc] init];

    // 时间滑动条
    self.durationSlider = [[UISlider alloc] init];
    [self durationSlidersetting];
    
    //切换屏幕按钮
    self.switchScrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //倍速按钮
    self.playbackrateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //清晰度按钮
    self.qualityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //选集按钮
    self.selectvideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
   
    //这样的代码 真是非我所愿
    self.vrInteractiveBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    self.vrDisplayBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    
}
# pragma mark 屏幕翻转
-(void)loadSwitchScrBtn
{
    CGRect frame;
    if (_isFullscreen == NO) {
        frame.origin.x = self.footerView.frame.size.width - 35;
        frame.origin.y = self.footerView.frame.origin.y;
        frame.size.width = 38;
        frame.size.height = 38;
    }
    else{
        frame.origin.x = self.footerView.frame.size.width - 35;
        frame.origin.y = self.footerView.frame.origin.y;
        frame.size.width = 40;
        frame.size.height = 40;
    }
    
    
    self.switchScrBtn.frame = frame;
    self.switchScrBtn.backgroundColor = [UIColor clearColor];
    self.switchScrBtn.showsTouchWhenHighlighted = YES;
    [self.switchScrBtn setImage:[UIImage imageNamed:@"fullscreen.png"] forState:UIControlStateNormal];
    [self.switchScrBtn setImage:[UIImage imageNamed:@"nonfullscreen.png"] forState:UIControlStateSelected];
    [self.switchScrBtn addTarget:self action:@selector(switchScreenAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.switchScrBtn];
    logdebug(@"self.switchScrBtn.frame: %@", NSStringFromCGRect(self.switchScrBtn.frame));
   
}



-(void)switchScreenAction:(UIButton *)button
{
    self.switchScrBtn.selected = !self.switchScrBtn.selected;
    
    if (self.switchScrBtn.selected == YES) {
        
        
        [self FullScreenFrameChanges];
        if (_adPlay && _playMode) {
            [self loadAdview];
        }

        self.isFullscreen = YES;
        
    }
    else{
        [self SmallScreenFrameChanges];
        if (_adPlay && _playMode) {
            [self loadAdview];
        }
        self.isFullscreen = NO;
       
    }
}

-(void)SmallScreenFrameChanges{
    self.isFullscreen = NO;
    
    if (self.audioPlayer.isAudioPlaying) {
        
        return;
    }
    
//    [self.videoBackgroundView removeFromSuperview];
//    [self.playerView removeFromSuperview];
//    [self.vrView removeFromSuperview];
//    [self.overlayView removeFromSuperview];
//   
//    [self.menuView removeFromSuperview];
//    [self.restView removeFromSuperview];
//    [self.lockButton removeFromSuperview];
//    [self.BigPauseButton removeFromSuperview];
     [self.movieSubtitleLabel removeFromSuperview];
    
    self.view.transform = CGAffineTransformIdentity;
    self.videoBackgroundView.transform =CGAffineTransformIdentity;
    self.overlayView.transform =CGAffineTransformIdentity;
    
    if ([self.playerView.mediatype isEqualToString:@"0"]) {
        
        self.bottomView.hidden =NO;
    }
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    
    BOOL haveMotion;
    if (_interative ==DWModeInteractiveMotion || _interative ==DWModeInteractiveMotionWithTouch) {
        
        haveMotion =YES;
    }
    
    if (_vrmode ==1 && haveMotion) {
        
        [self.vrLibrary switchInteractiveMode:DWModeInteractiveTouch];
        [self.vrLibrary switchInteractiveMode:DWModeInteractiveMotion];
    }
    
    [self.vrLibrary switchInteractiveMode:_interative];
    
    
    CGRect frame = self.view.frame;
    
    self.overlayView.backgroundColor = [UIColor clearColor];
    self.overlayView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height/2-50);
    
    [self.view addSubview:self.overlayView];
    
    self.videoBackgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height/2-50);
    self.videoBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self.view addSubview:self.videoBackgroundView];
    
    //VR视图 只是为了解决以往问题而添加 根据项目需求自己处理
    self.vrView.frame =self.videoBackgroundView.frame;
    [self.overlayView addSubview:self.vrView];

    self.playerView.backgroundColor = [UIColor clearColor];
    self.playerView.frame = CGRectMake(0, 0, frame.size.width,frame.size.height/2-50);
    [self.videoBackgroundView addSubview:self.playerView];
    [self.view bringSubviewToFront:self.overlayView];
    
    
    self.headerView.frame = CGRectMake(0, 0, self.overlayView.frame.size.width, 38);
    self.footerView.frame = CGRectMake(0, self.overlayView.frame.size.height - 38, self.overlayView.frame.size.width, 38);
    self.switchScrBtn.selected = NO;
    [self volumeView];
    [self headerViewframe];
    [self footerViewframe];
    [self loadVideoStatusLabel];
    if (self.subtitelSwitch.on == YES) {
        [self loadMovieSubtitle];
    }
    if (_pausebuttonClick) {
        [self loadBigPauseButton];
    }
    [self showBasicViews];
    self.hiddenDelaySeconds = 10;
    
    //根据自身视图情况 处理
    CGSize size =CGSizeMake(ScreenHeight, ScreenWidth);
    for (UIView *view in self.overlayView.subviews) {
        
        
        
        if (CGSizeEqualToSize(size, view.frame.size)) {
            
            
            view.frame =self.overlayView.frame;
            
        }
        
    }
    //取消GIF
    [self gifCancelAction];
    [self.gifCancelBtn removeFromSuperview];
    [self.gifBtn removeFromSuperview];
    [self.gifView removeFromSuperview];
    [self.toastView removeFromSuperview];
    
    //移除打点
    for (UIView *view in self.durationSlider.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            [view removeFromSuperview];
        }
        
    }
    
    for (UIGestureRecognizer *gestureRecognizers in self.durationSlider.gestureRecognizers) {
        
        if ([gestureRecognizers isKindOfClass:[UITapGestureRecognizer class]]) {
            
            [self.durationSlider removeGestureRecognizer:gestureRecognizers];

        }
        
        
    }
    
    self.markView.hidden =YES;
    self.arrowImageView.hidden =YES;
    
    [self updateQuestionViewAndFeedBackView];
    
}
- (void)updateQuestionViewAndFeedBackView{
    
    
    if (_questionView) {
        _questionView.frame =CGRectMake((ScreenWidth-300)/2, (ScreenHeight-620/2)/2,300, 620/2);
        [self.view bringSubviewToFront:_questionView];
        
    }
    
    if (_feedBackView) {
        
        _feedBackView.frame =CGRectMake(0,0,ScreenWidth,ScreenHeight);
        [self.view bringSubviewToFront:_feedBackView];
    }
    
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self FullScreenFrameChanges];
    if (_adPlay && _playMode) {
        [self loadAdview];
    }
}

-(void)FullScreenFrameChanges{
    self.isFullscreen = YES;
    
//    [self.videoBackgroundView removeFromSuperview];
//    [self.playerView removeFromSuperview];
//    [self.BigPauseButton removeFromSuperview];
   [self.movieSubtitleLabel removeFromSuperview];
//    [self.vrView removeFromSuperview];
//    [self.overlayView removeFromSuperview];
    
    self.bottomView.hidden =YES;
    
    self.view.transform = CGAffineTransformIdentity;
    self.videoBackgroundView.transform =CGAffineTransformIdentity;
    self.overlayView.transform = CGAffineTransformIdentity;
    self.vrView.transform =CGAffineTransformIdentity;
    
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    
    //此种方法组合可以实现Motion下的正确方向
    BOOL haveMotion;
    if (_interative ==DWModeInteractiveMotion || _interative ==DWModeInteractiveMotionWithTouch) {
        
        haveMotion =YES;
    }
    
    if (_vrmode ==1 && haveMotion) {
        
        [self.vrLibrary switchInteractiveMode:DWModeInteractiveTouch];
        [self.vrLibrary switchInteractiveMode:DWModeInteractiveMotion];
    }
    
   [self.vrLibrary switchInteractiveMode:_interative];
    
   
    
    CGFloat max = MAX(self.view.frame.size.width, self.view.frame.size.height);
    CGFloat min = MIN(self.view.frame.size.width, self.view.frame.size.height);
    self.overlayView.backgroundColor = [UIColor clearColor];
    self.overlayView.frame = CGRectMake(0, 0, max, min);
  //  [self.view addSubview:self.overlayView];
    
    self.videoBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    self.videoBackgroundView.frame = CGRectMake(0, 0, max, min);
  //  [self.view addSubview:self.videoBackgroundView];
    

    self.playerView.backgroundColor = [UIColor clearColor];
    self.playerView.frame = CGRectMake(0, 0, max, min);
  //  [self.videoBackgroundView addSubview:self.playerView];
    
    self.vrView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.8];
    self.vrView.frame =CGRectMake(0, 0, max, min);
   // [self.overlayView addSubview:self.vrView];
    
    self.headerView.frame = CGRectMake(0, 0, self.overlayView.frame.size.width, 38);
    self.footerView.frame = CGRectMake(0, self.overlayView.frame.size.height - 60, self.overlayView.frame.size.width, 60);
    self.switchScrBtn.selected = YES;
    [self volumeView];
    [self headerViewframe];
    [self footerViewframe];
    [self loadLockButton];
    [self loadVideoStatusLabel];
    if (_pausebuttonClick) {
        [self loadBigPauseButton];
    }
    if (self.subtitelSwitch.on == YES) {
        [self loadMovieSubtitle];
    }
    [self.view bringSubviewToFront:self.overlayView];
    [self showBasicViews];
    self.hiddenDelaySeconds = 10;
    
    if (_vrmode ==1) {
        
        [self loadVoiceButton];
        
    }
    
    //创建GIF按钮 GIF取消按钮
    self.gifBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.gifBtn setImage:[UIImage imageNamed:@"GIF_nor"] forState:UIControlStateNormal];
    [self.gifBtn setImage:[UIImage imageNamed:@"stop_nor"] forState:UIControlStateSelected];
    [self.gifBtn setImage:[UIImage imageNamed:@"stop_ban"] forState:UIControlStateDisabled];
    self.gifBtn.frame =CGRectMake(CGRectGetMinX(self.lockButton.frame), CGRectGetMaxY(self.lockButton.frame)+10, 40, 40);
    self.gifBtn.layer.cornerRadius =20;
    self.gifBtn.layer.masksToBounds =YES;
    [self.gifBtn addTarget:self action:@selector(gifAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.gifBtn];
    
    
    self.gifCancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.gifCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.gifCancelBtn.titleLabel.font =[UIFont systemFontOfSize:15];
    self.gifCancelBtn.frame =CGRectMake(ScreenWidth-70,60, 60, 30);
    self.gifCancelBtn.layer.cornerRadius =15;
    self.gifCancelBtn.layer.masksToBounds =YES;
    [self.gifCancelBtn addTarget:self action:@selector(gifCancelAction) forControlEvents:UIControlEventTouchUpInside];
    self.gifCancelBtn.backgroundColor =[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75];
    self.gifCancelBtn.hidden =YES;
    [self.overlayView addSubview:self.gifCancelBtn];
    
    
    self.gifView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,0,viewHeight)];
    [self.overlayView addSubview:self.gifView];
    
    _toastView =[[DWToastView alloc]initWithFrame:CGRectMake((ScreenWidth-250)/2, 60, 250,30)];
    _toastView.hidden =YES;
    [self.overlayView addSubview:_toastView];
    
    if (self.videomarkArray.count) {
        
        //添加tap手势 用于打点功能
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOfVideoMarkAction:)];
        
        [self.durationSlider addGestureRecognizer:tap];
    }
    
    
    [self.markButtonArray removeAllObjects];
    //打点功能
    for (DWVideoMarkModel *markModel in self.videomarkArray) {
        //视频总时长
        CGFloat duration =CMTimeGetSeconds([self.playerView.player.currentItem duration]);
        CGFloat sliderWidth =CGRectGetWidth(self.durationSlider.frame);
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        
        NSNumber *number =[NSNumber numberWithFloat:markModel.marktime/duration*sliderWidth];
        button.frame =CGRectMake([number integerValue],(30-2)/2,5,2);
        button.layer.cornerRadius =1;
        button.layer.masksToBounds =YES;
        button.backgroundColor =[DWTools colorWithHexString:@"#ffffff"];
        [self.durationSlider addSubview:button];
        [self.markButtonArray addObject:button];
        
    }
    
    [self updateQuestionViewAndFeedBackView];
   
}

//markView的tap方法
- (void)markViewTapAction:(UITapGestureRecognizer *)tap{
    
    self.markView.hidden =YES;
    self.arrowImageView.hidden =YES;
    [self.playerView scrub:_markScrubtime];
    
}

- (void)tapOfVideoMarkAction:(UITapGestureRecognizer *)tap{
    
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider  =(UISlider *)tap.view;
        CGPoint point =[tap locationInView:slider];
        
        CGFloat tapValue =point.x / slider.frame.size.width;
        //视频总时长
        CGFloat duration =CMTimeGetSeconds([self.playerView.player.currentItem duration]);
        [self showVideoMarkCurrentValue:tapValue videoDuration:duration isTap:YES];
        
    }
    
}

- (void)showVideoMarkCurrentValue:(CGFloat )currentValue videoDuration:(CGFloat )duration isTap:(BOOL )isTap{
    
    NSNumber *number =[NSNumber numberWithFloat:currentValue*duration];
    NSInteger integer =[number integerValue];
    
    [self.videomarkArray enumerateObjectsUsingBlock:^(DWVideoMarkModel *markModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //根据打点时间设置取值范围
        if (integer >= markModel.marktime -4 && integer <= markModel.marktime+4) {
            
            *stop =YES;
            self.markView.markModel =markModel;
            CGFloat width =self.markView.width;
            
            UIButton *button =self.markButtonArray[idx];
            CGRect frame =[button convertRect:button.bounds toView:self.overlayView];
            
            self.markView.frame =CGRectMake(frame.origin.x+2.5 - width/2, ScreenHeight-77/2-50,width,30);
            self.arrowImageView.frame =CGRectMake(frame.origin.x+2.5 -17/2, CGRectGetMaxY(self.markView.frame), 34/2, 15/2);
            
            self.markView.hidden =NO;
            self.arrowImageView.hidden =NO;
            
            self.markScrubtime =markModel.marktime;
        }
        
    }];
    
}

#pragma mark--GIF相关------
- (void)gifAction:(UIButton *)sender{
    
   //截取视频的默认时长 15s
    _gifTotalTime =15;

    //获取视频总时长
   NSInteger durSec = [[NSNumber numberWithFloat:CMTimeGetSeconds(self.playerView.player.currentItem.duration)] integerValue];
    //加密调用drmGIFURL 非加密调用unDrmGIFURL
    _videoURL =[self.playerView drmGIFURL];
    
    _isFirstClick =!_isFirstClick;
    
    if (_isFirstClick) {
        
        //获取点击时的时间
        _gifStartTime =[[NSNumber numberWithFloat:CMTimeGetSeconds([self.playerView.player currentTime])] integerValue];
      
        
    }else{
      //第二次点击
        NSInteger clickTime =[[NSNumber numberWithFloat:CMTimeGetSeconds([self.playerView.player currentTime])] integerValue];
        
        _gifTotalTime =clickTime - _gifStartTime;
    }
    
    
    if (_gifStartTime +3 >= durSec) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"时间少于三秒"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        
        return;
        
    }
    
    self.gifBtn.enabled =NO;
    self.gifCancelBtn.hidden =NO;
     _isGIF =YES;
   
    [self hiddenAllView];
    
    [self getRealtimeWithVideoTime:durSec];
    
    
   if (!_gifTimer) {
        
        _gifTimer =[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(gifTimerAction) userInfo:nil repeats:YES];
    }
    
    
    //传值的字典
    _gifDictionary =@{@"gifStartTime": [NSString stringWithFormat:@"%ld",_gifStartTime],
                      @"gifTotalTime": [NSString stringWithFormat:@"%ld",_gifTotalTime],
                      @"videoURL":_videoURL
                      };

    
    
    if (_clipTime > 3) {
        
       [self gifCancelAction];
       [self turnGIFViewController];
        
    }
    
}



//取消GIF
- (void)gifCancelAction{

    if (_gifTimer) {
        
        [_gifTimer invalidate];
        _gifTimer =nil;
        
    }
 
    
    _isGIF =NO;
    _gifView.hidden =YES;
    _toastView.hidden =YES;
    [_toastView recoverTextAndColor];
    _clipTime =0;
    _gifTotalTime =0;
    _gifStartTime =0;

    _isFirstClick =NO;
    _gifBtn.selected =NO;
    _gifBtn.enabled =YES;
    _gifCancelBtn.hidden =YES;
    
    
}



- (void)gifTimerAction{
    
    _clipTime +=seconds;
    _gifView.hidden =NO;
    _gifView.frame =CGRectMake(0, 0,ScreenWidth/_gifTotalTime*_clipTime,viewHeight);
    _toastView.hidden =NO;
    // 大于3秒 制作GIF
    if (_clipTime > 3) {
        
        self.gifBtn.enabled =YES;
        self.gifBtn.selected =YES;
        _gifView.backgroundColor =[UIColor greenColor];
        [_toastView changeTextAndColor];
        
        
       
    }else{
        
        _gifView.backgroundColor =[UIColor orangeColor];
        
        
    }
    
    NSInteger clipTime =[[NSNumber numberWithFloat:_clipTime] integerValue];
    if (clipTime   >= _gifTotalTime) {
        
        [self gifCancelAction];
        [self turnGIFViewController];
       
    }
    NSInteger sec = [[NSNumber numberWithFloat:CMTimeGetSeconds(self.playerView.player.currentItem.duration)] integerValue];
    
    
}


//计算截取视频的真实时间
- (void)getRealtimeWithVideoTime:(NSInteger )time{
    
    if (_gifStartTime + _gifTotalTime >= time) {
        
        _gifTotalTime =time - _gifStartTime;
        
    }
    
    
}



- (void)turnGIFViewController{
    
    if (self.playerView.playing) {
        
        [self.playerView pause];
        
    }
  
    _gifBtn.enabled =YES;
    _gifBtn.selected =NO;
    
    
    DWGIFViewController *gifViewCtrl =[[DWGIFViewController alloc]init];
    gifViewCtrl.gifDictionary = _gifDictionary;
    [self.navigationController pushViewController:gifViewCtrl animated:NO];
    
}


-(void)footerViewframe
{
    [self loadPlaybackButton];
    [self loadCurrentPlaybackTimeLabel];
    [self loadPlaybackSlider];
    [self loadDurationLabel];
    [self loadSwitchScrBtn];
    if (self.isFullscreen == YES) {
        [self loadLastButton];
        [self loadNextButton];
        [self loadQualityView];
        [self loadPlaybackRateButton];
        [self loadSelectvideoButton];
      
       
        
    }
    
    if (_vrmode ==1) {
        
        [self loadVRButton];
    }
    
}



-(void)headerViewframe
{
    [self loadBackButton];
    [self loadDownloadButton];
    [self loadMenuButton];
}
//隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}
/**
 *  旋转屏幕通知
 */

- (void)onDeviceOrientationChange{
    if (self.playerView ==nil){
        return;
    }
    
   

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationUnknown:{
            NSLog(@"旋转方向未知");
            [self SmallScreenFrameChanges];
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            
            
            
            [self SmallScreenFrameChanges];
            if (_adPlay && _playMode) {
                [self loadAdview];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            
            
            NSLog(@"第2个旋转方向---电池栏在左");
            if (self.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
              }
            
           
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            if (self.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
            
        }
            break;
        default:
            //设备平躺条件下进入播放界面
            if (self.isFullscreen == NO) {
                [self SmallScreenFrameChanges];
            }
            break;
    }
}

# pragma mark 选集

-(void)loadSelectvideoButton
{
    CGRect frame = CGRectZero;
    frame.size.width = 50;
    frame.size.height = 30;
    frame.origin.x = self.qualityButton.frame.origin.x + 30 + 50;
    frame.origin.y = self.qualityButton.frame.origin.y;
    self.selectvideoButton.frame = frame;
    
    self.selectvideoButton.backgroundColor = [UIColor clearColor];
    [self.selectvideoButton setTitle:@"选集" forState:UIControlStateNormal];
    [self.selectvideoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectvideoButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.selectvideoButton addTarget:self action:@selector(selectvideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.selectvideoButton.hidden = self.qualityButton.hidden;
    [self.overlayView addSubview:self.selectvideoButton];
}

-(void)selectvideoButtonAction:(UIButton *)button
{
    CGRect frame = CGRectZero;
    frame.origin.x = self.overlayView.frame.size.width * 1 / 2;
    frame.origin.y = 0;
    frame.size.width = self.overlayView.frame.size.width / 2;
    frame.size.height = self.overlayView.frame.size.height;
    self.menuView = [[UIView alloc]initWithFrame:frame];
    self.menuView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
    [self.overlayView addSubview:self.menuView];
    



    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = self.menuView.frame.size.width;
    frame.size.height = self.menuView.frame.size.height;
    self.selectvideoTable = [[DWTableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.selectvideoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectvideoTable.rowHeight = self.overlayView.frame.size.height / 4;
    self.selectvideoTable.backgroundColor = [UIColor clearColor];
    [self.selectvideoTable resetDelegate];
    self.selectvideoTable.scrollEnabled = YES;
    [self.menuView addSubview:self.selectvideoTable];
    self.selectvideoTable.hidden =NO;
    
    __weak DWCustomPlayerViewController *blockSelf = self;
    self.selectvideoTable.tableViewNumberOfRowsInSection = ^NSInteger(UITableView *tableView, NSInteger section) {
                return blockSelf.videos.count;
            };

    self.selectvideoTable.tableViewCellForRowAtIndexPath = ^UITableViewCell*(UITableView *tableView, NSIndexPath *indexPath){
        static NSString *cellId = @"selectvideoTableCellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.imageView.image = [UIImage imageNamed:@"cc-placeholder"];
            cell.textLabel.text = [blockSelf.videos objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            if (blockSelf.indexpath == indexPath.row) {
                cell.textLabel.textColor = [UIColor orangeColor];
            }
        }
        return cell;
    };
    self.selectvideoTable.tableViewDidSelectRowAtIndexPath = ^void(UITableView *tableView, NSIndexPath *indexPath){
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        // 更新表格文字颜色，已选中行为橙色，为选中行为白色。
        UITableViewCell *cell = [blockSelf.selectvideoTable cellForRowAtIndexPath:indexPath];
        NSArray *cells = [blockSelf.selectvideoTable visibleCells];
        for (UITableViewCell *cl in cells) {
            if (cl == cell) {
                cl.textLabel.textColor = [UIColor orangeColor];
            } else {
                cl.textLabel.textColor = [UIColor whiteColor];
            }
        }
        blockSelf.pausebuttonClick = NO;
        [blockSelf.BigPauseButton removeFromSuperview];
        blockSelf.videoId = cell.textLabel.text;
        blockSelf.indexpath = indexPath.row;
        
        _isSwitchVideo =YES;
       // 注意：视频切换资源时 要先释放当前资源 如果是VR视频 vrView置为空 重新加载 承载VR的视图
        [blockSelf switchAction];
        
        [blockSelf loadPlayUrls];
        
    };
    
}


# pragma mark 播放按钮
- (void)loadPlaybackButton
{
    CGRect frame = CGRectZero;
    if (self.isFullscreen == NO) {
        frame.origin.x = self.footerView.frame.origin.x + 5;
        frame.origin.y = self.footerView.frame.origin.y + self.footerView.frame.size.height / 2 - 15;
    }else{
        
        //
        frame.origin.x = _vrmode ==1?self.footerView.frame.size.width/4 - 90 : self.footerView.frame.size.width/4 - 15;
        
        frame.origin.y = self.footerView.frame.origin.y + (self.footerView.frame.size.height/4)*3 - 15;
        if (self.localPath) {
            frame.origin.x = self.footerView.frame.size.width/10;
            frame.origin.y = self.footerView.frame.origin.y + (self.footerView.frame.size.height/4)*3 - 15;
        }
    }
    
    frame.size.width = 30;
    frame.size.height = 30;
    self.playbackButton.frame = frame;

    [self.playbackButton setImage:[UIImage imageNamed:@"player-pausebutton"] forState:UIControlStateNormal];
    [self.playbackButton addTarget:self action:@selector(playbackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.playbackButton];
}

- (void)playbackButtonAction:(UIButton *)button
{
    self.hiddenDelaySeconds = 10;
    
    if (!self.playUrls || self.playUrls.count == 0) {
        [self loadPlayUrls];
        return;
    }
    
    UIImage *image = nil;
    
    if (self.playerView.playing) {
        // 暂停播放
        self.pausebuttonClick = YES;
        image = [UIImage imageNamed:@"player-playbutton"];
        
        [self loadBigPauseButton];
        [self.playerView pause];
        
        if (_playMode) {
            _type = @"2";
            [self startRequestAdInfo];
            _adPlay = YES;
            }
    } else {
        // 继续播放
        self.pausebuttonClick = NO;
        self.BigPauseButton.hidden = YES;
        image = [UIImage imageNamed:@"player-pausebutton"];
        [self.playerView play];
        
        [self.materialView setHidden:YES];
        _adPlay = NO;
    }
    
   
    [self.playbackButton setImage:image forState:UIControlStateNormal];
}

-(void)loadLastButton
{
    CGRect frame = CGRectZero;
    frame.origin.x = self.playbackButton.frame.origin.x - 50;
    frame.origin.y = self.footerView.frame.origin.y + (self.footerView.frame.size.height/4)*3 - 15;
    frame.size.width = 30;
    frame.size.height = 30;
    self.lastButton.frame = frame;
    
    [self.lastButton setImage:[UIImage imageNamed:@"last-button"] forState:UIControlStateNormal];
    [self.lastButton addTarget:self action:@selector(lastButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.lastButton];
    
}
-(void)lastButtonAction:(UIButton *)button
{
    if (self.indexpath == 0) {
        self.indexpath = self.videos.count;
    }
    self.videoId = self.videos[self.indexpath - 1];
    
    _isSwitchVideo =YES;
    
    // 注意：视频切换资源时 要先释放当前资源 如果是VR视频 vrView置为空 重新加载 承载VR的视图
    [self switchAction];
    [self loadPlayUrls];
    
  
    
    self.indexpath --;
    [self.BigPauseButton removeFromSuperview];
}

-(void)loadNextButton
{
    CGRect frame = CGRectZero;
    frame.origin.x = self.playbackButton.frame.origin.x + 50;
    frame.origin.y = self.footerView.frame.origin.y + (self.footerView.frame.size.height/4)*3 - 15;
    frame.size.width = 30;
    frame.size.height = 30;
    self.nextButton.frame = frame;
 
    [self.nextButton setImage:[UIImage imageNamed:@"next-button"] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.nextButton];
    
}
-(void)nextButtonAction:(UIButton *)button
{
    _isNext =YES;
    
    if (self.indexpath == self.videos.count - 1) {
        self.indexpath = -1;
    }
    self.videoId = self.videos[self.indexpath + 1];
  
    _isSwitchVideo =YES;
    // 注意：视频切换资源时 要先释放当前资源 如果是VR视频 vrView置为空 重新加载 承载VR的视图
    [self switchAction];
    [self loadPlayUrls];
    
    self.indexpath ++;  
    [self.BigPauseButton removeFromSuperview];
}

// 注意：视频切换资源时 要先释放当前资源 如果是VR视频 vrView置为空 重新加载 承载VR的视图
- (void)switchAction{
    
    if (_vrmode ==1) {
         
            self.vrView =nil;
            [self loadVRView];
       
            if (_isFullscreen) {
    
                [self FullScreenFrameChanges];
            }else{
    
                [self SmallScreenFrameChanges];
            }
          
            
        }

}

# pragma mark 倍速
-(void)loadPlaybackRateButton
{
    CGRect frame = CGRectZero;
    if (self.videoId) {
        frame.size.width = 50;
        frame.size.height = 30;
        frame.origin.x = self.qualityButton.frame.origin.x - 30 - 50;
        frame.origin.y = self.qualityButton.frame.origin.y;
    }
    else{
        frame.size.width = 50;
        frame.size.height = 30;
        frame.origin.x = self.footerView.frame.size.width/4 + self.footerView.frame.size.width/2 + 5 + 50;
        frame.origin.y = self.playbackButton.frame.origin.y;
    }
    self.playbackrateButton.frame = frame;

    self.playbackrateButton.backgroundColor = [UIColor clearColor];
    self.playbackrateButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.playbackrateButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.playbackrateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.playbackrateButton setTitle:@"倍速x1.0" forState:UIControlStateNormal];
    self.playbackrateButton.tag = 101;
    [self.playbackrateButton addTarget:self action:@selector(playbackrateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.playbackrateButton];
}

-(void)playbackrateButtonAction:(UIButton *)button
{
    if (self.playbackrateButton.tag % 4 == 0) {
        
        [self.playerView setPlayerRate:1.0];
        _speed =1.0;
        [self.playbackrateButton setTitle:@"倍速x1.0" forState:UIControlStateNormal];
    }
    if (self.playbackrateButton.tag % 4 == 1) {
         [self.playerView setPlayerRate:1.5];
        _speed =1.5;
        [self.playbackrateButton setTitle:@"倍速x1.5" forState:UIControlStateNormal];
    }
    if (self.playbackrateButton.tag % 4 == 2) {
         [self.playerView setPlayerRate:2.0];
        _speed =2.0;
        [self.playbackrateButton setTitle:@"倍速x2.0" forState:UIControlStateNormal];
    }
    if (self.playbackrateButton.tag % 4 == 3) {
        
         [self.playerView setPlayerRate:0.5];
        _speed =0.5;
         [self.playbackrateButton setTitle:@"倍速x0.5" forState:UIControlStateNormal];
    }
    self.playbackrateButton.tag ++;
}

# pragma mark 清晰度
- (void)loadQualityView
{
    if (self.qualityButton == nil) {
        self.qualityButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    }
    CGRect frame = CGRectZero;

    frame.origin.x =ScreenWidth-150;
    frame.origin.y = self.playbackButton.frame.origin.y;
    frame.size.width = 50;
    frame.size.height = 30;
    self.qualityButton.frame = frame;
    
    self.qualityButton.backgroundColor = [UIColor clearColor];
    [self.qualityButton setTitle:self.currentQuality forState:UIControlStateNormal];
    self.qualityButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.qualityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.qualityButton addTarget:self action:@selector(qualityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //self.qualityButton.tag = 103;
    [self.overlayView addSubview:self.qualityButton];
}

- (void)reloadQualityView
{
    if (self.isFullscreen == YES) {
        [self loadQualityView];
    }
}

- (void)qualityButtonAction:(UIButton *)button
{
    
    if (_qualityIndex % self.qualityDescription.count == 0) {
        [self switchQuality:0];
        self.currentQuality =@"清晰";
        [self.qualityButton setTitle:@"清晰" forState:UIControlStateNormal];
    }
    if (_qualityIndex % self.qualityDescription.count == 1) {
        [self switchQuality:1];
        self.currentQuality =@"高清";
        [self.qualityButton setTitle:@"高清" forState:UIControlStateNormal];
    }
    if (_qualityIndex % self.qualityDescription.count == 2) {
        [self switchQuality:2];
        self.currentQuality =@"超清";
        [self.qualityButton setTitle:@"超清" forState:UIControlStateNormal];
    }
    _qualityIndex ++;
    if (self.qualityDescription.count > 1) {
        [self.BigPauseButton removeFromSuperview];
    }
     
    
   
}

//切换清晰度
- (void)switchQuality:(NSInteger)index
{
    _videoIndex =index;
    
    
    
    NSInteger currentQualityIndex =  [[self.playUrls objectForKey:@"qualities"] indexOfObject:self.currentPlayUrl];
    
    NSDictionary *currentUrl = [[self.playUrls objectForKey:@"qualities"] objectAtIndex:_videoIndex];
    
    
    if (index == currentQualityIndex) {
        //不需要切换
        logdebug(@"current quality: %ld %@", (long)currentQualityIndex, self.currentPlayUrl);
        return;
    }
    
    
    self.isSwitchquality = YES;
    self.switchTime = CMTimeGetSeconds([self.playerView.player currentTime]);
    // 注意：视频切换资源时 要先释放当前资源 如果是VR视频 vrView置为空 重新加载 承载VR的视图
    [self switchAction];
    [self.playerView switchQuality:[NSURL URLWithString:[currentUrl objectForKey:@"playurl"]]];
   
    
   
   
}

- (void)showStatusLabel{

    self.videoStatusLabel.hidden = NO;
    self.videoStatusLabel.text = @"正在加载";

}


- (void)hiddentatusLabel{

    self.videoStatusLabel.hidden = YES;
    
}

- (void)showFailLabel{
    
    self.videoStatusLabel.hidden = NO;
    self.videoStatusLabel.text = @"加载失败";
}



#pragma mark----VR按钮
- (void)loadVRButton{
    
    NSInteger height =15;
    
     CGRect frame = CGRectZero;
     CGRect sliderFrame =self.durationSlider.frame;
    if (!_isFullscreen) {
      
        sliderFrame.size.width =80;
        self.durationSlider.frame =sliderFrame;
        
        frame.origin.x =self.durationSlider.frame.origin.x+80+10;
       
        height =18;
        
        
    }else{
    
       frame.origin.x = self.nextButton.frame.origin.x + 80;
      
    }

   
    
    frame.origin.y = self.footerView.frame.origin.y + (self.footerView.frame.size.height/4)*3 - height;
    frame.size.width = 30;
    frame.size.height = 30;
    self.vrInteractiveBtn.frame = frame;
    self.vrInteractiveBtn.tag =200;
    [self.vrInteractiveBtn setImage:[UIImage imageNamed:@"interativeSelect"] forState:UIControlStateSelected];
    [self.vrInteractiveBtn setImage:[UIImage imageNamed:@"inselectNormal"] forState:UIControlStateNormal];
    
    [self.vrInteractiveBtn addTarget:self action:@selector(vrAction:) forControlEvents: UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.vrInteractiveBtn];
   
    frame.origin.x =self.vrInteractiveBtn.frame.origin.x+80;
    if (!_isFullscreen) {
        
        frame.origin.x =self.vrInteractiveBtn.frame.origin.x+40;
        
    }
    
    
    self.vrDisplayBtn.frame =frame;
    self.vrDisplayBtn.tag =201;
    
    [self.vrDisplayBtn setImage:[UIImage imageNamed:@"displayNormal"] forState:UIControlStateNormal];
    [self.vrDisplayBtn setImage:[UIImage imageNamed:@"displaySelect"] forState:UIControlStateSelected];
    
    [self.vrDisplayBtn addTarget:self action:@selector(vrAction:) forControlEvents: UIControlEventTouchUpInside];
    
    [self.overlayView addSubview:self.vrDisplayBtn];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.vrDisplayBtn.hidden =NO;
        self.vrInteractiveBtn.hidden =NO;
        
    }];
}

- (void)vrAction:(UIButton *)button{
    
    button.selected =!button.selected;

    switch (button.tag) {
        case 200:
         
            if (button.selected) {
                
                [self.vrLibrary switchInteractiveMode:DWModeInteractiveTouch];
                _interative =DWModeInteractiveTouch;
                
            }else{
            
                [self.vrLibrary switchInteractiveMode:DWModeInteractiveMotion];
                _interative =DWModeInteractiveMotion;
            }
            
            
            break;
            
        case 201:
            
            if (button.selected) {
                
                [self.vrLibrary switchDisplayMode:DWModeDisplayGlass];
                _display =DWModeDisplayGlass;
                
            }else{
            
                [self.vrLibrary switchDisplayMode:DWModeDisplayNormal];
                _display =DWModeDisplayNormal;
              
            }
            
            
            break;
            
        default:
            break;
    }
    
    
//    if (self.vrInteractiveBtn.selected && self.vrDisplayBtn.selected) {
//        
//        [self.vrLibrary switchInteractiveMode:DWModeInteractiveMotionWithTouch];
//        _interative =DWModeInteractiveMotionWithTouch;
//    }


}


# pragma mark 当前播放时间
- (void)loadCurrentPlaybackTimeLabel
{//视频当前播放时间
    CGRect frame = CGRectZero;
    if (self.isFullscreen == NO) {
        frame.origin.x = self.playbackButton.frame.origin.x + self.playbackButton.frame.size.width + 5;
        frame.origin.y = self.playbackButton.frame.origin.y + 5;
    }
    else{
        frame.origin.x = 10;
        frame.origin.y = self.footerView.frame.origin.y + 9;
    }
    frame.size.width = 40;
    frame.size.height = 20;
    
    self.currentPlaybackTimeLabel.frame = frame;
    self.currentPlaybackTimeLabel.text = @"00:00:00";
    self.currentPlaybackTimeLabel.textColor = [UIColor whiteColor];
    self.currentPlaybackTimeLabel.font = [UIFont systemFontOfSize:8];
    self.currentPlaybackTimeLabel.backgroundColor = [UIColor clearColor];
    [self.overlayView addSubview:self.currentPlaybackTimeLabel];
    logdebug(@"currentPlaybackTimeLabel frame: %@", NSStringFromCGRect(self.currentPlaybackTimeLabel.frame));
}

# pragma mark 视频总时间
- (void)loadDurationLabel
{//视频总时间label
    CGRect frame = CGRectZero;
    if (self.isFullscreen == NO) {
        frame.origin.x = self.durationSlider.frame.origin.x + self.durationSlider.frame.size.width + 5;
        frame.origin.y = self.playbackButton.frame.origin.y + 5;
    }else{
        frame.origin.x = self.footerView.frame.size.width - 50 - 40;
        frame.origin.y = self.footerView.frame.origin.y + 9;
    }
    frame.size.width = 40;
    frame.size.height = 20;

    self.durationLabel.frame = frame;
    self.durationLabel.text = @"00:00:00";
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.backgroundColor = [UIColor clearColor];
    self.durationLabel.font = [UIFont systemFontOfSize:8];
    
    [self.overlayView addSubview:self.durationLabel];
}

# pragma mark 时间滑动条
- (void)loadPlaybackSlider
{
    CGRect frame = CGRectZero;
    if (self.isFullscreen == NO) {
        frame.origin.x = self.currentPlaybackTimeLabel.frame.origin.x + self.currentPlaybackTimeLabel.frame.size.width ;
        frame.origin.y = self.playbackButton.frame.origin.y;
    }else{
        frame.origin.x = self.footerView.frame.origin.x + 10 + 10 + 40;
        frame.origin.y = self.footerView.frame.origin.y + 4;
    }
    frame.size.width = self.footerView.frame.size.width - 60 - 100;
    frame.size.height = 30;
    
    self.durationSlider.frame =frame;
    
    [self.overlayView addSubview:self.durationSlider];
    
    
}
-(void)durationSlidersetting
{
    self.durationSlider.minimumValue = 0.0f;
    self.durationSlider.maximumValue = 1.0f;
    self.durationSlider.value = 0.0f;
    self.durationSlider.continuous = NO;
    [self.durationSlider setMaximumTrackImage:[UIImage imageNamed:@"player-slider-inactive"]
                                     forState:UIControlStateNormal];
    [self.durationSlider setMinimumTrackImage:[UIImage imageNamed:@"slider"]
                                     forState:UIControlStateNormal];
    [self.durationSlider setThumbImage:[UIImage imageNamed:@"player-slider-handle"]
                              forState:UIControlStateNormal];
    
    [self.durationSlider addTarget:self action:@selector(durationSliderMoving:) forControlEvents:UIControlEventValueChanged | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self.durationSlider addTarget:self action:@selector(durationSliderEnded:) forControlEvents: UIControlEventTouchCancel];

    [self.durationSlider addTarget:self action:@selector(durationSliderBegan:) forControlEvents:UIControlEventTouchDown];
   
    
}

- (void)durationSliderBegan:(UISlider *)slider{

     _isSlidering =YES;

}


- (void)durationSliderEnded:(UISlider *)slider{

    _isSlidering =NO;

}


- (void)durationSliderMoving:(UISlider *)slider
{
    float seconds =slider.value;
    CGFloat durationInSeconds = CMTimeGetSeconds(self.playerView.player.currentItem.duration);
    
    CGFloat time = durationInSeconds * seconds;
 
    // 继续播放
    _pausebuttonClick =NO;
    _isSlidering =NO;
    
   
   for (DWQuestionModel *questionModel in self.questionModelArray) {
        
        if (!questionModel.unScrubShow && ![questionModel.jump boolValue] && time >[questionModel.showTime floatValue]) {
            
            questionModel.unScrubShow =NO;
            time =[questionModel.showTime floatValue];
            break;
            
        }
        
        
    }
    
        //让视频从指定的CMTime对象处播放。滑动用scrub方法
        [self.playerView scrub:time];
   
}


# pragma mark - 其它控件

# pragma mark 屏幕锁
-(void)loadLockButton
{
    if (!self.lockButton) {
        self.lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    CGRect frame = CGRectZero;
    frame.origin.x = 20;
    frame.origin.y = self.overlayView.frame.size.height/2 - 20;
    frame.size.width = 40;
    frame.size.height = 40;

    self.lockButton.frame = frame;
    self.lockButton.backgroundColor = [UIColor clearColor];
    [self.lockButton setImage:[UIImage imageNamed:@"unlock_ic"] forState:UIControlStateNormal];
    [self.lockButton setImage:[UIImage imageNamed:@"lock_ic"] forState:UIControlStateSelected];
    [self.lockButton addTarget:self action:@selector(lockScreenAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.lockButton];
    
    
    
}
- (void)loadVoiceButton{

  
       if (_voiceSlider) {
        
          [_voiceSlider removeFromSuperview];
           
        }
        
        _voiceSlider =[[UISlider alloc]initWithFrame:CGRectMake(ScreenWidth-100, ScreenHeight-160, 130, 8)];
        _voiceSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
        _voiceSlider.minimumValue = 0.0f;
        _voiceSlider.maximumValue = 1.0f;
        _voiceSlider.value = _voiceValue;
        _voiceSlider.continuous = NO;
        [_voiceSlider setMaximumTrackImage:[UIImage imageNamed:@"player-slider-inactive"]
                                  forState:UIControlStateNormal];
        [_voiceSlider setMinimumTrackImage:[UIImage imageNamed:@"slider"]
                                  forState:UIControlStateNormal];
        [_voiceSlider setThumbImage:[UIImage imageNamed:@"player-slider-handle"]
                           forState:UIControlStateNormal];
        
    
        [_voiceSlider addTarget:self action:@selector(voiceSliderDone:) forControlEvents:UIControlEventTouchUpInside];
        [self.overlayView addSubview:_voiceSlider];
        
        
        if (_voiceBtn) {
    
          [_voiceBtn removeFromSuperview];
       }
        
        _voiceBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.frame =CGRectMake(CGRectGetMinX(_voiceSlider.frame)-4 , CGRectGetMaxY(_voiceSlider.frame),30, 30);
        [_voiceBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage imageNamed:@"noVoice"] forState:UIControlStateSelected];
        
        [_voiceBtn addTarget:self action:@selector(voiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.overlayView addSubview:_voiceBtn];
        
}


- (void)voiceSliderDone:(UISlider *)slider{


   _voiceValue =_voiceSlider.value;
    
    [self.volumeViewSlider setValue:_voiceValue animated:YES];
    
}

- (void)voiceBtnAction:(UIButton *)btn{

    btn.selected =!btn.selected;
    
    if (btn.selected) {
        
     
        [self.volumeViewSlider setValue:0.0f animated:YES];
    }else{
    
     
        [self.volumeViewSlider setValue:_voiceValue animated:YES];
        
    }


}


-(void)lockScreenAction:(UIButton *)button
{
    self.lockButton.selected = !self.lockButton.selected;
    
    if (self.lockButton.selected == YES) {
        self.isLock = YES;
        [self hiddenAllView];
        [self loadTipLabelview:NO];
        self.tipLabel.text = @"屏幕已锁定";
       
    }
    else{
        [self showBasicViews];
        self.isLock = NO;
        [self loadTipLabelview:NO];
        self.tipLabel.text = @"屏幕已解锁";
       
    }
}

# pragma mark 播放状态提示
- (void)loadVideoStatusLabel
{
    CGRect frame = CGRectZero;
    frame.size.height = 40;
    frame.size.width = 100;
    frame.origin.x = self.overlayView.frame.size.width/2 - frame.size.width/2;
    frame.origin.y = self.overlayView.frame.size.height/2 - frame.size.height/2;
    
    self.videoStatusLabel.frame = frame;
    if (self.pausebuttonClick) {
        self.videoStatusLabel.text = @"暂停";
    }else{
        self.videoStatusLabel.text = @"正在加载";
    }
    self.videoStatusLabel.textAlignment = NSTextAlignmentCenter;
    self.videoStatusLabel.textColor = [UIColor whiteColor];
    self.videoStatusLabel.backgroundColor = [UIColor clearColor];
    self.videoStatusLabel.font = [UIFont systemFontOfSize:16];
    [self.overlayView addSubview:self.videoStatusLabel];
}
-(void)loadBigPauseButton
{
    CGRect frame = CGRectZero;
    frame.size.height = 100;
    frame.size.width = 100;
    frame.origin.x = self.overlayView.frame.size.width/2 - frame.size.width/2;
    frame.origin.y = self.overlayView.frame.size.height/2 - frame.size.height/2;
    if (!self.BigPauseButton) {
        self.BigPauseButton = [[UIButton alloc]init];
    }
    self.BigPauseButton.frame = frame;
    [self.BigPauseButton setImage:[UIImage imageNamed:@"big_stop_ic"] forState:UIControlStateNormal];
    [self.BigPauseButton addTarget:self action:@selector(playbackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.BigPauseButton.hidden = NO;
    [self.overlayView addSubview:self.BigPauseButton];
}
-(void)loadTipLabelview:(BOOL )isAudio;
{
    CGRect frame = CGRectZero;
    frame.size.height = 40;
    frame.size.width = 100;
    frame.origin.x = self.overlayView.frame.size.width/2 - frame.size.width/2;
    frame.origin.y = self.overlayView.frame.size.height/2 - frame.size.height/2 + 30;

    self.tipLabel.frame = frame;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.adjustsFontSizeToFitWidth = YES;
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.hidden = NO;
    
    if (!isAudio) {
        
        [self.overlayView addSubview:self.tipLabel];
        
    }else{
        
        [self.audioView addSubview:self.tipLabel];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        [self.tipLabel removeFromSuperview];
        
    });
    
   
}
#pragma mark - 控件隐藏 & 显示
- (void)hiddenAllView
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.backButton.hidden = YES;
    self.downloadButton.hidden = YES;
    self.menuButton.hidden = YES;
    self.subtitleButton.hidden = YES;
    self.qualityButton.hidden = YES;
    self.playbackrateButton.hidden = YES;
    self.screenSizeButton.hidden = YES;
    self.selectvideoButton.hidden = YES;
    self.playbackButton.hidden = YES;
    self.lastButton.hidden = YES;
    self.nextButton.hidden = YES;
    self.currentPlaybackTimeLabel.hidden = YES;
    self.durationLabel.hidden = YES;
    self.durationSlider.hidden = YES;
    self.switchScrBtn.hidden = YES;
    self.headerView.hidden = YES;
    self.footerView.hidden = YES;
    
    
    self.hiddenAll = YES;
    
    //打点视图隐藏
    self.markView.hidden =YES;
    self.arrowImageView.hidden =YES;
    
   
    //VR按钮
    self.vrInteractiveBtn.hidden =YES;
    self.vrDisplayBtn.hidden =YES;
    
    //音量相关
    self.voiceBtn.hidden =YES;
    self.voiceSlider.hidden =YES;
    
    if (!self.isLock) {
        self.lockButton.hidden = YES;
    }
    
    if (_isGIF) return;
    self.gifBtn.hidden =YES;
    
}

- (void)showBasicViews
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.backButton.hidden = NO;
    self.downloadButton.hidden = NO;
    self.menuButton.hidden = NO;
    self.subtitleButton.hidden = NO;
    self.qualityButton.hidden = NO;
    self.playbackrateButton.hidden = NO;
    self.screenSizeButton.hidden = NO;
    self.playbackButton.hidden = NO;
    self.selectvideoButton.hidden = NO;
    self.lastButton.hidden = NO;
    self.nextButton.hidden = NO;
    self.currentPlaybackTimeLabel.hidden = NO;
    self.durationLabel.hidden = NO;
    self.durationSlider.hidden = NO;
    self.switchScrBtn.hidden = NO;
    self.lockButton.hidden = NO;
    self.headerView.hidden = NO;
    self.footerView.hidden = NO;
    self.hiddenAll = NO;
    
    self.vrDisplayBtn.hidden =NO;
    self.vrInteractiveBtn.hidden =NO;
    
    self.voiceSlider.hidden =NO;
    self.voiceBtn.hidden =NO;
    
    if (!self.isFullscreen) {
        self.menuButton.hidden = YES;
        self.nextButton.hidden = YES;
        self.lastButton.hidden = YES;
        self.selectvideoButton.hidden = YES;
        self.lockButton.hidden = YES;

       
    }
    if (self.localPath) {
        self.downloadButton.hidden = YES;
        self.qualityButton.hidden = YES;
        self.selectvideoButton.hidden = YES;
        self.lastButton.hidden = YES;
        self.nextButton.hidden = YES;
    }
    
    if (_vrmode != 1) {
        
        self.vrDisplayBtn.hidden =YES;
        self.vrInteractiveBtn.hidden =YES;
    }
    
    self.gifBtn.hidden =NO;
    
}

# pragma mark - 手势识别 UIGestureRecognizerDelegate

-(void)handleSignelTap:(UIGestureRecognizer*)gestureRecognizer
{
    if (_isGIF) return;
    
    if (!self.isLock) {
        if (self.hiddenAll) {
            [self showBasicViews];
            self.hiddenDelaySeconds = 10;
            
        } else {
            self.menuView.hidden =YES;
            [self hiddenAllView];
            self.hiddenDelaySeconds = 0;
        }
    }
    else{
        if (self.lockButton.hidden) {
            self.lockButton.hidden = NO;
            self.hiddenDelaySeconds = 10;
        }
        else{
            self.lockButton.hidden = YES;
            self.hiddenDelaySeconds = 0;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.signelTap) {
        if ([touch.view isKindOfClass:[UIButton class]]) {
            return NO;
        }
        if ([touch.view isKindOfClass:[DWTableView class]]) {
            return NO;
        }
        if ([touch.view isKindOfClass:[UISlider class]]) {
            return NO;
        }
        if ([touch.view isKindOfClass:[UIImageView class]]) {
            return NO;
        }
        if ([touch.view isKindOfClass:[UITableView class]]) {
            return NO;
        }
        if ([touch.view isKindOfClass:[UITableViewCell class]]) {
            return NO;
        }
        // UITableViewCellContentView => UITableViewCell
        if([touch.view.superview isKindOfClass:[UITableViewCell class]]) {
            return NO;
        }
        // UITableViewCellContentView => UITableViewCellScrollView => UITableViewCell
        if([touch.view.superview.superview isKindOfClass:[UITableViewCell class]]) {
            return NO;
        }
    }
    return YES;
}


#pragma mark 手势调节
- (void)touchesBeganWithPoint:(CGPoint)point {
    //记录首次触摸坐标
    self.startPoint = point;
    //检测用户是触摸屏幕的左边还是右边，以此判断用户是要调节音量还是亮度，左边是亮度，右边是音量
    if (self.startPoint.x <= self.overlayView.frame.size.width / 2.0) {
        //亮度
        self.startVB = [UIScreen mainScreen].brightness;
    } else {
        //音/量
        self.startVB = self.volumeViewSlider.value;
    }
    //方向置为无
    self.direction = DirectionNone;
    //记录当前视频播放的进度
   // self.startVideoRate = self.player.item. / self.player.duration;
}

- (void)touchesEndWithPoint:(CGPoint)point {
//    if (self.direction == DirectionLeftOrRight) {
//        self.player.item.currentTime = self.currentRate * self.player.item.duration;
//    }
}

- (void)touchesMoveWithPoint:(CGPoint)point {
    //得出手指在Button上移动的距离
    CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    //分析出用户滑动的方向
    if (self.direction == DirectionNone) {
        if (panPoint.x >= 30 || panPoint.x <= -30) {
            //进度
            self.direction = DirectionLeftOrRight;
        } else if (panPoint.y >= 30 || panPoint.y <= -30) {
            //音量和亮度
            self.direction = DirectionUpOrDown;
        }
    }
    
    if (self.direction == DirectionNone) {
        return;
    } else if (self.direction == DirectionUpOrDown) {
        //音量和亮度
        if (self.startPoint.x <= self.overlayView.frame.size.width / 2.0) {
            //调节亮度
            if (panPoint.y < 0) {
                //增加亮度
                [[UIScreen mainScreen] setBrightness:self.startVB + (-panPoint.y / 30.0 / 10)];
            } else {
                //减少亮度
                [[UIScreen mainScreen] setBrightness:self.startVB - (panPoint.y / 30.0 / 10)];
            }
        } else {
            //音量
            if (panPoint.y < 0) {
                //增大音量
                [self.volumeViewSlider setValue:self.startVB + (-panPoint.y / 30.0 / 10) animated:YES];
                if (self.startVB + (-panPoint.y / 30 / 10) - self.volumeViewSlider.value >= 0.1) {
                    [self.volumeViewSlider setValue:0.1 animated:NO];
                    [self.volumeViewSlider setValue:self.startVB + (-panPoint.y / 30.0 / 10) animated:YES];
                }
            } else {
                //减少音量
                [self.volumeViewSlider setValue:self.startVB - (panPoint.y / 30.0 / 10) animated:YES];
            }
        }
    } else if (self.direction == DirectionLeftOrRight ) {
        //进度
        CGFloat rate = self.startVideoRate + (panPoint.x / 30.0 / 80.0);
        if (rate > 1) {
            rate = 1;
        } else if (rate < 0) {
            rate = 0;
        }
        self.currentRate = rate;
    }
}

- (MPVolumeView *)volumeView {
    if (_volumeView == nil) {
        _volumeView  = [[MPVolumeView alloc] init];
        [_volumeView sizeToFit];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeView;
}

# pragma mark - 播放视频
- (void)loadPlayUrls
{
    
    self.playerView.videoId =self.videoId;
    self.playerView.timeoutSeconds = 10;
    //1为视频 2为音频 0为视频+音频 若不传该参数默认为视频
    self.playerView.mediatype =DWAPPDELEGATE.mediatype;
    __weak typeof(self)weakSelf =self;
    self.playerView.failBlock = ^(NSError *error) {
        loginfo(@"error: %@", [error localizedDescription]);
        
         [weakSelf showFailLabel];
    };
    
    self.playerView.getPlayUrlsBlock = ^(NSDictionary *playUrls) {
        // [必须]判断 status 的状态，不为"0"说明该视频不可播放，可能正处于转码、审核等状态。
        NSNumber *status = [playUrls objectForKey:@"status"];
        
        if (status == nil || [status integerValue] != 0) {
            NSString *message = [NSString stringWithFormat:@"%@ %@:%@",
                                 weakSelf.videoId,
                                 [playUrls objectForKey:@"status"],
                                 [playUrls objectForKey:@"statusinfo"]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        weakSelf.playUrls = playUrls;
        
        [weakSelf resetViewContent];
    };
    [self.playerView startRequestPlayInfo];
    
}

# pragma mark - 根据播放url更新涉及的视图
- (void)resetViewContent
{
    
    //判断是否是VR视频  1表示播放VR视频，0表示普通
     _vrmode =[[self.playUrls objectForKey:@"vrmode"] integerValue];
   //  _vrmode =1;
   
    //根据mediatype决定显示哪个view
    [self showMediatypeView];
    
    //打点的数组
    NSArray *markArray =[self.playUrls objectForKey:@"videomarks"];
    [self.videomarkArray removeAllObjects];
    for (int i =0;i< markArray.count;i++) {
        
        DWVideoMarkModel *markModel =[DWVideoMarkModel mj_objectWithKeyValues:markArray[i]];
        [self.videomarkArray addObject:markModel];
    }
    
    
    //问答的数组
    NSArray *questionsArray =[self.playUrls objectForKey:@"questions"];
    [self.questionModelArray removeAllObjects];
    [self.videoquestionsDic removeAllObjects];
    for (NSDictionary *dic in questionsArray) {
        
        
        
        //模型中套模型
        [DWQuestionModel mj_setupObjectClassInArray:^NSDictionary *{
            
            return @{@"answers":@"DWAnswerModel",
                     
                    };
            
        }];
        DWQuestionModel *questionmodel =[DWQuestionModel mj_objectWithKeyValues:dic];
        //储存 便于以后取值 使用字典可以优化性能
        [self.videoquestionsDic setObject:questionmodel forKey:questionmodel.showTime];
        [self.questionModelArray addObject:questionmodel];
       
    }
    
    
    if (self.videoId) {
        [self resetQualityView];
    }
    
    NSArray *array =[self.playUrls objectForKey:@"qualities"];
    if (array.count) {
        
        //只是举例 自己根据数据来处理
        self.currentPlayUrl =[array objectAtIndex:_videoIndex];
        
        
    }
    
    //只是举例 要根据项目需求具体处理
    NSArray *typeArray =[self.playUrls objectForKey:@"qualityDescription"];
    [typeArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //说明有音频
            if ([obj containsString:@"m4a"] || [obj containsString:@"mp3"] || [obj containsString:@"aac"]) {
                
                *stop =YES;
                //取得对应的音频字典
                self.audioDic =[array objectAtIndex:idx];
                //预加载音频
                [self.audioPlayer setAudioURL:[NSURL URLWithString:[self.audioDic objectForKey:@"playurl"]]];
                
            }
            
        }];
    
    
   //说明是纯音频
    if (_isChangePlay || [self.playerView.mediatype isEqualToString:@"2"] ) {
        
        [self.audioPlayer audioPlay];
        
        return;
        
    }
    
        NSString *urlStr =[self.currentPlayUrl objectForKey:@"playurl"];
        //setURL方法 添加播放资源  如果有正在播放的资源，会释放掉当前播放的资源
        [self.playerView setURL:[NSURL URLWithString:urlStr] withCustomId:nil];
        //根据项目需求调用 并设置按钮title
        //  [self.playerView setPlayerRate:1.0];
        [self vrAction];//VR设置
        [self.playerView play];
        
    
    
}

- (void)vrAction{
    
    if (_vrmode ==1) {
        //如果playerView存在 则隐藏
        self.playerView.hidden =YES;//因为放在同一张视图上 所以隐藏
        [self playVR];
        [self loadVRButton];
        
        
        
    }else{
        //如果vrView存在 则隐藏
        self.vrView.hidden =YES;//因为放在同一张视图上 所以隐藏
        
    }
    
}

//VR播放模式
- (void)playVR{
    /*
     *记录交互方式
     *与后面的
     *       if (_vrmode ==1 && haveMotion) {
     
            [self.vrLibrary switchInteractiveMode:DWModeInteractiveTouch];
            [self.vrLibrary switchInteractiveMode:DWModeInteractiveMotion];
          }
     *结合使用可实现重力感应下的正确方向
     *注意：只是以前代码设置方向不正确 我才做此处理 若项目中方向正确 就不需要此处理
     */
    
     
   
   //vr
    _config = [DWVRLibrary createConfig];
    
    [_config asVideo:self.playerView.player.currentItem];
    [_config setContainer:self view:self.vrView];
    
    // optional
    [_config projectionMode:DWModeProjectionSphere];//效果
    [_config displayMode:_display];//是否分屏
    [_config interactiveMode:_interative];//交互方式
    [_config pinchEnabled:true];
    [_config setDirectorFactory:[[CustomDirectorFactory alloc]init]];
    
    self.vrLibrary =[_config build];
    
}

- (void)resetQualityView
{
    //数组
    self.qualityDescription = [[self.playUrls objectForKey:@"qualityDescription"] mutableCopy];
    //去除音频
    [self.qualityDescription enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
                if ([obj containsString:@"m4a"] || [obj containsString:@"mp3"] || [obj containsString:@"aac"]) {
        
                    [self.qualityDescription removeObject:obj];
        
                }
        
    }];
    
    // 由于每个视频的清晰度种类不同，所以这里需要重新加载
    [self reloadQualityView];
}





# pragma mark - 播放本地文件
- (void)playLocalVideo
{
   // self.playUrls = [NSDictionary dictionaryWithObject:self.localPath forKey:@"playurl"];
    
    self.bottomView.hidden =YES;
    
   //读取Docunment下文件路径 拼接完整的文件路径
    NSArray *fileList = [NSArray array];
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSError *error;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    fileList =[fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error];  
    NSLog(@"路径==%@,fileList%@___%@", documentsDirectory,fileList,self.localPath);
    //文件路径
    NSString *fileLocalPath =[NSString stringWithFormat:@"%@/%@",documentsDirectory,self.localPath];
    
    //说明是播放本地音频文件
    if ([self.localPath containsString:@"m4a"] || [self.localPath containsString:@"mp3"] || [self.localPath containsString:@"aac"]) {
        
        
        [self.audioPlayer setAudioURL:[NSURL fileURLWithPath:fileLocalPath]];
        [self.audioPlayer audioPlay];
        
        
        //音频视图放在最前面
        self.audioView.hidden =NO;
        self.audioView.downloadBtn.hidden =YES;
        [self.view bringSubviewToFront:self.audioView];
        
        return;
    }
    
    
    
    [self.playerView setURL:[NSURL fileURLWithPath:fileLocalPath] withCustomId:nil];
   
    
  /*
    //VR 隐藏当前playerView 放在当前控制视图上
     self.playerView.hidden =YES;
    //vr
    DWVRConfiguration* config = [DWVRLibrary createConfig];
    
    [config asVideo:self.playerView.player.currentItem];
    [config setContainer:self view:self.vrView];
    
    // optional
    [config projectionMode:DWModeProjectionSphere];//效果
    [config displayMode:DWModeDisplayNormal];//是否分屏
    [config interactiveMode:DWModeInteractiveMotion];//交互方式
    [config pinchEnabled:true];
    [config setDirectorFactory:[[CustomDirectorFactory alloc]init]];
    
    self.vrLibrary =[config build];
    */
    ////如果vrView存在 则隐藏
    self.vrView.hidden =YES;//因为放在同一张视图上 所以隐藏
    
   [self.playerView play];
    
}

# pragma mark - 记录播放位置
-(void)saveNsUserDefaults
{
    //记录播放信息
    NSTimeInterval time = CMTimeGetSeconds([self.playerView.player currentTime]);
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu",dTime];
    self.playPosition = [NSDictionary dictionaryWithObjectsAndKeys:
                         curTime,@"playbackTime",
                         nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.videoId) {
        //在线视频
        [userDefaults setObject:self.playPosition forKey:_videoId];
        
    } else if (self.localPath) {
        //本地视频
        [userDefaults setObject:self.playPosition forKey:_localPath];
    }
    //同步到磁盘
    [userDefaults synchronize];
}
-(void)readNSUserDefaults
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    if (self.videoId) {
        NSDictionary *playPosition = [userDefaultes dictionaryForKey:_videoId];
        
        self.switchTime = [[playPosition valueForKey:@"playbackTime"] floatValue];

    }else if (self.localPath){
        NSDictionary *playPosition = [userDefaultes dictionaryForKey:_localPath];
        
        self.switchTime = [[playPosition valueForKey:@"playbackTime"] floatValue];
    }
    
    
}

- (void)removeAllObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerView removeObserver:self forKeyPath:@"playing"];
    
}

#pragma mark---观察者方法 player的播放 暂停属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    //回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        if (object == self.playerView) {
            
            if ([keyPath isEqualToString:@"playing"]) {
                
                BOOL isPlaying =[[change objectForKey:@"new"] boolValue];
                
                //播放
                if (isPlaying) {
                    
                    
                    
                    self.isPlayable = YES;
                    [self.playbackButton setImage:[UIImage imageNamed:@"player-pausebutton"] forState:UIControlStateNormal];
                    
                    self.BigPauseButton.hidden =YES;
                    logdebug(@"movie playing");
                    
                }else{
                    //暂停
                    
                    
                    [self.playbackButton setImage:[UIImage imageNamed:@"player-playbutton"] forState:UIControlStateNormal];
                    self.BigPauseButton.hidden =NO;
                    self.videoStatusLabel.hidden = NO;
                    
                }
                
                
            }
            
        }
        
    });

   
}

#pragma mark--问答功能------
- (void)showQuestionsView:(float )time{
    
    NSNumber *number =[NSNumber numberWithFloat:time];
    NSString *key =[NSString stringWithFormat:@"%ld",[number integerValue]];
    DWQuestionModel *model =[self.videoquestionsDic objectForKey:key];
    if (model && !model.isShow) {
        
        model.isShow =YES;
        [self.playerView pause];//暂停
        model.unScrubShow =YES;
        self.questionView.questionModel =model;
        
        WeakSelf(self);
        [self.questionView didQuestionBlock:^(BOOL right) {
            StrongSelf(self);
           
            [self showFeedBackView:model withRight:right];
            
        }];
        
        [self.questionView didSkipBlock:^{
            
            StrongSelf(self);
            [self resumeVideoPlay];
            
            
        }];
        
        
        
    }
    
}

- (void)showFeedBackView:(DWQuestionModel *)model withRight:(BOOL )right{
    
     self.feedBackView =[[DWFeedBackView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight)];
    [self.view addSubview:self.feedBackView];
    [self.feedBackView showResult:model withRight:right];
    WeakSelf(self);
    [self.feedBackView didFeedBackBlock:^{
        StrongSelf(self);
       if (!right && [model.backSecond floatValue] >0){
            //答案错误且有返回时间 才返回
           [self removeQuestionAndFeedBackView];
           [self.playerView scrub:[model.backSecond floatValue]];
           [self.playerView play];
           
           
       }else{
           
           [self resumeVideoPlay];
       }
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            model.isShow =NO;
        });
        
    }];
    
}

- (void)resumeVideoPlay{
    
    [self.playerView play];//播放
    [self removeQuestionAndFeedBackView];
}

- (void)removeQuestionAndFeedBackView{
    
    
    [self.feedBackView removeFromSuperview];
    [self.questionView removeFromSuperview];
    self.feedBackView =nil;
    self.questionView =nil;
}


#pragma mark-------DWVideoPlayerDelegate-----

//可播放／播放中
- (void)videoPlayerIsReadyToPlayVideo:(DWPlayerView *)playerView{
   
    
    if (_videoId) {
        
        
        
        if (!_adPlay && !_isSwitchquality) {
            
            [self readNSUserDefaults];
            
        }
        
        
        
        if(_isSwitchVideo){
            
            //切换了资源 从头开始
            self.switchTime =0.0f;
            
        }
        
        //读取原先的播放时间 用oldTimeScrub方法
        [self.playerView oldTimeScrub:self.switchTime];
        
        
        _isSwitchVideo =NO;
    }
    
   
}


//播放完毕
- (void)videoPlayerDidReachEnd:(DWPlayerView *)playerView{
   
   
    NSLog(@"播放完毕");
    
    if (_isGIF) {
        [self.playerView pause];
        return;
        
    }
    
    self.videoStatusLabel.hidden = YES;
    if (_adPlay && _playMode) {
        //处理片头广告视频轮播逻辑
        if (_adInfo.ad.count == 1) {

          
            [self.playerView setURL:[NSURL URLWithString:_materialUrl] withCustomId:nil];
            [self.playerView play];
            
           
            
        }
        if (_adInfo.ad.count > 1) {
            if (_adNum <= _adInfo.ad.count - 2) {
                _adNum ++;
                [self playAdmovie];
            }
            else{
                _adNum = 0;
                [self playAdmovie];
            }
        }
    }
    else {
        //进度记忆清零
        if (self.videoId) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:_videoId];
        }else if (self.localPath)
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:_localPath];
        }
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self nextButtonAction:self.nextButton];
    }
   
    
    //重播的方法
  //  [self.playerView repeatPlay];
    
}

//当前播放时间
- (void)videoPlayer:(DWPlayerView *)playerView timeDidChange:(float)time{
    
    

    if (time >1) {
        
        [self hiddentatusLabel];
    }
    
    CGFloat durSec =CMTimeGetSeconds(self.playerView.player.currentItem.duration);
    if (!_isSlidering) {
        
      self.currentPlaybackTimeLabel.text =[DWTools formatSecondsToString:time];
      self.durationLabel.text =[DWTools formatSecondsToString:durSec];
      //进度条
      self.durationSlider.value =(float) time / durSec;
        
      NSString *string = [self.mediaSubtitle searchWithTime:time];
      CGSize size =[DWTools widthWithHeight:ScreenWidth-100 andFont:_subtitleModel.size/2 andLabelText:string];
     self.movieSubtitleLabel.text =string;
     self.movieSubtitleLabel.frame =CGRectMake((_overlayView.frame.size.width-size.width)/2,_overlayView.frame.size.height*(1-self.subtitleModel.bottom), size.width, size.height);
        
     
        
    }
    
   //问答功能
    [self showQuestionsView:time];
    
    
}

//duration 当前缓冲的长度
- (void)videoPlayer:(DWPlayerView *)playerView loadedTimeRangeDidChange:(float)duration{
   
 //   NSLog(@"缓冲长度为__%f",duration);
    
}



//没数据 即播放卡顿
- (void)videoPlayerPlaybackBufferEmpty:(DWPlayerView *)playerView{

   
    NSLog(@"卡了");
    
    [self showStatusLabel];
    
    //卡顿的时候 可先暂停几秒钟再播放 也可切换备用线路spareurl 视情况处理
//    [self.playerView pause];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.playerView play];
//       
//    });
    
   
}

//有数据 能够继续播放
- (void)videoPlayerPlaybackLikelyToKeepUp:(DWPlayerView *)playerView{
 
    [self hiddentatusLabel];
    
}



//加载失败
- (void)videoPlayer:(DWPlayerView *)playerView didFailWithError:(NSError *)error{
    
    NSLog(@"错误原因:%@__%@",[error localizedDescription],[playerView urlOfCurrentlyPlayingInPlayer]);
    
    
    [self.playerView setURL:[NSURL URLWithString:[self.currentPlayUrl objectForKey:@"playurl"]] withCustomId:nil];
    [self.playerView play];

    self.isPlayable =NO;
    
    
}

- (void)changePlayerViewPlay{
    
    _audioView.hidden =YES;
    
    //取得当前播放时间
    self.currentPlayTime =CMTimeGetSeconds([self.audioPlayer.player currentTime]);
    
    //关闭音频播放 打开视频播放
    if (self.audioPlayer.isAudioPlaying) {
        
        [self.audioPlayer audioPause];
        
    }
    
    
    if (!self.playerView.playing) {
        
        if (_isNext) {
            
             [self.playerView setURL:[NSURL URLWithString:[self.currentPlayUrl objectForKey:@"playurl"]] withCustomId:nil];
        }
        
        
        [self.playerView scrub:self.currentPlayTime];
        [self.playerView play];
        
        _isNext =NO;
    }
    
    
}

- (void)changeAudioPlayerPlay{
    
    _audioView.hidden =NO;
    [self.view bringSubviewToFront:_audioView];
    
    //取得当前播放时间
    self.currentPlayTime =CMTimeGetSeconds([self.playerView.player currentTime]);
    
    //关闭视频播放 打开音频播放
    if (self.playerView.playing) {
        
        [self.playerView pause];
    }
    
    if (!self.audioPlayer.isAudioPlaying) {
        
        
        if (_isNext) {
            
            [self.audioPlayer setAudioURL:[NSURL URLWithString:[self.audioDic objectForKey:@"playurl"]]];
        }
        
        [self.audioPlayer audioScrub:self.currentPlayTime];
        [self.audioPlayer audioPlay];
        
        _isNext =NO;
    }
    
    
}

#pragma mark---DWBottomViewDelegate----
//切换到视频播放
-(void)videoBottomViewPlayAction{
    
    _isChangePlay =NO;
    
    [self changePlayerViewPlay];
   
}


//切换到音频播放
- (void)audioBottomViewPlayAction{
    
    self.audioView.playBtn.selected =NO;
    _isChangePlay =YES;
    [self changeAudioPlayerPlay];
  
}

#pragma mark---DWAudioPlayViewDelegate---

- (void)audioPlayViewBackAction{
    //页面关闭时 务必调用 否则仍会发送统计信息
    [self.playerView removeTimer];
    [self.navigationController popViewControllerAnimated:YES];
    
}

//音频下载
- (void)audioPlayViewDownloadAction{
    
    // 获取下载地址
    DWPlayInfo *playinfo = [[DWPlayInfo alloc] initWithUserId:DWACCOUNT_USERID andVideoId:self.videoId key:DWACCOUNT_APIKEY hlsSupport:@"0"];
    //设置mediatype
    playinfo.mediatype =@"2";
    //网络请求超时时间
    playinfo.timeoutSeconds =20;
    playinfo.errorBlock = ^(NSError *error){
        
        
    };
    
    playinfo.finishBlock = ^(NSDictionary *response){
        
        NSDictionary *playUrls =[DWUtils parsePlayInfoResponse:response];
        
        if (!playUrls) {
            //说明 网络资源暂时不可用
        }
        
        //获取PlayInfo 配对url 推送offlineview
        NSArray *videos = [playUrls valueForKey:@"definitions"];
        
        //注意 只是举例 自己根据数据处理
        NSDictionary *videoInfo = videos[0];
        
        //字典转模型
        DWOfflineModel *model =[[DWOfflineModel alloc]init];
        model.definition =[videoInfo objectForKey:@"definition"];
        model.desp =[videoInfo objectForKey:@"desp"];
        model.playurl =[videoInfo objectForKey:@"playurl"];
        model.videoId =self.videoId;
        
      //音频均不加密 不需要token
     //   model.token =[playUrls objectForKey:@"token"];
        
        //路径
        // 开始下载
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        
        
        /* 注意：
         音频文件格式为m4a mp3
         */
        NSString *audioStr;
        if ([model.playurl containsString:@"m4a"]) {
            
            audioStr =@"m4a";
            
        }else if ([model.playurl containsString:@"mp3"]){
            
            audioStr =@"mp3";
        }else if ([model.playurl containsString:@"aac"]){
            
            audioStr =@"aac";
        }
        
        
        NSString *videoPath;
        if (!model.definition) {
            
            videoPath = [NSString stringWithFormat:@"%@/%@.%@", documentDirectory, model.videoId,audioStr];
        } else {
            
            videoPath = [NSString stringWithFormat:@"%@/%@-%@.%@", documentDirectory, model.videoId, model.definition,audioStr];
        }
        
        model.videoPath =videoPath;
        DWDownloadViewController *viewCtrl =[DWDownloadViewController sharedInstance];
        
        BOOL repeat =[self cleanRepeatModel:model];
        if (repeat){
            
            [self loadTipLabelview:YES];
            self.tipLabel.text = @"该音频已经下载";
            
            
         return;
            
        }
        
        [viewCtrl startDownloadWith:model videoPath:model.videoPath isBegin:YES];
        
        
    };
    [playinfo start];
    
    
}
//倍速
- (void)audioPlayViewRateAction{
    
    CGFloat speed;
    if (self.audioView.rateBtn.tag % 4 ==0) {
        
        speed =1.0;
    }
    
    if (self.audioView.rateBtn.tag % 4 ==1) {
        
        speed =1.5;
    }
    
    if (self.audioView.rateBtn.tag % 4 ==2) {
        
        speed =2.0;
    }
    
    if (self.audioView.rateBtn.tag % 4 ==3) {
        
        speed =0.5;
    }
    
    [self.audioPlayer setAudioPlayerRate:speed];
    [self.audioView.rateBtn setTitle:[NSString stringWithFormat:@"倍速x%.1f",speed] forState:UIControlStateNormal];
    
    self.audioView.rateBtn.tag++;
}
//拖动
- (void)durationPlayViewSliderMoving{
    
    CGFloat seconds =self.audioView.audioSlider.value;
    CGFloat durationInSeconds = CMTimeGetSeconds([self.audioPlayer.player.currentItem duration]);
    
    CGFloat time = durationInSeconds * seconds;
    
    //让音频从指定的CMTime对象处播放
    [self.audioPlayer audioScrub:time];
    
}
//播放|暂停
- (void)playPlayViewBtnAction{
    
    self.audioView.playBtn.selected =!self.audioView.playBtn.selected;
    
    if (self.audioView.playBtn.selected) {
        
        [self.audioPlayer audioPause];
        
    }else{
        
        [self.audioPlayer audioPlay];
    }
    
}

//回退15s
- (void)fallbackPlayViewBtnAction{
    
    CGFloat seconds =CMTimeGetSeconds([self.audioPlayer.player currentTime]);
    
    [self.audioPlayer audioScrub:seconds-15.0f];
    
}

//前进15s
- (void)farwardPlayViewBtnAction{
    
    CGFloat seconds =CMTimeGetSeconds([self.audioPlayer.player currentTime]);
    
    [self.audioPlayer audioScrub:seconds+15.0f];
    
    
}

#pragma mark---DWAudioPlayerDelegate---
// 可播放／播放中
- (void)audioPlayerIsReadyToPlayVideo:(DWAudioPlayer *)audioPlayer{
    
    
    
}
//播放完毕
- (void)audioPlayerDidReachEnd:(DWAudioPlayer *)audioPlayer{
    
      [self nextButtonAction:nil];
    
}
//当前播放时间
- (void)audioPlayer:(DWAudioPlayer *)audioPlayer timeDidChange:(CGFloat )time{
    
     NSLog(@"音频播放时间____%f",time);
    
    if (!self.audioView.isAudioSlidering) {
        
        //当前播放
      //  CGFloat currentSec = CMTimeGetSeconds([self.audioPlayer.player currentTime]);
        self.audioView.playLabel.text =[DWTools formatSecondsToString:time];
        
        //总时长
        CGFloat totalSec =CMTimeGetSeconds([self.audioPlayer.player.currentItem duration]);
        self.audioView.totalLabel.text =[DWTools formatSecondsToString:totalSec];
        
        //进度条
        self.audioView.audioSlider.value =(float) time / totalSec;
    }
    
}
//duration 当前缓冲的长度
- (void)audioPlayer:(DWAudioPlayer *)audioPlayer loadedTimeRangeDidChange:(CGFloat )duration{
    
    NSLog(@"音频缓冲时间%f",duration);
    
    self.audioView.progressView.progress =duration / CMTimeGetSeconds([self.audioPlayer.player.currentItem duration]);
    
   
}
//进行跳转后没数据 即播放卡顿
- (void)audioPlayerPlaybackBufferEmpty:(DWAudioPlayer *)audioPlayer{
    
    NSLog(@"音频播放卡顿");
    
}
// 进行跳转后有数据 能够继续播放
- (void)audioPlayerPlaybackLikelyToKeepUp:(DWAudioPlayer *)audioPlayer{
    
    
     NSLog(@"音频能够继续播放");
    
}
//加载失败
- (void)audioPlayer:(DWAudioPlayer *)audioPlayer didFailWithError:(NSError *)error{
    
    NSLog(@"音频播放error:%@",error);
    
}


@end
