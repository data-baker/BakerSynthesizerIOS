//
//  ViewController.m
//  WebSocketDemo
//
//  Created by linxi on 19/11/6.
//  Copyright © 2017年 newbike. All rights reserved.
//

#import "ViewController.h"
#import <DBFlowTTS/DBSynthesizerManager.h>
#import <AVFoundation/AVFoundation.h>
#import "NLSPlayAudio.h"


const  NSInteger temPacket = 3200;

static NSString * textViewText = @"你好啊，这是默认要合成的文本。";

@interface ViewController ()<DBSynthesizerDelegate,UITextViewDelegate,NLSPlayAudioDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/// 合成管理类
@property(nonatomic,strong)DBSynthesizerManager * synthesizerManager;

/// 合成需要的参数
@property(nonatomic,strong)DBSynthesizerRequestParam * synthesizerPara;


@property (weak, nonatomic) IBOutlet UITextView *textView;

@property(nonatomic,strong) NLSPlayAudio *nlsAudioPlayer;

@property(nonatomic,strong)NSMutableString * textString;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBorderOfView:self.tableView];
    [self addBorderOfView:self.textView];
    self.textView.text = textViewText;
    _synthesizerManager = [DBSynthesizerManager instance];
    _synthesizerManager.delegate = self;
    // 请联系标贝公司获取
  [self.synthesizerManager setupClientId:@"" clientSecret:@""];
}

// MARK: IBActions

- (IBAction)startAction:(id)sender
{
    
    //2.1 初始化语音播放类
    if (_nlsAudioPlayer != NULL) {
        [_nlsAudioPlayer cleanup];
        _nlsAudioPlayer = NULL;
        _nlsAudioPlayer.delegate = nil;
    }
    _nlsAudioPlayer = [[NLSPlayAudio alloc]init];
    _nlsAudioPlayer.delegate = self;
    // 设置合成参数
    
    if (_synthesizerPara != NULL) {
        _synthesizerPara = NULL;
    }
    _synthesizerPara = [[DBSynthesizerRequestParam alloc]init];
    _synthesizerPara.audioType = DBTTSAudioTypePCM16K;
    _synthesizerPara.text = self.textView.text;
    _synthesizerPara.voice = @"标准合成_模仿儿童_果子";
    NSInteger code = [self.synthesizerManager setSynthesizerParams:self.synthesizerPara];
    if (code == 0) {
        [self.synthesizerManager start];
    }
    
}

- (IBAction)closeAction:(id)sender {
    if (_nlsAudioPlayer != NULL) {
        [_nlsAudioPlayer cleanup];
        _nlsAudioPlayer = NULL;
        _nlsAudioPlayer.delegate = nil;
    }
    [self.synthesizerManager stop];
    
}

// MARK: DBSynthesizerDelegate
- (void)onSynthesisCompleted {
    [_nlsAudioPlayer finishFeed:NO];
  
}

- (void)onSynthesisStarted {
}

- (void)onBinaryReceivedIndex:(NSInteger)index data:(NSData *)data audioType:(DBTTSAudioType)audioType interval:(NSString *)interval endFlag:(BOOL)endFlag {
    if (data) {
        [_nlsAudioPlayer process:(Byte *)[data bytes] length:data.length];
    }

}

- (void)onTaskFailed:(DBFailureModel *)failreModel  {
    NSLog(@"合成失败 %@",failreModel);
}

//MARK:  UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:textViewText]) {
        textView.text = @"";
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
    }
}

//MARK: player Delegate

- (void)playDone {
    //播放结束的回调
       
}


// MARK: Private Methods

- (void)addBorderOfView:(UIView *)view {
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.f;
    view.layer.masksToBounds =  YES;
}



@end
