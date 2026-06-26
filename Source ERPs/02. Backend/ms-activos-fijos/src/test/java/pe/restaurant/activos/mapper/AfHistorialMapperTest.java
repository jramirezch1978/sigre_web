package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfHistorialRequest;
import pe.restaurant.activos.dto.AfHistorialResponse;
import pe.restaurant.activos.entity.AfHistorial;

import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfHistorialMapperTest {

    private final AfHistorialMapper mapper = Mappers.getMapper(AfHistorialMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfHistorial entity = new AfHistorial();
        entity.setId(1L);
        entity.setAfMaestroId(10L);
        entity.setTipoEvento("TRASLADO");
        entity.setDescripcion("Traslado de sede Lima a Arequipa");
        entity.setValorAnterior("LIMA-01");
        entity.setValorNuevo("AQP-03");
        entity.setUsuarioId(5L);
        entity.setFechaEvento(LocalDateTime.of(2025, 6, 15, 10, 30, 0));
        entity.setIpOrigen("192.168.1.100");
        entity.setModulo("ACTIVOS");

        AfHistorialResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfMaestroId()).isEqualTo(10L);
        assertThat(response.getTipoEvento()).isEqualTo("TRASLADO");
        assertThat(response.getDescripcion()).isEqualTo("Traslado de sede Lima a Arequipa");
        assertThat(response.getValorAnterior()).isEqualTo("LIMA-01");
        assertThat(response.getValorNuevo()).isEqualTo("AQP-03");
        assertThat(response.getUsuarioId()).isEqualTo(5L);
        assertThat(response.getFechaEvento()).isEqualTo(LocalDateTime.of(2025, 6, 15, 10, 30, 0));
        assertThat(response.getIpOrigen()).isEqualTo("192.168.1.100");
        assertThat(response.getModulo()).isEqualTo("ACTIVOS");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfHistorial e1 = new AfHistorial();
        e1.setId(1L);
        e1.setTipoEvento("TRASLADO");
        AfHistorial e2 = new AfHistorial();
        e2.setId(2L);
        e2.setTipoEvento("VALUACION");

        List<AfHistorialResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getTipoEvento()).isEqualTo("TRASLADO");
        assertThat(result.get(1).getTipoEvento()).isEqualTo("VALUACION");
    }

    @Test
    void toEntity_mapsAllFields() {
        AfHistorialRequest request = new AfHistorialRequest();
        request.setAfMaestroId(10L);
        request.setTipoEvento("TRASLADO");
        request.setDescripcion("Traslado de sede");
        request.setValorAnterior("LIMA-01");
        request.setValorNuevo("AQP-03");
        request.setUsuarioId(5L);
        request.setFechaEvento(LocalDateTime.of(2025, 6, 15, 10, 30, 0));
        request.setIpOrigen("192.168.1.100");
        request.setModulo("ACTIVOS");

        AfHistorial entity = mapper.toEntity(request);

        assertThat(entity.getAfMaestroId()).isEqualTo(10L);
        assertThat(entity.getTipoEvento()).isEqualTo("TRASLADO");
        assertThat(entity.getDescripcion()).isEqualTo("Traslado de sede");
        assertThat(entity.getValorAnterior()).isEqualTo("LIMA-01");
        assertThat(entity.getValorNuevo()).isEqualTo("AQP-03");
        assertThat(entity.getUsuarioId()).isEqualTo(5L);
        assertThat(entity.getFechaEvento()).isEqualTo(LocalDateTime.of(2025, 6, 15, 10, 30, 0));
        assertThat(entity.getIpOrigen()).isEqualTo("192.168.1.100");
        assertThat(entity.getModulo()).isEqualTo("ACTIVOS");
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfHistorial entity = new AfHistorial();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setTipoEvento("OLD");

        AfHistorialRequest request = new AfHistorialRequest();
        request.setAfMaestroId(50L);
        request.setTipoEvento("VALUACION");
        request.setDescripcion("Revaluación anual");
        request.setValorAnterior("50000");
        request.setValorNuevo("55000");
        request.setUsuarioId(8L);
        request.setFechaEvento(LocalDateTime.of(2026, 1, 10, 14, 0, 0));
        request.setIpOrigen("10.0.0.50");
        request.setModulo("VALUACION");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getAfMaestroId()).isEqualTo(50L);
        assertThat(entity.getTipoEvento()).isEqualTo("VALUACION");
        assertThat(entity.getDescripcion()).isEqualTo("Revaluación anual");
        assertThat(entity.getValorAnterior()).isEqualTo("50000");
        assertThat(entity.getValorNuevo()).isEqualTo("55000");
        assertThat(entity.getUsuarioId()).isEqualTo(8L);
        assertThat(entity.getFechaEvento()).isEqualTo(LocalDateTime.of(2026, 1, 10, 14, 0, 0));
        assertThat(entity.getIpOrigen()).isEqualTo("10.0.0.50");
        assertThat(entity.getModulo()).isEqualTo("VALUACION");
    }
}
