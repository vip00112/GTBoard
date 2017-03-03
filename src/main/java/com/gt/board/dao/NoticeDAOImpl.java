package com.gt.board.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.gt.board.vo.Notice;

@Repository
public class NoticeDAOImpl implements NoticeDAO {
    private SqlSession session;

    public void setSession(SqlSession session) {
        this.session = session;
    }

    @Override
    public int insert(Notice notice) {
        return session.insert("notice.insert", notice);
    }

    @Override
    public int delete(int no) {
        return session.delete("notice.delete", no);
    }

    @Override
    public int update(Notice notice) {
        return session.update("notice.update", notice);
    }

    @Override
    public Notice selectOne(int no) {
        return session.selectOne("notice.selectOne", no);
    }

    @Override
    public int updateHit(int no) {
        return session.update("notice.updateHit", no);
    }

    @Override
    public List<Notice> selectListByRecent(int max) {
        return session.selectList("notice.selectListByRecent", max);
    }

    @Override
    public int selectCount(Map<String, Object> map) {
        return session.selectOne("notice.selectCount", map);
    }

    @Override
    public List<Notice> selectList(Map<String, Object> map) {
        return session.selectList("notice.selectList", map);
    }
}
