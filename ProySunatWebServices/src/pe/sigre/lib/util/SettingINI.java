package pe.sigre.lib.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Clase utilitaria para manejo de archivos de configuración INI
 */
public class SettingINI {
    
    public static String fileINI = "config.ini";
    private static Properties properties = null;
    
    /**
     * Obtiene el valor de una clave del archivo INI
     * @param section Sección del archivo INI
     * @param key Clave a buscar
     * @return Valor de la clave o null si no existe
     */
    public static String getValue(String section, String key) {
        loadProperties();
        String fullKey = section + "." + key;
        return properties.getProperty(fullKey, properties.getProperty(key));
    }
    
    /**
     * Obtiene el valor de una clave del archivo INI con valor por defecto
     * @param section Sección del archivo INI
     * @param key Clave a buscar
     * @param defaultValue Valor por defecto
     * @return Valor de la clave o el valor por defecto
     */
    public static String getValue(String section, String key, String defaultValue) {
        String value = getValue(section, key);
        return value != null ? value : defaultValue;
    }
    
    /**
     * Carga las propiedades del archivo INI
     */
    private static void loadProperties() {
        if (properties == null) {
            properties = new Properties();
            try (InputStream input = new FileInputStream(fileINI)) {
                properties.load(input);
            } catch (IOException e) {
                // Si no se puede cargar el archivo, usar propiedades del sistema
                properties = new Properties(System.getProperties());
                
                // Cargar valores por defecto para conexión a BD
                loadDefaultDatabaseProperties();
            }
        }
    }
    
    /**
     * Carga propiedades por defecto para la base de datos
     */
    private static void loadDefaultDatabaseProperties() {
        // Intentar cargar desde variables de entorno
        String dbHost = System.getenv("DB_HOST");
        String dbPort = System.getenv("DB_PORT");
        String dbService = System.getenv("DB_SERVICE");
        String dbUser = System.getenv("DB_USER");
        String dbPassword = System.getenv("DB_PASSWORD");
        
        if (dbHost != null) properties.setProperty("database.host", dbHost);
        if (dbPort != null) properties.setProperty("database.port", dbPort);
        if (dbService != null) properties.setProperty("database.service", dbService);
        if (dbUser != null) properties.setProperty("database.user", dbUser);
        if (dbPassword != null) properties.setProperty("database.password", dbPassword);
    }
    
    /**
     * Recarga las propiedades del archivo INI
     */
    public static void reload() {
        properties = null;
        loadProperties();
    }
    
    /**
     * Obtiene todas las propiedades cargadas
     * @return Properties con todas las configuraciones
     */
    public static Properties getProperties() {
        loadProperties();
        return properties;
    }
}
