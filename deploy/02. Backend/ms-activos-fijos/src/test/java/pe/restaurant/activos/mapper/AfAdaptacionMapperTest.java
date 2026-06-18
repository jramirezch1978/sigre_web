package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfAdaptacionRequest;
import pe.restaurant.activos.dto.AfAdaptacionResponse;
import pe.restaurant.activos.entity.AfAdaptacion;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfAdaptacionMapperTest {

    private final AfAdaptacionMapper mapper = Mappers.getMapper(AfAdaptacionMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfAdaptacion entity = new AfAdaptacion();
        entity.setId(1L);
        entity.setAfMaestroId(10L);
        entity.setFecha(LocalDate.of(2025, 6, 15));
        entity.setDescripcion("Ampliación de oficina");
        entity.setMontoTotal(new BigDecimal("25000.0000"));
        entity.setFlagEstado("1");
        entity.setEstado("REGISTRADO");

        AfAdaptacionResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfMaestroId()).isEqualTo(10L);
        assertThat(response.getFecha()).isEqualTo(LocalDate.of(2025, 6, 15));
        assertThat(response.getDescripcion()).isEqualTo("Ampliación de oficina");
        assertThat(response.getMontoTotal()).isEqualByComparingTo(new BigDecimal("25000.0000"));
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getEstado()).isEqualTo("REGISTRADO");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfAdaptacion e1 = new AfAdaptacion();
        e1.setId(1L);
        AfAdaptacion e2 = new AfAdaptacion();
        e2.setId(2L);

        List<AfAdaptacionResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getId()).isEqualTo(1L);
        assertThat(result.get(1).getId()).isEqualTo(2L);
    }

    @Test
    void toEntity_mapsAllFields() {
        AfAdaptacionRequest request = new AfAdaptacionRequest();
        request.setAfMaestroId(10L);
        request.setFecha(LocalDate.of(2025, 6, 15));
        request.setDescripcion("Ampliación de oficina");
        request.setMontoTotal(new BigDecimal("25000.0000"));

        AfAdaptacion entity = mapper.toEntity(request);

        assertThat(entity.getAfMaestroId()).isEqualTo(10L);
        assertThat(entity.getFecha()).isEqualTo(LocalDate.of(2025, 6, 15));
        assertThat(entity.getDescripcion()).isEqualTo("Ampliación de oficina");
        assertThat(entity.getMontoTotal()).isEqualByComparingTo(new BigDecimal("25000.0000"));
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
        assertThat(entity.getEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfAdaptacion entity = new AfAdaptacion();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setEstado("REGISTRADO");
        entity.setAfMaestroId(1L);

        AfAdaptacionRequest request = new AfAdaptacionRequest();
        request.setAfMaestroId(50L);
        request.setFecha(LocalDate.of(2026, 1, 10));
        request.setDescripcion("Nuevo texto");
        request.setMontoTotal(new BigDecimal("30000.0000"));

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getEstado()).isEqualTo("REGISTRADO");
        assertThat(entity.getAfMaestroId()).isEqualTo(50L);
        assertThat(entity.getFecha()).isEqualTo(LocalDate.of(2026, 1, 10));
        assertThat(entity.getDescripcion()).isEqualTo("Nuevo texto");
        assertThat(entity.getMontoTotal()).isEqualByComparingTo(new BigDecimal("30000.0000"));
    }
}
