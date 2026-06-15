package com.sigre.almacen.config;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.core.convert.ConversionFailedException;
import org.springframework.format.support.DefaultFormattingConversionService;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class AlmacenWebMvcConfigTest {

    private DefaultFormattingConversionService conversionService;

    @BeforeEach
    void setUp() {
        conversionService = new DefaultFormattingConversionService();
        new AlmacenWebMvcConfig().addFormatters(conversionService);
    }

    @Test
    void localDate_blankEsNull() {
        assertThat(conversionService.convert("", LocalDate.class)).isNull();
        assertThat(conversionService.convert("  ", LocalDate.class)).isNull();
    }

    @Test
    void localDate_parseaIso() {
        assertThat(conversionService.convert("2026-05-04", LocalDate.class))
                .isEqualTo(LocalDate.of(2026, 5, 4));
    }

    @Test
    void localDate_invalida_lanza() {
        assertThatThrownBy(() -> conversionService.convert("no-es-fecha", LocalDate.class))
                .isInstanceOf(ConversionFailedException.class)
                .satisfies(ex -> assertThat(ex.getCause())
                        .isInstanceOf(IllegalArgumentException.class)
                        .hasMessageContaining("no es válida"));
    }

    @Test
    void long_blankEsNull() {
        assertThat(conversionService.convert("", Long.class)).isNull();
    }

    @Test
    void long_parseaEntero() {
        assertThat(conversionService.convert(" 42 ", Long.class)).isEqualTo(42L);
    }

    @Test
    void long_invalido_lanza() {
        assertThatThrownBy(() -> conversionService.convert("abc", Long.class))
                .isInstanceOf(ConversionFailedException.class)
                .hasRootCauseInstanceOf(IllegalArgumentException.class);
    }
}
