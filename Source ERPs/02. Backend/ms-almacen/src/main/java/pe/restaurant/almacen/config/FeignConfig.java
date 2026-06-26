package pe.restaurant.almacen.config;

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
            propagarHeader(requestTemplate, attributes, "Authorization");
            propagarHeader(requestTemplate, attributes, "X-User-Id");
            propagarHeader(requestTemplate, attributes, "X-Empresa-Id");
            propagarHeader(requestTemplate, attributes, "X-Sucursal-Id");
        };
    }

    private void propagarHeader(feign.RequestTemplate requestTemplate,
                                ServletRequestAttributes attributes, String header) {
        String value = attributes.getRequest().getHeader(header);
        if (value != null) {
            requestTemplate.header(header, value);
        }
    }
}
