package pe.sigre.lib.bean.ancestor;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import javax.sql.rowset.CachedRowSet;

/**
 * Clase base para todos los Beans del sistema SIGRE
 * Proporciona funcionalidades comunes como manejo de respuesta y utilidades
 */
public class BeanAncestor {
    
    private Boolean isOk = false;
    private String mensaje = "";
    
    public Boolean getIsOk() {
        return isOk;
    }
    
    public void setIsOk(Boolean isOk) {
        this.isOk = isOk;
    }
    
    public String getMensaje() {
        return mensaje;
    }
    
    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }
    
    /**
     * Verifica si una columna existe en el ResultSet
     * @param rs CachedRowSet a verificar
     * @param columnName Nombre de la columna
     * @return true si la columna existe, false en caso contrario
     */
    public boolean hasColumn(CachedRowSet rs, String columnName) {
        try {
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();
            
            for (int i = 1; i <= columnCount; i++) {
                if (metaData.getColumnName(i).equalsIgnoreCase(columnName)) {
                    return true;
                }
            }
            return false;
        } catch (SQLException e) {
            return false;
        }
    }
    
    /**
     * Verifica si una columna existe en el ResultSet
     * @param rs ResultSet a verificar
     * @param columnName Nombre de la columna
     * @return true si la columna existe, false en caso contrario
     */
    public boolean hasColumn(ResultSet rs, String columnName) {
        try {
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();
            
            for (int i = 1; i <= columnCount; i++) {
                if (metaData.getColumnName(i).equalsIgnoreCase(columnName)) {
                    return true;
                }
            }
            return false;
        } catch (SQLException e) {
            return false;
        }
    }
}
