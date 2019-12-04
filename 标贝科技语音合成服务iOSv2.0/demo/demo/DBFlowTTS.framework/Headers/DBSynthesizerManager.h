//
//  DBSocketManager.h
//  DBTTSScocketSDK
//
//  Created by linxi on 2019/11/13.
//  Copyright © 2019 newbike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBSynthesizerRequestParam.h"
#import "DBFailureModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol DBSynthesizerDelegate <NSObject>

@required
/// 开始合成
- (void)onSynthesisStarted;

/// 流式持续返回数据的接口回调
/// @param index  数据块序列号，请求内容会以流式的数据块方式返回给客户端。服务器端生成，从1递增。

/// @param data 合成的音频数据，已使用base64加密，客户端需进行base64解密。
/// @param audioType 音频类型，如audio/pcm，audio/mp3。
/// @param interval 音频interval信息。
/// @param endFlag 是否时最后一个数据块，0：否，1：是。
- (void)onBinaryReceivedIndex:(NSInteger)index data:(NSData *)data audioType:(DBTTSAudioType)audioType interval:(NSString *)interval endFlag:(BOOL)endFlag;

/// 当onBinaryReceived方法中endFlag参数=1，即最后一条消息返回后，会回调此方法。
- (void)onSynthesisCompleted;

@optional

/// 合成失败 返回msg内容格式为：{"code":40000,"message":"…","trace_id":" 1572234229176271"}
- (void)onTaskFailed:(DBFailureModel *)failreModel;

@end

@interface DBSynthesizerManager : NSObject

@property(nonatomic,weak)id <DBSynthesizerDelegate> delegate;

///超时时间,默认30s
@property(nonatomic,assign)NSInteger  timeOut;

+ (DBSynthesizerManager *)instance;


- (void)setupClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret;


/**
 * @brief 设置SynthesizerRequestParam对象参数,返回值为0,表示设置参数成功
 */
-(NSInteger)setSynthesizerParams:(DBSynthesizerRequestParam *)requestParam;

/// 开始合成
- (void)start;
///  停止合成
- (void)stop;

@end



NS_ASSUME_NONNULL_END
