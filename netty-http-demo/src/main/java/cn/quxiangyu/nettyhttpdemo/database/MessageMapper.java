package cn.quxiangyu.nettyhttpdemo.database;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface MessageMapper {

    @Select("SELECT * FROM history_message order by time")
    List<HistoryMessage> fetchAllHistoryMessage();

    @Insert("INSERT INTO history_message (user,time,message) values(#{user},#{time},#{message})")
    void insertHistoryMessage(HistoryMessage history);
}
