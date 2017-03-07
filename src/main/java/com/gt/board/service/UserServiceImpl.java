package com.gt.board.service;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;

import com.gt.board.dao.UsersDAO;
import com.gt.board.enums.Point;
import com.gt.board.vo.User;

@Service
public class UserServiceImpl implements UserService {
    private UsersDAO usersDAO;

    public void setUsersDAO(UsersDAO usersDAO) {
        this.usersDAO = usersDAO;
    }

    @Override
    public User getUser(String email) {
        return usersDAO.selectOneByEmail(email);
    }

    @Override
    public User getUser(int no) {
        return usersDAO.selectOneByNo(no);
    }

    @Override
    public boolean join(User user) {
        String email = user.getEmail();
        String nickname = user.getNickname();
        String password = user.getPassword();

        // 유효성 검사
        if (!Pattern.matches("^([0-9a-zA-Z_\\.-]+)@([0-9a-zA-Z_-]+)(\\.[a-zA-Z]+){1,2}$", email)) {
            return false;
        } else if (!Pattern.matches("^[A-Za-z0-9가-힣ㄱ-ㅎㅏ-ㅣ]{1,6}$", nickname)) {
            return false;
        } else if (!Pattern.matches("^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-zA-z])[A-Za-z0-9!@#$%^&*]{8,20}$", password)) {
            return false;
        } else if (isOverlap(0, "email", email) || isOverlap(0, "nickname", nickname)) {
            return false;
        }

        // DB저장 전 비밀번호 암호화
        String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        user.setPassword(hashedPassword);

        return usersDAO.insert(user) == 1;
    }

    @Override
    public boolean setActive(int no) {
        return usersDAO.updateActive(no) == 1;
    }

    @Override
    public boolean isOverlap(int no, String type, String value) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("no", no);
        paramMap.put("value", value);

        if (type.equals("email")) {
            return usersDAO.selectCountByEmail(paramMap) > 0;
        } else if (type.equals("nickname")) {
            return usersDAO.selectCountByNickname(paramMap) > 0;
        }
        return false;
    }

    @Override
    public boolean updateNickname(int no, String nickname) {
        if (!Pattern.matches("^[A-Za-z0-9가-힣ㄱ-ㅎㅏ-ㅣ]{1,6}$", nickname)) {
            return false;
        }

        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("no", no);
        paramMap.put("nickname", nickname);
        return usersDAO.updateNickname(paramMap) == 1;
    }

    @Override
    public boolean updatePassword(String email, String password) {
        if (!Pattern.matches("^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-zA-z])[A-Za-z0-9!@#$%^&*]{8,20}$", password)) {
            return false;
        }

        // DB저장 전 비밀번호 암호화
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("email", email);
        paramMap.put("password", hashedPassword);
        return usersDAO.updatePassword(paramMap) == 1;
    }

    @Override
    public boolean updatePointTX(int no, int point, Point reason) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("no", no);
        paramMap.put("type", reason.getType());
        paramMap.put("point", point);
        paramMap.put("reason", reason.getReason());
        usersDAO.insertPointHistory(paramMap);
        return usersDAO.updatePoint(paramMap) == 1;
    }

}
