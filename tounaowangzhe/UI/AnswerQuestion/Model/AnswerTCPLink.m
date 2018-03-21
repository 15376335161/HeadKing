//
//  AnswerTCPLink.m
//  huanle
//
//  Created by Sj03 on 2018/1/16.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "AnswerTCPLink.h"
#import "NSString+Catogory.h"
#import "Security.h"
#import "GTMBase64.h"
#import "NSData+AES128.h"

//固定的头部长度
//起始符(1Byte) + 目标地址(2byte) + 源地址(2byte) + 应用层数据长度(2byte) = 7Byte
#define KPacketHeaderLength 7
typedef NS_ENUM(NSInteger ,KReadDataType){
    TAG_FIXED_LENGTH_HEADER = 10,//消息头部tag
    TAG_RESPONSE_BODY = 11//消息体tag
};


@interface AnswerTCPLink ()<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket    *socket;       // socket
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的prot
@property (nonatomic, strong)NSTimer *heartbeatTime;


@property(nonatomic,strong)NSData* headData;
@property(nonatomic,assign)short bodyLength;

@end

@implementation AnswerTCPLink
static AnswerTCPLink *answerLink = nil;
+ (instancetype)share {
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^{
        if(answerLink == nil) {
            answerLink = [[AnswerTCPLink alloc] init];
        }
    });
    
    return answerLink;
}
- (instancetype)init
{
    if (self = [super init]) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//        if (_socket.isConnected) {
//
//        } else {
//            NSError *error;
//            [_socket connectToHost:_socketHost onPort:_socketPort withTimeout:-1 error:&error];
//            if (error) {
//                NSLog(@"%@",error);
//            }
//        }
    }
    return self;
}

