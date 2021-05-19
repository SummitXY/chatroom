//
//  ViewController.m
//  Client
//
//  Created by quxiangyu on 2021/4/26.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

#define XORKEY 0xC9

@interface ViewController ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *clientSocket;

@property (strong, nonatomic) NSMutableData *readBuf;
@property (strong, nonatomic) NSMutableData *historyBuf;

@property (strong, nonatomic) UIButton * btn;
@property (strong, nonatomic) UIButton * btn2one;
@property (strong, nonatomic) UIButton * btn2img;
@property (strong, nonatomic) UITextField * textField;

@property (strong, nonatomic) UILabel * logLabel;
@property (strong, nonatomic) UIImageView * imgView;

@property (strong, nonatomic) UIButton * a1Btn;
@property (strong, nonatomic) UIButton * a2Btn;
@property (strong, nonatomic) UIButton * a3Btn;

@property (strong, nonatomic) UIView * statusView;


@end

static NSString *account = @"null";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    self.readBuf = [NSMutableData data];
    self.historyBuf = [NSMutableData data];
    
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self doConnect];
    
}

- (void)createUI {
    
    self.a1Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 50, 50)];
    [self.a1Btn setTitle:@"A1" forState:UIControlStateNormal];
    self.a1Btn.backgroundColor = UIColor.blueColor;
    [self.view addSubview:self.a1Btn];
    [self.a1Btn addTarget:self action:@selector(btnClicked1:) forControlEvents:UIControlEventTouchUpInside];
    
    self.a2Btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    [self.a2Btn setTitle:@"A2" forState:UIControlStateNormal];
    self.a2Btn.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:self.a2Btn];
    [self.a2Btn addTarget:self action:@selector(btnClicked2:) forControlEvents:UIControlEventTouchUpInside];
    
    self.a3Btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 50, 50)];
    [self.a3Btn setTitle:@"A3" forState:UIControlStateNormal];
    self.a3Btn.backgroundColor = UIColor.grayColor;
    [self.view addSubview:self.a3Btn];
    [self.a3Btn addTarget:self action:@selector(btnClicked3:) forControlEvents:UIControlEventTouchUpInside];
    
    // 发送群消息
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 50, 50)];
    self.btn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 发送单条消息
    self.btn2one = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 50, 50)];
    self.btn2one.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.btn2one];
    [self.btn2one addTarget:self action:@selector(btnClicked2One:) forControlEvents:UIControlEventTouchUpInside];
    
    // 发送图片
    self.btn2img = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    self.btn2img.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.btn2img];
    [self.btn2img addTarget:self action:@selector(btnClicked2Img:) forControlEvents:UIControlEventTouchUpInside];
    
    self.logLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 400)];
    self.logLabel.backgroundColor = [UIColor grayColor];
    self.logLabel.font = [UIFont systemFontOfSize:12];
    self.logLabel.numberOfLines = 0;
    [self.view addSubview:self.logLabel];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 600, 100, 100)];
    self.imgView.backgroundColor = [UIColor orangeColor];
    self.imgView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.imgView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(150, 100, 200, 50)];
    self.textField.backgroundColor = [UIColor grayColor];
    [self.view addSubview: self.textField];
    
    // 小指示灯
    self.statusView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 10, 100, 10, 10)];
    self.statusView.backgroundColor = UIColor.redColor;
    [self.view addSubview:self.statusView];
    
    // -test
    // 加密
//    NSString *origin = @"Hello世界123";
//    NSData *jsonData = [origin dataUsingEncoding:NSUTF8StringEncoding];
//    int value = (int)jsonData.length;
//
//    Byte *byteData = (Byte *)malloc(value);
//    Byte *encryByteData = (Byte *)malloc(value);
//    memcpy(byteData, [jsonData bytes], value);
//
//    for (int i=0; i<value; i++) {
//        *(encryByteData + sizeof(UInt8)*i) = *(byteData + sizeof(UInt8)*i) ^ XORKEY;
////        encryByteData[i] =
//    }
//
//    NSData *encryJsonData = [NSData dataWithBytes:encryByteData length:value];
//    NSString *encryString = [[NSString alloc] initWithData:encryJsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"加密的字符串：%@",encryString);
//    [self decryped:encryJsonData];
}

