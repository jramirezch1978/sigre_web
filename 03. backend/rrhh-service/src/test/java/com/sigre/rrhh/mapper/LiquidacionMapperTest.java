package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.response.LiquidacionResponse;
import com.sigre.rrhh.entity.Liquidacion;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.repository.TrabajadorRepository;

import java.math.BigDecimal;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("LiquidacionMapper — Pruebas Unitarias")
class LiquidacionMapperTest {

    @Mock
    private TrabajadorRepository trabajadorRepository;

    @InjectMocks
    private LiquidacionMapper mapper;

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        Liquidacion entity = RrhhTestFixtures.liquidacion(1L);
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);
        when(trabajadorRepository.findById(1L)).thenReturn(Optional.of(trabajador));

        LiquidacionResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getTrabajadorNombres()).isEqualTo("Nombre 1 Paterno Materno");
        assertThat(response.getFechaCese()).isEqualTo("2026-01-31");
        assertThat(response.getCtsPendiente()).isEqualByComparingTo(new BigDecimal("1500.0000"));
        assertThat(response.getVacacionesTruncas()).isEqualByComparingTo(new BigDecimal("250.0000"));
        assertThat(response.getGratificacionTrunca()).isEqualByComparingTo(new BigDecimal("3000.0000"));
        assertThat(response.getIndemnizacion()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(response.getTotalBeneficios()).isEqualByComparingTo(new BigDecimal("4750.0000"));
        assertThat(response.getTotalDescuentos()).isEqualByComparingTo(new BigDecimal("390.0000"));
        assertThat(response.getNetoPagar()).isEqualByComparingTo(new BigDecimal("4360.0000"));
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponse() con trabajadorId null -> no resuelve nombres")
    void toResponse_trabajadorIdNull_noResuelveNombres() {
        Liquidacion entity = RrhhTestFixtures.liquidacion(1L);
        entity.setTrabajadorId(null);

        LiquidacionResponse response = mapper.toResponse(entity);

        assertThat(response.getTrabajadorNombres()).isNull();
    }

    @Test
    @DisplayName("toResponse() con trabajador inexistente -> nombres null")
    void toResponse_trabajadorInexistente_nombresNull() {
        Liquidacion entity = RrhhTestFixtures.liquidacion(1L);
        when(trabajadorRepository.findById(1L)).thenReturn(Optional.empty());

        LiquidacionResponse response = mapper.toResponse(entity);

        assertThat(response.getTrabajadorNombres()).isNull();
    }

    @Test
    @DisplayName("toResponse() -> formatea fecCreacion correctamente")
    void toResponse_formateaFecCreacion() {
        Liquidacion entity = RrhhTestFixtures.liquidacion(1L);
        when(trabajadorRepository.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.trabajador(1L)));

        LiquidacionResponse response = mapper.toResponse(entity);

        assertThat(response.getFecCreacion()).isNotNull();
        assertThat(response.getCreatedBy()).isEqualTo(1L);
    }
}
