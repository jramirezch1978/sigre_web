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
        entity.setEstado("APROBADO");
        entity.setFechaProgramada(LocalDate.of(2025, 3, 10));
        entity.setFechaAprobacion(LocalDate.of(2025, 3, 5));
        entity.setCentroCostoOrigenId(300L);
        entity.setCentroCostoDestinoId(400L);
        entity.setResponsableEjecucionId(7L);
        entity.setComentarioRechazo("Aprobado sin observaciones");

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
        assertThat(response.getEstado()).isEqualTo("APROBADO");
        assertThat(response.getFechaProgramada()).isEqualTo(LocalDate.of(2025, 3, 10));
        assertThat(response.getFechaAprobacion()).isEqualTo(LocalDate.of(2025, 3, 5));
        assertThat(response.getCentroCostoOrigenId()).isEqualTo(300L);
        assertThat(response.getCentroCostoDestinoId()).isEqualTo(400L);
        assertThat(response.getResponsableEjecucionId()).isEqualTo(7L);
        assertThat(response.getComentarioRechazo()).isEqualTo("Aprobado sin observaciones");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfTraslado e1 = new AfTraslado();
        e1.setId(1L);
        e1.setEstado("SOLICITUD");
        AfTraslado e2 = new AfTraslado();
        e2.setId(2L);
        e2.setEstado("APROBADO");

        List<AfTrasladoResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getEstado()).isEqualTo("SOLICITUD");
        assertThat(result.get(1).getEstado()).isEqualTo("APROBADO");
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
        request.setFechaProgramada(LocalDate.of(2025, 3, 10));
        request.setCentroCostoOrigenId(300L);
        request.setCentroCostoDestinoId(400L);
        request.setResponsableEjecucionId(7L);

        AfTraslado entity = mapper.toEntity(request);

        assertThat(entity.getAfMaestroId()).isEqualTo(10L);
        assertThat(entity.getUbicacionOrigenId()).isEqualTo(100L);
        assertThat(entity.getUbicacionDestinoId()).isEqualTo(200L);
        assertThat(entity.getSolicitanteId()).isEqualTo(5L);
        assertThat(entity.getAprobadorId()).isEqualTo(6L);
        assertThat(entity.getFechaSolicitud()).isEqualTo(LocalDate.of(2025, 3, 1));
        assertThat(entity.getFechaEjecucion()).isEqualTo(LocalDate.of(2025, 3, 15));
        assertThat(entity.getMotivo()).isEqualTo("Reorganización");
        assertThat(entity.getFechaProgramada()).isEqualTo(LocalDate.of(2025, 3, 10));
        assertThat(entity.getCentroCostoOrigenId()).isEqualTo(300L);
        assertThat(entity.getCentroCostoDestinoId()).isEqualTo(400L);
        assertThat(entity.getResponsableEjecucionId()).isEqualTo(7L);
        assertThat(entity.getId()).isNull();
        assertThat(entity.getEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfTraslado entity = new AfTraslado();
        entity.setId(99L);
        entity.setEstado("SOLICITUD");
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
        request.setFechaProgramada(LocalDate.of(2026, 1, 15));
        request.setCentroCostoOrigenId(700L);
        request.setCentroCostoDestinoId(800L);
        request.setResponsableEjecucionId(11L);

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getEstado()).isEqualTo("SOLICITUD");
        assertThat(entity.getAfMaestroId()).isEqualTo(50L);
        assertThat(entity.getUbicacionOrigenId()).isEqualTo(500L);
        assertThat(entity.getUbicacionDestinoId()).isEqualTo(600L);
        assertThat(entity.getSolicitanteId()).isEqualTo(8L);
        assertThat(entity.getAprobadorId()).isEqualTo(9L);
        assertThat(entity.getFechaSolicitud()).isEqualTo(LocalDate.of(2026, 1, 1));
        assertThat(entity.getFechaEjecucion()).isEqualTo(LocalDate.of(2026, 1, 20));
        assertThat(entity.getMotivo()).isEqualTo("Mudanza");
        assertThat(entity.getFechaProgramada()).isEqualTo(LocalDate.of(2026, 1, 15));
        assertThat(entity.getCentroCostoOrigenId()).isEqualTo(700L);
        assertThat(entity.getCentroCostoDestinoId()).isEqualTo(800L);
        assertThat(entity.getResponsableEjecucionId()).isEqualTo(11L);
    }
}
