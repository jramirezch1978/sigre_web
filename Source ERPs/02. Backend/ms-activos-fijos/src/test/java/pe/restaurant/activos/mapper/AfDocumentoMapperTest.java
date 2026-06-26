package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfDocumentoRequest;
import pe.restaurant.activos.dto.AfDocumentoResponse;
import pe.restaurant.activos.entity.AfDocumento;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfDocumentoMapperTest {

    private final AfDocumentoMapper mapper = Mappers.getMapper(AfDocumentoMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfDocumento entity = new AfDocumento();
        entity.setId(1L);
        entity.setAfMaestroId(10L);
        entity.setTipoDocumento("FACTURA");
        entity.setNombreArchivo("factura_001.pdf");
        entity.setRutaArchivo("/docs/facturas/factura_001.pdf");
        entity.setDescripcion("Factura de compra");
        entity.setFechaCarga(LocalDate.of(2025, 3, 20));
        entity.setTamanioBytes(204800L);
        entity.setExtension("pdf");
        entity.setUsuarioCargaId(5L);

        AfDocumentoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfMaestroId()).isEqualTo(10L);
        assertThat(response.getTipoDocumento()).isEqualTo("FACTURA");
        assertThat(response.getNombreArchivo()).isEqualTo("factura_001.pdf");
        assertThat(response.getRutaArchivo()).isEqualTo("/docs/facturas/factura_001.pdf");
        assertThat(response.getDescripcion()).isEqualTo("Factura de compra");
        assertThat(response.getFechaCarga()).isEqualTo(LocalDate.of(2025, 3, 20));
        assertThat(response.getTamanioBytes()).isEqualTo(204800L);
        assertThat(response.getExtension()).isEqualTo("pdf");
        assertThat(response.getUsuarioCargaId()).isEqualTo(5L);
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfDocumento e1 = new AfDocumento();
        e1.setId(1L);
        e1.setNombreArchivo("doc1.pdf");
        AfDocumento e2 = new AfDocumento();
        e2.setId(2L);
        e2.setNombreArchivo("doc2.pdf");

        List<AfDocumentoResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getNombreArchivo()).isEqualTo("doc1.pdf");
        assertThat(result.get(1).getNombreArchivo()).isEqualTo("doc2.pdf");
    }

    @Test
    void toEntity_mapsAllFields() {
        AfDocumentoRequest request = new AfDocumentoRequest();
        request.setAfMaestroId(10L);
        request.setTipoDocumento("FACTURA");
        request.setNombreArchivo("factura_001.pdf");
        request.setRutaArchivo("/docs/facturas/factura_001.pdf");
        request.setDescripcion("Factura de compra");
        request.setFechaCarga(LocalDate.of(2025, 3, 20));
        request.setTamanioBytes(204800L);
        request.setExtension("pdf");
        request.setUsuarioCargaId(5L);

        AfDocumento entity = mapper.toEntity(request);

        assertThat(entity.getAfMaestroId()).isEqualTo(10L);
        assertThat(entity.getTipoDocumento()).isEqualTo("FACTURA");
        assertThat(entity.getNombreArchivo()).isEqualTo("factura_001.pdf");
        assertThat(entity.getRutaArchivo()).isEqualTo("/docs/facturas/factura_001.pdf");
        assertThat(entity.getDescripcion()).isEqualTo("Factura de compra");
        assertThat(entity.getFechaCarga()).isEqualTo(LocalDate.of(2025, 3, 20));
        assertThat(entity.getTamanioBytes()).isEqualTo(204800L);
        assertThat(entity.getExtension()).isEqualTo("pdf");
        assertThat(entity.getUsuarioCargaId()).isEqualTo(5L);
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfDocumento entity = new AfDocumento();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setAfMaestroId(1L);

        AfDocumentoRequest request = new AfDocumentoRequest();
        request.setAfMaestroId(50L);
        request.setTipoDocumento("CONTRATO");
        request.setNombreArchivo("contrato_v2.pdf");
        request.setRutaArchivo("/docs/contratos/contrato_v2.pdf");
        request.setDescripcion("Contrato actualizado");
        request.setFechaCarga(LocalDate.of(2026, 1, 5));
        request.setTamanioBytes(512000L);
        request.setExtension("pdf");
        request.setUsuarioCargaId(8L);

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getAfMaestroId()).isEqualTo(50L);
        assertThat(entity.getTipoDocumento()).isEqualTo("CONTRATO");
        assertThat(entity.getNombreArchivo()).isEqualTo("contrato_v2.pdf");
        assertThat(entity.getRutaArchivo()).isEqualTo("/docs/contratos/contrato_v2.pdf");
        assertThat(entity.getDescripcion()).isEqualTo("Contrato actualizado");
        assertThat(entity.getFechaCarga()).isEqualTo(LocalDate.of(2026, 1, 5));
        assertThat(entity.getTamanioBytes()).isEqualTo(512000L);
        assertThat(entity.getExtension()).isEqualTo("pdf");
        assertThat(entity.getUsuarioCargaId()).isEqualTo(8L);
    }
}
