package cn.quxiangyu.nettyhttpdemo;

import cn.quxiangyu.nettyhttpdemo.database.HistoryMessageManager;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
@EnableCaching
public class NettyHttpDemoApplication {

    public static void main(String[] args) {
        ConfigurableApplicationContext context = SpringApplication.run(NettyHttpDemoApplication.class, args);

    }

}
