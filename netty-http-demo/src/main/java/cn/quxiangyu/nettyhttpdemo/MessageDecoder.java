package cn.quxiangyu.nettyhttpdemo;

import com.alibaba.fastjson.JSON;
import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.ByteToMessageDecoder;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MessageDecoder extends ByteToMessageDecoder {
    @Override
    protected void decode(ChannelHandlerContext channelHandlerContext, ByteBuf in, List<Object> out) throws Exception {

        if (in.readableBytes() < 4) {
            System.out.println("长度标示位不足4字节，不处理");
            return;
        }

        in.markReaderIndex();

        int length = in.readInt();
        if (length < 0) {
            System.out.println("长度标示位小于0，有问题");
            in.resetReaderIndex();
            return;
        } else {
            System.out.println("读取到长度标示位："+length);
        }

        if (in.readableBytes() < length) {
            System.out.println("内容长度不足长度标示位，不处理");
            in.resetReaderIndex();
            return;
        }

        byte[] content = new byte[length];
        in.readBytes(content);

        Map<String, Object> map = JSON.parseObject(content, HashMap.class);
        if (map instanceof Map){
            String fromId = (String) map.get("from_id");
            String type = (String) map.get("type");
            System.out.println("收到数据 fromId "+fromId+" type "+type);
            out.add(map);
        } else {
            System.out.println("客户端传的数据不是Json格式");
        }
    }
}
