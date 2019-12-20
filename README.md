# 标贝科技语音合成服务iOS SDK使用说明文档（2.1）


## 1.XCode集成Framework（参考demo） 


1. 将framework添加到项目project的目录下面。
2. 在viewController中引用SDK的头文件；

```
#import <DBFlowTTS/DBSynthesizerManager.h>// 合成器的头文件
#import <DBFlowTTS/DBSynthesisPlayer.h> //合成播放器的头文件
```

3. 实例化DBSynthesisPlayer相关：

```
     _synthesizerManager.delegate = self;
``` 
4. 在代理的回调中处理相关的逻辑，回传数据或者处理异常;

## 2.SDK关键类

1. DBSynthesizerManager.h：语音合成关键业务处理类，全局只需一个实例即可,并且需要注册自己为该类的回调对象；
1. DBSynthesisPlayer.h 合成播放器类，这里包含播放器的状态回调以及合成数据的回调,（如果使用该player需要将该player赋值给DBSynthesizerManager的实例持有）
1. DBSynthesizerRequestParam.h：设置合成需要的相关参数，按照如下的接口文档设置即可；
1. DBFailureModel.h：请求异常的回调类，包含错误码，错误信息，和错误的trace_id。
1. DBTTSEnumerate.h：sdk全局的枚举类；

## 3.调用说明
1. 初始化DBSynthesizerManager类，得到DBSynthesizerManager的实例。
1. 实例化DBSynthesisPlayer类，将实例对象给DBSynthesizerManager的实例对象持有，就可以处理播放器相关的回调资源；（如果不设置该player，那么回调播放器相关的逻辑将不会执行,可以通过合成的回调协议，只处理合成相关的回调状态）
1. 设置DBSynthesizerRequestParam合成参数，包括必填参数和非必填参数
1. 调用DBSynthesizerManager.start()方法开始与云端服务连接；
1. 在业务完全处理完毕，或者页面关闭时，调DBSynthesizerManager.stop结束websocket服务，释放资源，调用synthesisDataPlayer的stop，释放播放器相关资源，并处理相关的UI状态；

```
播放器说明：
属性：

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

控制相关：
// 初始化播放器，audioType;包含16k，和8k两张采样率
- (void)startPlay; // 开始播放
- (void)pausePlay; //暂停播放
- (void)stopPlay; // 停止播放
```

## 4.参数说明
### 4.1基本参数说明
| 参数 | 参数名称 |是否必填|说明|
|--------|--------|--------|--------|
|  clientId  |  clientId | 是|初始化sdk的clientId    |
|clientSecret|	clientSecret|	是|	初始化sdk的clientSecret|
|setText	|合成文本	|是	|设置要转为语音的合成文本|
|setBakerCallback|	数据回调方法|	是	|设置返回数据的callback|
|setVoice	|发音人	|是	|设置发音人声音名称，默认：标准合成_模仿儿童_果子|
|setLanguage|	合并文本语言类型|	否	|合成请求文本的语言，目前支持ZH(中文和中英混)和ENG(纯英文，中文部分不会合成),默认：ZH
|setSpeed	|语速	|否|	设置播放的语速，在0～9之间（支持浮点值），不传时默认为5
|setVolume|	音量|	否	|设置语音的音量，在0～9之间（只支持整型值），不传时默认值为5|
|setPitch	|音调|	否	|设置语音的音调，取值0-9，不传时默认为5中语调|
|setAudioType|	返回数据文件格式	|否	|"可不填，不填时默认为4audiotype=4 ：返回16K采样率的pcm格式audiotype=5 ：返回8K采样率的pcm格式 |


### 4.2 BakerCallback 回调类方法说明

| 参数 | 参数名称 |说明|
|--------|--------|--------|
|onSynthesisStarted	|开始合成	|开始合成|
|onBinaryReceived|流式持续返回数据的接口回调|idx  数据块序列号，请求内容会以流式的数据块方式返回给客户端。服务器端生成，从1递增。data 合成的音频数据;audioType  音频类型，如pcm、wav。interval  音频interval信息，可能为空。endFlag  是否时最后一个数据块，false：否，true：是。|
|onSynthesisCompleted|	合成完成。	|当onBinaryReceived方法中endFlag参数=true，即最后一条消息返回后，会回调此方法。|
|onTaskFailed	|合成失败	|返回msg内容格式为：{"code":40000,"message":"…","trace_id":" 1572234229176271"} trace_id是引擎内部合成任务ID。|

### 4.3 DBSynthesisPlayerDelegate 回调类方法说明

| 参数 | 参数名称 |说明|
|--------|--------|--------|
|onSynthesisStarted	|开始合成	|开始合成|
|onBinaryReceived|流式持续返回数据的接口回调|idx  数据块序列号，请求内容会以流式的数据块方式返回给客户端。服务器端生成，从1递增。data 合成的音频数据;audioType  音频类型，如pcm、wav。interval  音频interval信息，可能为空。endFlag  是否时最后一个数据块，false：否，true：是。|
|onSynthesisCompleted|	合成完成。	|当onBinaryReceived方法中endFlag参数=true，即最后一条消息返回后，会回调此方法。|
|onTaskFailed	|合成失败	|返回msg内容格式为：{"code":40000,"message":"…","trace_id":" 1572234229176271"} trace_id是引擎内部合成任务ID。|
|readlyToPlay|	播放器准备就绪	|此时可以调起播放器进行播放|
|playFinished|	播放完成|	播放结束回调|
|playPausedIfNeed|	播放暂停|	播放暂停回调|
|playResumeIfNeed|	播放继续|	播放继续回调|
|updateBufferPositon|	更新播放buffer进度|	更新播放器buffer进度回调|


### 4.3失败时返回的code对应表
#### 4.3.1失败时返回的msg格式
| 参数 | 类型 |描述|
|--------|--------|--------|
|code	|int	|错误码9xxxx表示SDK相关错误，1xxxx参数相关错误，2xxxx合成引擎相关错误，3xxxx授权及其他错误|
|message	|string|	错误描述|
|trace_id	|string	|引擎内部合成任务id|

#### 4.3.2 对应code值：
| 错误码 | 含义 |
|--------|--------|
|90001	|合成SDK初始化失败|
|90002	|合成文本内容为空|
|90003	|参数格式错误|
|90004	|返回结果解析错误|
|90005	|合成失败，失败信息相关错误。|
|90006	|播放器错误相关回调。|
|10001	|access_token参数获取失败或未传输|
|10002	|domain参数值错误|
|10003	|language参数错误|
|10004	|voice_name参数错误|
|10005	|audiotype参数错误|
|10006	|rate参数错误|
|10007	|idx错误|
|10008	|single错误|
|10009	|text参数错误|
|10010	|文本太长|
|20000|	获取资源错误|
|20001	|断句失败|
|20002	|分段数错误|
|20003	|分段后的文本长度错误|
|20004	|获取引擎链接错误|
|20005	|RPC链接失败错误|
|20006	|引擎内部错误|
|20007|	操作redis错误|
|20008	|音频编码错误|
|30000	|鉴权错误（access_token值不正确或已经失效）|
|30001|	并发错误|
|30002	|内部配置错误|
|30003	|json串解析错误|
|30004|	获取url失败|
|30005|	获取客户IP地址失败|
|30006|	任务队列错误|
|40001	|请求不是 json 结构 |
|40002	|缺少必须字段 |
|40003	|版本错误 |
|40004	|字段值类型错误 |
|40005|	参数错误 |
|50001|	处理超时 |
|50002	|内部 rpc 调用失败| 
|50004|	其他内部错误 |



