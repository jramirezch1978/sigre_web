package pe.sunat.web.rest.infrastructure.controller;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import pe.sunat.web.rest.application.AuthService;
import pe.sunat.web.rest.domain.model.TokenRequest;
import pe.sunat.web.rest.domain.model.TokenResponse;

/**
 * Controlador REST para autenticacion
 * Endpoint: /api/auth
 */
@Path("/auth")
public class AuthController {
    
    private AuthService authService;
    
    public AuthController() {
        this.authService = new AuthService();
    }
    
    /**
     * Genera un token JWT
     * POST /api/auth/token
     * 
     * Request Body:
     * {
     *   "usuario": "usuario",
     *   "clave": "clave123",
     *   "empresa": "EMPRESA01"
     * }
     * 
     * Response:
     * {
     *   "success": true,
     *   "token": "eyJhbGciOiJI...",
     *   "expiresIn": 900
     * }
     */
    @POST
    @Path("/token")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response generarToken(TokenRequest request) {
        try {
            // Validar request
            if (request.getUsuario() == null || request.getUsuario().trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(TokenResponse.error("El usuario es requerido"))
                    .build();
            }
            
            if (request.getClave() == null || request.getClave().trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(TokenResponse.error("La clave es requerida"))
                    .build();
            }
            
            if (request.getEmpresa() == null || request.getEmpresa().trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(TokenResponse.error("La empresa es requerida"))
                    .build();
            }
            
            // Generar token
            TokenResponse response = authService.generarToken(request);
            
            if (response.isSuccess()) {
                return Response.ok(response).build();
            } else {
                return Response.status(Response.Status.UNAUTHORIZED)
                    .entity(response)
                    .build();
            }
            
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(TokenResponse.error("Error interno: " + e.getMessage()))
                .build();
        }
    }
}
