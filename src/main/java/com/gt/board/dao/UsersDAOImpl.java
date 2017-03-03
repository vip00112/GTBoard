package com.gt.board.dao;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.gt.board.vo.User;

@Repository
public class UsersDAOImpl implements UsersDAO {
    private SqlSession session;

    public void setSession(SqlSession session) {
        this.session = session;
    }

    @Override
    public int selectCountByEmail(Map<String, Object> map) {
        return session.selectOne("users.selectCountByEmail", map);
    }

    @Override
    public User selectOneByNo(int no) {
        return session.selectOne("users.selectOneByNo", no);
    }

    @Override
    public int insert(User user) {
        return session.insert("users.insert", user);
    }

    @Override
    public int updateActive(int no) {
        return session.update("users.updateActive", no);
    }

    @Override
    public int selectCountByNickname(Map<String, Object> map) {
        return session.selectOne("users.selectCountByNickname", map);
    }

    @Override
    public User selectOneByEmail(String email) {
        return session.selectOne("users.selectOneByEmail", email);
    }

    @Override
    public int updateNickname(Map<String, Object> map) {
        return session.update("users.updateNickname", map);
    }

    @Override
    public int updatePassword(Map<String, Object> map) {
        return session.update("users.updatePassword", map);
    }

    @Override
    public int updatePoint(Map<String, Object> map) {
        return session.update("users.updatePoint", map);
    }

    @Override
    public int insertPointHistory(Map<String, Object> map) {
        return session.insert("users.insertPointHistory", map);
    }

}
