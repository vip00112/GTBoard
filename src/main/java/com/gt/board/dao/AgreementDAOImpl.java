package com.gt.board.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.gt.board.vo.Agreement;

@Repository
public class AgreementDAOImpl implements AgreementDAO {
    private SqlSession session;

    public void setSession(SqlSession session) {
        this.session = session;
    }

    @Override
    public Agreement selectOne(int no) {
        return session.selectOne("agreement.selectOne", no);
    }

    @Override
    public List<Agreement> selectList(String type) {
        return session.selectList("agreement.selectList", type);
    }

    @Override
    public int insert(Agreement agreement) {
        return session.insert("agreement.insert", agreement);
    }

    @Override
    public int update(Agreement agreement) {
        return session.update("agreement.update", agreement);
    }

}
