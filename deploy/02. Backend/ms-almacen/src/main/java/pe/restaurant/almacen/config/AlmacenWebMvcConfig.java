package pe.restaurant.almacen.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.format.FormatterRegistry;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;

/**
 * Trata cadenas vacías en query params ({@code fechaDesde=}, {@code almacenId=}) como {@code null}
 * para no forzar errores de conversión cuando Postman u otros clientes envían parámetros sin valor.
 */
@Configuration
public class AlmacenWebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addFormatters(@NonNull FormatterRegistry registry) {
        registry.addConverter(new Converter<String, LocalDate>() {
            @Override
            public LocalDate convert(@NonNull String source) {
                if (source.isBlank()) {
                    return null;
                }
                try {
                    return LocalDate.parse(source.trim());
                } catch (DateTimeParseException e) {
                    throw new IllegalArgumentException(
                            "La fecha '" + source.trim()
                                    + "' no es válida. Use el formato yyyy-MM-dd (ISO), por ejemplo 2026-05-04.",
                            e);
                }
            }
        });

        registry.addConverter(new Converter<String, Long>() {
            @Override
            public Long convert(@NonNull String source) {
                if (source.isBlank()) {
                    return null;
                }
                try {
                    return Long.parseLong(source.trim());
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException(
                            "El valor '" + source.trim() + "' no es un número entero válido para este parámetro.",
                            e);
                }
            }
        });
    }
}
