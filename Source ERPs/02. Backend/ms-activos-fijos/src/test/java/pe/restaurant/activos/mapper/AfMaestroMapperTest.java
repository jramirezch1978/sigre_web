package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfMaestroRequest;
import pe.restaurant.activos.dto.AfMaestroResponse;
import pe.restaurant.activos.entity.AfMaestro;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfMaestroMapperTest {

    private final AfMaestroMapper mapper = Mappers.getMapper(AfMaestroMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfMaestro entity = new AfMaestro();
        entity.setId(1L);
        entity.setCodigo("ACT-0001");
        entity.setNombre("Impresora Epson L3250");
        entity.setAfSubClaseId(5L);
        entity.setAfUbicacionId(3L);
        entity.setFechaAdquisicion(LocalDate.of(2024, 1, 15));
        entity.setValorAdquisicion(new BigDecimal("2500.0000"));
        entity.setValorResidual(new BigDecimal("250.0000"));
        entity.setProveedorId(20L);
        entity.setUnidadesProduccionTotales(100000);
        entity.setUnidadesProduccionPeriodo(5000);
        entity.setOrdenCompraId(30L);
        entity.setOrdenCompraLineaId(31L);
        entity.setFlagEstado("1");

        AfMaestroResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("ACT-0001");
        assertThat(response.getNombre()).isEqualTo("Impresora Epson L3250");
        assertThat(response.getAfSubClaseId()).isEqualTo(5L);
        assertThat(response.getAfUbicacionId()).isEqualTo(3L);
        assertThat(response.getFechaAdquisicion()).isEqualTo(LocalDate.of(2024, 1, 15));
        assertThat(response.getValorAdquisicion()).isEqualByComparingTo(new BigDecimal("2500.0000"));
        assertThat(response.getValorResidual()).isEqualByComparingTo(new BigDecimal("250.0000"));
        assertThat(response.getProveedorId()).isEqualTo(20L);
        assertThat(response.getUnidadesProduccionTotales()).isEqualTo(100000);
        assertThat(response.getUnidadesProduccionPeriodo()).isEqualTo(5000);
        assertThat(response.getOrdenCompraId()).isEqualTo(30L);
        assertThat(response.getOrdenCompraLineaId()).isEqualTo(31L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfMaestro e1 = new AfMaestro();
        e1.setId(1L);
        e1.setCodigo("ACT-0001");
        AfMaestro e2 = new AfMaestro();
        e2.setId(2L);
        e2.setCodigo("ACT-0002");

        List<AfMaestroResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getCodigo()).isEqualTo("ACT-0001");
        assertThat(result.get(1).getCodigo()).isEqualTo("ACT-0002");
    }

    @Test
    void toEntity_mapsAllFields() {
        AfMaestroRequest request = new AfMaestroRequest();
        request.setCodigo("ACT-0001");
        request.setNombre("Impresora Epson L3250");
        request.setAfSubClaseId(5L);
        request.setAfUbicacionId(3L);
        request.setFechaAdquisicion(LocalDate.of(2024, 1, 15));
        request.setValorAdquisicion(new BigDecimal("2500.0000"));
        request.setValorResidual(new BigDecimal("250.0000"));
        request.setProveedorId(20L);
        request.setUnidadesProduccionTotales(100000);
        request.setUnidadesProduccionPeriodo(5000);

        AfMaestro entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("ACT-0001");
        assertThat(entity.getNombre()).isEqualTo("Impresora Epson L3250");
        assertThat(entity.getAfSubClaseId()).isEqualTo(5L);
        assertThat(entity.getAfUbicacionId()).isEqualTo(3L);
        assertThat(entity.getFechaAdquisicion()).isEqualTo(LocalDate.of(2024, 1, 15));
        assertThat(entity.getValorAdquisicion()).isEqualByComparingTo(new BigDecimal("2500.0000"));
        assertThat(entity.getValorResidual()).isEqualByComparingTo(new BigDecimal("250.0000"));
        assertThat(entity.getProveedorId()).isEqualTo(20L);
        assertThat(entity.getUnidadesProduccionTotales()).isEqualTo(100000);
        assertThat(entity.getUnidadesProduccionPeriodo()).isEqualTo(5000);
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
        assertThat(entity.getOrdenCompraId()).isNull();
        assertThat(entity.getOrdenCompraLineaId()).isNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfMaestro entity = new AfMaestro();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setCodigo("OLD");

        AfMaestroRequest request = new AfMaestroRequest();
        request.setCodigo("ACT-NEW");
        request.setNombre("Laptop HP ProBook");
        request.setAfSubClaseId(7L);
        request.setAfUbicacionId(4L);
        request.setFechaAdquisicion(LocalDate.of(2025, 6, 1));
        request.setValorAdquisicion(new BigDecimal("5000.0000"));
        request.setValorResidual(new BigDecimal("500.0000"));
        request.setProveedorId(25L);
        request.setUnidadesProduccionTotales(50000);
        request.setUnidadesProduccionPeriodo(2500);

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCodigo()).isEqualTo("ACT-NEW");
        assertThat(entity.getNombre()).isEqualTo("Laptop HP ProBook");
        assertThat(entity.getAfSubClaseId()).isEqualTo(7L);
        assertThat(entity.getAfUbicacionId()).isEqualTo(4L);
        assertThat(entity.getFechaAdquisicion()).isEqualTo(LocalDate.of(2025, 6, 1));
        assertThat(entity.getValorAdquisicion()).isEqualByComparingTo(new BigDecimal("5000.0000"));
        assertThat(entity.getValorResidual()).isEqualByComparingTo(new BigDecimal("500.0000"));
        assertThat(entity.getProveedorId()).isEqualTo(25L);
        assertThat(entity.getUnidadesProduccionTotales()).isEqualTo(50000);
        assertThat(entity.getUnidadesProduccionPeriodo()).isEqualTo(2500);
    }
}
