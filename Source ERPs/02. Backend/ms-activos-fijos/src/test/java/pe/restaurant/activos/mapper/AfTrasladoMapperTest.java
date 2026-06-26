package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfTrasladoRequest;
import pe.restaurant.activos.dto.AfTrasladoResponse;
import pe.restaurant.activos.entity.AfTraslado;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfTrasladoMapperTest {

    private final AfTrasladoMapper mapper = Mappers.getMapper(AfTrasladoMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfTraslado entity = new AfTraslado();
        entity.setId(1L);
        entity.setAfMaestroId(10L);
        entity.setUbicacionOrigenId(100L);
        entity.setUbicacionDestinoId(200L);
        entity.setSolicitanteId(5L);
        entity.setAprobadorId(6L);
        entity.setFechaSolicitud(LocalDate.of(2025, 3, 1));
        entity.setFechaEjecucion(LocalDate.of(2025, 3, 15));
        entity.setMotivo("Reorganización de planta");

        AfTrasladoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfMaestroId()).isEqualTo(10L);
        assertThat(response.getUbicacionOrigenId()).isEqualTo(100L);
        assertThat(response.getUbicacionDestinoId()).isEqualTo(200L);
        assertThat(response.getSolicitanteId()).isEqualTo(5L);
        assertThat(response.getAprobadorId()).isEqualTo(6L);
        assertThat(response.getFechaSolicitud()).isEqualTo(LocalDate.of(2025, 3, 1));
        assertThat(response.getFechaEjecucion()).isEqualTo(LocalDate.of(2025, 3, 15));
        assertThat(response.getMotivo()).isEqualTo("Reorganización de planta");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfTraslado e1 = new AfTraslado();
        e1.setId(1L);
        AfTraslado e2 = new AfTraslado();
        e2.setId(2L);

        List<AfTrasladoResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getId()).isEqualTo(1L);
        assertThat(result.get(1).getId()).isEqualTo(2L);
    }

    @Test
    void toEntity_mapsAllFields() {
        AfTrasladoRequest request = new AfTrasladoRequest();
        request.setAfMaestroId(10L);
        request.setUbicacionOrigenId(100L);
        request.setUbicacionDestinoId(200L);
        request.setSolicitanteId(5L);
        request.setAprobadorId(6L);
        request.setFechaSolicitud(LocalDate.of(2025, 3, 1));
        request.setFechaEjecucion(LocalDate.of(2025, 3, 15));
        request.setMotivo("Reorganización");

        AfTraslado entity = mapper.toEntity(request);

        assertThat(entity.getAfMaestroId()).isEqualTo(10L);
        assertThat(entity.getUbicacionOrigenId()).isEqualTo(100L);
        assertThat(entity.getUbicacionDestinoId()).isEqualTo(200L);
        assertThat(entity.getSolicitanteId()).isEqualTo(5L);
        assertThat(entity.getAprobadorId()).isEqualTo(6L);
        assertThat(entity.getFechaSolicitud()).isEqualTo(LocalDate.of(2025, 3, 1));
        assertThat(entity.getFechaEjecucion()).isEqualTo(LocalDate.of(2025, 3, 15));
        assertThat(entity.getMotivo()).isEqualTo("Reorganización");
        assertThat(entity.getId()).isNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfTraslado entity = new AfTraslado();
        entity.setId(99L);
        entity.setAfMaestroId(1L);

        AfTrasladoRequest request = new AfTrasladoRequest();
        request.setAfMaestroId(50L);
        request.setUbicacionOrigenId(500L);
        request.setUbicacionDestinoId(600L);
        request.setSolicitanteId(8L);
        request.setAprobadorId(9L);
        request.setFechaSolicitud(LocalDate.of(2026, 1, 1));
        request.setFechaEjecucion(LocalDate.of(2026, 1, 20));
        request.setMotivo("Mudanza");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getAfMaestroId()).isEqualTo(50L);
        assertThat(entity.getUbicacionOrigenId()).isEqualTo(500L);
        assertThat(entity.getUbicacionDestinoId()).isEqualTo(600L);
        assertThat(entity.getSolicitanteId()).isEqualTo(8L);
        assertThat(entity.getAprobadorId()).isEqualTo(9L);
        assertThat(entity.getFechaSolicitud()).isEqualTo(LocalDate.of(2026, 1, 1));
        assertThat(entity.getFechaEjecucion()).isEqualTo(LocalDate.of(2026, 1, 20));
        assertThat(entity.getMotivo()).isEqualTo("Mudanza");
    }
}
