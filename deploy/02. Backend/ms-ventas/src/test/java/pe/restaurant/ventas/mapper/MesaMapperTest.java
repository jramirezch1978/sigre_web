package pe.restaurant.ventas.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.ventas.VentasTestFixtures;
import pe.restaurant.ventas.dto.request.MesaRequest;
import pe.restaurant.ventas.dto.response.MesaResponse;
import pe.restaurant.ventas.entity.Mesa;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("MesaMapper — Pruebas Unitarias")
class MesaMapperTest {

    private final MesaMapper mapper = Mappers.getMapper(MesaMapper.class);

    @Test
    @DisplayName("toEntity() con request válido -> mapea correctamente")
    void toEntity_conRequestValido_mapeaCorrectamente() {
        MesaRequest request = VentasTestFixtures.mesaRequest();
        request.setNumero("M-001");
        request.setCapacidad(6);
        request.setZonaId(5L);

        Mesa entity = mapper.toEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getNumero()).isEqualTo("M-001");
        assertThat(entity.getCapacidad()).isEqualTo(6);
        assertThat(entity.getZona()).isNotNull();
        assertThat(entity.getZona().getId()).isEqualTo(5L);
        assertThat(entity.getId()).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity válida -> mapea correctamente")
    void toResponse_conEntityValida_mapeaCorrectamente() {
        Mesa entity = VentasTestFixtures.mesaEntity(1L, "1");
        entity.setCreatedBy(10L);
        entity.setFecCreacion(Instant.now());

        MesaResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNumero()).isEqualTo("M-1");
        assertThat(response.getCapacidad()).isEqualTo(4);
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getZonaId()).isEqualTo(1L);
        assertThat(response.getZonaNombre()).isEqualTo("Zona Test");
    }

    @Test
    @DisplayName("toResponseList() con lista -> mapea correctamente")
    void toResponseList_conLista_mapeaCorrectamente() {
        List<Mesa> entities = List.of(
            VentasTestFixtures.mesaEntity(1L, "1"),
            VentasTestFixtures.mesaEntity(2L, "1")
        );

        List<MesaResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("updateEntity() actualiza campos modificables")
    void updateEntity_actualizaCamposModificables() {
        Mesa existing = VentasTestFixtures.mesaEntity(5L, "1");
        existing.setCreatedBy(1L);

        MesaRequest request = new MesaRequest();
        request.setNumero("M-999");
        request.setCapacidad(8);

        mapper.updateEntity(request, existing);

        assertThat(existing.getId()).isEqualTo(5L);
        assertThat(existing.getNumero()).isEqualTo("M-999");
        assertThat(existing.getCapacidad()).isEqualTo(8);
        assertThat(existing.getCreatedBy()).isEqualTo(1L);
    }

    @Test
    @DisplayName("createZonaFromId() con ID válido -> crea Zona")
    void createZonaFromId_conIdValido_creaZona() {
        Mesa.Zona zona = mapper.createZonaFromId(10L);

        assertThat(zona).isNotNull();
        assertThat(zona.getId()).isEqualTo(10L);
    }

    @Test
    @DisplayName("createZonaFromId() con null -> retorna null")
    void createZonaFromId_conNull_retornaNull() {
        Mesa.Zona zona = mapper.createZonaFromId(null);

        assertThat(zona).isNull();
    }

    @Test
    @DisplayName("loadZonaNombre() con zona válida -> retorna nombre")
    void loadZonaNombre_conZonaValida_retornaNombre() {
        Mesa.Zona zona = new Mesa.Zona();
        zona.setNombre("Zona VIP");

        String nombre = mapper.loadZonaNombre(zona);

        assertThat(nombre).isEqualTo("Zona VIP");
    }

    @Test
    @DisplayName("loadZonaNombre() con zona null -> retorna null")
    void loadZonaNombre_conZonaNull_retornaNull() {
        String nombre = mapper.loadZonaNombre(null);

        assertThat(nombre).isNull();
    }

    @Test
    @DisplayName("formatTimestamp() con Instant válido -> formatea correctamente")
    void formatTimestamp_conInstantValido_formateaCorrectamente() {
        Instant timestamp = Instant.parse("2026-05-22T14:30:00Z");

        String formatted = mapper.formatTimestamp(timestamp);

        assertThat(formatted).isNotNull();
        assertThat(formatted).matches("\\d{2}/\\d{2}/\\d{4} \\d{2}:\\d{2}:\\d{2}");
    }
}
