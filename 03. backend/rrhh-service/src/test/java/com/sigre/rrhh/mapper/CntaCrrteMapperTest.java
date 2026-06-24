package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.CntaCrrteCreateRequest;
import com.sigre.rrhh.dto.request.CntaCrrteMovimientoRequest;
import com.sigre.rrhh.dto.request.CntaCrrteMovimientoUpdateRequest;
import com.sigre.rrhh.dto.request.CntaCrrteUpdateRequest;
import com.sigre.rrhh.dto.response.CntaCrrteDetResponse;
import com.sigre.rrhh.dto.response.CntaCrrteResponse;
import com.sigre.rrhh.entity.CntaCrrte;
import com.sigre.rrhh.entity.CntaCrrteDet;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("CntaCrrteMapper — Pruebas Unitarias")
class CntaCrrteMapperTest {

    private final CntaCrrteMapper mapper = Mappers.getMapper(CntaCrrteMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        CntaCrrte entity = RrhhTestFixtures.cntaCrrte(1L);

        CntaCrrteResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getDocTipoId()).isEqualTo(1L);
        assertThat(response.getNroDoc()).isEqualTo("CC-001");
        assertThat(response.getFecPrestamo()).isEqualTo("2026-01-01");
        assertThat(response.getMontoOriginal()).isEqualByComparingTo("1000.00000");
        assertThat(response.getSaldoPrestamo()).isEqualByComparingTo("500.00000");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteLista() {
        List<CntaCrrte> entities = List.of(
                RrhhTestFixtures.cntaCrrte(1L),
                RrhhTestFixtures.cntaCrrte(2L)
        );

        List<CntaCrrteResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
    }

    @Test
    @DisplayName("toEntity() -> convierte CreateRequest a entidad ignorando auditoría")
    void toEntity_convierteCreateRequestAEntidad() {
        CntaCrrteCreateRequest request = RrhhTestFixtures.cntaCrrteCreateRequest();

        CntaCrrte entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getTrabajadorId()).isEqualTo(1L);
        assertThat(entity.getDocTipoId()).isEqualTo(1L);
        assertThat(entity.getSaldoPrestamo()).isNull();
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza solo campos editables")
    void updateEntity_actualizaCamposEditables() {
        CntaCrrteUpdateRequest request = RrhhTestFixtures.cntaCrrteUpdateRequest();
        CntaCrrte entity = RrhhTestFixtures.cntaCrrte(1L);

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getTrabajadorId()).isEqualTo(1L);
        assertThat(entity.getFecPrestamo()).isEqualTo("2026-02-01");
    }

    @Test
    @DisplayName("toDetResponse() -> convierte detalle a DTO")
    void toDetResponse_convierteDetalleADTO() {
        CntaCrrteDet det = RrhhTestFixtures.cntaCrrteDet(1L);

        CntaCrrteDetResponse response = mapper.toDetResponse(det);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCntaCrrteId()).isEqualTo(1L);
        assertThat(response.getMonto()).isEqualByComparingTo("200.0000");
    }

    @Test
    @DisplayName("toDetResponseList() -> convierte lista de detalles")
    void toDetResponseList_convierteListaDetalles() {
        List<CntaCrrteDet> dets = List.of(
                RrhhTestFixtures.cntaCrrteDet(1L),
                RrhhTestFixtures.cntaCrrteDet(2L)
        );

        List<CntaCrrteDetResponse> responses = mapper.toDetResponseList(dets);

        assertThat(responses).hasSize(2);
    }

    @Test
    @DisplayName("toDetEntity() -> convierte movimiento request a entidad ignorando auditoría")
    void toDetEntity_convierteMovimientoRequest() {
        CntaCrrteMovimientoRequest request = RrhhTestFixtures.cntaCrrteMovimientoRequest();

        CntaCrrteDet det = mapper.toDetEntity(request);

        assertThat(det.getId()).isNull();
        assertThat(det.getCntaCrrteId()).isNull();
        assertThat(det.getImpDscto()).isEqualByComparingTo("200.0000");
        assertThat(det.getCreatedBy()).isNull();
    }

    @Test
    @DisplayName("updateDetEntity() -> actualiza movimiento")
    void updateDetEntity_actualizaMovimiento() {
        CntaCrrteMovimientoUpdateRequest request = RrhhTestFixtures.cntaCrrteMovimientoUpdateRequest();
        CntaCrrteDet det = RrhhTestFixtures.cntaCrrteDet(1L);

        mapper.updateDetEntity(det, request);

        assertThat(det.getImpDscto()).isEqualByComparingTo("300.0000");
        assertThat(det.getObservaciones()).isEqualTo("Abono actualizado");
    }

    @Test
    @DisplayName("métodos con null -> retornan null")
    void metodosConNull_retornanNull() {
        assertThat(mapper.toResponse(null)).isNull();
        assertThat(mapper.toResponseList(null)).isNull();
        assertThat(mapper.toEntity(null)).isNull();
        assertThat(mapper.toDetResponse(null)).isNull();
        assertThat(mapper.toDetResponseList(null)).isNull();
        assertThat(mapper.toDetEntity(null)).isNull();
    }
}
