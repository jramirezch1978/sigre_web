package pe.com.hermes.appmobile.data.config;

import android.content.Context;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Configuracion de conexion — lista de perfiles de SERVIDOR REMOTO (nombre, host, puerto,
 * protocolo, si es el default), igual que ImplServerRemote/BeanServerRemote de FastSales,
 * pero persistida en un ARCHIVO real dentro del almacenamiento privado de la app
 * (files/appconfig.json), no en SharedPreferences.
 *
 * Al primer arranque se copia el default embebido en assets/appconfig.json; a partir de ahi
 * toda lectura/escritura (alta/edicion/borrado de servidores desde la UI) opera sobre ese
 * archivo, que persiste entre sesiones y sobrevive un logout.
 */
public class AppConfig {

    public static final String DEFAULT_API_BASE_URL = "http://10.0.2.2:9080/api/";

    private final Context context;
    private final File configFile;

    public AppConfig(Context context) {
        this.context = context;
        this.configFile = new File(context.getFilesDir(), "appconfig.json");
    }

    private File asegurarArchivo() {
        if (!configFile.exists()) {
            try {
                InputStream in = context.getAssets().open("appconfig.json");
                BufferedReader reader = new BufferedReader(new InputStreamReader(in));
                StringBuilder sb = new StringBuilder();
                String linea;
                while ((linea = reader.readLine()) != null) sb.append(linea).append('\n');
                reader.close();
                try (FileWriter writer = new FileWriter(configFile)) {
                    writer.write(sb.toString());
                }
            } catch (IOException e) {
                throw new RuntimeException("No se pudo inicializar appconfig.json", e);
            }
        }
        return configFile;
    }

    private JSONObject leerJson() {
        try {
            File archivo = asegurarArchivo();
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new FileReader(archivo))) {
                String linea;
                while ((linea = reader.readLine()) != null) sb.append(linea).append('\n');
            }
            return new JSONObject(sb.toString());
        } catch (IOException | JSONException e) {
            return new JSONObject();
        }
    }

    private void escribirJson(JSONObject json) {
        try (FileWriter writer = new FileWriter(asegurarArchivo())) {
            writer.write(json.toString(2));
        } catch (IOException | JSONException e) {
            throw new RuntimeException("No se pudo escribir appconfig.json", e);
        }
    }

    public List<ServerProfile> listarServidores() {
        List<ServerProfile> resultado = new ArrayList<>();
        JSONArray arr = leerJson().optJSONArray("servers");
        if (arr == null) return resultado;
        for (int i = 0; i < arr.length(); i++) {
            JSONObject o = arr.optJSONObject(i);
            if (o == null) continue;
            resultado.add(new ServerProfile(
                    o.optString("nombre", ""),
                    o.optString("hostIp", ""),
                    o.optString("port", ""),
                    o.optString("protocolo", "http"),
                    o.optBoolean("flagDefault", false)
            ));
        }
        return resultado;
    }

    public void guardarServidores(List<ServerProfile> servidores) {
        JSONArray arr = new JSONArray();
        for (ServerProfile s : servidores) {
            JSONObject o = new JSONObject();
            try {
                o.put("nombre", s.getNombre());
                o.put("hostIp", s.getHostIp());
                o.put("port", s.getPort());
                o.put("protocolo", s.getProtocolo());
                o.put("flagDefault", s.isFlagDefault());
            } catch (JSONException e) {
                throw new RuntimeException(e);
            }
            arr.put(o);
        }
        JSONObject json = leerJson();
        try {
            json.put("servers", arr);
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
        escribirJson(json);
    }

    /** Anade un servidor; si viene marcado como default, desmarca a los demas. */
    public void agregarServidor(ServerProfile nuevo) {
        List<ServerProfile> actuales = listarServidores();
        if (nuevo.isFlagDefault()) {
            for (ServerProfile s : actuales) s.setFlagDefault(false);
        }
        actuales.add(nuevo);
        guardarServidores(actuales);
    }

    /** Reemplaza el servidor en indice; si viene marcado como default, desmarca a los demas. */
    public void actualizarServidor(int indice, ServerProfile editado) {
        List<ServerProfile> actuales = listarServidores();
        if (indice < 0 || indice >= actuales.size()) return;
        if (editado.isFlagDefault()) {
            for (ServerProfile s : actuales) s.setFlagDefault(false);
        }
        actuales.set(indice, editado);
        guardarServidores(actuales);
    }

    public void eliminarServidor(int indice) {
        List<ServerProfile> actuales = listarServidores();
        if (indice < 0 || indice >= actuales.size()) return;
        actuales.remove(indice);
        guardarServidores(actuales);
    }

    public ServerProfile obtenerDefault() {
        for (ServerProfile s : listarServidores()) {
            if (s.isFlagDefault()) return s;
        }
        return null;
    }

    /** URL base real que consume Retrofit — la del servidor marcado como default. */
    public String getApiBaseUrl() {
        ServerProfile def = obtenerDefault();
        return def != null ? def.apiBaseUrl() : DEFAULT_API_BASE_URL;
    }
}
