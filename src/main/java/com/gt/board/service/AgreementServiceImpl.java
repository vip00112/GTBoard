package com.gt.board.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.gt.board.dao.AgreementDAO;
import com.gt.board.vo.Agreement;

@Service
public class AgreementServiceImpl implements AgreementService {
    private AgreementDAO agreementDAO;

    public void setAgreementDAO(AgreementDAO agreementDAO) {
        this.agreementDAO = agreementDAO;
    }

    @Override
    public Agreement getAgreement(int no) {
        return agreementDAO.selectOne(no);
    }

    @Override
    public Agreement getAgreementRecent(String type) {
        List<Agreement> list = agreementDAO.selectList(type);
        if (list.size() > 0) {
            return list.get(0);
        }
        return null;
    }

    @Override
    public List<Agreement> getAgreementList(String type) {
        return agreementDAO.selectList(type);
    }

    @Override
    public boolean addAgreement(Agreement agreement) {
        return agreementDAO.insert(agreement) == 1;
    }

    @Override
    public boolean updateAgreement(Agreement agreement) {
        return agreementDAO.update(agreement) == 1;
    }
}
