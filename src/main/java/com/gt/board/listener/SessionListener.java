package com.gt.board.listener;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class SessionListener implements HttpSessionListener {
    private int count;

    public int getCount() {
        return count;
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        count++;
        System.out.println("CREATE SESSION : " + session.getId() + " / count : " + count);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        count--;
        System.out.println("DESTROYED SESSION : " + session.getId() + " / count : " + count);
    }

}
