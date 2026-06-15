package com.sigre.finanzas.testutil;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;

/**
 * Helper para obtener tokens de autenticación con contexto de empresa para tests.
 * Implementa el flujo completo: login → seleccionar-empresa → token final.
 * 
 * @author Equipo de Desarrollo
 */
public class TokenHelper {
    
    private static final String LOGIN_URL = "/api/auth/login";
    private static final String SELECCIONAR_EMPRESA_URL = "/api/auth/seleccionar-empresa";
    
    private static final ObjectMapper objectMapper;
    
    static {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
    }
    
    /**
     * Obtiene token de autenticación con contexto de empresa completo.
     * Ejecuta el flujo: login → seleccionar-empresa.
     * 
     * @param mockMvc Cliente MockMvc para realizar peticiones
     * @return Token JWT con contexto de empresa (empresaId=2, sucursalId=1)
     * @throws Exception Si ocurre error en la autenticación
     */
    public static String obtenerTokenConEmpresa(MockMvc mockMvc) throws Exception {
        // Paso 1: Login inicial
        String loginRequest = """
            {
                "email": "jramirez@npssac.com.pe",
                "password": "bxmuoLXS87hcR4IfUhEjS4Btmeo2SQ==",
                "passwordHash": "009389e3858fa09ccdabb98c29170408f65bbe7dc76268e7e4d37c79b97efafc",
                "ipAddress": "127.0.0.1",
                "ipPrivada": "192.168.1.10",
                "browser": "PostmanRuntime/7.44.0",
                "sistemaOperativo": "Windows 11"
            }
            """;
        
        MvcResult loginResult = mockMvc.perform(post(LOGIN_URL)
                .contentType(MediaType.APPLICATION_JSON)
                .content(loginRequest))
                .andReturn();
        
        if (loginResult.getResponse().getStatus() != 200) {
            throw new RuntimeException("Login falló: " + loginResult.getResponse().getContentAsString());
        }
        
        String loginResponse = loginResult.getResponse().getContentAsString();
        String tokenInicial = extraerTokenDeResponse(loginResponse);
        
        // Paso 2: Seleccionar empresa
        String seleccionarEmpresaRequest = """
            {
                "empresaId": 2,
                "sucursalId": 1,
                "ipAddress": "127.0.0.1",
                "ipPrivada": "192.168.1.10",
                "browser": "PostmanRuntime/7.44.0",
                "sistemaOperativo": "Windows 11"
            }
            """;
        
        MvcResult seleccionarResult = mockMvc.perform(post(SELECCIONAR_EMPRESA_URL)
                .contentType(MediaType.APPLICATION_JSON)
                .header("Authorization", "Bearer " + tokenInicial)
                .content(seleccionarEmpresaRequest))
                .andReturn();
        
        if (seleccionarResult.getResponse().getStatus() != 200) {
            throw new RuntimeException("Selección de empresa falló: " + seleccionarResult.getResponse().getContentAsString());
        }
        
        String seleccionarResponse = seleccionarResult.getResponse().getContentAsString();
        return extraerTokenDeResponse(seleccionarResponse);
    }
    
    /**
     * Extrae el token JWT de una respuesta JSON de autenticación.
     * Busca el campo "token" en la respuesta.
     * 
     * @param jsonResponse Respuesta JSON del endpoint de autenticación
     * @return Token JWT
     * @throws RuntimeException Si no encuentra el token en la respuesta
     */
    private static String extraerTokenDeResponse(String jsonResponse) {
        try {
            // Parsear JSON y extraer token
            com.fasterxml.jackson.databind.JsonNode jsonNode = objectMapper.readTree(jsonResponse);
            
            // Buscar token en diferentes posibles estructuras
            if (jsonNode.has("data") && jsonNode.get("data").has("token")) {
                return jsonNode.get("data").get("token").asText();
            }
            
            if (jsonNode.has("token")) {
                return jsonNode.get("token").asText();
            }
            
            throw new RuntimeException("No se encontró token en respuesta: " + jsonResponse);
            
        } catch (Exception e) {
            throw new RuntimeException("Error al extraer token de respuesta: " + jsonResponse, e);
        }
    }
    
    /**
     * Obtiene el encabezado Authorization completo para usar en MockMvc.
     * 
     * @param mockMvc Cliente MockMvc
     * @return String con formato "Bearer {token}"
     * @throws Exception Si ocurre error en autenticación
     */
    public static String obtenerAuthorizationHeader(MockMvc mockMvc) throws Exception {
        String token = obtenerTokenConEmpresa(mockMvc);
        return "Bearer " + token;
    }
}
