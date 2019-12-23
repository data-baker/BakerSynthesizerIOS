//
//  DBSynthesisPlayerManager.h
//  DBFlowTTS
//
//  Created by linxi on 2019/12/20.
//  Copyright © 2019 biaobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBTTSEnumerate.h"
#import "DBFailureModel.h"
#import "PCMDataPlayer.h"
#import "DBSynthesizerManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DBSynthesisPlayerDelegate <NSObject>

@required
/// 准备好了，可以开始播放了，回调
- (void)readlyToPlay;

/// 播放完成回调
- (void)playFinished;

@optional

/// 开始合成
- (void)onSynthesisStarted;

/// 流式持续返回数据的接口回调
/// @param data 合成的音频数据
/// @param audioType 音频类型
/// @param interval 音频interval信息。
/// @param endFlag 是否时最后一个数据块，0：否，1：是。
- (void)onBinaryReceivedData:(NSData *)data audioType:(DBTTSAudioType)audioType interval:(NSString *)interval endFlag:(BOOL)endFlag;

/// 合成完成，当onBinaryReceived方法中endFlag参数=1，即最后一条消息返回后，会回调此方法。
- (void)onSynthesisCompleted;

/// 合成和播放失败相关的回调 返回msg内容格式为：{"code":40000,"message":"…","trace_id":" 1572234229176271"}
- (void)onTaskFailed:(DBFailureModel *)failreModel;


/// 更新播放器的缓存进度
-  (void)updateBufferPositon:(float)bufferPosition;


/// 播放开始回调
- (void)playResumeIfNeed;

/// 播放暂停回调
- (void)playPausedIfNeed;


@end

@interface DBSynthesisPlayer : NSObject<DBPCMPlayDelegate,DBSynthesizerDelegate>

/// 持有的pcm播放器
@property(nonatomic,strong,nullable)PCMDataPlayer * pcmDataPlayer;

/// 设置audioType类型，默认为DBTTSAudioTypePCM16K
@property(nonatomic,assign)DBTTSAudioType  audioType;

/// 合成播放器的回调
@property(nonatomic,weak)id <DBSynthesisPlayerDelegate> delegate;

/// 当前的播放进度
@property(nonatomic,assign,readonly)NSInteger currentPlayPosition;

/// 音频总长度
@property(nonatomic,assign,readonly)NSInteger audioLength;
/// 当前的播放状态
@property(nonatomic,assign,readonly,getter=isPlayerPlaying)BOOL playerPlaying;

/// 是否准备好开始播放
@property(nonatomic,assign,readonly,getter=isReadyToPlay)BOOL readyToPlay;
/// 是否全部合成完成
@property(nonatomic,assign,readwrite,getter=isFinished)BOOL finished;

/// 开始播放
- (void)startPlay;

/// 暂停播放，暂停播放后可以继续播放
- (void)pausePlay;

/// 停止播放,停止播放后不能再继续播放
- (void)stopPlay;

/// 往播放器中追加数据
- (void)appendData:(NSData *)data totalDatalength:(float)length endFlag:(BOOL)endflag;

@end

NS_ASSUME_NONNULL_END
