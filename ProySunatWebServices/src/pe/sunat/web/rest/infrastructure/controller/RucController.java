package pe.sunat.web.rest.infrastructure.controller;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import pe.sunat.web.rest.application.AuthService;
import pe.sunat.web.rest.application.RucService;
import pe.sunat.web.rest.domain.model.RucData;
import pe.sunat.web.rest.domain.model.RucRequest;
import pe.sunat.web.rest.domain.model.RucResponse;
import pe.sunat.web.rest.domain.port.AuthPort.TokenClaims;

/**
 * Controlador REST para consulta de RUC
 * Endpoint: /api/ruc
 * Requiere autenticacion JWT
 */
@Path("/ruc")
public class RucController {
    
    private RucService rucService;
    private AuthService authService;
    
    public RucController() {
        this.rucService = new RucService();
        this.authService = new AuthService();
    }
    
    /**
     * Consulta un RUC por GET
     * GET /api/ruc/{ruc}
     * Header: Authorization: Bearer {token}
     */
    @GET
    @Path("/{ruc}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response consultarRucGet(
            @PathParam("ruc") String ruc,
            @QueryParam("rucOrigen") String rucOrigen,
            @QueryParam("computerName") String computerName,
            @HeaderParam("Authorization") String authHeader) {
        
        // Validar token
        TokenClaims claims = validarAutorizacion(authHeader);
        if (!claims.isValid()) {
            return Response.status(Response.Status.UNAUTHORIZED)
                .entity(RucResponse.error(claims.getError()))
                .build();
        }
        
        return procesarConsulta(ruc, rucOrigen, computerName, claims);
    }
    
    /**
     * Consulta un RUC por POST
     * POST /api/ruc/consultar
     * Header: Authorization: Bearer {token}
     * 
     * Request Body:
     * {
     *   "rucConsulta": "20123456789",
     *   "rucOrigen": "20100000001",
     *   "computerName": "PC-01"
     * }
     */
    @POST
    @Path("/consultar")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response consultarRucPost(
            RucRequest request,
            @HeaderParam("Authorization") String authHeader) {
        
        // Validar token
        TokenClaims claims = validarAutorizacion(authHeader);
        if (!claims.isValid()) {
            return Response.status(Response.Status.UNAUTHORIZED)
                .entity(RucResponse.error(claims.getError()))
                .build();
        }
        
        // Validar request
        if (request.getRucConsulta() == null || request.getRucConsulta().trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(RucResponse.error("El RUC a consultar es requerido"))
                .build();
        }
        
        return procesarConsulta(
            request.getRucConsulta(), 
            request.getRucOrigen(), 
            request.getComputerName(), 
            claims
        );
    }
    
    /**
     * Procesa la consulta de RUC
     */
    private Response procesarConsulta(String ruc, String rucOrigen, 
                                       String computerName, TokenClaims claims) {
        try {
            // Consultar RUC
            RucData data = rucService.consultarRuc(ruc);
            
            // Registrar consulta
            try {
                rucService.registrarConsulta(
                    ruc, 
                    rucOrigen != null ? rucOrigen : "", 
                    claims.getEmpresa(), 
                    computerName != null ? computerName : "REST-API", 
                    claims.getUsuario(), 
                    true
                );
            } catch (Exception e) {
                // No fallar si el registro falla
                System.err.println("Error registrando consulta: " + e.getMessage());
            }
            
            return Response.ok(RucResponse.ok(data)).build();
            
        } catch (Exception e) {
            // Registrar consulta fallida
            try {
                rucService.registrarConsulta(
                    ruc, 
                    rucOrigen != null ? rucOrigen : "", 
                    claims.getEmpresa(), 
                    computerName != null ? computerName : "REST-API", 
                    claims.getUsuario(), 
                    false
                );
            } catch (Exception ex) {
                // Ignorar
            }
            
            return Response.status(Response.Status.NOT_FOUND)
                .entity(RucResponse.error(e.getMessage()))
                .build();
        }
    }
    
    /**
     * Valida el header de autorizacion
     */
    private TokenClaims validarAutorizacion(String authHeader) {
        if (authHeader == null || authHeader.trim().isEmpty()) {
            return TokenClaims.invalid("Token no proporcionado");
        }
        
        if (!authHeader.startsWith("Bearer ")) {
            return TokenClaims.invalid("Formato de token invalido. Use: Bearer {token}");
        }
        
        String token = authHeader.substring(7);
        return authService.validarToken(token);
    }
}
