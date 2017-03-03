package com.gt.board.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.gt.board.vo.Comment;

@Repository
public class CommentsDAOImpl implements CommentsDAO {
    private SqlSession session;

    public void setSession(SqlSession session) {
        this.session = session;
    }

    @Override
    public int insert(Comment comment) {
        return session.insert("comments.insert", comment);
    }

    @Override
    public int delete(int no) {
        return session.delete("comments.delete", no);
    }

    @Override
    public int deleteByBoard(int boardNo) {
        return session.delete("comments.deleteByBoard", boardNo);
    }

    @Override
    public Comment selectOne(int no) {
        return session.selectOne("comments.selectOne", no);
    }

    @Override
    public int selectCount(Map<String, Object> map) {
        return session.selectOne("comments.selectCount", map);
    }

    @Override
    public List<Comment> selectList(Map<String, Object> map) {
        return session.selectList("comments.selectList", map);
    }

}
