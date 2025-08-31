package com.sigre.sync.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import lombok.extern.slf4j.Slf4j;

import java.util.Properties;

@Configuration
@Slf4j
public class EmailConfig {
    
    @Value("${spring.mail.host:smtp.gmail.com}")
    private String host;
    
    @Value("${spring.mail.port:587}")
    private int port;
    
    @Value("${spring.mail.username:}")
    private String username;
    
    @Value("${spring.mail.password:}")
    private String password;
    
    @Value("${spring.mail.properties.mail.smtp.auth:true}")
    private boolean auth;
    
    @Value("${spring.mail.properties.mail.smtp.starttls.enable:true}")
    private boolean starttls;
    
    @Value("${spring.mail.notifications.enabled:false}")
    private boolean emailEnabled;
    
    /**
     * Bean condicional de JavaMailSender
     * Solo se crea si las notificaciones están habilitadas
     */
    @Bean
    @ConditionalOnProperty(
        name = "spring.mail.notifications.enabled", 
        havingValue = "true",
        matchIfMissing = false
    )
    public JavaMailSender javaMailSender() {
        log.info("📧 Configurando servicio de email - Notificaciones habilitadas");
        
        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
        mailSender.setHost(host);
        mailSender.setPort(port);
        
        if (username != null && !username.isEmpty()) {
            mailSender.setUsername(username);
            mailSender.setPassword(password);
        }
        
        Properties props = mailSender.getJavaMailProperties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.auth", auth);
        props.put("mail.smtp.starttls.enable", starttls);
        props.put("mail.debug", "false");
        
        log.info("✅ JavaMailSender configurado exitosamente");
        return mailSender;
    }
    
    /**
     * Bean nulo cuando las notificaciones están deshabilitadas
     */
    @Bean
    @ConditionalOnProperty(
        name = "spring.mail.notifications.enabled", 
        havingValue = "false",
        matchIfMissing = true
    )
    public JavaMailSender nullMailSender() {
        log.warn("⚠️ Notificaciones por email deshabilitadas - JavaMailSender no configurado");
        return null;
    }
}
