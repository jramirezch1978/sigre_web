package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.DetraccionRequest;
import pe.restaurant.core.dto.DetraccionResponse;
import pe.restaurant.core.entity.Detraccion;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class DetraccionMapperTest {

    private final DetraccionMapper mapper = Mappers.getMapper(DetraccionMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        Detraccion entity = new Detraccion();
        entity.setId(1L);
        entity.setBienServ("001");
        entity.setDescripcion("Servicio de transporte");
        entity.setFlagEstado("1");
        entity.setCodSunatPdbe("04");
        entity.setTasaPdbe(new BigDecimal("12.00"));
        entity.setFlagIndImp("1");
        entity.setCntblTipoDetraccionId(5L);
        entity.setMontoMinDepre(new BigDecimal("700.00"));

        DetraccionResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getBienServ()).isEqualTo("001");
        assertThat(response.getDescripcion()).isEqualTo("Servicio de transporte");
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCodSunatPdbe()).isEqualTo("04");
        assertThat(response.getTasaPdbe()).isEqualByComparingTo(new BigDecimal("12.00"));
        assertThat(response.getFlagIndImp()).isEqualTo("1");
        assertThat(response.getCntblTipoDetraccionId()).isEqualTo(5L);
        assertThat(response.getMontoMinDepre()).isEqualByComparingTo(new BigDecimal("700.00"));
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        Detraccion e1 = new Detraccion();
        e1.setId(1L);
        e1.setBienServ("001");
        e1.setDescripcion("Desc 1");
        e1.setMontoMinDepre(BigDecimal.ZERO);

        Detraccion e2 = new Detraccion();
        e2.setId(2L);
        e2.setBienServ("002");
        e2.setDescripcion("Desc 2");
        e2.setMontoMinDepre(BigDecimal.ZERO);

        List<DetraccionResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getBienServ()).isEqualTo("001");
        assertThat(responses.get(1).getBienServ()).isEqualTo("002");
    }

    @Test
    void toEntity_mapsAllFields() {
        DetraccionRequest request = new DetraccionRequest();
        request.setBienServ("001");
        request.setDescripcion("Servicio de transporte");
        request.setFlagEstado("1");
        request.setCodSunatPdbe("04");
        request.setTasaPdbe(new BigDecimal("12.00"));
        request.setFlagIndImp("1");
        request.setCntblTipoDetraccionId(5L);
        request.setMontoMinDepre(new BigDecimal("700.00"));

        Detraccion entity = mapper.toEntity(request);

        assertThat(entity.getBienServ()).isEqualTo("001");
        assertThat(entity.getDescripcion()).isEqualTo("Servicio de transporte");
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCodSunatPdbe()).isEqualTo("04");
        assertThat(entity.getTasaPdbe()).isEqualByComparingTo(new BigDecimal("12.00"));
        assertThat(entity.getFlagIndImp()).isEqualTo("1");
        assertThat(entity.getCntblTipoDetraccionId()).isEqualTo(5L);
        assertThat(entity.getMontoMinDepre()).isEqualByComparingTo(new BigDecimal("700.00"));
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        Detraccion entity = new Detraccion();
        entity.setId(1L);
        entity.setBienServ("001");
        entity.setMontoMinDepre(BigDecimal.ZERO);

        DetraccionRequest request = new DetraccionRequest();
        request.setBienServ("002");
        request.setDescripcion("Nuevo servicio");
        request.setFlagEstado("1");
        request.setCodSunatPdbe("05");
        request.setTasaPdbe(new BigDecimal("10.00"));
        request.setFlagIndImp("0");
        request.setCntblTipoDetraccionId(6L);
        request.setMontoMinDepre(new BigDecimal("400.00"));

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getBienServ()).isEqualTo("002");
        assertThat(entity.getDescripcion()).isEqualTo("Nuevo servicio");
        assertThat(entity.getMontoMinDepre()).isEqualByComparingTo(new BigDecimal("400.00"));
    }
}
