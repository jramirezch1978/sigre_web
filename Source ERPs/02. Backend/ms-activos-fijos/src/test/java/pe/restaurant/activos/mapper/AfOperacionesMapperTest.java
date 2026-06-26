package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfOperacionesRequest;
import pe.restaurant.activos.dto.AfOperacionesResponse;
import pe.restaurant.activos.entity.AfOperaciones;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfOperacionesMapperTest {

    private final AfOperacionesMapper mapper = Mappers.getMapper(AfOperacionesMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfOperaciones entity = new AfOperaciones();
        entity.setId(1L);
        entity.setAfMaestroId(10L);
        entity.setTipo("MANTENIMIENTO");
        entity.setFechaProgramada(LocalDate.of(2025, 7, 1));
        entity.setFechaEjecucion(LocalDate.of(2025, 7, 5));
        entity.setCosto(new BigDecimal("1200.0000"));
        entity.setProveedorServicio("TecnoServ SAC");

        AfOperacionesResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfMaestroId()).isEqualTo(10L);
        assertThat(response.getTipo()).isEqualTo("MANTENIMIENTO");
        assertThat(response.getFechaProgramada()).isEqualTo(LocalDate.of(2025, 7, 1));
        assertThat(response.getFechaEjecucion()).isEqualTo(LocalDate.of(2025, 7, 5));
        assertThat(response.getCosto()).isEqualByComparingTo(new BigDecimal("1200.0000"));
        assertThat(response.getProveedorServicio()).isEqualTo("TecnoServ SAC");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfOperaciones e1 = new AfOperaciones();
        e1.setId(1L);
        e1.setTipo("MANTENIMIENTO");
        AfOperaciones e2 = new AfOperaciones();
        e2.setId(2L);
        e2.setTipo("REPARACION");

        List<AfOperacionesResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getTipo()).isEqualTo("MANTENIMIENTO");
        assertThat(result.get(1).getTipo()).isEqualTo("REPARACION");
    }

    @Test
    void toEntity_mapsAllFields() {
        AfOperacionesRequest request = new AfOperacionesRequest();
        request.setAfMaestroId(10L);
        request.setTipo("MANTENIMIENTO");
        request.setFechaProgramada(LocalDate.of(2025, 7, 1));
        request.setFechaEjecucion(LocalDate.of(2025, 7, 5));
        request.setCosto(new BigDecimal("1200.0000"));
        request.setProveedorServicio("TecnoServ SAC");

        AfOperaciones entity = mapper.toEntity(request);

        assertThat(entity.getAfMaestroId()).isEqualTo(10L);
        assertThat(entity.getTipo()).isEqualTo("MANTENIMIENTO");
        assertThat(entity.getFechaProgramada()).isEqualTo(LocalDate.of(2025, 7, 1));
        assertThat(entity.getFechaEjecucion()).isEqualTo(LocalDate.of(2025, 7, 5));
        assertThat(entity.getCosto()).isEqualByComparingTo(new BigDecimal("1200.0000"));
        assertThat(entity.getProveedorServicio()).isEqualTo("TecnoServ SAC");
        assertThat(entity.getId()).isNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfOperaciones entity = new AfOperaciones();
        entity.setId(99L);
        entity.setTipo("OLD");

        AfOperacionesRequest request = new AfOperacionesRequest();
        request.setAfMaestroId(50L);
        request.setTipo("REPARACION");
        request.setFechaProgramada(LocalDate.of(2026, 2, 1));
        request.setFechaEjecucion(LocalDate.of(2026, 2, 10));
        request.setCosto(new BigDecimal("3000.0000"));
        request.setProveedorServicio("MaquiPeru SRL");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getAfMaestroId()).isEqualTo(50L);
        assertThat(entity.getTipo()).isEqualTo("REPARACION");
        assertThat(entity.getFechaProgramada()).isEqualTo(LocalDate.of(2026, 2, 1));
        assertThat(entity.getFechaEjecucion()).isEqualTo(LocalDate.of(2026, 2, 10));
        assertThat(entity.getCosto()).isEqualByComparingTo(new BigDecimal("3000.0000"));
        assertThat(entity.getProveedorServicio()).isEqualTo("MaquiPeru SRL");
    }
}
