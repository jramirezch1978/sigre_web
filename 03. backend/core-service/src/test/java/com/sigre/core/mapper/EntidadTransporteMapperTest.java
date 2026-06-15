package com.sigre.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.core.dto.EntidadTransporteRequest;
import com.sigre.core.dto.EntidadTransporteResponse;
import com.sigre.core.entity.EntidadTransporte;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class EntidadTransporteMapperTest {

    private final EntidadTransporteMapper mapper = Mappers.getMapper(EntidadTransporteMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        EntidadTransporte entity = new EntidadTransporte();
        entity.setId(1L);
        entity.setEntidadContribuyenteId(10L);
        entity.setPlaca("ABC-123");
        entity.setLicencia("LIC001");
        entity.setMtc("MTC001");
        entity.setChofer("Pedro Lopez");
        entity.setFlagEstado("1");

        EntidadTransporteResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getEntidadContribuyenteId()).isEqualTo(10L);
        assertThat(response.getPlaca()).isEqualTo("ABC-123");
        assertThat(response.getLicencia()).isEqualTo("LIC001");
        assertThat(response.getMtc()).isEqualTo("MTC001");
        assertThat(response.getChofer()).isEqualTo("Pedro Lopez");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        EntidadTransporte e1 = new EntidadTransporte();
        e1.setId(1L);
        e1.setEntidadContribuyenteId(10L);
        e1.setPlaca("ABC-123");
        e1.setFlagEstado("1");

        EntidadTransporte e2 = new EntidadTransporte();
        e2.setId(2L);
        e2.setEntidadContribuyenteId(10L);
        e2.setPlaca("XYZ-789");
        e2.setFlagEstado("1");

        List<EntidadTransporteResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getPlaca()).isEqualTo("ABC-123");
        assertThat(responses.get(1).getPlaca()).isEqualTo("XYZ-789");
    }

    @Test
    void toEntity_mapsAllFields() {
        EntidadTransporteRequest request = new EntidadTransporteRequest();
        request.setPlaca("ABC-123");
        request.setLicencia("LIC001");
        request.setMtc("MTC001");
        request.setChofer("Pedro Lopez");

        EntidadTransporte entity = mapper.toEntity(request);

        assertThat(entity.getPlaca()).isEqualTo("ABC-123");
        assertThat(entity.getLicencia()).isEqualTo("LIC001");
        assertThat(entity.getMtc()).isEqualTo("MTC001");
        assertThat(entity.getChofer()).isEqualTo("Pedro Lopez");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_ignoresNullFields() {
        EntidadTransporte entity = new EntidadTransporte();
        entity.setId(1L);
        entity.setEntidadContribuyenteId(10L);
        entity.setPlaca("ABC-123");
        entity.setLicencia("LIC001");
        entity.setMtc("MTC001");
        entity.setChofer("Pedro Lopez");
        entity.setFlagEstado("1");

        EntidadTransporteRequest request = new EntidadTransporteRequest();
        request.setPlaca("DEF-456");
        request.setLicencia(null);
        request.setMtc(null);
        request.setChofer(null);

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getPlaca()).isEqualTo("DEF-456");
        assertThat(entity.getLicencia()).isEqualTo("LIC001");
        assertThat(entity.getMtc()).isEqualTo("MTC001");
        assertThat(entity.getChofer()).isEqualTo("Pedro Lopez");
    }
}
