package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.response.QuintaCategoriaResponse;
import com.sigre.rrhh.entity.QuintaCategoria;
import com.sigre.rrhh.entity.TipoPlanilla;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.repository.TipoPlanillaRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;

import java.math.BigDecimal;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("QuintaCategoriaMapper — Pruebas Unitarias")
class QuintaCategoriaMapperTest {

    @Mock
    private TrabajadorRepository trabajadorRepo;

    @Mock
    private TipoPlanillaRepository tipoPlanillaRepo;

    @InjectMocks
    private QuintaCategoriaMapper mapper;

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        QuintaCategoria entity = RrhhTestFixtures.quintaCategoria(1L);
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);
        TipoPlanilla tipoPlanilla = new TipoPlanilla();
        tipoPlanilla.setId(1L);
        tipoPlanilla.setCodigo("N");
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(tipoPlanillaRepo.findById(1L)).thenReturn(Optional.of(tipoPlanilla));

        QuintaCategoriaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getFecProceso()).isEqualTo("30/06/2026");
        assertThat(response.getTipoPlanillaCodigo()).isEqualTo("N");
        assertThat(response.getRemProyectable()).isEqualByComparingTo(new BigDecimal("42000.00"));
        assertThat(response.getRemRetencion()).isEqualByComparingTo(new BigDecimal("60.67"));
    }

    @Test
    @DisplayName("toResponse() -> resuelve nombre del trabajador")
    void toResponse_resuelveNombreTrabajador() {
        QuintaCategoria entity = RrhhTestFixtures.quintaCategoria(1L);
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.trabajador(1L)));
        when(tipoPlanillaRepo.findById(1L)).thenReturn(Optional.empty());

        QuintaCategoriaResponse response = mapper.toResponse(entity);

        assertThat(response.getTrabajadorNombres()).isNotNull();
    }

    @Test
    @DisplayName("toResponse() con trabajadorId null -> nombres null")
    void toResponse_trabajadorIdNull_nombresNull() {
        QuintaCategoria entity = RrhhTestFixtures.quintaCategoria(1L);
        entity.setTrabajadorId(null);

        QuintaCategoriaResponse response = mapper.toResponse(entity);

        assertThat(response.getTrabajadorNombres()).isNull();
    }

    @Test
    @DisplayName("toResponse() -> formatea fecCreacion correctamente")
    void toResponse_formateaFecCreacion() {
        QuintaCategoria entity = RrhhTestFixtures.quintaCategoria(1L);
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.trabajador(1L)));
        when(tipoPlanillaRepo.findById(1L)).thenReturn(Optional.empty());

        QuintaCategoriaResponse response = mapper.toResponse(entity);

        assertThat(response.getFecCreacion()).isNotNull();
        assertThat(response.getCreatedBy()).isEqualTo(1L);
    }
}
