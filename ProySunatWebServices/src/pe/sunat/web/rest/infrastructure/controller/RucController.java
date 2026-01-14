package pe.sunat.web.rest.infrastructure.controller;

import javax.ws.rs.Consumes;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
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
 * 
 * Parametros SOAP equivalentes:
 * - pRucConsulta  -> rucConsulta (body)
 * - pRucOrigen    -> rucOrigen (body)
 * - pComputerName -> computerName (body)
 * - pUsuario      -> en JWT (token)
 * - pClave        -> validado al generar token
 * - pEmpresa      -> en JWT (token)
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
     * Consulta un RUC
     * POST /api/ruc/consultar
     * Header: Authorization: Bearer {token}
     * 
     * Request Body:
     * {
     *   "rucConsulta": "20123456789",
     *   "rucOrigen": "20100070970",
     *   "computerName": "PC-COMPRAS01"
     * }
     */
    @POST
    @Path("/consultar")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response consultarRuc(
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
        if (request == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(RucResponse.error("Request body es requerido"))
                .build();
        }
        
        if (request.getRucConsulta() == null || request.getRucConsulta().trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(RucResponse.error("El campo rucConsulta es requerido"))
                .build();
        }
        
        if (request.getRucOrigen() == null || request.getRucOrigen().trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(RucResponse.error("El campo rucOrigen es requerido"))
                .build();
        }
        
        if (request.getComputerName() == null || request.getComputerName().trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(RucResponse.error("El campo computerName es requerido"))
                .build();
        }
        
        try {
            // Consultar RUC
            RucData data = rucService.consultarRuc(request.getRucConsulta());
            
            // Registrar consulta exitosa
            try {
                rucService.registrarConsulta(
                    request.getRucConsulta(), 
                    request.getRucOrigen(), 
                    claims.getEmpresa(), 
                    request.getComputerName(), 
                    claims.getUsuario(), 
                    true
                );
            } catch (Exception e) {
                System.err.println("Error registrando consulta: " + e.getMessage());
            }
            
            return Response.ok(RucResponse.ok(data)).build();
            
        } catch (Exception e) {
            // Registrar consulta fallida
            try {
                rucService.registrarConsulta(
                    request.getRucConsulta(), 
                    request.getRucOrigen(), 
                    claims.getEmpresa(), 
                    request.getComputerName(), 
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
