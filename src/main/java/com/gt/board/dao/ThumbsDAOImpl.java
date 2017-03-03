package com.gt.board.dao;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.gt.board.vo.Thumb;

@Repository
public class ThumbsDAOImpl implements ThumbsDAO {
    private SqlSession session;

    public void setSession(SqlSession session) {
        this.session = session;
    }

    @Override
    public int selectCount(Map<String, Object> map) {
        return session.selectOne("thumbs.selectCount", map);
    }

    @Override
    public int insert(Thumb thumb) {
        return session.insert("thumbs.insert", thumb);
    }

    @Override
    public int delete(int no) {
        return session.delete("thumbs.delete", no);
    }

}
