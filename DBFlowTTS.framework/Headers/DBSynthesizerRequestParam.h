//
//  DBSynthesizerRequestParam.h
//  WebSocketDemo
//
//  Created by linxi on 2019/11/14.
//  Copyright © 2019 newbike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBTTSEnumerate.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBSynthesizerRequestParam : NSObject

/// 根据接口获取到的token
@property(nonatomic,copy)NSString * token;

/// 设置发音人声音名称，默认：标准合成_模仿儿童_果子
@property(nonatomic,copy)NSString * voice;

/// 设置要转为语音的合成文本
@property(nonatomic,copy)NSString * text;

/// 合成请求文本的语言，目前支持ZH(中文和中英混)和ENG(纯英文，中文部分不会合成),默认：ZH
@property(nonatomic,assign)DBlanguageType language;

/// 设置播放的语速，在0～9之间（支持浮点值），不传时默认为5
@property(nonatomic,copy)NSString * speed;

/// 设置语音的音量，在0～9之间（只支持整型值），不传时默认值为5
@property(nonatomic,copy)NSString * volume;

/// 设置语音的音调，取值0-9，不传时默认为5中语调
@property(nonatomic,copy)NSString * pitch;

///  根据类型指定audioType
@property(nonatomic,assign)DBTTSAudioType audioType;

/// 可不填，不填时默认为2，取值范围1-8，2以上的值仅针对返回MP3格式，
@property(nonatomic,assign)DBTTSRate  rate;


/// 设置是否返回时间戳内容。true=支持返回，false=不需要返回。不设置默认为false不返回。
@property(nonatomic,assign)BOOL  enableTimestamp;

/// 私有化部署的服务器url地址。
@property(nonatomic,copy)NSString * url;






@end

NS_ASSUME_NONNULL_END