- (void)starLink {
    NSError *error = nil;  
     [_socket connectToHost:@"39.108.225.203" onPort:2347 withTimeout:10 error:&error];//2347
    self.socket.delegate = self;// 实现这个 SRWebSocketDelegate 协议啊
}
//在socket连接成功之后应
- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(UInt16)port {
    NSLog(@"连接成功，还有开启心跳");
    NSLog(@"成功连接到%@:%d",host,port);
    // 存储接收数据的缓存区
    [_socket readDataWithTimeout:-1 tag:0];
    
    self.socket = sock;
    
    self.heartbeatTime = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(heartbeat) userInfo:@{@"key":@"value"} repeats:YES];
     // runLoop 模式问题
    [[NSRunLoop currentRunLoop] addTimer:self.heartbeatTime forMode:NSRunLoopCommonModes];
    
    // -1不超时一直读取 等待数据，先读取头部信息长度为 KPacketHeaderLength
    // tag为头部消息tag，这个在接收到数据时，用来区分此次读取的是头部数据还是消息体数据
    //[self.socket readDataToLength:KPacketHeaderLength withTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
    // 等待数据来啊
    [self.socket readDataWithTimeout:-1 tag:0];
    [self.socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:10 maxLength:KPacketHeaderLength tag:0];
    //发送消息
    [self sendMsg];
    
}
- (BOOL)connectToHost:(NSString *)host onPort:(uint16_t)port withTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr{
    return YES;
}
//等待连接
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    NSLog(@"等待链接");
    //这里需要对Socket的工作原理进行一点解释，当Socket accept一个连接服务请求时，将生成一个新的Socket，即此处的newSocket。在此可查看newSocket.connectedHost和newSocket.connectedPort等参数，并通过新的socket向客户端发送一包数据后会关闭你一开始创建的socket(self.serverSocket),接下来你都将使用newSocket(我将此保存为self.clientSocket)
    self.socket = newSocket;

}
-(void)sendData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"user_send_msg" forKey:@"type"];
    [params setObject:@"100012" forKey:@"uid"];
    [params setObject:@"nimeide" forKey:@"msg"];
    
    [params setObject:@"http://img4q.duitang.com/uploads/item/201408/14/20140814211503_fruNR.thumb.700_0.jpeg" forKey:@"avatar"];
    [params setObject:@"aaa" forKey:@"nick_name"];
    //NSString* msgStr = [NSString stringWithFormat:@"{\"type\":%@,\"uid\":%@,\"nick_name\":\"%@\",\"msg\":\"%@\",\"avatar\":\"%@\"}\r\n",@"user_send_msg",@"100012",@"aaa",@"nimeide",@"http://img4q.duitang.com/uploads/item/201408/14/20140814211503_fruNR.thumb.700_0.jpeg"];
    
    //和后端开发人员商定好socket协议格式
    //GCDAsyncSocket不支持自定义边界符，它提供了四种边界符供你使用\r\n、\r、\n、空字符串
    //在拼装好socket请求之后，你需要调用GCDAsyncSocket的写方法，来发送请求，然后在写完成之后你会收到写的回调
    //[NSString stringWithFormat:@"{\"version\":%d,\"reqType\":%d,\"body\":\"%@\"}\r\n",PROTOCOL_VERSION,reqType,reqBody];
    
    //NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // [param setObject:params forKey:@"jsondata"];
    
    //NSError *error;
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    //param 先转成str
    NSString* jsonStr = [NSString dictionaryToJson:params].base64String;
    
    NSString* upDateStr = [NSData aes256_encrypt:kAES Encrypttext:jsonStr];
    //发送数据
    NSData* data = [upDateStr dataUsingEncoding:NSUTF8StringEncoding];
   // NSLog(@"jsonStr ==%@ upDateStr == %@  encodeStr == %@",jsonStr,upDateStr,[NSData aes256_encrypt:kAES Encrypttext:jsonStr]);
    
  
    
    
    [self.socket writeData:data withTimeout:-1 tag:0];
}
- (void) sendMsg {
    // 写这里代码
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"user_send_msg" forKey:@"type"];
    [params setObject:@"100012" forKey:@"uid"];
    [params setObject:@"nimeide" forKey:@"msg"];
    
    [params setObject:@"http://img4q.duitang.com/uploads/item/201408/14/20140814211503_fruNR.thumb.700_0.jpeg" forKey:@"avatar"];
    [params setObject:@"aaa" forKey:@"nick_name"];
    
   
    //NSString* updataStr =  [NSData aes256_encrypt:kAES Encrypttext:s].base64String;
    //[NSData AES256ParmEncryptWithKey:<#(NSString *)#> Encrypttext:<#(NSData *)#>]
   // NSData *data = [updataStr dataUsingEncoding:NSUTF8StringEncoding];
    // 开始发送
   
    // 发送消息 这里不需要知道对象的ip地址和端口
    //[_socket writeData:data withTimeout:-1 tag:0];
}
// 接受到服务器的数据 收到信息
- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag {
    //因为你只在连接成功后设置了一次超时时间。每当你接收到数据之后
    //接收到消息。
    
    //[sock readDataWithTimeout:-1 tag:0];
    
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    NSLog(@"deCodedata == %@",[GTMBase64 decodeData:data]);
    
    NSLog(@"dataStr == %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSString *s = [[NSString alloc] initWithData:[GTMBase64 decodeData:data] encoding:NSUTF8StringEncoding];
     NSString *jsonStr = [Security AES128DecryptString:s];
    
    NSLog(@"aes转吗后数据 == %@",jsonStr);
    
    NSLog(@"接收到服务器返回的数据 tcp [%@:%d] %@  %@", ip, port, s,jsonStr);
    
    NSLog(@"读取数据 dic  ==========%@",jsonStr);
    
    NSLog(@"接收到服务器返回的数据");
    // 根据tag来做不同的操作
    switch (tag) {
        case TAG_FIXED_LENGTH_HEADER:
        {
            self.headData = data;
            Byte *bytes = (Byte *)[data bytes];
            
            //身体长度 = 消息体 + 1Byte的校验码
            self.bodyLength =  [self readShort:bytes location:5] + 1;
            
            // 从数据缓冲区读取完整的身体部分数据，此时tag变成了TAG_RESPONSE_BODY
            [self.socket readDataToLength:self.bodyLength withTimeout:-1 tag:TAG_RESPONSE_BODY];
        }
            break;
        case TAG_RESPONSE_BODY:{
            
            //如果当前读取出来的数据长度没有达到完整包身体的长度，则包不完整(则根据当前接收的数据长度，和身体长度比较，继续读取两者相差的数据长度)
            
            //读取完身体数据，开始校验，校验成功，则展示数据并且，开始等待下一次读取数据，tag变成TAG_FIXED_LENGTH_HEADER
            [self.socket readDataToLength:KPacketHeaderLength withTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
        }
            break;
        default:
            break;
    }

}
- (short)readShort:(Byte *)bytes location:(int)location {
    return OSReadLittleInt16(bytes, location);
}

- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err {
    NSLog(@"连接失败，这里可以实现掉线自动重连，要注意以下几点 err == %@",err);
//    if (err.code == 57) {
//        _socket.userData = @(SocketOfflineByWifiCut); // wifi断开
//    }
//    else {
//        _socket.userData =  @(SocketOfflineByServer);  // 服务器掉线
//    }
    
//    NSLog(@"1.判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连");
//    NSLog(@"2.判断调用层是否需要连接，例如用户都没在聊天界面，连接上去浪费流量");
//    NSLog(@"3.连接次数限制，如果连接失败了，重试10次左右就可以了，不然就死循环了。或者每隔1，2，4，8，10，10秒重连...f(x) = f(x-1) * 2, (x=5)");
//        [self deallocForSocket];
    NSLog(@"连接失败 %@", err);
    // 断线重连
    NSString *host = _socketHost;
    uint16_t port = _socketPort;
    [_socket connectToHost:host onPort:port withTimeout:60 error:nil];
    //只需要再调用一次建连请求，我这边设置的重连规则是重连次数为5次，每次的时间间隔为2的n次方，超过次数之后，就不再去重连了
//    self.status= -1;
//    if(self.reconnection_time>=0 && self.reconnection_time <= kMaxReconnection_time) {
//        [self.timer invalidate];
//        self.timer = nil;
//        int time = pow(2,self.reconnection_time);
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:time target:selfselector:@selector(reconnection) userInfo:nil repeats:NO];
//        self.reconnection_time++;
//        NSLog(@"socket did reconnection,after %ds try again",time);
//    } else {
//        self.reconnection_time = 0;
//        NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
//    }
}
#pragma mark - 消息发送成功 代理函数
//对发送的数据根据tag进行管理
- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag{
     NSLog(@"消息发送成功");
    // 在写之后，需要再调用读方法，这样才能收到你发出请求后从服务器那边收到的数据
    //设置边界符
    [self.socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 maxLength:50000 tag:0];//
}

- (void)setupReadTimerWithTimeout:(NSTimeInterval)timeout{
    NSLog(@"timeout === %f",timeout);
}
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
    NSLog(@"Received bytes: %zd",partialLength);
}
//当过了超时时间服务器还未响应，说明网络拥堵或异常，你可以选择重新发送、提醒用户网络不稳定等操作。
//-1代表没有超时时间。
//超时后回回调方法。
-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length{
    
    return 10;
}

