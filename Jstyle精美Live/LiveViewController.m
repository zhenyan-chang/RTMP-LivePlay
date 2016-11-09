//
//  LiveViewController.m
//  Jstyle精美Live
//
//  Created by 精美 on 16/9/7.
//  Copyright © 2016年 zhenyan_C. All rights reserved.
//

#import "LiveViewController.h"
#import "Masonry.h"
#import "CZYNavigationViewController.h"
#import "LFLiveSession.h"
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height)
@interface LiveViewController ()<LFLiveSessionDelegate>

@property (nonatomic, assign) BOOL isPortrait;
@property (nonatomic, strong) LFLiveSession * session;
@property (nonatomic, strong) LFLiveStreamInfo *streamInfo;

//美颜
@property (nonatomic, assign) UIButton *beautyButton;

//切换前后摄像头
@property (nonatomic, strong) UIButton *cameraButton;

// 状态
@property (weak, nonatomic) UILabel *statusLabel;

//关闭
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic) int CorssInt;
@end
static int padding = 30;
@implementation LiveViewController

#pragma mark - Override
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.session stopLive];
    self.session = nil;
}
- (LFLiveSession*)session {
    if (!_session) {
        if (self.CorssBool == YES) {
            if (self.kbpsInt == 0) {
                _session = [[LFLiveSession alloc]initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfigurationForQuality: LFLiveAudioQuality_Medium] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_High1 orientation:UIInterfaceOrientationLandscapeRight ] liveType:LFLiveRTMP];
            }else if (self.kbpsInt == 1){
                 _session = [[LFLiveSession alloc]initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfigurationForQuality: LFLiveAudioQuality_Medium] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_High2 orientation:UIInterfaceOrientationLandscapeRight ] liveType:LFLiveRTMP];
            }else if (self.kbpsInt == 2){
                _session = [[LFLiveSession alloc]initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfigurationForQuality: LFLiveAudioQuality_Medium] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_High3 orientation:UIInterfaceOrientationLandscapeRight ] liveType:LFLiveRTMP];
            }
        }else{
            if (self.kbpsInt == 0) {
                _session = [[LFLiveSession alloc]initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfigurationForQuality: LFLiveAudioQuality_Medium] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_High1 orientation:UIInterfaceOrientationPortrait ] liveType:LFLiveRTMP];
            }else if (self.kbpsInt == 1){
                _session = [[LFLiveSession alloc]initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfigurationForQuality: LFLiveAudioQuality_Medium] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_High2 orientation:UIInterfaceOrientationPortrait ] liveType:LFLiveRTMP];
            }else if (self.kbpsInt == 2){
                _session = [[LFLiveSession alloc]initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfigurationForQuality: LFLiveAudioQuality_Medium] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_High3 orientation:UIInterfaceOrientationPortrait ] liveType:LFLiveRTMP];
            }
        }
        _session.running = YES;
        _session.preView = self.view;
        _session.delegate = self;
    }
    return _session;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     *  这种强制旋转方式尽量不要使用 NavigationController 自带的返回按钮（因为需要在页面关闭前将方向复原）
     *
     *  而且旋转动画也有一点点瑕疵，不是很建议使用这种方式，需求场景能不使用强制旋转就尽量不要使用吧，特殊场景的话酌情考虑
     */
    self.navigationController.navigationBarHidden = YES;
       [self setUpAll];
    
    if (self.CorssBool == NO) {
        self.isPortrait = NO;
    }else{
        self.isPortrait = YES;
    }
    [self forceRotationButtonClicked];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)setUpAll
{
    // 美颜按钮
    [self setUpBeautyButton];
    // 切换摄像头
    [self setUpCameraButton];
    
    // 状态显示框
    [self setUpStatusLabel];
    // 关闭直播
    [self setUpCloseButton];
    
    [self aaaaa];
    [self startShow];
    
}
-(void)startShow
{
    LFLiveStreamInfo *streamInfo = [LFLiveStreamInfo new];
    _streamInfo = streamInfo;
    _streamInfo.url = @"自己直播服务器地址";
    [self.session startLive:_streamInfo];
}
-(void)setUpBeautyButton
{
    //位置
    UIButton *beautyButton = [[UIButton alloc]initWithFrame:CGRectMake(padding, padding, padding, padding)];
    _beautyButton = beautyButton;
    [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty_close"] forState:UIControlStateSelected];
    [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty"] forState:UIControlStateNormal];
    _beautyButton.exclusiveTouch = YES;
    [_beautyButton addTarget:self action:@selector(beautifulFaceSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_beautyButton];
}

-(void)setUpCameraButton
{
    //位置
    UIButton *cameraButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - padding * 4, padding, padding, padding)];
    _cameraButton = cameraButton;
    [_cameraButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
    _cameraButton.exclusiveTouch = YES;
    [_cameraButton addTarget:self action:@selector(cameraSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cameraButton];
    
}
-(void)setUpCloseButton
{
    //位置
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - padding * 2, padding, padding, padding)];
    _closeButton = closeButton;
    [_closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
    _closeButton.exclusiveTouch = YES;
    [_closeButton addTarget:self action:@selector(closeShow:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
}
-(void)setUpStatusLabel
{
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding * 3, padding, padding * 5, padding)];
    _statusLabel = statusLabel;
    _statusLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_statusLabel];
    
}


#pragma mark - View Action

- (void)backButtonClicked
{
    if (!self.isPortrait)
    {
        [self forcePortrait];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)forceRotationButtonClicked
{
    if (self.isPortrait)
    {
        [self setIsPortrait:NO];
        [self forceLandscapeLeft];
    }
    else
    {
        [self setIsPortrait:YES];
        [self forcePortrait];
    }
}

- (void)beautifulFaceSwitch:(UIButton *)sender {
    sender.selected = !sender.selected;
    _session.beautyFace = !_session.beautyFace;
}
- (void)cameraSwitch:(UIButton *)sender {
    _session.captureDevicePosition = _session.captureDevicePosition == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
}
-(void)closeShow:(UIButton *)sender{
    if (!_session) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.session stopLive];
        [self dismissViewControllerAnimated:YES completion:nil];
        if (!self.isPortrait)
        {
            [self forcePortrait];
            [self.navigationController popViewControllerAnimated:NO];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

#pragma mark - LFLiveSessionDelegate
- (void)liveSession:(LFLiveSession *)session liveStateDidChange:(LFLiveState)state {
    NSString * hints = nil;
    switch (state) {
        case LFLiveReady:
            hints = @"准备中";
            break;
        case LFLivePending:
            hints = @"连接中";
            break;
        case LFLiveStart:
            hints = @"已连接";
            break;
        case LFLiveStop:
            hints = @"已断开";
            break;
        case LFLiveError:
            hints = @"连接出错";
            break;
        default:
            hints = @"未知状态";
            break;
    }
    _statusLabel.text = [NSString stringWithFormat:@"状态: %@", hints];
}


#pragma mark - Private

/**
 *  强制右横屏
 */
- (void)forceLandscapeLeft
{
    [(CZYNavigationViewController *)self.navigationController changeSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscapeRight];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

/**
 *  强制竖屏
 */
- (void)forcePortrait
{
    [(CZYNavigationViewController *)self.navigationController changeSupportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


-(void)aaaaa
{
    [_beautyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(30);
        //        make.right.equalTo(self.view).with.offset(-30);
        make.top.equalTo(self.view).with.offset(11);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(_beautyButton.mas_height).multipliedBy(1);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_beautyButton.mas_right).with.offset(30);
        //        make.right.equalTo(self.view).with.offset(-30);
        make.top.equalTo(self.view).with.offset(11);
        make.height.mas_equalTo(40);
    }];
    
    [_cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusLabel.mas_right).with.offset(30);
        //        make.right.equalTo(self.view).with.offset(-30);
        make.top.equalTo(self.view).with.offset(11);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(_cameraButton.mas_height).multipliedBy(1);
        
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cameraButton.mas_right).with.offset(30);
        make.right.equalTo(self.view).with.offset(-30);
        make.top.equalTo(self.view).with.offset(11);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(_closeButton.mas_height).multipliedBy(1);
        
    }];
    
}
@end
