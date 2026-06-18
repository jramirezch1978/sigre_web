package com.sigre.sync.worker.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import com.sigre.common.schema.PgSchemaMetadataReader;

@Configuration
@EnableConfigurationProperties({
        SchemaSyncNotificationProperties.class,
        DataSyncProperties.class,
        ActivosJobsProperties.class
})
public class SchemaSyncBeanConfig {

    @Bean
    public PgSchemaMetadataReader pgSchemaMetadataReader() {
        return new PgSchemaMetadataReader();
    }
}
