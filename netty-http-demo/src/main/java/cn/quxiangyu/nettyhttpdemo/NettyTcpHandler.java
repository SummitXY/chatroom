package cn.quxiangyu.nettyhttpdemo;

import cn.quxiangyu.nettyhttpdemo.database.HistoryMessage;
import cn.quxiangyu.nettyhttpdemo.database.HistoryMessageManager;
import cn.quxiangyu.nettyhttpdemo.database.MessageMapper;
import cn.quxiangyu.nettyhttpdemo.database.Student;
import com.alibaba.fastjson.JSON;
import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
@ChannelHandler.Sharable
public class NettyTcpHandler extends SimpleChannelInboundHandler<Map> {

    @Autowired
    private DispatcherManager manager;

    @Autowired
    private HistoryMessageManager historyMessageManager;

    @Override
    protected void channelRead0(ChannelHandlerContext channelHandlerContext, Map map) throws Exception {
        System.out.println("handler在处理");

        String fromId = (String) map.get("from_id");
        manager.addUserChannel(fromId,channelHandlerContext.channel().id());
        System.out.println("添加了用户"+fromId);

        String type = (String) map.get("type");
        if (type.equalsIgnoreCase("history")) {
            System.out.println("客户端请求历史消息 historyManager :"+historyMessageManager);
            List<HistoryMessage> messages = historyMessageManager.fetchAllHistoryMessage();
            Map<String, Object> resp = new HashMap<>();
            resp.put("message","OK");
            resp.put("type","history");
            resp.put("data",messages);
            channelHandlerContext.channel().writeAndFlush(resp);

        } else if (type.equalsIgnoreCase("send")) {
            System.out.println("客户端发送了群发消息");
            Map<String, Object> resp = new HashMap<>();
            resp.put("message","OK");
            resp.put("type","send");
            resp.put("data",map);
            manager.sendAll(resp);
            HistoryMessage historyMessage = JSON.parseObject(JSON.toJSONBytes(map),HistoryMessage.class);
            historyMessageManager.insertHistoryMessage(historyMessage);

        } else if (type.equalsIgnoreCase("send2one")) {
            String toId = (String)map.get("to_id");
            System.out.println(fromId + "客户端发送了单发消息给:"+toId);
            Map<String, Object> resp = new HashMap<>();
            resp.put("message","OK");
            resp.put("type","send");
            resp.put("data",map);
            manager.sendOne(toId, resp);

        } else if (type.equalsIgnoreCase("send2img")) {
            System.out.println("客户端发送了图片消息");
            Map<String, Object> resp = new HashMap<>();
            resp.put("message","OK");
            resp.put("type","send_img");
            resp.put("data",map);
            manager.sendAll(resp);
        } else {
            System.out.println("消息结构不对 或 type类型不对");
        }

    }

    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        manager.addChannel(ctx.channel().id(), ctx.channel());
    }

    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        manager.removeChannel(ctx.channel().id());
    }
}
