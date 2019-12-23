//
//  DBTTSEnumerate.h
//  WebSocketDemo
//
//  Created by linxi on 2019/11/14.
//  Copyright © 2019 newbike. All rights reserved.
//

#ifndef DBTTSEnumerate_h
#define DBTTSEnumerate_h

typedef NS_ENUM(NSUInteger, DBTTSAudioType){
    DBTTSAudioTypePCM16K=4, // 返回16K采样率的pcm格式
    DBTTSAudioTypePCM8K, // 返回8K采样率的pcm格式
};

typedef NS_ENUM(NSUInteger, DBTTSRate) {
    DBTTSRate8k = 1,
    DBTTSRate16k,
};

typedef NS_ENUM(NSUInteger,DBlanguageType) {
    DBlanguageTypeChinese, // 中文
    DBlanguageTypeEnglish // 英文
};

typedef NS_ENUM(NSUInteger,DBErrorFailedCode) {
    DBErrorFailedCodeInitial = 90001, // 合成SDK初始化失败
    DBErrorFailedCodeText = 90002, // 合成文本内容为空
    DBErrorFailedCodeParameters = 90003, // 参数格式错误
    DBErrorFailedCodeResultParse = 90004, // 返回结果解析错误
    DBErrorFailedCodeSynthesis = 90005, // 合成失败，失败信息相关错误
    DBPlayerError = 90006, // 播放器相关错误
    //**********服务端返回的错误*********//
    DBErrorFailedCodeAccessToken = 10001, // access_token参数获取失败或未传输
    DBErrorFailedCodeDomin = 10002, //domain参数值错误
    DBErrorFailedCodeLanguage =10003, //language参数错误
    DBErrorFailedCodeVoiveName = 10004, // voiceName参数错误
    DBErrorFailedCodeAudioType = 10005, // audioType 参数错误
    DBErrorFailedCodeRate = 10006, // rate参数错误
    DBErrorFailedCodeIdx = 10007, // idx错误
    DBErrorFailedCodeSingle = 10008, // single错误
    DBErrorFailedCodeTextSever = 10009, // text参数错误
    DBErrorFailedCodeTextLong = 10010, //文本太长
    DBErrorFailedCodeGetResource = 20000, //获取资源错误
    DBErrorFailedCodeAssertText = 20001, //断句失败
    DBErrorFailedCodeSegmentTation = 20002 ,// 分段数错误
    DBErrorFailedCodeSegmentTationText = 20003, //分段后的文本长度错误
    DBErrorFailedCodeEngineLink = 20004, // 获取引擎链接错误
    DBErrorFailedCodeRPC = 20005, //RPC链接错误
    DBErrorFailedCodeEngineInner = 20006,// 引擎内部错误
    DBErrorFailedCodeRedis = 20007, // 操作redis错误
    DBErrorFailedCodeAudioEncode = 20008,// 音频编码错误
    DBErrorFailedCodeAuthor = 30000,//鉴权错误
    DBErrorFailedCodeConcurrency = 30001,// 并发错误
    DBErrorFailedCodeInnerConfigure = 30002,// 内部配置错误
    DBErrorFailedCodeParseJSON = 30003, // json串解析错误
    DBErrorFailedCodeGetUrl = 30004,// 获取url错误
    DBErrorFailedCodeGetIP = 30005,// 获取客户ip错误
    DBErrorFailedCodeTaskQueue = 30006,// 任务队列错误
    DBErrorFailedCodeJsonStruct = 40001, //请求不是json结构
    DBErrorFailedCodeLackRequireFied = 40002,// 缺少必须字段
    DBErrorFailedCodeVersion = 40003,// 版本错误
    DBErrorFailedCodeFiedType = 40004,//字段类型错误
    DBErrorFailedCodeFiedError = 40005,// 参数错误
    
    
};




#endif /* DBTTSEnumerate_h */
