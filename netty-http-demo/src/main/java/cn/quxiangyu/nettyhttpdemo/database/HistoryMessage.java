package cn.quxiangyu.nettyhttpdemo.database;

import com.alibaba.fastjson.annotation.JSONField;

import java.io.Serializable;

public class HistoryMessage implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;

    @JSONField(name="from_id")
    private String user;

    private double time;

    @JSONField(name="content")
    private String message;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public double getTime() {
        return time;
    }

    public void setTime(double time) {
        this.time = time;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    @Override
    public String toString() {
        return "HistoryMessage{" +
                "id=" + id +
                ", user='" + user + '\'' +
                ", time=" + time +
                ", message='" + message + '\'' +
                '}';
    }
}
