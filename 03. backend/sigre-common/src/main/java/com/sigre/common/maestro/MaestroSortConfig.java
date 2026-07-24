package com.sigre.common.maestro;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

/**
 * Habilita el aspect de sort por unique key (escaneado vía {@code com.sigre.common}).
 */
@Configuration
@EnableAspectJAutoProxy
public class MaestroSortConfig {
}
