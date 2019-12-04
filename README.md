#标贝科技语音合成服务iOS SDK使用说明文档（2.0）
[toc]
##1.XCode集成Framework（参考demo） 


1. 将framework添加到项目project的目录下面。

1. 在viewController中引用SDK的头文件；
1. 实现DBSynthesizerDelegate的代理。
```
     _synthesizerManager.delegate = self;
``` 
1. 在代理的回调中处理相关的逻辑，回传数据或者处理异常;

##2.SDK关键类

1. DBSynthesizerManager：语音合成关键业务处理类，全局只需一个实例即可,并且需要注册自己为该类的回调对象；

2. DBSynthesizerRequestParam：设置合成需要的相关参数，按照如下的接口文档设置即可；
3. DBFailureModel：请求异常的回调类，包含错误码，错误信息，和错误的trace_id。

##3.调用顺序
1. 初始化DBSynthesizerManager类，得到DBSynthesizerManager的实例。
1. 注册成为DBSynthesizerDelegate的回调者。
1. 设置DBSynthesizerRequestParam合成参数，包括必填参数和非必填参数
1. 调用DBSynthesizerManager.start()方法开始与云端服务连接
1. 在DBSynthesizerDelegate回调中获得合成的音频数据并按您自己的业务需要处理合成结果或错误情况。
1. 如果需要发起新的请求，可以重复第3-5步。
1. 在业务完全处理完毕，或者页面关闭时，调DBSynthesizerManager.stop()结束websocket服务，释放资源。

##4.参数说明
### 4.1基本参数说明

| 参数 | 参数名称 |是否必填|说明|
|--------|--------|
|  clientId  |  clientId | 是|初始化sdk的clientId    |
|clientSecret|	clientSecret|	是|	初始化sdk的clientSecret|
|setText	|合成文本	|是	|设置要转为语音的合成文本|
|setBakerCallback|	数据回调方法|	是	|设置返回数据的callback|
|setVoice	|发音人	|是	|设置发音人声音名称，默认：标准合成_模仿儿童_果子|
|setBakerCallbackDelegate|	数据回调方法	|是|	设置返回数据的callback|
|setLanguage|	合并文本语言类型|	否	|合成请求文本的语言，目前支持ZH(中文和中英混)和ENG(纯英文，中文部分不会合成),默认：ZH
|setSpeed	|语速	|否|	设置播放的语速，在0～9之间（支持浮点值），不传时默认为5
|setVolume|	音量|	否	|设置语音的音量，在0～9之间（只支持整型值），不传时默认值为5|
|setPitch	|音调|	否	|设置语音的音调，取值0-9，不传时默认为5中语调|
|setAudioType|	返回数据文件格式	|否	|"可不填，不填时默认为4audiotype=4 ：返回16K采样率的pcm格式audiotype=5 ：返回8K采样率的pcm格式audiotype=6 ：返回16K采样率的wav格式  audiotype=6&rate=1 ：返回8K的wav格式"|
|setEnableTimestamp	|是否返回时间戳内容	|否	|设置是否返回时间戳内容。true=支持返回，false=不需要返回。不设置默认为false不返回。|

###4.2 BakerCallback 回调类方法说明
| 参数 | 参数名称 |说明|
|--------|--------|
|onSynthesisStarted	|开始合成	|开始合成|
|onBinaryReceived|流式持续返回数据的接口回调|idx  数据块序列号，请求内容会以流式的数据块方式返回给客户端。服务器端生成，从1递增。data 合成的音频数据;audioType  音频类型，如pcm、wav。interval  音频interval信息，可能为空。endFlag  是否时最后一个数据块，false：否，true：是。|
|onSynthesisCompleted|	合成完成。	|当onBinaryReceived方法中endFlag参数=true，即最后一条消息返回后，会回调此方法。|
|onTaskFailed	|合成失败	|返回msg内容格式为：{"code":40000,"message":"…","trace_id":" 1572234229176271"} trace_id是引擎内部合成任务ID。|

###4.3失败时返回的code对应表
#### 4.3.1失败时返回的msg格式
| 参数 | 类型 |描述|
|--------|--------|
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



