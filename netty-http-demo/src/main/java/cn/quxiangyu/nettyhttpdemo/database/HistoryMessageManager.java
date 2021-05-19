package cn.quxiangyu.nettyhttpdemo.database;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

@Component
public class HistoryMessageManager {

    public static AtomicInteger version = new AtomicInteger(0);

    @Autowired
    private MessageMapper messageMapper;

    @Cacheable(value = "historyList")
    public List<HistoryMessage> fetchAllHistoryMessage() {
        System.out.println("未命中缓存，从数据库拉数据，version:");
        return messageMapper.fetchAllHistoryMessage();
    }

    public void insertHistoryMessage(HistoryMessage history) {
        version.getAndIncrement();
        messageMapper.insertHistoryMessage(history);
    }

    @Cacheable(value = "allStudents")
    public List<Student> fetchAllStudetns() {
        System.out.println("查询多个学生");
        Student student1 = new Student();
        student1.setId(11);
        student1.setName("qxy");
        student1.setAge(22);

        Student student2 = new Student();
        student2.setId(20);
        student2.setName("qxy2");
        student2.setAge(24);

        List<Student> list = new ArrayList<>();
        list.add(student1);
        list.add(student2);

        return list;
    }
}
