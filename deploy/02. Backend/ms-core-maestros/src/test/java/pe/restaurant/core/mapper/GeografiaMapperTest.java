package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.entity.Departamento;
import pe.restaurant.core.entity.Distrito;
import pe.restaurant.core.entity.Pais;
import pe.restaurant.core.entity.Provincia;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class GeografiaMapperTest {

    private final GeografiaMapper mapper = Mappers.getMapper(GeografiaMapper.class);

    @Test
    void toResponse_pais_mapsAllFields() {
        Pais entity = new Pais();
        entity.setId(1L);
        entity.setCodigo("PE");
        entity.setNombre("Peru");
        entity.setMonedaId(1L);
        entity.setFormatoFecha("dd/MM/yyyy");
        entity.setZonaHoraria("America/Lima");
        entity.setFlagEstado("1");

        PaisResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("PE");
        assertThat(response.getNombre()).isEqualTo("Peru");
        assertThat(response.getMonedaId()).isEqualTo(1L);
        assertThat(response.getFormatoFecha()).isEqualTo("dd/MM/yyyy");
        assertThat(response.getZonaHoraria()).isEqualTo("America/Lima");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_pais_nullReturnsNull() {
        assertThat(mapper.toResponse((Pais) null)).isNull();
    }

    @Test
    void toPaisResponseList_mapsAll() {
        Pais e1 = new Pais();
        e1.setId(1L);
        e1.setCodigo("PE");
        e1.setNombre("Peru");
        e1.setFlagEstado("1");

        Pais e2 = new Pais();
        e2.setId(2L);
        e2.setCodigo("CO");
        e2.setNombre("Colombia");
        e2.setFlagEstado("1");

        List<PaisResponse> responses = mapper.toPaisResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("PE");
        assertThat(responses.get(1).getCodigo()).isEqualTo("CO");
    }

    @Test
    void toEntity_pais_mapsAllFields() {
        PaisRequest request = new PaisRequest();
        request.setCodigo("PE");
        request.setNombre("Peru");
        request.setMonedaId(1L);
        request.setFormatoFecha("dd/MM/yyyy");
        request.setZonaHoraria("America/Lima");

        Pais entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("PE");
        assertThat(entity.getNombre()).isEqualTo("Peru");
        assertThat(entity.getMonedaId()).isEqualTo(1L);
        assertThat(entity.getFormatoFecha()).isEqualTo("dd/MM/yyyy");
        assertThat(entity.getZonaHoraria()).isEqualTo("America/Lima");
    }

    @Test
    void toEntity_pais_nullReturnsNull() {
        assertThat(mapper.toEntity((PaisRequest) null)).isNull();
    }

    @Test
    void toResponse_departamento_mapsAllFields() {
        Departamento entity = new Departamento();
        entity.setId(1L);
        entity.setPaisId(1L);
        entity.setCodigo("15");
        entity.setNombre("Lima");
        entity.setFlagEstado("1");

        DepartamentoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getPaisId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("15");
        assertThat(response.getNombre()).isEqualTo("Lima");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_departamento_nullReturnsNull() {
        assertThat(mapper.toResponse((Departamento) null)).isNull();
    }

    @Test
    void toDepartamentoResponseList_mapsAll() {
        Departamento e1 = new Departamento();
        e1.setId(1L);
        e1.setCodigo("15");
        e1.setNombre("Lima");
        e1.setFlagEstado("1");

        Departamento e2 = new Departamento();
        e2.setId(2L);
        e2.setCodigo("04");
        e2.setNombre("Arequipa");
        e2.setFlagEstado("1");

        List<DepartamentoResponse> responses = mapper.toDepartamentoResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("15");
        assertThat(responses.get(1).getCodigo()).isEqualTo("04");
    }

    @Test
    void toEntity_departamento_mapsAllFields() {
        DepartamentoRequest request = new DepartamentoRequest();
        request.setPaisId(1L);
        request.setCodigo("15");
        request.setNombre("Lima");

        Departamento entity = mapper.toEntity(request);

        assertThat(entity.getPaisId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("15");
        assertThat(entity.getNombre()).isEqualTo("Lima");
    }

    @Test
    void toEntity_departamento_nullReturnsNull() {
        assertThat(mapper.toEntity((DepartamentoRequest) null)).isNull();
    }

    @Test
    void toResponse_provincia_mapsAllFields() {
        Provincia entity = new Provincia();
        entity.setId(1L);
        entity.setDepartamentoId(1L);
        entity.setCodigo("1501");
        entity.setNombre("Lima");
        entity.setFlagEstado("1");

        ProvinciaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getDepartamentoId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("1501");
        assertThat(response.getNombre()).isEqualTo("Lima");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_provincia_nullReturnsNull() {
        assertThat(mapper.toResponse((Provincia) null)).isNull();
    }

    @Test
    void toProvinciaResponseList_mapsAll() {
        Provincia e1 = new Provincia();
        e1.setId(1L);
        e1.setCodigo("1501");
        e1.setNombre("Lima");
        e1.setFlagEstado("1");

        Provincia e2 = new Provincia();
        e2.setId(2L);
        e2.setCodigo("1502");
        e2.setNombre("Barranca");
        e2.setFlagEstado("1");

        List<ProvinciaResponse> responses = mapper.toProvinciaResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("1501");
        assertThat(responses.get(1).getCodigo()).isEqualTo("1502");
    }

    @Test
    void toEntity_provincia_mapsAllFields() {
        ProvinciaRequest request = new ProvinciaRequest();
        request.setDepartamentoId(1L);
        request.setCodigo("1501");
        request.setNombre("Lima");

        Provincia entity = mapper.toEntity(request);

        assertThat(entity.getDepartamentoId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("1501");
        assertThat(entity.getNombre()).isEqualTo("Lima");
    }

    @Test
    void toEntity_provincia_nullReturnsNull() {
        assertThat(mapper.toEntity((ProvinciaRequest) null)).isNull();
    }

    @Test
    void toResponse_distrito_mapsAllFields() {
        Distrito entity = new Distrito();
        entity.setId(1L);
        entity.setProvinciaId(1L);
        entity.setCodigo("150101");
        entity.setNombre("Lima");
        entity.setFlagEstado("1");

        DistritoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getProvinciaId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("150101");
        assertThat(response.getNombre()).isEqualTo("Lima");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_distrito_nullReturnsNull() {
        assertThat(mapper.toResponse((Distrito) null)).isNull();
    }

    @Test
    void toDistritoResponseList_mapsAll() {
        Distrito e1 = new Distrito();
        e1.setId(1L);
        e1.setCodigo("150101");
        e1.setNombre("Lima");
        e1.setFlagEstado("1");

        Distrito e2 = new Distrito();
        e2.setId(2L);
        e2.setCodigo("150102");
        e2.setNombre("Ancon");
        e2.setFlagEstado("1");

        List<DistritoResponse> responses = mapper.toDistritoResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("150101");
        assertThat(responses.get(1).getCodigo()).isEqualTo("150102");
    }

    @Test
    void toEntity_distrito_mapsAllFields() {
        DistritoRequest request = new DistritoRequest();
        request.setProvinciaId(1L);
        request.setCodigo("150101");
        request.setNombre("Lima");

        Distrito entity = mapper.toEntity(request);

        assertThat(entity.getProvinciaId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("150101");
        assertThat(entity.getNombre()).isEqualTo("Lima");
    }

    @Test
    void toEntity_distrito_nullReturnsNull() {
        assertThat(mapper.toEntity((DistritoRequest) null)).isNull();
    }

    @Test
    void updateEntity_pais_mapsAllFields() {
        Pais entity = new Pais();
        entity.setId(1L);
        entity.setCodigo("PE");
        entity.setNombre("Peru");
        entity.setFlagEstado("1");

        PaisRequest request = new PaisRequest();
        request.setCodigo("CO");
        request.setNombre("Colombia");
        request.setMonedaId(2L);
        request.setFormatoFecha("yyyy-MM-dd");
        request.setZonaHoraria("America/Bogota");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("CO");
        assertThat(entity.getNombre()).isEqualTo("Colombia");
        assertThat(entity.getMonedaId()).isEqualTo(2L);
    }

    @Test
    void updateEntity_departamento_mapsAllFields() {
        Departamento entity = new Departamento();
        entity.setId(1L);
        entity.setCodigo("15");
        entity.setNombre("Lima");
        entity.setFlagEstado("1");

        DepartamentoRequest request = new DepartamentoRequest();
        request.setPaisId(2L);
        request.setCodigo("04");
        request.setNombre("Arequipa");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("04");
        assertThat(entity.getNombre()).isEqualTo("Arequipa");
        assertThat(entity.getPaisId()).isEqualTo(2L);
    }

    @Test
    void updateEntity_provincia_mapsAllFields() {
        Provincia entity = new Provincia();
        entity.setId(1L);
        entity.setCodigo("1501");
        entity.setNombre("Lima");
        entity.setFlagEstado("1");

        ProvinciaRequest request = new ProvinciaRequest();
        request.setDepartamentoId(2L);
        request.setCodigo("0401");
        request.setNombre("Arequipa");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("0401");
        assertThat(entity.getNombre()).isEqualTo("Arequipa");
    }

    @Test
    void updateEntity_distrito_mapsAllFields() {
        Distrito entity = new Distrito();
        entity.setId(1L);
        entity.setCodigo("150101");
        entity.setNombre("Lima");
        entity.setFlagEstado("1");

        DistritoRequest request = new DistritoRequest();
        request.setProvinciaId(2L);
        request.setCodigo("040101");
        request.setNombre("Arequipa");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("040101");
        assertThat(entity.getNombre()).isEqualTo("Arequipa");
    }
}
