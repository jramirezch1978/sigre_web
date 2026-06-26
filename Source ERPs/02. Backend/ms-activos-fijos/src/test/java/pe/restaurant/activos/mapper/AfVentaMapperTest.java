package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfVentaRequest;
import pe.restaurant.activos.dto.AfVentaResponse;
import pe.restaurant.activos.entity.AfVenta;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfVentaMapperTest {

    private final AfVentaMapper mapper = Mappers.getMapper(AfVentaMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfVenta entity = new AfVenta();
        entity.setId(1L);
        entity.setAfMaestroId(10L);
        entity.setCntasCobrarId(20L);
        entity.setDocTipoId(3L);
        entity.setSerieDoc("F001");
        entity.setNroDoc("00000123");
        entity.setFechaBaja(LocalDate.of(2025, 6, 30));
        entity.setMotivo("VENTA");
        entity.setValorVenta(new BigDecimal("35000.0000"));
        entity.setDepreciacionAcumulada(new BigDecimal("15000.0000"));
        entity.setValorNetoContable(new BigDecimal("20000.0000"));
        entity.setComprador("Inversiones ABC SAC");
        entity.setFlagEstado("1");

        AfVentaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfMaestroId()).isEqualTo(10L);
        assertThat(response.getCntasCobrarId()).isEqualTo(20L);
        assertThat(response.getDocTipoId()).isEqualTo(3L);
        assertThat(response.getSerieDoc()).isEqualTo("F001");
        assertThat(response.getNroDoc()).isEqualTo("00000123");
        assertThat(response.getFechaBaja()).isEqualTo(LocalDate.of(2025, 6, 30));
        assertThat(response.getMotivo()).isEqualTo("VENTA");
        assertThat(response.getValorVenta()).isEqualByComparingTo(new BigDecimal("35000.0000"));
        assertThat(response.getDepreciacionAcumulada()).isEqualByComparingTo(new BigDecimal("15000.0000"));
        assertThat(response.getValorNetoContable()).isEqualByComparingTo(new BigDecimal("20000.0000"));
        assertThat(response.getComprador()).isEqualTo("Inversiones ABC SAC");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfVenta e1 = new AfVenta();
        e1.setId(1L);
        e1.setMotivo("VENTA");
        AfVenta e2 = new AfVenta();
        e2.setId(2L);
        e2.setMotivo("BAJA POR OBSOLESCENCIA");

        List<AfVentaResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getMotivo()).isEqualTo("VENTA");
        assertThat(result.get(1).getMotivo()).isEqualTo("BAJA POR OBSOLESCENCIA");
    }

    @Test
    void toEntity_mapsAllFields() {
        AfVentaRequest request = new AfVentaRequest();
        request.setAfMaestroId(10L);
        request.setCntasCobrarId(20L);
        request.setDocTipoId(3L);
        request.setSerieDoc("F001");
        request.setNroDoc("00000123");
        request.setFechaBaja(LocalDate.of(2025, 6, 30));
        request.setMotivo("VENTA");
        request.setValorVenta(new BigDecimal("35000.0000"));
        request.setComprador("Inversiones ABC SAC");

        AfVenta entity = mapper.toEntity(request);

        assertThat(entity.getAfMaestroId()).isEqualTo(10L);
        assertThat(entity.getCntasCobrarId()).isEqualTo(20L);
        assertThat(entity.getDocTipoId()).isEqualTo(3L);
        assertThat(entity.getSerieDoc()).isEqualTo("F001");
        assertThat(entity.getNroDoc()).isEqualTo("00000123");
        assertThat(entity.getFechaBaja()).isEqualTo(LocalDate.of(2025, 6, 30));
        assertThat(entity.getMotivo()).isEqualTo("VENTA");
        assertThat(entity.getValorVenta()).isEqualByComparingTo(new BigDecimal("35000.0000"));
        assertThat(entity.getComprador()).isEqualTo("Inversiones ABC SAC");
        assertThat(entity.getId()).isNull();
        assertThat(entity.getDepreciacionAcumulada()).isNull();
        assertThat(entity.getValorNetoContable()).isNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfVenta entity = new AfVenta();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setDepreciacionAcumulada(new BigDecimal("10000.0000"));
        entity.setValorNetoContable(new BigDecimal("40000.0000"));
        entity.setAfMaestroId(1L);

        AfVentaRequest request = new AfVentaRequest();
        request.setAfMaestroId(50L);
        request.setCntasCobrarId(30L);
        request.setDocTipoId(4L);
        request.setSerieDoc("B001");
        request.setNroDoc("00000456");
        request.setFechaBaja(LocalDate.of(2026, 2, 28));
        request.setMotivo("OBSOLESCENCIA");
        request.setValorVenta(new BigDecimal("5000.0000"));
        request.setComprador("Recicladora Perú SRL");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getDepreciacionAcumulada()).isEqualByComparingTo(new BigDecimal("10000.0000"));
        assertThat(entity.getValorNetoContable()).isEqualByComparingTo(new BigDecimal("40000.0000"));
        assertThat(entity.getAfMaestroId()).isEqualTo(50L);
        assertThat(entity.getCntasCobrarId()).isEqualTo(30L);
        assertThat(entity.getDocTipoId()).isEqualTo(4L);
        assertThat(entity.getSerieDoc()).isEqualTo("B001");
        assertThat(entity.getNroDoc()).isEqualTo("00000456");
        assertThat(entity.getFechaBaja()).isEqualTo(LocalDate.of(2026, 2, 28));
        assertThat(entity.getMotivo()).isEqualTo("OBSOLESCENCIA");
        assertThat(entity.getValorVenta()).isEqualByComparingTo(new BigDecimal("5000.0000"));
        assertThat(entity.getComprador()).isEqualTo("Recicladora Perú SRL");
    }
}
