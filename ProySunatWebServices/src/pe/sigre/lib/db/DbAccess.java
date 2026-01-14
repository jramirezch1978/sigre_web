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
 * Lee configuracion del archivo SunatWebServices.ini
 */
public class DbAccess {
    
    private Connection connection = null;
    private static DbAccess instance = null;
    
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
            // Leer configuracion del INI
            String empresaDefault = SettingINI.getValue("General", "EMPRESA_DEFAULT", "DEFAULT");
            String environment = SettingINI.getValue(empresaDefault, "ENVIRONMENT", "PROD");
            String seccionBD = empresaDefault + "_" + environment;
            
            String driver = SettingINI.getValue(empresaDefault, "DRIVER_JDBC", "oracle.jdbc.driver.OracleDriver");
            String host = SettingINI.getValue(seccionBD, "HOST", "localhost");
            String port = SettingINI.getValue(seccionBD, "PORT", "1521");
            String sid = SettingINI.getValue(seccionBD, "SID", "ORCL");
            String user = SettingINI.getValue(seccionBD, "USER", "system");
            String password = SettingINI.getValue(seccionBD, "CLAVE", "oracle");
            
            Class.forName(driver);
            
            String url = "jdbc:oracle:thin:@" + host + ":" + port + ":" + sid;
            
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
