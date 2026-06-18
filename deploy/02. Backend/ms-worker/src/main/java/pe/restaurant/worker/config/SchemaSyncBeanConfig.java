package pe.restaurant.worker.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import pe.restaurant.common.schema.PgSchemaMetadataReader;

@Configuration
@EnableConfigurationProperties(SchemaSyncNotificationProperties.class)
public class SchemaSyncBeanConfig {

    @Bean
    public PgSchemaMetadataReader pgSchemaMetadataReader() {
        return new PgSchemaMetadataReader();
    }
}
