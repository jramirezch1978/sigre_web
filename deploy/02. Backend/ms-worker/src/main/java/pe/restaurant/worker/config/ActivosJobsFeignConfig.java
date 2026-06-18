package pe.restaurant.worker.config;

import feign.RequestInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.util.StringUtils;

public class ActivosJobsFeignConfig {

    @Bean
    public RequestInterceptor activosJobsAuthInterceptor(ActivosJobsProperties properties) {
        return template -> {
            if (StringUtils.hasText(properties.getBearerToken())) {
                template.header("Authorization", "Bearer " + properties.getBearerToken());
            }
            if (properties.getEmpresaId() != null) {
                template.header("X-Empresa-Id", String.valueOf(properties.getEmpresaId()));
            }
            if (StringUtils.hasText(properties.getDbName())) {
                template.header("X-Tenant-Db", properties.getDbName());
            }
        };
    }
}