//- (void)decryped:(NSData *)jsonData {
//    int encryValue = (int)jsonData.length;
//    Byte *byteData = (Byte *)malloc(encryValue);
//    Byte *decryByteData = (Byte *)malloc(encryValue);
//    memcpy(byteData, [jsonData bytes], encryValue);
//
//    for (UInt8 i=0; i<encryValue; i++) {
//        *(decryByteData + sizeof(UInt8)*i) = *(byteData + sizeof(UInt8)*i) ^ XORKEY;
//    }
//
//    NSData *decrypedData = [NSData dataWithBytes:decryByteData length:encryValue];
//    NSString *decrypedString = [[NSString alloc] initWithData:decrypedData encoding:NSUTF8StringEncoding];
//    NSLog(@"解密：%@",decrypedString);
//}

- (void)btnClicked1:(UIButton *)sender {
    account = @"A1";
    [self fetchHistoryMessage];
}

- (void)btnClicked2:(UIButton *)sender {
    account = @"A2";
    [self fetchHistoryMessage];
}

- (void)btnClicked3:(UIButton *)sender {
    account = @"A3";
    [self fetchHistoryMessage];
}

- (void)fetchHistoryMessage {
    
    if ([self.clientSocket isConnected]) {
        NSDictionary *msg = @{
            @"from_id":account,
            @"type":@"history"
        };
        [self sendDict:msg tag:0];
        
    } else {
        [self doConnect];
    }
}

#pragma mark 发送消息

- (NSString *)encryptWithTxt:(NSString *)plainTxt {
    NSData *plainData = [plainTxt dataUsingEncoding:NSUTF8StringEncoding];
    int len = (int)plainData.length;
    
    Byte *plainBytes = (Byte *)malloc(len);
    Byte *encryByteData = (Byte *)malloc(len);
    memcpy(plainBytes, [plainData bytes], len);
    
    for (int i=0; i<len; i++) {
        *(encryByteData + sizeof(UInt8)*i) = *(plainBytes + sizeof(UInt8)*i) ^ XORKEY;
    }
    
    NSData *encryptData = [NSData dataWithBytes:encryByteData length:len];
    return [encryptData base64EncodedStringWithOptions:0];
}

- (NSString *)decrptWithData:(NSString *)encryptTxt {
    NSData *encryptData = [[NSData alloc] initWithBase64EncodedString:encryptTxt options:0];
    int len = (int)encryptData.length;
    
    Byte *encryptBytes = (Byte *)malloc(len);
    Byte *decryptBytes = (Byte *)malloc(len);
    memcpy(encryptBytes, [encryptData bytes], len);
    
    for (int i=0; i<len; i++) {
        *(decryptBytes + sizeof(UInt8)*i) = *(encryptBytes + sizeof(UInt8)*i) ^ XORKEY;
    }
    NSData *decryptData = [NSData dataWithBytes:decryptBytes length:len];
    return [[NSString alloc] initWithData:decryptData encoding:kCFStringEncodingUTF8];
}

- (void)sendDict:(NSDictionary *)msg tag:(long)tag {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msg options:0 error:nil];
    int value = (int)jsonData.length;
    
    Byte byte[4] = {};
    byte[0]=(Byte)((value>>24) & 0xFF);
    byte[1]=(Byte)((value>>16) & 0xFF);
    byte[2]=(Byte)((value>>8) & 0xFF);
    byte[3]=(Byte)(value & 0xFF);
    
    NSData *dataLen = [NSData dataWithBytes:byte length:4];
    
    NSMutableData *mutData = [NSMutableData data];
    [mutData appendData:dataLen];
    [mutData appendData:jsonData];
    
    
    [self.clientSocket writeData:mutData withTimeout:-1 tag:tag];
}



- (void)btnClicked:(UIButton *)sender {
    
    NSDictionary *msg = @{
        @"from_id":account,
        @"type":@"send",
        @"time":@([NSDate timeIntervalSinceReferenceDate]),
        @"content":[self encryptWithTxt:self.textField.text]
    };
    [self sendDict:msg tag:0];
}

- (void)btnClicked2One:(UIButton *)sender {
    
    NSString *toId = @"";
    if ([account isEqualToString:@"A1"]) {
        toId = @"A2";
    } else if ([account isEqualToString:@"A2"]) {
        toId = @"A3";
    } else if ([account isEqualToString:@"A3"]) {
        toId = @"A1";
    }
    
    NSDictionary *msg = @{
        @"from_id":account,
        @"to_id":toId,
        @"type":@"send2one",
        @"time":@([NSDate timeIntervalSinceReferenceDate]),
        @"content":[self encryptWithTxt:self.textField.text]
    };
    [self sendDict:msg tag:0];
}

