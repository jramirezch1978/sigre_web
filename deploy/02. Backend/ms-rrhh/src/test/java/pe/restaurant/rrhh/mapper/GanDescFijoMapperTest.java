package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.rrhh.dto.response.GanDescFijoResponse;
import pe.restaurant.rrhh.entity.ConceptoPlanilla;
import pe.restaurant.rrhh.entity.GanDescFijo;
import pe.restaurant.rrhh.entity.Trabajador;
import pe.restaurant.rrhh.repository.ConceptoPlanillaRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("GanDescFijoMapper — Pruebas Unitarias")
class GanDescFijoMapperTest {

    @Mock private TrabajadorRepository trabajadorRepository;
    @Mock private ConceptoPlanillaRepository conceptoPlanillaRepository;

    private GanDescFijoMapper mapper;

    @BeforeEach
    void setUp() {
        mapper = new GanDescFijoMapper(trabajadorRepository, conceptoPlanillaRepository);
    }

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO con nombres resueltos")
    void toResponse_convierteEntidadADTO() {
        Trabajador t = new Trabajador();
        t.setId(1L);
        t.setNombres("Juan");
        t.setApellidoPaterno("Pérez");
        t.setApellidoMaterno("García");

        ConceptoPlanilla cp = new ConceptoPlanilla();
        cp.setId(1L);
        cp.setNombre("Bonificación por productividad");

        when(trabajadorRepository.findById(1L)).thenReturn(Optional.of(t));
        when(conceptoPlanillaRepository.findById(1L)).thenReturn(Optional.of(cp));

        GanDescFijo entity = new GanDescFijo();
        entity.setId(1L);
        entity.setTrabajadorId(1L);
        entity.setConceptoId(1L);
        entity.setImpGanDesc(new BigDecimal("500.0000"));
        entity.setFlagEstado("1");
        entity.setCreatedBy(10L);
        entity.setFecCreacion(Instant.parse("2026-05-20T15:30:00Z"));

        GanDescFijoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getTrabajadorNombres()).isEqualTo("Pérez García, Juan");
        assertThat(response.getConceptoId()).isEqualTo(1L);
        assertThat(response.getConceptoDescripcion()).isEqualTo("Bonificación por productividad");
        assertThat(response.getImpGanDesc()).isEqualByComparingTo(new BigDecimal("500.0000"));
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(10L);
        assertThat(response.getFecCreacion()).isEqualTo("20/05/2026 10:30:00");
    }

    @Test
    @DisplayName("toResponse() con trabajador sin apellido materno -> solo paterno y nombres")
    void toResponse_sinApellidoMaterno() {
        Trabajador t = new Trabajador();
        t.setId(1L);
        t.setNombres("Juan");
        t.setApellidoPaterno("Pérez");

        when(trabajadorRepository.findById(1L)).thenReturn(Optional.of(t));
        when(conceptoPlanillaRepository.findById(1L)).thenReturn(Optional.of(new ConceptoPlanilla()));

        GanDescFijo entity = new GanDescFijo();
        entity.setId(1L);
        entity.setTrabajadorId(1L);
        entity.setConceptoId(1L);
        entity.setFlagEstado("1");

        GanDescFijoResponse response = mapper.toResponse(entity);

        assertThat(response.getTrabajadorNombres()).isEqualTo("Pérez, Juan");
    }

    @Test
    @DisplayName("toResponse() con repositorios que retornan empty -> nombres null")
    void toResponse_repositoriosEmpty_nombresNull() {
        when(trabajadorRepository.findById(anyLong())).thenReturn(Optional.empty());
        when(conceptoPlanillaRepository.findById(anyLong())).thenReturn(Optional.empty());

        GanDescFijo entity = new GanDescFijo();
        entity.setId(1L);
        entity.setTrabajadorId(1L);
        entity.setConceptoId(1L);
        entity.setFlagEstado("1");

        GanDescFijoResponse response = mapper.toResponse(entity);

        assertThat(response.getTrabajadorNombres()).isNull();
        assertThat(response.getConceptoDescripcion()).isNull();
    }
}
