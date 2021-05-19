package cn.quxiangyu.nettyhttpdemo;

import io.netty.channel.Channel;
import io.netty.channel.ChannelId;
import org.springframework.stereotype.Component;

import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Component
public class DispatcherManager {

    private  ConcurrentMap<ChannelId, Channel> channelMap = new ConcurrentHashMap<>();
    private ConcurrentMap<String, ChannelId> userChannels = new ConcurrentHashMap<>();

    public void addChannel(ChannelId channelId, Channel channel) {
        InetSocketAddress remoteAddress = (InetSocketAddress)channel.remoteAddress();
        int port = remoteAddress.getPort();
        System.out.println("添加一个新channel "+channelId+" 端口号是 "+port);
        channelMap.put(channelId, channel);
    }

    public void removeChannel(ChannelId channelId) {
        System.out.println("移除channel "+channelId);
        channelMap.remove(channelId);
    }

    public void addUserChannel(String user, ChannelId channelId) {
        userChannels.put(user, channelId);
    }

    public void sendAll(Map<String, Object> msg) {
        for (Channel channel :
                channelMap.values()) {
            if (!channel.isActive()){
                System.out.println("[send][连接未激活]"+channel.id());
                return;
            }

            channel.writeAndFlush(msg);
        }
    }

    public void sendOne(String toId, Map<String, Object> msg) {
        ChannelId channelId = userChannels.get(toId);
        Channel channel = channelMap.get(channelId);
        System.out.println("单发的channelId和channel:"+channelId+channel);
        if (!channel.isActive()){
            System.out.println("[send][连接未激活]"+channel.id());
            return;
        }
        channel.writeAndFlush(msg);
    }
}
















