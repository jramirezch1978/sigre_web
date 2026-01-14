package pe.sigre.lib.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.rowset.CachedRowSet;

import pe.sigre.lib.util.SettingINI;

import com.sun.rowset.CachedRowSetImpl;

/**
 * Clase para acceso a base de datos Oracle
 */
public class DbAccess {
    
    private Connection connection = null;
    private static DbAccess instance = null;
    
    private static final String DEFAULT_HOST = "localhost";
    private static final String DEFAULT_PORT = "1521";
    private static final String DEFAULT_SERVICE = "ORCL";
    private static final String DEFAULT_USER = "system";
    private static final String DEFAULT_PASSWORD = "oracle";
    
    private DbAccess() throws SQLException {
        connect();
    }
    
    public static DbAccess getInstance() throws SQLException {
        if (instance == null || instance.connection == null || instance.connection.isClosed()) {
            instance = new DbAccess();
        }
        return instance;
    }
    
    private void connect() throws SQLException {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            
            String host = SettingINI.getValue("database", "host", DEFAULT_HOST);
            String port = SettingINI.getValue("database", "port", DEFAULT_PORT);
            String service = SettingINI.getValue("database", "service", DEFAULT_SERVICE);
            String user = SettingINI.getValue("database", "user", DEFAULT_USER);
            String password = SettingINI.getValue("database", "password", DEFAULT_PASSWORD);
            
            if (System.getenv("DB_HOST") != null) host = System.getenv("DB_HOST");
            if (System.getenv("DB_PORT") != null) port = System.getenv("DB_PORT");
            if (System.getenv("DB_SERVICE") != null) service = System.getenv("DB_SERVICE");
            if (System.getenv("DB_USER") != null) user = System.getenv("DB_USER");
            if (System.getenv("DB_PASSWORD") != null) password = System.getenv("DB_PASSWORD");
            
            String url = "jdbc:oracle:thin:@" + host + ":" + port + ":" + service;
            
            connection = DriverManager.getConnection(url, user, password);
            connection.setAutoCommit(true);
            
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver Oracle no encontrado: " + e.getMessage());
        }
    }
    
    public CachedRowSet ExecuteQuery(String sql, List<Object> params) throws SQLException {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        CachedRowSet cachedRowSet = null;
        
        try {
            stmt = connection.prepareStatement(sql);
            
            if (params != null) {
                for (int i = 0; i < params.size(); i++) {
                    stmt.setObject(i + 1, params.get(i));
                }
            }
            
            rs = stmt.executeQuery();
            
            cachedRowSet = new CachedRowSetImpl();
            cachedRowSet.populate(rs);
            
            return cachedRowSet;
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
    }
    
    public int ExecuteNonQuery(String sql, List<Object> params) throws SQLException {
        PreparedStatement stmt = null;
        
        try {
            stmt = connection.prepareStatement(sql);
            
            if (params != null) {
                for (int i = 0; i < params.size(); i++) {
                    stmt.setObject(i + 1, params.get(i));
                }
            }
            
            return stmt.executeUpdate();
            
        } finally {
            if (stmt != null) stmt.close();
        }
    }
    
    public Object ExecuteScalar(String sql, List<Object> params) throws SQLException {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            stmt = connection.prepareStatement(sql);
            
            if (params != null) {
                for (int i = 0; i < params.size(); i++) {
                    stmt.setObject(i + 1, params.get(i));
                }
            }
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getObject(1);
            }
            
            return null;
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
    }
    
    public void CerrarConexion() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
        instance = null;
    }
    
    public Connection getConnection() {
        return connection;
    }
}
