package pe.restaurant.compras.config;

import feign.RequestInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Configuration
public class FeignConfig {

    @Bean
    public RequestInterceptor requestInterceptor() {
        return requestTemplate -> {
            ServletRequestAttributes attributes =
                    (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes == null) {
                return;
            }

            String authorization = attributes.getRequest().getHeader("Authorization");
            if (authorization != null) {
                requestTemplate.header("Authorization", authorization);
            }

            String userId = attributes.getRequest().getHeader("X-User-Id");
            if (userId != null) {
                requestTemplate.header("X-User-Id", userId);
            }

            String empresaId = attributes.getRequest().getHeader("X-Empresa-Id");
            if (empresaId != null) {
                requestTemplate.header("X-Empresa-Id", empresaId);
            }

            String sucursalId = attributes.getRequest().getHeader("X-Sucursal-Id");
            if (sucursalId != null) {
                requestTemplate.header("X-Sucursal-Id", sucursalId);
            }
        };
    }
}
