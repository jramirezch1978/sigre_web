package pe.sigre.lib.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Clase utilitaria para manejo de archivos de configuracion INI
 * Soporta secciones como [General], [DEFAULT], [DEFAULT_PROD], etc.
 */
public class SettingINI {
    
    public static String fileINI = "config.ini";
    private static Map<String, Map<String, String>> sections = null;
    private static String loadedFile = null;
    
    /**
     * Obtiene el valor de una clave del archivo INI
     * @param section Seccion del archivo INI
     * @param key Clave a buscar
     * @return Valor de la clave o null si no existe
     */
    public static String getValue(String section, String key) {
        loadProperties();
        Map<String, String> sectionMap = sections.get(section.toUpperCase());
        if (sectionMap != null) {
            return sectionMap.get(key.toUpperCase());
        }
        return null;
    }
    
    /**
     * Obtiene el valor de una clave del archivo INI con valor por defecto
     * @param section Seccion del archivo INI
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
        // Recargar si el archivo INI cambio
        if (sections != null && loadedFile != null && !loadedFile.equals(fileINI)) {
            sections = null;
        }
        
        if (sections == null) {
            loadedFile = fileINI;
            sections = new HashMap<String, Map<String, String>>();
            BufferedReader reader = null;
            
            try {
                reader = new BufferedReader(new FileReader(fileINI));
                String line;
                String currentSection = "GENERAL";
                
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    
                    // Ignorar lineas vacias y comentarios
                    if (line.isEmpty() || line.startsWith(";") || line.startsWith("#")) {
                        continue;
                    }
                    
                    // Detectar seccion [NombreSeccion]
                    if (line.startsWith("[") && line.endsWith("]")) {
                        currentSection = line.substring(1, line.length() - 1).toUpperCase();
                        if (!sections.containsKey(currentSection)) {
                            sections.put(currentSection, new HashMap<String, String>());
                        }
                        continue;
                    }
                    
                    // Leer clave = valor
                    int equalsPos = line.indexOf('=');
                    if (equalsPos > 0) {
                        String key = line.substring(0, equalsPos).trim().toUpperCase();
                        String value = line.substring(equalsPos + 1).trim();
                        
                        if (!sections.containsKey(currentSection)) {
                            sections.put(currentSection, new HashMap<String, String>());
                        }
                        sections.get(currentSection).put(key, value);
                    }
                }
                
            } catch (IOException e) {
                System.err.println("Error leyendo archivo INI [" + fileINI + "]: " + e.getMessage());
                // Crear secciones vacias por defecto
                sections.put("GENERAL", new HashMap<String, String>());
            } finally {
                if (reader != null) {
                    try {
                        reader.close();
                    } catch (IOException e) {
                        // Ignorar
                    }
                }
            }
        }
    }
    
    /**
     * Recarga las propiedades del archivo INI
     */
    public static void reload() {
        sections = null;
        loadProperties();
    }
}
