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

 NSString * textViewText = @"很久以前，在波斯国的某城市里住着兄弟俩，哥哥叫戈西母，弟弟叫阿里巴巴。父亲去世后，他俩各自分得了有限的一点财产，分家自立，各谋生路。不久银财便花光了，生活日益艰难。为了解决吃穿，糊口度日，兄弟俩不得不日夜奔波，吃苦耐劳。　后来戈西母幸运地与一个富商的女儿结了婚，他继承了岳父的产业，开始走上做生意的道路。由于生意兴隆，发展迅速，戈西母很快就成为远近闻名的大富商了。　阿里巴巴娶了一个穷苦人家的女儿，夫妻俩过着贫苦的生活。全部家当除了一间破屋外，就只有三匹毛驴。阿里巴巴靠卖柴禾为生，每天赶着毛驴去丛林中砍柴，再驮到集市去卖，以此维持生活。";
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
    [_synthesizerManager setupClientId:@"e2d17fce-f69a-4b78-bbe5-7fef824a77c2" clientSecret:@"ZTZlOTMyMzAtMThlZS00M2ZjLWJhMTktYTQ2NjBhZTE3Yzk0"];
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
    // 设置播放器的audioType
    _synthesisDataPlayer.audioType = _synthesizerPara.audioType;
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
    // 重置播放器状态
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



// MARK: DBSynthesizerDelegate
- (void)onPrepared {
    [self appendLogMessage:@"准备就绪"];
}

- (void)onSynthesisCompleted {
    [self appendLogMessage:@"合成完成"];
}

- (void)onSynthesisStarted {
    [self appendLogMessage:@"开始合成"];

}
- (void)onBinaryReceivedData:(NSData *)data audioType:(DBTTSAudioType)audioType interval:(NSString *)interval endFlag:(BOOL)endFlag {
    [self appendLogMessage:@"收到合成回调的数据"];
}

- (void)onTaskFailed:(DBFailureModel *)failreModel  {
    NSLog(@"合成失败 %@",failreModel);
    [self appendLogMessage:@"合成失败"];
}

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
}

- (void)playResumeIfNeed  {
    self.playButton.selected = YES;
}

- (void)updateBufferPositon:(float)bufferPosition {
    [self appendLogMessage:[NSString stringWithFormat:@"buffer 进度 %.0f%%",bufferPosition*100]];
}
- (void)palyerCallBackFaiure:(DBFailureModel *)failureModel {
    [self appendLogMessage:[NSString stringWithFormat:@"error code:%@,error message:%@",@(failureModel.code),failureModel.message]];

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
