package com.gt.board.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.gt.board.vo.Board;

@Repository
public class BoardsDAOImpl implements BoardsDAO {
    private SqlSession session;

    public void setSession(SqlSession session) {
        this.session = session;
    }

    @Override
    public int insert(Board board) {
        return session.insert("boards.insert", board);
    }

    @Override
    public int delete(int no) {
        return session.delete("boards.delete", no);
    }

    @Override
    public int update(Board board) {
        return session.update("boards.update", board);
    }

    @Override
    public int updateContent(Board board) {
        return session.update("boards.updateContent", board);
    }

    @Override
    public Board selectOne(int no) {
        return session.selectOne("boards.selectOne", no);
    }

    @Override
    public int updateHit(int no) {
        return session.update("boards.updateHit", no);
    }

    @Override
    public int updateCommentCount(Map<String, Object> map) {
        return session.update("boards.updateCommentCount", map);
    }

    @Override
    public int updateThumb(int no) {
        return session.update("boards.updateThumb", no);
    }

    @Override
    public List<Board> selectListByRecent(Map<String, Object> map) {
        return session.selectList("boards.selectListByRecent", map);
    }

    @Override
    public List<Board> selectListByBoardType(int typeNo) {
        return session.selectList("boards.selectListByBoardType", typeNo);
    }

    @Override
    public int selectCount(Map<String, Object> map) {
        return session.selectOne("boards.selectCount", map);
    }

    @Override
    public List<Board> selectList(Map<String, Object> map) {
        return session.selectList("boards.selectList", map);
    }

    @Override
    public List<Board> selectListByNotice(int typeNo) {
        return session.selectList("boards.selectListByNotice", typeNo);
    }

    @Override
    public List<Board> selectListByAd(int typeNo) {
        return session.selectList("boards.selectListByAd", typeNo);
    }

    @Override
    public int updateTypeNo(Map<String, Object> map) {
        return session.update("boards.updateTypeNo", map);
    }
}
