package com.sigre.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.sigre.common.util.AesEncryptor;

/**
 * Configura el encriptador AES para contraseñas de BD tenant.
 * Solo se activa si existe la propiedad {@code app.encryption.key}.
 */
@Configuration
@ConditionalOnProperty(prefix = "app.encryption", name = "key")
public class EncryptionConfig {

    @Bean
    public AesEncryptor aesEncryptor(@Value("${app.encryption.key}") String base64Key) {
        return new AesEncryptor(base64Key);
    }
}
