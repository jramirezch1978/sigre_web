package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.response.GanDescVariableResponse;
import com.sigre.rrhh.entity.GanDescVariable;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.entity.ConceptoPlanilla;
import com.sigre.rrhh.repository.ConceptoPlanillaRepository;
import com.sigre.rrhh.repository.GanDescVariableRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("GanDescVariableMapper — Pruebas Unitarias")
class GanDescVariableMapperTest {

    @Mock
    private TrabajadorRepository trabajadorRepository;

    @Mock
    private ConceptoPlanillaRepository conceptoPlanillaRepository;

    @Mock
    private GanDescVariableRepository ganDescVariableRepository;

    @InjectMocks
    private GanDescVariableMapper mapper;

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO con nombres resueltos")
    void toResponse_convierteEntidadADTORespuesta() {
        GanDescVariable entity = RrhhTestFixtures.ganDescVariable(1L);
        when(trabajadorRepository.findById(1L)).thenReturn(Optional.of(Trabajador.builder()
                .nombres("Nombre 1").apellidoPaterno("Paterno").apellidoMaterno("Materno").build()));
        ConceptoPlanilla concepto = new ConceptoPlanilla();
        concepto.setNombre("Sueldo Básico Test");
        when(conceptoPlanillaRepository.findById(1L)).thenReturn(Optional.of(concepto));
        when(ganDescVariableRepository.findTipoPlanillaNombreById(1L)).thenReturn("Planilla Test");

        GanDescVariableResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getTrabajadorNombres()).isEqualTo("Paterno Materno, Nombre 1");
        assertThat(response.getConceptoNombre()).isEqualTo("Sueldo Básico Test");
        assertThat(response.getTipoPlanillaNombre()).isEqualTo("Planilla Test");
        assertThat(response.getImpVar()).isEqualByComparingTo("500.0000");
    }
}
