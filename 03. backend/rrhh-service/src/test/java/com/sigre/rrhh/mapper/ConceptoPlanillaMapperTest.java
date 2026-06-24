package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.dto.request.ConceptoPlanillaCreateRequest;
import com.sigre.rrhh.dto.request.ConceptoPlanillaUpdateRequest;
import com.sigre.rrhh.dto.response.ConceptoPlanillaResponse;
import com.sigre.rrhh.entity.ConceptoPlanilla;
import com.sigre.rrhh.entity.GrupoConceptosPlanilla;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("Pruebas Unitarias - ConceptoPlanillaMapper")
class ConceptoPlanillaMapperTest {

    private final ConceptoPlanillaMapper mapper = Mappers.getMapper(ConceptoPlanillaMapper.class);

    @Test
    @DisplayName("toResponse() mapea correctamente entity a response")
    void toResponse_mapeaCorrectamente() {
        GrupoConceptosPlanilla grupo = new GrupoConceptosPlanilla();
        grupo.setCodigo("10");

        ConceptoPlanilla entity = new ConceptoPlanilla();
        entity.setId(1L);
        entity.setCodigo("1013");
        entity.setNombre("PRIMA DE FRIO");
        entity.setDescripcionBreve("PRIMA DE FRIO");
        entity.setGrupoConceptosPlanilla(grupo);
        entity.setFactorPago(new BigDecimal("1"));
        entity.setImporteTopeMin(BigDecimal.ZERO);
        entity.setImporteTopeMax(BigDecimal.ZERO);
        entity.setFlagReplicacion("1");
        entity.setFlagSubsidio("0");
        entity.setFlagReporteQuinta("0");
        entity.setConceptoRtps("0303");
        entity.setNumeroOrden("1013");

        ConceptoPlanillaResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("1013");
        assertThat(response.getGrupoCalculo()).isEqualTo("10");
        assertThat(response.getFactorPago()).isEqualByComparingTo(BigDecimal.ONE);
        assertThat(response.getConceptoRtps()).isEqualTo("0303");
    }

    @Test
    @DisplayName("toEntity() mapea correctamente request a entity")
    void toEntity_mapeaCorrectamente() {
        ConceptoPlanillaCreateRequest request = new ConceptoPlanillaCreateRequest();
        request.setCodigo("2119");
        request.setNombre("CRED EPS");
        request.setDescripcionBreve("CRED EPS");
        request.setGrupoCalculo("23");
        request.setFactorPago(new BigDecimal("0.025"));
        request.setImporteTopeMin(BigDecimal.ZERO);
        request.setImporteTopeMax(BigDecimal.ZERO);
        request.setFlagReplicacion("1");
        request.setFlagSubsidio("0");
        request.setFlagReporteQuinta("0");
        request.setConceptoRtps("0611");

        ConceptoPlanilla entity = mapper.toEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getCodigo()).isEqualTo("2119");
        assertThat(entity.getGrupoConceptosPlanilla()).isNull();
        assertThat(entity.getFactorPago()).isEqualByComparingTo(new BigDecimal("0.025"));
    }

    @Test
    @DisplayName("toResponse() con entidad null -> retorna null")
    void toResponse_conEntidadNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() convierte lista de entidades a DTOs")
    void toResponseList_convierteListaADTOs() {
        ConceptoPlanilla e1 = new ConceptoPlanilla();
        e1.setId(1L);
        e1.setCodigo("1013");
        ConceptoPlanilla e2 = new ConceptoPlanilla();
        e2.setId(2L);
        e2.setCodigo("2119");

        List<ConceptoPlanillaResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("toResponse() con fecCreacion no nulo -> mapea correctamente")
    void toResponse_conFecCreacionNoNulo_mapeaCorrectamente() {
        ConceptoPlanilla entity = new ConceptoPlanilla();
        entity.setId(1L);
        entity.setCodigo("1013");
        entity.setFecCreacion(Instant.parse("2026-01-15T10:00:00Z"));

        ConceptoPlanillaResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("updateEntity() actualiza correctamente sin modificar código")
    void updateEntity_actualizaCorrectamenteSinModificarCodigo() {
        GrupoConceptosPlanilla grupo = new GrupoConceptosPlanilla();
        grupo.setCodigo("10");

        ConceptoPlanilla entity = new ConceptoPlanilla();
        entity.setId(1L);
        entity.setCodigo("1013");
        entity.setNombre("PRIMA DE FRIO");
        entity.setGrupoConceptosPlanilla(grupo);

        ConceptoPlanillaUpdateRequest request = new ConceptoPlanillaUpdateRequest();
        request.setNombre("PRIMA DE FRIO ACTUALIZADA");
        request.setGrupoCalculo("10");
        request.setFactorPago(new BigDecimal("1.5"));
        request.setImporteTopeMin(BigDecimal.ZERO);
        request.setImporteTopeMax(BigDecimal.ZERO);
        request.setFlagReplicacion("1");
        request.setFlagSubsidio("0");
        request.setFlagReporteQuinta("0");

        mapper.updateEntity(entity, request);

        assertThat(entity.getCodigo()).isEqualTo("1013");
        assertThat(entity.getNombre()).isEqualTo("PRIMA DE FRIO ACTUALIZADA");
        assertThat(entity.getFactorPago()).isEqualByComparingTo(new BigDecimal("1.5"));
        assertThat(entity.getGrupoConceptosPlanilla().getCodigo()).isEqualTo("10");
    }
}
