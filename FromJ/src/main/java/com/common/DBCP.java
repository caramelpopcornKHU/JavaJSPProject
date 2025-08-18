package com.common;

import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;

public class DBCP {
    private static DataSource ds;

    static {
        try {
            ds = (DataSource) new InitialContext().lookup("java:comp/env/jdbc/FromJ");
        } catch (Exception e) {
            throw new RuntimeException("JNDI DataSource lookup failed", e);
        }
    }

    public static Connection getConnection() throws Exception {
        return ds.getConnection();
    }
}
