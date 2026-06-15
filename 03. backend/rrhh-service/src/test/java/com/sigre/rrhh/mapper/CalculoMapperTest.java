package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.response.CalculoDetResponse;
import com.sigre.rrhh.dto.response.CalculoDetalleResponse;
import com.sigre.rrhh.dto.response.CalculoResponse;
import com.sigre.rrhh.entity.Calculo;
import com.sigre.rrhh.entity.CalculoDet;
import com.sigre.rrhh.entity.ConceptoPlanilla;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.repository.CalculoRepository;
import com.sigre.rrhh.repository.ConceptoPlanillaRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("CalculoMapper — Pruebas Unitarias")
class CalculoMapperTest {

    @Mock private TrabajadorRepository trabajadorRepo;
    @Mock private ConceptoPlanillaRepository conceptoRepo;
    @Mock private CalculoRepository calculoRepo;

    @InjectMocks
    private CalculoMapper mapper;

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de listado")
    void toResponse_convierteEntidadADTORespuesta() {
        Calculo entity = RrhhTestFixtures.calculo(1L);
        when(calculoRepo.findTipoPlanillaNombreById(1L)).thenReturn("Planilla Mensual");

        CalculoResponse response = mapper.toResponse(entity, 2);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAnio()).isEqualTo(2026);
        assertThat(response.getMes()).isEqualTo(6);
        assertThat(response.getTipoPlanillaId()).isEqualTo(1L);
        assertThat(response.getTipoPlanillaNombre()).isEqualTo("Planilla Mensual");
        assertThat(response.getTotalIngresos()).isEqualByComparingTo("5000.0000");
        assertThat(response.getTotalDescuentos()).isEqualByComparingTo("500.0000");
        assertThat(response.getTotalNeto()).isEqualByComparingTo("4500.0000");
        assertThat(response.getTotalAportes()).isEqualByComparingTo("500.0000");
        assertThat(response.getTotalTrabajadores()).isEqualTo(2);
    }

    @Test
    @DisplayName("toDetalleResponse() -> convierte entidad y detalles a DTO detallado")
    void toDetalleResponse_convierteEntidadYDetalles() {
        Calculo entity = RrhhTestFixtures.calculo(1L);
        CalculoDet det = RrhhTestFixtures.calculoDet(1L, 1L);
        det.setTrabajadorId(1L);
        det.setConceptoId(1L);

        when(calculoRepo.findTipoPlanillaNombreById(1L)).thenReturn("Planilla Mensual");
        when(calculoRepo.findTipoConceptoCalculoNombreById(1L)).thenReturn("INGRESO");
        Trabajador t = RrhhTestFixtures.trabajador(1L);
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(t));
        ConceptoPlanilla cp = new ConceptoPlanilla();
        cp.setNombre("Remuneración básica");
        when(conceptoRepo.findById(1L)).thenReturn(Optional.of(cp));

        CalculoDetalleResponse response = mapper.toDetalleResponse(entity, List.of(det));

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTotalTrabajadores()).isEqualTo(1);
        assertThat(response.getDetalles()).hasSize(1);
        assertThat(response.getDetalles().get(0).getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getDetalles().get(0).getConceptoNombre()).isEqualTo("Remuneración básica");
        assertThat(response.getDetalles().get(0).getTipoConceptoCalculoNombre()).isEqualTo("INGRESO");
    }

    @Test
    @DisplayName("toDetResponse() -> convierte detalle a DTO")
    void toDetResponse_convierteDetalle() {
        CalculoDet det = RrhhTestFixtures.calculoDet(1L, 1L);
        det.setTrabajadorId(1L);
        det.setConceptoId(1L);

        when(calculoRepo.findTipoConceptoCalculoNombreById(1L)).thenReturn("INGRESO");
        Trabajador t = RrhhTestFixtures.trabajador(1L);
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(t));
        ConceptoPlanilla cp = new ConceptoPlanilla();
        cp.setNombre("Remuneración básica");
        when(conceptoRepo.findById(1L)).thenReturn(Optional.of(cp));

        CalculoDetResponse response = mapper.toDetResponse(det);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCalculoId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getTrabajadorNombres()).isEqualTo("Paterno Nombre 1 Materno");
        assertThat(response.getConceptoId()).isEqualTo(1L);
        assertThat(response.getConceptoNombre()).isEqualTo("Remuneración básica");
        assertThat(response.getMonto()).isEqualByComparingTo("2500.0000");
        assertThat(response.getTipoConceptoCalculoNombre()).isEqualTo("INGRESO");
    }

    @Test
    @DisplayName("toResponse() con tipoPlanillaId null -> tipoPlanillaNombre null")
    void toResponse_tipoPlanillaNull_retornaNull() {
        Calculo entity = RrhhTestFixtures.calculo(1L);
        entity.setTipoPlanillaId(null);

        CalculoResponse response = mapper.toResponse(entity, 0);

        assertThat(response.getTipoPlanillaNombre()).isNull();
    }

    @Test
    @DisplayName("toDetResponse() con trabajadorId null -> trabajadorNombres null")
    void toDetResponse_trabajadorNull_retornaNombresNull() {
        CalculoDet det = RrhhTestFixtures.calculoDet(1L, 1L);
        det.setTrabajadorId(null);

        CalculoDetResponse response = mapper.toDetResponse(det);

        assertThat(response.getTrabajadorNombres()).isNull();
    }

    @Test
    @DisplayName("toDetResponse() con conceptoId null -> conceptoNombre null")
    void toDetResponse_conceptoNull_retornaConceptoNull() {
        CalculoDet det = RrhhTestFixtures.calculoDet(1L, 1L);
        det.setConceptoId(null);

        CalculoDetResponse response = mapper.toDetResponse(det);

        assertThat(response.getConceptoNombre()).isNull();
    }

    @Test
    @DisplayName("toDetResponse() con tipoConceptoCalculoId null -> retorna tipoConceptoCalculoNombre null")
    void toDetResponse_tipoConceptoNull_retornaNull() {
        CalculoDet det = RrhhTestFixtures.calculoDet(1L, 1L);
        det.setTipoConceptoCalculoId(null);

        CalculoDetResponse response = mapper.toDetResponse(det);

        assertThat(response.getTipoConceptoCalculoNombre()).isNull();
    }
}
