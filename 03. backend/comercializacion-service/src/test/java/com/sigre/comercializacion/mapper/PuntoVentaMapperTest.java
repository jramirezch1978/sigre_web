package com.sigre.comercializacion.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.comercializacion.VentasTestFixtures;
import com.sigre.comercializacion.dto.request.PuntoVentaRequest;
import com.sigre.comercializacion.dto.response.PuntoVentaResponse;
import com.sigre.comercializacion.entity.PuntoVenta;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("PuntoVentaMapper — Pruebas Unitarias")
class PuntoVentaMapperTest {

    private final PuntoVentaMapper mapper = Mappers.getMapper(PuntoVentaMapper.class);

    @Test
    @DisplayName("toEntity() con request válido -> mapea correctamente")
    void toEntity_conRequestValido_mapeaCorrectamente() {
        PuntoVentaRequest request = VentasTestFixtures.puntoVentaRequest();

        PuntoVenta entity = mapper.toEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getCodigo()).isEqualTo("PV-TEST-REQ");
        assertThat(entity.getNombre()).isEqualTo("Punto Venta Test Request");
        assertThat(entity.getId()).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity válida -> mapea correctamente")
    void toResponse_conEntityValida_mapeaCorrectamente() {
        PuntoVenta entity = VentasTestFixtures.puntoVentaEntity(1L, "1");

        PuntoVentaResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("PV-1");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() con lista -> mapea correctamente")
    void toResponseList_conLista_mapeaCorrectamente() {
        List<PuntoVenta> entities = List.of(
            VentasTestFixtures.puntoVentaEntity(1L, "1"),
            VentasTestFixtures.puntoVentaEntity(2L, "1")
        );

        List<PuntoVentaResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
    }

    @Test
    @DisplayName("updateEntity() actualiza campos modificables")
    void updateEntity_actualizaCamposModificables() {
        PuntoVenta existing = VentasTestFixtures.puntoVentaEntity(5L, "1");
        PuntoVentaRequest request = new PuntoVentaRequest();
        request.setNombre("Nuevo Nombre");

        mapper.updateEntity(request, existing);

        assertThat(existing.getId()).isEqualTo(5L);
        assertThat(existing.getNombre()).isEqualTo("Nuevo Nombre");
    }
}
