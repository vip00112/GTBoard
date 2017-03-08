package com.gt.board.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.gt.board.vo.AttachFile;

@Repository
public class AttachFilesDAOImpl implements AttachFilesDAO {
    private SqlSession session;

    public void setSession(SqlSession session) {
        this.session = session;
    }

    @Override
    public int insert(AttachFile file) {
        return session.insert("attachFiles.insert", file);
    }

    @Override
    public AttachFile selectOne(Map<String, Object> map) {
        return session.selectOne("attachFiles.selectOne", map);
    }

    @Override
    public List<AttachFile> selectList(int boardNo) {
        return session.selectList("attachFiles.selectList", boardNo);
    }

    @Override
    public int deleteByName(Map<String, Object> map) {
        return session.delete("attachFiles.deleteByName", map);
    }

    @Override
    public int deleteByBoard(int boardNo) {
        return session.delete("attachFiles.deleteByBoard", boardNo);
    }

    @Override
    public int insertLog(Map<String, Object> map) {
        return session.insert("attachFiles.insertLog", map);
    }

    @Override
    public int selectCountLog(Map<String, Object> map) {
        return session.selectOne("attachFiles.selectCountLog", map);
    }
}
