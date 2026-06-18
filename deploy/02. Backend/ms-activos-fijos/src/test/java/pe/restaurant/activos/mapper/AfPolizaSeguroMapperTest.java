package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfPolizaSeguroRequest;
import pe.restaurant.activos.dto.AfPolizaSeguroResponse;
import pe.restaurant.activos.entity.AfPolizaSeguro;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfPolizaSeguroMapperTest {

    private final AfPolizaSeguroMapper mapper = Mappers.getMapper(AfPolizaSeguroMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfPolizaSeguro entity = new AfPolizaSeguro();
        entity.setId(1L);
        entity.setAfAseguradoraId(10L);
        entity.setNumeroPoliza("POL-2025-001");
        entity.setFechaInicio(LocalDate.of(2025, 1, 1));
        entity.setFechaFin(LocalDate.of(2025, 12, 31));
        entity.setPrima(new BigDecimal("5000.0000"));
        entity.setCobertura(new BigDecimal("500000.0000"));
        entity.setFlagEstado("1");

        AfPolizaSeguroResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfAseguradoraId()).isEqualTo(10L);
        assertThat(response.getNumeroPoliza()).isEqualTo("POL-2025-001");
        assertThat(response.getFechaInicio()).isEqualTo(LocalDate.of(2025, 1, 1));
        assertThat(response.getFechaFin()).isEqualTo(LocalDate.of(2025, 12, 31));
        assertThat(response.getPrima()).isEqualByComparingTo(new BigDecimal("5000.0000"));
        assertThat(response.getCobertura()).isEqualByComparingTo(new BigDecimal("500000.0000"));
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfPolizaSeguro e1 = new AfPolizaSeguro();
        e1.setId(1L);
        e1.setNumeroPoliza("POL-001");
        AfPolizaSeguro e2 = new AfPolizaSeguro();
        e2.setId(2L);
        e2.setNumeroPoliza("POL-002");

        List<AfPolizaSeguroResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getNumeroPoliza()).isEqualTo("POL-001");
        assertThat(result.get(1).getNumeroPoliza()).isEqualTo("POL-002");
    }

    @Test
    void toEntity_mapsAllFields() {
        AfPolizaSeguroRequest request = new AfPolizaSeguroRequest();
        request.setAfAseguradoraId(10L);
        request.setNumeroPoliza("POL-2025-001");
        request.setFechaInicio(LocalDate.of(2025, 1, 1));
        request.setFechaFin(LocalDate.of(2025, 12, 31));
        request.setPrima(new BigDecimal("5000.0000"));
        request.setCobertura(new BigDecimal("500000.0000"));

        AfPolizaSeguro entity = mapper.toEntity(request);

        assertThat(entity.getAfAseguradoraId()).isEqualTo(10L);
        assertThat(entity.getNumeroPoliza()).isEqualTo("POL-2025-001");
        assertThat(entity.getFechaInicio()).isEqualTo(LocalDate.of(2025, 1, 1));
        assertThat(entity.getFechaFin()).isEqualTo(LocalDate.of(2025, 12, 31));
        assertThat(entity.getPrima()).isEqualByComparingTo(new BigDecimal("5000.0000"));
        assertThat(entity.getCobertura()).isEqualByComparingTo(new BigDecimal("500000.0000"));
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfPolizaSeguro entity = new AfPolizaSeguro();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setNumeroPoliza("OLD");

        AfPolizaSeguroRequest request = new AfPolizaSeguroRequest();
        request.setAfAseguradoraId(50L);
        request.setNumeroPoliza("POL-2026-010");
        request.setFechaInicio(LocalDate.of(2026, 1, 1));
        request.setFechaFin(LocalDate.of(2026, 12, 31));
        request.setPrima(new BigDecimal("8000.0000"));
        request.setCobertura(new BigDecimal("800000.0000"));

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getAfAseguradoraId()).isEqualTo(50L);
        assertThat(entity.getNumeroPoliza()).isEqualTo("POL-2026-010");
        assertThat(entity.getFechaInicio()).isEqualTo(LocalDate.of(2026, 1, 1));
        assertThat(entity.getFechaFin()).isEqualTo(LocalDate.of(2026, 12, 31));
        assertThat(entity.getPrima()).isEqualByComparingTo(new BigDecimal("8000.0000"));
        assertThat(entity.getCobertura()).isEqualByComparingTo(new BigDecimal("800000.0000"));
    }
}
