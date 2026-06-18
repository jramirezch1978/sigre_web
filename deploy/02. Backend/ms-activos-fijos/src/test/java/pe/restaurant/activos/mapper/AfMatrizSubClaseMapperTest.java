package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfMatrizSubClaseRequest;
import pe.restaurant.activos.dto.AfMatrizSubClaseResponse;
import pe.restaurant.activos.entity.AfMatrizSubClase;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfMatrizSubClaseMapperTest {

    private final AfMatrizSubClaseMapper mapper = Mappers.getMapper(AfMatrizSubClaseMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfMatrizSubClase entity = new AfMatrizSubClase();
        entity.setId(1L);
        entity.setAfSubClaseId(10L);
        entity.setCuentaActivoId(100L);
        entity.setCuentaDepAcumId(101L);
        entity.setCuentaGastoDepId(102L);
        entity.setCuentaBajaId(103L);
        entity.setCuentaResVentaId(104L);
        entity.setCentroCostoId(200L);
        entity.setCuentaGastoSeguroId(105L);
        entity.setCuentaPasivoSeguroId(106L);
        entity.setCuentaProveedorTransitoriaId(107L);
        entity.setCuentaCapitalizacionId(108L);
        entity.setFlagEstado("1");

        AfMatrizSubClaseResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfSubClaseId()).isEqualTo(10L);
        assertThat(response.getCuentaActivoId()).isEqualTo(100L);
        assertThat(response.getCuentaDepAcumId()).isEqualTo(101L);
        assertThat(response.getCuentaGastoDepId()).isEqualTo(102L);
        assertThat(response.getCuentaBajaId()).isEqualTo(103L);
        assertThat(response.getCuentaResVentaId()).isEqualTo(104L);
        assertThat(response.getCentroCostoId()).isEqualTo(200L);
        assertThat(response.getCuentaGastoSeguroId()).isEqualTo(105L);
        assertThat(response.getCuentaPasivoSeguroId()).isEqualTo(106L);
        assertThat(response.getCuentaProveedorTransitoriaId()).isEqualTo(107L);
        assertThat(response.getCuentaCapitalizacionId()).isEqualTo(108L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfMatrizSubClase e1 = new AfMatrizSubClase();
        e1.setId(1L);
        e1.setAfSubClaseId(10L);
        AfMatrizSubClase e2 = new AfMatrizSubClase();
        e2.setId(2L);
        e2.setAfSubClaseId(20L);

        List<AfMatrizSubClaseResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getAfSubClaseId()).isEqualTo(10L);
        assertThat(result.get(1).getAfSubClaseId()).isEqualTo(20L);
    }

    @Test
    void toEntity_mapsAllFields() {
        AfMatrizSubClaseRequest request = new AfMatrizSubClaseRequest();
        request.setAfSubClaseId(10L);
        request.setCuentaActivoId(100L);
        request.setCuentaDepAcumId(101L);
        request.setCuentaGastoDepId(102L);
        request.setCuentaBajaId(103L);
        request.setCuentaResVentaId(104L);
        request.setCentroCostoId(200L);
        request.setCuentaGastoSeguroId(105L);
        request.setCuentaPasivoSeguroId(106L);
        request.setCuentaProveedorTransitoriaId(107L);
        request.setCuentaCapitalizacionId(108L);

        AfMatrizSubClase entity = mapper.toEntity(request);

        assertThat(entity.getAfSubClaseId()).isEqualTo(10L);
        assertThat(entity.getCuentaActivoId()).isEqualTo(100L);
        assertThat(entity.getCuentaDepAcumId()).isEqualTo(101L);
        assertThat(entity.getCuentaGastoDepId()).isEqualTo(102L);
        assertThat(entity.getCuentaBajaId()).isEqualTo(103L);
        assertThat(entity.getCuentaResVentaId()).isEqualTo(104L);
        assertThat(entity.getCentroCostoId()).isEqualTo(200L);
        assertThat(entity.getCuentaGastoSeguroId()).isEqualTo(105L);
        assertThat(entity.getCuentaPasivoSeguroId()).isEqualTo(106L);
        assertThat(entity.getCuentaProveedorTransitoriaId()).isEqualTo(107L);
        assertThat(entity.getCuentaCapitalizacionId()).isEqualTo(108L);
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfMatrizSubClase entity = new AfMatrizSubClase();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setAfSubClaseId(1L);

        AfMatrizSubClaseRequest request = new AfMatrizSubClaseRequest();
        request.setAfSubClaseId(50L);
        request.setCuentaActivoId(200L);
        request.setCuentaDepAcumId(201L);
        request.setCuentaGastoDepId(202L);
        request.setCuentaBajaId(203L);
        request.setCuentaResVentaId(204L);
        request.setCentroCostoId(300L);
        request.setCuentaGastoSeguroId(205L);
        request.setCuentaPasivoSeguroId(206L);
        request.setCuentaProveedorTransitoriaId(207L);
        request.setCuentaCapitalizacionId(208L);

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getAfSubClaseId()).isEqualTo(50L);
        assertThat(entity.getCuentaActivoId()).isEqualTo(200L);
        assertThat(entity.getCuentaDepAcumId()).isEqualTo(201L);
        assertThat(entity.getCuentaGastoDepId()).isEqualTo(202L);
        assertThat(entity.getCuentaBajaId()).isEqualTo(203L);
        assertThat(entity.getCuentaResVentaId()).isEqualTo(204L);
        assertThat(entity.getCentroCostoId()).isEqualTo(300L);
        assertThat(entity.getCuentaGastoSeguroId()).isEqualTo(205L);
        assertThat(entity.getCuentaPasivoSeguroId()).isEqualTo(206L);
        assertThat(entity.getCuentaProveedorTransitoriaId()).isEqualTo(207L);
        assertThat(entity.getCuentaCapitalizacionId()).isEqualTo(208L);
    }
}
