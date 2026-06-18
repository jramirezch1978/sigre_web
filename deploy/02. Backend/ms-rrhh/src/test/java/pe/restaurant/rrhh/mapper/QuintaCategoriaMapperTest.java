package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.response.QuintaCategoriaResponse;
import pe.restaurant.rrhh.entity.QuintaCategoria;
import pe.restaurant.rrhh.entity.Trabajador;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.math.BigDecimal;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("QuintaCategoriaMapper — Pruebas Unitarias")
class QuintaCategoriaMapperTest {

    @Mock
    private TrabajadorRepository trabajadorRepo;

    @InjectMocks
    private QuintaCategoriaMapper mapper;

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        QuintaCategoria entity = RrhhTestFixtures.quintaCategoria(1L);
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));

        QuintaCategoriaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getAnio()).isEqualTo(2026);
        assertThat(response.getMes()).isEqualTo(6);
        assertThat(response.getRentaBrutaAcumulada()).isEqualByComparingTo(new BigDecimal("15000.0000"));
        assertThat(response.getRentaBrutaProyectada()).isEqualByComparingTo(new BigDecimal("42000.0000"));
        assertThat(response.getDeduccion7uit()).isEqualByComparingTo(new BigDecimal("37450.0000"));
        assertThat(response.getRentaNeta()).isEqualByComparingTo(new BigDecimal("4550.0000"));
        assertThat(response.getImpuestoAnualProyectado()).isEqualByComparingTo(new BigDecimal("364.0000"));
        assertThat(response.getRetencionMensual()).isEqualByComparingTo(new BigDecimal("60.6667"));
        assertThat(response.getRetencionAcumulada()).isEqualByComparingTo(new BigDecimal("364.0000"));
    }

    @Test
    @DisplayName("toResponse() -> resuelve nombre del trabajador")
    void toResponse_resuelveNombreTrabajador() {
        QuintaCategoria entity = RrhhTestFixtures.quintaCategoria(1L);
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.trabajador(1L)));

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

        QuintaCategoriaResponse response = mapper.toResponse(entity);

        assertThat(response.getFecCreacion()).isNotNull();
        assertThat(response.getCreatedBy()).isEqualTo(1L);
    }
}
