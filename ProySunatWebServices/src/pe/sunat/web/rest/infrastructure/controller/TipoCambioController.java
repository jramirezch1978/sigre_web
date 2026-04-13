package pe.sunat.web.rest.infrastructure.controller;

import javax.ws.rs.Consumes;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import pe.sunat.web.beans.BeanPadronRuc;
import pe.sunat.web.beans.BeanUsuario;
import pe.sunat.web.controlador.CntrlConsultaRUC;
import pe.sunat.web.rest.application.AuthService;
import pe.sunat.web.rest.application.TipoCambioService;
import pe.sunat.web.rest.domain.model.TipoCambioData;
import pe.sunat.web.rest.domain.model.TipoCambioRequest;
import pe.sunat.web.rest.domain.model.TipoCambioResponse;
import pe.sunat.web.rest.domain.port.AuthPort.TokenClaims;

/**
 * Controlador REST para consulta de tipo de cambio SUNAT/SBS
 * Endpoint: /api/tipo-cambio
 * Requiere autenticacion JWT
 * 
 * POST /api/tipo-cambio/consultar
 * Header: Authorization: Bearer {token}
 * Body: {"fecha": "2026-04-13"}  (o vacio para hoy)
 */
@Path("/tipo-cambio")
public class TipoCambioController {
    
    private TipoCambioService tipoCambioService;
    private AuthService authService;
    private CntrlConsultaRUC cntrlConsultaRUC;
    
    public TipoCambioController() {
        this.tipoCambioService = new TipoCambioService();
        this.authService = new AuthService();
        this.cntrlConsultaRUC = new CntrlConsultaRUC();
    }
    
    @POST
    @Path("/consultar")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response consultarTipoCambio(
            TipoCambioRequest request,
            @HeaderParam("Authorization") String authHeader) {
        
        TokenClaims claims = validarAutorizacion(authHeader);
        if (!claims.isValid()) {
            return Response.status(Response.Status.UNAUTHORIZED)
                .entity(TipoCambioResponse.error(claims.getError()))
                .build();
        }
        
        String fecha = (request != null && request.getFecha() != null) 
                        ? request.getFecha().trim() : "today";
        
        try {
            TipoCambioData data = tipoCambioService.consultarTipoCambio(fecha);
            
            registrarConsulta(fecha, claims, true);
            
            return Response.ok(TipoCambioResponse.ok(data)).build();
            
        } catch (Exception e) {
            registrarConsulta(fecha, claims, false);
            
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(TipoCambioResponse.error(e.getMessage()))
                .build();
        }
    }
    
    private void registrarConsulta(String fecha, TokenClaims claims, boolean exitoso) {
        try {
            BeanUsuario beanUsuario = new BeanUsuario();
            beanUsuario.setCodUsuario(claims.getUsuario());
            
            BeanPadronRuc beanLog = new BeanPadronRuc();
            beanLog.setIsOk(exitoso);
            beanLog.setRuc("TIPO_CAMBIO");
            
            cntrlConsultaRUC.registrarConsulta(
                "TIPO_CAMBIO", fecha,
                claims.getEmpresa(), claims.getComputerName(),
                claims.getIpLocal(), beanUsuario, beanLog);
        } catch (Exception e) {
            System.err.println("Error registrando consulta tipo cambio: " + e.getMessage());
        }
    }
    
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