// 心跳包 发送消息
- (void)heartbeat{
    //发送数据
   // [self sendData];
   // [self sendMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"user_send_msg" forKey:@"type"];
    [params setObject:@"100012" forKey:@"uid"];
    [params setObject:@"nimeide" forKey:@"msg"];
    [params setObject:@"http://img4q.duitang.com/uploads/item/201408/14/20140814211503_fruNR.thumb.700_0.jpeg" forKey:@"avatar"];
    [params setObject:@"aaa" forKey:@"nick_name"];
    //NSString* msgStr = [NSString stringWithFormat:@"{\"type\":%@,\"uid\":%@,\"nick_name\":\"%@\",\"msg\":\"%@\",\"avatar\":\"%@\"}\r\n",@"user_send_msg",@"100012",@"aaa",@"nimeide",@"http://img4q.duitang.com/uploads/item/201408/14/20140814211503_fruNR.thumb.700_0.jpeg"];
    
    //和后端开发人员商定好socket协议格式
    //GCDAsyncSocket不支持自定义边界符，它提供了四种边界符供你使用\r\n、\r、\n、空字符串
    //在拼装好socket请求之后，你需要调用GCDAsyncSocket的写方法，来发送请求，然后在写完成之后你会收到写的回调
    //[NSString stringWithFormat:@"{\"version\":%d,\"reqType\":%d,\"body\":\"%@\"}\r\n",PROTOCOL_VERSION,reqType,reqBody];

    //NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // [param setObject:params forKey:@"jsondata"];

    //NSError *error;
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    //param 先转成str  AES128加密 然后 base64 然后转Data上传
    NSString* jsonStr = [NSString dictionaryToJson:params];
    jsonStr = @"123";
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesData = [jsonData AES128EncryptWithKey:kAES iv:@""];
//    NSLog(@"GTMBase64 == %@",[GTMBase64 stringByEncodingData:aesData]) ;
//
    NSString* base64 = [GTMBase64 stringByEncodingData:aesData];
    NSData*  upData = [base64 dataUsingEncoding:NSUTF8StringEncoding];

    
     NSString* aesStr = [Security AES128Encrypt:jsonStr key:kAES];
//     NSLog(@"aesStr == %@",aesStr);
    
    // NSString* baseAESstr = [GTMBase64 stringByEncodingData:[]];
    
  //  NSData* upData1 =  [GTMBase64 encodeData:aesData];
   // NSLog(@"upDate == %@ \n  updata1 == %@\n",upData,upData1);
//    NSString* base64Str = [GTMBase64 stringByEncodingData:[[Security AES128EncryptStrig:@"12345678"] dataUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"aes加密== %@",[Security AES128EncryptStrig:@"12345678"].base64String);
//    NSLog(@"base64Str == %@",base64Str);
   // NSString* upDateStr = [Security AES128EncryptStrig:jsonStr].base64String;//[NSData aes256_encrypt:kAES Encrypttext:jsonStr].base64String;
    //发送数据
    //NSData* data = [upDateStr dataUsingEncoding:NSUTF8StringEncoding];
    
   // NSLog(@"jsonStr ==%@ upDateStr == %@  encodeStr == %@",jsonStr,upDateStr,[NSData aes256_encrypt:kAES Encrypttext:jsonStr]);
    
    [self.socket writeData:upData withTimeout:-1 tag:0];
}

 //  释放不需要的内存
- (void)deallocForSocket {
    //关闭链接
    self.socket = nil;
    [_socket disconnect];
    [self.heartbeatTime invalidate];
    self.heartbeatTime = nil;
}

@end
