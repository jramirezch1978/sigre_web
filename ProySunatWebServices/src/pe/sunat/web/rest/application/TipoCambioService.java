package pe.sunat.web.rest.application;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;

import pe.sunat.web.rest.domain.model.TipoCambioData;
import pe.sunat.web.rest.domain.port.TipoCambioPort;

/**
 * Servicio de tipo de cambio - Capa de aplicacion
 * Consulta la API externa free.e-api.net.pe
 * Acepta fecha en formato dd/MM/yyyy y la convierte a YYYY-MM-DD para la API
 */
public class TipoCambioService implements TipoCambioPort {
    
    private static final String API_BASE_URL = "https://free.e-api.net.pe/tipo-cambio/";
    private static final int TIMEOUT_MS = 10000;
    
    private static final SimpleDateFormat FMT_INPUT  = new SimpleDateFormat("dd/MM/yyyy");
    private static final SimpleDateFormat FMT_API    = new SimpleDateFormat("yyyy-MM-dd");
    
    @Override
    public TipoCambioData consultarTipoCambio(String fecha) throws Exception {
        String fechaApi = convertirFecha(fecha);
        String url = API_BASE_URL + fechaApi + ".json";
        
        String jsonResponse = httpGet(url);
        
        if (jsonResponse == null || jsonResponse.trim().isEmpty()) {
            throw new Exception("Respuesta vacia de la API de tipo de cambio");
        }
        
        TipoCambioData data = parsearRespuesta(jsonResponse);
        
        // Devolver la fecha en formato dd/MM/yyyy al cliente
        if (data.getFecha() != null && data.getFecha().contains("-")) {
            try {
                Date d = FMT_API.parse(data.getFecha());
                data.setFecha(FMT_INPUT.format(d));
            } catch (Exception ignored) {}
        }
        
        return data;
    }
    
    /**
     * Convierte dd/MM/yyyy a YYYY-MM-DD para la API externa.
     * Si es null/vacio o "today", retorna "today".
     * Si ya viene en YYYY-MM-DD, lo deja tal cual.
     */
    private String convertirFecha(String fecha) throws Exception {
        if (fecha == null || fecha.trim().isEmpty() || fecha.trim().equalsIgnoreCase("today")) {
            return "today";
        }
        
        String f = fecha.trim();
        
        if (f.contains("/")) {
            try {
                Date d = FMT_INPUT.parse(f);
                return FMT_API.format(d);
            } catch (Exception e) {
                throw new Exception("Formato de fecha invalido: " + f + ". Use dd/MM/yyyy");
            }
        }
        
        return f;
    }
    
    private String httpGet(String urlStr) throws Exception {
        HttpURLConnection conn = null;
        try {
            // Forzar TLS 1.2 (JBoss/Java 7 usa TLS 1.0 por defecto)
            SSLContext sslContext = SSLContext.getInstance("TLSv1.2");
            sslContext.init(null, null, null);
            HttpsURLConnection.setDefaultSSLSocketFactory(sslContext.getSocketFactory());
            
            URL url = new URL(urlStr);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(TIMEOUT_MS);
            conn.setReadTimeout(TIMEOUT_MS);
            conn.setRequestProperty("Accept", "application/json");
            
            int status = conn.getResponseCode();
            if (status != 200) {
                throw new Exception("API retorno codigo " + status + " para fecha solicitada");
            }
            
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            reader.close();
            
            return sb.toString();
            
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }
    
    /**
     * Parsea JSON manualmente (sin Jackson, consistente con el proyecto)
     * Formato esperado: {"fecha":"2026-04-13","sunat":3.382,"compra":3.379,"venta":3.385}
     */
    private TipoCambioData parsearRespuesta(String json) throws Exception {
        TipoCambioData data = new TipoCambioData();
        
        data.setFecha(extraerString(json, "fecha"));
        data.setSunat(extraerDouble(json, "sunat"));
        data.setCompra(extraerDouble(json, "compra"));
        data.setVenta(extraerDouble(json, "venta"));
        
        if (data.getFecha() == null || data.getFecha().isEmpty()) {
            throw new Exception("No se pudo parsear la respuesta de tipo de cambio: " + json);
        }
        
        return data;
    }
    
    private String extraerString(String json, String key) {
        String search = "\"" + key + "\":\"";
        int pos = json.indexOf(search);
        if (pos < 0) return null;
        
        int start = pos + search.length();
        int end = json.indexOf("\"", start);
        if (end < 0) return null;
        
        return json.substring(start, end);
    }
    
    private double extraerDouble(String json, String key) {
        String search = "\"" + key + "\":";
        int pos = json.indexOf(search);
        if (pos < 0) return 0.0;
        
        int start = pos + search.length();
        int end = start;
        while (end < json.length() && (Character.isDigit(json.charAt(end)) || json.charAt(end) == '.')) {
            end++;
        }
        
        try {
            return Double.parseDouble(json.substring(start, end));
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }
}
