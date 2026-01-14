package pe.sunat.web.rest.infrastructure.config;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Filtro CORS para permitir peticiones desde cualquier origen
 * Implementado como Servlet Filter (compatible con JAX-RS 1.x/2.x)
 */
public class CorsFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        
        httpResponse.setHeader("Access-Control-Allow-Origin", "*");
        httpResponse.setHeader("Access-Control-Allow-Credentials", "true");
        httpResponse.setHeader("Access-Control-Allow-Headers", 
            "origin, content-type, accept, authorization");
        httpResponse.setHeader("Access-Control-Allow-Methods", 
            "GET, POST, PUT, DELETE, OPTIONS, HEAD");
        
        // Handle preflight OPTIONS request
        if ("OPTIONS".equalsIgnoreCase(httpRequest.getMethod())) {
            httpResponse.setStatus(HttpServletResponse.SC_OK);
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // No cleanup needed
    }
}
