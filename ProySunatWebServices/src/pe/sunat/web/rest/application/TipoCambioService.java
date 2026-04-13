package pe.sunat.web.rest.application;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import pe.sunat.web.rest.domain.model.TipoCambioData;
import pe.sunat.web.rest.domain.port.TipoCambioPort;

/**
 * Servicio de tipo de cambio - Capa de aplicacion
 * Consulta la API externa free.e-api.net.pe y parsea la respuesta
 */
public class TipoCambioService implements TipoCambioPort {
    
    private static final String API_BASE_URL = "https://free.e-api.net.pe/tipo-cambio/";
    private static final int TIMEOUT_MS = 10000;
    
    @Override
    public TipoCambioData consultarTipoCambio(String fecha) throws Exception {
        String endpoint = (fecha == null || fecha.trim().isEmpty()) ? "today" : fecha.trim();
        String url = API_BASE_URL + endpoint + ".json";
        
        String jsonResponse = httpGet(url);
        
        if (jsonResponse == null || jsonResponse.trim().isEmpty()) {
            throw new Exception("Respuesta vacia de la API de tipo de cambio");
        }
        
        return parsearRespuesta(jsonResponse);
    }
    
    private String httpGet(String urlStr) throws Exception {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(urlStr);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(TIMEOUT_MS);
            conn.setReadTimeout(TIMEOUT_MS);
            conn.setRequestProperty("Accept", "application/json");
            
            int status = conn.getResponseCode();
            if (status != 200) {
                throw new Exception("API retorno codigo " + status + " para URL: " + urlStr);
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