- (void)btnClicked2Img:(UIButton *)sender {
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"tag" ofType:@"jpg"];
    NSData *imgData = [NSData dataWithContentsOfFile:imgPath];
    NSString *imgStr = [imgData base64EncodedStringWithOptions:0];
    NSDictionary *msg = @{
        @"from_id":account,
        @"type":@"send2img",
        @"time":@([NSDate timeIntervalSinceReferenceDate]),
        @"content":imgStr
    };
    [self sendDict:msg tag:0];
}

#pragma mark Socket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    self.statusView.backgroundColor = UIColor.greenColor;
    NSLog(@"链接成功 服务器IP: %@-------端口: %d",host,port);
    [sock readDataWithTimeout:-1 tag:0];
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"发送数据 tag = %zi",tag);
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"didReadData,当前线程：%@",[NSThread currentThread]);
    [self.readBuf appendData:data];
    
    [self readWithSocket:sock tag:tag];
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    self.statusView.backgroundColor = UIColor.redColor;
    // Code=61 "Connection refused" 服务端还未开机
    // Code=7 "Socket closed by remote peer" 服务端空闲检测
    NSLog(@"断开链接 error:%@",err);
    self.logLabel.text = @"";
    if (err) {
        NSInteger code = err.code;
        if (code == 61) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self doConnect];
            });
        }
    }
    
}

#pragma mark Private

- (void)doConnect {
    NSLog(@"尝试链接127.0.0.1 ...");
        [self.clientSocket connectToHost:@"175.24.235.144" onPort:10066 error:NULL];
//    [self.clientSocket connectToHost:@"127.0.0.1" onPort:10066 error:NULL];
}

- (void)readWithSocket:(GCDAsyncSocket *)sock tag:(long)tag {
    
    NSData *dataBuf = self.readBuf;
    
    while (dataBuf.length > 4) {
        NSLog(@"目前缓冲区长度：%lu",(unsigned long)dataBuf.length);
        int dataLength=0;
        NSData *lengthData = [dataBuf subdataWithRange:NSMakeRange(0, 4)];
        NSLog(@"目前缓冲区长度：%lu",(unsigned long)dataBuf.length);
        
        [lengthData getBytes:&dataLength length:sizeof(dataLength)];
        NSLog(@"datalength的值为:%d 占位长度:%lu",dataLength,sizeof(dataLength));
        
        if (dataBuf.length >= (dataLength + 4)) {
            NSData *content = [[dataBuf subdataWithRange:NSMakeRange(4, dataLength)] copy];
            [self handleData:content];
            self.readBuf = [NSMutableData dataWithData:[dataBuf subdataWithRange:NSMakeRange(dataLength+4, dataBuf.length - (dataLength+4))]];
            dataBuf = self.readBuf;
        } else {
            break;
        }
    }
    
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)handleData:(NSData *)content {
    NSDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:content options:0 error:nil];
    NSLog(@"接收到服务端消息：%@",contentDict);
    NSString *type = [contentDict objectForKey:@"type"];
    
    if ([type isEqualToString:@"send"] || [type isEqualToString:@"send2one"]) {
        NSDictionary *data = [contentDict objectForKey:@"data"];
        NSString *user = [data objectForKey:@"from_id"];
        NSString *contentStr = [self decrptWithData:[data objectForKey:@"content"]];
        NSString *line = [NSString stringWithFormat:@"%@ : %@",user,contentStr];
        self.logLabel.text = [NSString stringWithFormat:@"%@\n%@",self.logLabel.text,line];
        
    } else if ([type isEqualToString:@"history"]) {
        NSArray *list = [contentDict objectForKey:@"data"];
        for (NSDictionary *msg in list) {
            NSString *user = [msg objectForKey:@"from_id"];
            NSString *message = [self decrptWithData:[msg objectForKey:@"content"]];
            NSString *line = [NSString stringWithFormat:@"%@ : %@",user,message];
            self.logLabel.text = [NSString stringWithFormat:@"%@\n%@",self.logLabel.text,line];
        }
    } else if ([type isEqualToString:@"send_img"]) {
        NSDictionary *data = [contentDict objectForKey:@"data"];
        NSString *contentStr = [data objectForKey:@"content"];
        self.imgView.image = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:contentStr options:0]];
        
    }
}

@end

