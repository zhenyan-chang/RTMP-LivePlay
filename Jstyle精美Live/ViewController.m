//
//  ViewController.m
//  Jstyle精美Live
//
//  Created by 精美 on 16/9/7.
//  Copyright © 2016年 zhenyan_C. All rights reserved.
//

#import "ViewController.h"
#import "LiveViewController.h"
#import <AVFoundation/AVFoundation.h>
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height)
@interface ViewController ()
@property (nonatomic, strong) UITextField *homeTextField;
@property (nonatomic, strong) UISegmentedControl *CrossBtn;
@property (nonatomic, strong) UISegmentedControl *kbpsBtn;

@property (nonatomic) int intFouse;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"精美直播";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *screenLab = [[UILabel alloc]initWithFrame:CGRectMake(11, 70, 130, 44)];
    screenLab.text = @"请选择拍摄方式:";
    [self.view addSubview:screenLab];
    
    UILabel *kbpsLab = [[UILabel alloc]initWithFrame:CGRectMake(11, 130, 130, 44)];
    kbpsLab.text = @"请选择分辨率:";
    [self.view addSubview:kbpsLab];
    
    UILabel *homeLab = [[UILabel alloc]initWithFrame:CGRectMake(11, 190, 130, 44)];
    homeLab.text = @"请输入房间号:";
    [self.view addSubview:homeLab];
    
    _CrossBtn = [[UISegmentedControl alloc]initWithItems:@[@"横屏",@"竖屏"]];
    _CrossBtn.frame = CGRectMake(170, 75, kScreenWidth - 200, 34);
    [_CrossBtn addTarget:self action:@selector(crossAction) forControlEvents:UIControlEventValueChanged];
    _CrossBtn.selectedSegmentIndex = 0;
    [self.view addSubview:_CrossBtn];
    
    _kbpsBtn = [[UISegmentedControl alloc]initWithItems:@[@"低",@"中",@"高"]];
    _kbpsBtn.frame = CGRectMake(170, 135, kScreenWidth - 180, 34);
    [_kbpsBtn addTarget:self action:@selector(kbpsAction) forControlEvents:UIControlEventValueChanged];
    _kbpsBtn.selectedSegmentIndex = 1;
    _intFouse = 1;
    [self.view addSubview:_kbpsBtn];
    
    _homeTextField = [[UITextField alloc]initWithFrame:CGRectMake(145, 190, kScreenWidth - 155, 44)];
    _homeTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_homeTextField];
    
    
    UIButton *liveBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 100)/2, 400, 100, 44)];
    liveBtn.backgroundColor = [UIColor redColor];
    [liveBtn setTitle:@"开启直播" forState:UIControlStateNormal];
    [liveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    liveBtn.alpha = 0.5;
    [liveBtn addTarget:self action:@selector(startShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:liveBtn];
    
}

-(void)startShow
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请在iPhone的“设置”-“隐私”-“相机”功能中,找到“精美”打开相机访问权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        
        [alert show];
        return;
    }

    LiveViewController *liveVC = [[LiveViewController alloc]init];
    // 横竖屏
    if (_CrossBtn.selectedSegmentIndex == 0) {
        liveVC.CorssBool = YES;
    }else{
        liveVC.CorssBool = NO;
    }
    
    // 分辨率
    if (_intFouse == 0) {
        liveVC.kbpsInt = 0;
    }else if (_intFouse == 1){
        liveVC.kbpsInt = 1;
    }else if (_intFouse == 2){
        liveVC.kbpsInt = 2;
    }
    liveVC.homeNum = _homeTextField.text;
    [self.navigationController pushViewController:liveVC animated:YES];
}

-(void)crossAction
{
    if (_CrossBtn.selectedSegmentIndex == 0) {
        _CrossBtn.selectedSegmentIndex = 0;
    }else{
        _CrossBtn.selectedSegmentIndex = 1;
    }
}

-(void)kbpsAction
{
    if (_kbpsBtn.selectedSegmentIndex == 0) {
        _intFouse = 0;
    }else if (_kbpsBtn.selectedSegmentIndex == 1)
    {
        _intFouse = 1;
    }else if (_kbpsBtn.selectedSegmentIndex == 2)
    {
        _intFouse = 2;
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_homeTextField resignFirstResponder];
}



@end
