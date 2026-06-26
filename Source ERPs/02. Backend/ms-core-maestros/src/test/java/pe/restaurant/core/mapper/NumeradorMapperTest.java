package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.NumeradorRequest;
import pe.restaurant.core.dto.NumeradorResponse;
import pe.restaurant.core.entity.Numerador;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class NumeradorMapperTest {

    private final NumeradorMapper mapper = Mappers.getMapper(NumeradorMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        Numerador entity = new Numerador();
        entity.setId(1L);
        entity.setCodigo("NUM-FAC");
        entity.setNombre("Numerador Factura");
        entity.setSerie("F001");
        entity.setUltimoNumero(100L);
        entity.setLongitud(8);
        entity.setFlagEstado("1");

        NumeradorResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("NUM-FAC");
        assertThat(response.getNombre()).isEqualTo("Numerador Factura");
        assertThat(response.getSerie()).isEqualTo("F001");
        assertThat(response.getUltimoNumero()).isEqualTo(100L);
        assertThat(response.getLongitud()).isEqualTo(8);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        Numerador e1 = new Numerador();
        e1.setId(1L);
        e1.setCodigo("NUM-FAC");
        e1.setNombre("Numerador Factura");
        e1.setFlagEstado("1");

        Numerador e2 = new Numerador();
        e2.setId(2L);
        e2.setCodigo("NUM-BOL");
        e2.setNombre("Numerador Boleta");
        e2.setFlagEstado("1");

        List<NumeradorResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("NUM-FAC");
        assertThat(responses.get(1).getCodigo()).isEqualTo("NUM-BOL");
    }

    @Test
    void toEntity_mapsAllFields() {
        NumeradorRequest request = new NumeradorRequest();
        request.setCodigo("NUM-FAC");
        request.setNombre("Numerador Factura");
        request.setSerie("F001");
        request.setUltimoNumero(0L);
        request.setLongitud(8);
        request.setFlagEstado("1");

        Numerador entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("NUM-FAC");
        assertThat(entity.getNombre()).isEqualTo("Numerador Factura");
        assertThat(entity.getSerie()).isEqualTo("F001");
        assertThat(entity.getUltimoNumero()).isEqualTo(0L);
        assertThat(entity.getLongitud()).isEqualTo(8);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        Numerador entity = new Numerador();
        entity.setId(1L);
        entity.setCodigo("NUM-FAC");
        entity.setNombre("Numerador Factura");
        entity.setSerie("F001");
        entity.setUltimoNumero(100L);
        entity.setLongitud(8);
        entity.setFlagEstado("1");

        NumeradorRequest request = new NumeradorRequest();
        request.setCodigo("NUM-BOL");
        request.setNombre("Numerador Boleta");
        request.setSerie("B001");
        request.setUltimoNumero(200L);
        request.setLongitud(10);
        request.setFlagEstado("1");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("NUM-BOL");
        assertThat(entity.getNombre()).isEqualTo("Numerador Boleta");
        assertThat(entity.getSerie()).isEqualTo("B001");
        assertThat(entity.getUltimoNumero()).isEqualTo(200L);
        assertThat(entity.getLongitud()).isEqualTo(10);
    }
}
