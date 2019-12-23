//
//  ViewController.m
//  WebSocketDemo
//
//  Created by linxi on 19/11/6.
//  Copyright © 2017年 newbike. All rights reserved.
//

#import "ViewController.h"
#import <DBFlowTTS/DBSynthesizerManager.h>
#import <DBFlowTTS/DBSynthesisPlayer.h>
#import <AVFoundation/AVFoundation.h>

 NSString * textViewText = @"标贝（北京）科技有限公司专注于智能语音交互，包括语音合成整体解决方案，并提供语音合成、语音识别、图像识别等人工智能数据服务。帮助客户实现数据价值，以推动技术、应用和产业的创新。帮助企业盘活大数据资源，挖掘数据中有价值的信息  。主要提供智能语音交互相关服务，包括语音合成整体解决方案，以及语音合成、语音识别、图像识别等人工智能数据服务。 标贝科技在范围内有数据采集、处理团队，可以满足在不同地区收集数据的需求。以语音数据为例，可采集、加工普通话、英语、粤语、日语、韩语及方言等各类数据，以支持客户进行语音合成或者语音识别系统的研发工作";
;

@interface ViewController ()<DBSynthesisPlayerDelegate,UITextViewDelegate>
/// 合成管理类
@property(nonatomic,strong)DBSynthesizerManager * synthesizerManager;
/// 合成需要的参数
@property(nonatomic,strong)DBSynthesizerRequestParam * synthesizerPara;
/// 展示文本的textView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong)NSMutableString * textString;

/// 播放器设置
@property(nonatomic,strong)DBSynthesisPlayer * synthesisDataPlayer;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
/// 展示回调状态
@property (weak, nonatomic) IBOutlet UITextView *displayTextView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textString = [textViewText mutableCopy];
    self.displayTextView.text = @"";
    [self addBorderOfView:self.textView];
    [self addBorderOfView:self.displayTextView];
    self.textView.text = textViewText;
    _synthesizerManager = [DBSynthesizerManager instance];
    //设置打印日志
     _synthesizerManager.log = NO;
    // TODO:请联系标贝科技公司获取
//    [_synthesizerManager setupClientId:@"" clientSecret:@""];
    // 设置播放器
    _synthesisDataPlayer = [[DBSynthesisPlayer alloc]init];
    _synthesisDataPlayer.delegate = self;
    // 将初始化的播放器给合成器持有
    self.synthesizerManager.synthesisDataPlayer = self.synthesisDataPlayer;
}

// MARK: IBActions

- (IBAction)startAction:(id)sender {
    // 先清除之前的数据
    [self resetPlayState];
    self.displayTextView.text = @"";
    if (!_synthesizerPara) {
        _synthesizerPara = [[DBSynthesizerRequestParam alloc]init];
    }
    _synthesizerPara.audioType = DBTTSAudioTypePCM16K;
    _synthesizerPara.text = self.textView.text;
    _synthesizerPara.voice = @"标准合成_模仿儿童_果子";
    // 设置合成参数
    NSInteger code = [self.synthesizerManager setSynthesizerParams:self.synthesizerPara];
    if (code == 0) {
        // 开始合成
        [self.synthesizerManager start];
    }
}
- (IBAction)closeAction:(id)sender {
    // 停止合成
    [self.synthesizerManager stop];
    [self resetPlayState];
    self.displayTextView.text = @"";

}
///  重置播放器播放控制状态
- (void)resetPlayState {
    if (self.playButton.isSelected) {
        self.playButton.selected = NO;
    }
    [self.synthesisDataPlayer stopPlay];
}

- (IBAction)playAction:(UIButton *)sender {
    if (self.synthesisDataPlayer.isReadyToPlay && self.synthesisDataPlayer.isPlayerPlaying == NO) {
        [self.synthesisDataPlayer startPlay];
    }else {
        [self.synthesisDataPlayer pausePlay];
    }
}
- (IBAction)currentPlayPosition:(id)sender {
    NSString *position = [NSString stringWithFormat:@"播放进度 %@",[self timeDataWithTimeCount:self.synthesisDataPlayer.currentPlayPosition]];
    [self appendLogMessage:position];
}
- (IBAction)getAudioLength:(id)sender {
    NSString *audioLength = [NSString stringWithFormat:@"音频数据总长度 %@",[self timeDataWithTimeCount:self.synthesisDataPlayer.audioLength]];
    [self appendLogMessage:audioLength];
}
- (IBAction)playState:(id)sender {
    NSString *message;
    if (self.synthesisDataPlayer.isPlayerPlaying) {
        message = @"正在播放";
    }else {
        message = @"播放暂停";
    }
    [self appendLogMessage:message];
}



// MARK: 合成播放器相关的回调
/*
- (void)onPrepared {
//    [self appendLogMessage:@"准备就绪"];
}

- (void)onSynthesisCompleted {
//    [self appendLogMessage:@"合成完成"];
}

- (void)onSynthesisStarted {
//    [self appendLogMessage:@"开始合成"];

}
- (void)onBinaryReceivedData:(NSData *)data audioType:(DBTTSAudioType)audioType interval:(NSString *)interval endFlag:(BOOL)endFlag {
//    [self appendLogMessage:@"收到合成回调的数据"];
}
*/


//MARK:  UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:textViewText]&&textView == self.textView) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
    }
    if (self.displayTextView.isFirstResponder) {
        [self.displayTextView resignFirstResponder];
    }
}

//MARK: player Delegate

- (void)readlyToPlay {
    [self appendLogMessage:@"准备就绪"];
    [self playAction:self.playButton];
}

- (void)playFinished {
    [self resetPlayState];
    [self appendLogMessage:@"播放结束"];
    self.playButton.selected = NO;

}

- (void)playPausedIfNeed {
    self.playButton.selected = NO;
    [self appendLogMessage:@"暂停"];
}

- (void)playResumeIfNeed  {
    self.playButton.selected = YES;
    [self appendLogMessage:@"播放"];

}

- (void)updateBufferPositon:(float)bufferPosition {
    [self appendLogMessage:[NSString stringWithFormat:@"buffer 进度 %.0f%%",bufferPosition*100]];
}

- (void)onTaskFailed:(DBFailureModel *)failreModel  {
    NSLog(@"失败 %@",failreModel);
//    [self appendLogMessage:@"合成失败"];
}


// MARK: Private Methods

- (void)addBorderOfView:(UIView *)view {
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.f;
    view.layer.masksToBounds =  YES;
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString *)timeDataWithTimeCount:(CGFloat)timeCount {
    long audioCurrent = ceil(timeCount);
    NSString *str = nil;
    if (audioCurrent < 3600) {
        str =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(audioCurrent/60.f)),lround(floor(audioCurrent/1.f))%60];
    } else {
        str =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(audioCurrent/3600.f)),lround(floor(audioCurrent%3600)/60.f),lround(floor(audioCurrent/1.f))%60];
    }
    return str;
    
}

- (void)appendLogMessage:(NSString *)message {
    NSString *text = self.displayTextView.text;
    NSString *appendText = [text stringByAppendingString:[NSString stringWithFormat:@"\n%@",message]];
    self.displayTextView.text = appendText;
    [self.displayTextView scrollRangeToVisible:NSMakeRange(self.displayTextView.text.length, 1)];
}


@end
