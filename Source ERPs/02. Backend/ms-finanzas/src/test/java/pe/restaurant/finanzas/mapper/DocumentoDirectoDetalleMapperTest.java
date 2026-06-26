package pe.restaurant.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import pe.restaurant.finanzas.dto.request.DocumentoDirectoDetalleRequest;
import pe.restaurant.finanzas.dto.response.DocumentoDirectoDetalleResponse;
import pe.restaurant.finanzas.entity.CntasPagarDet;

import java.math.BigDecimal;
import java.time.LocalDate;


@DisplayName("Pruebas Unitarias - DocumentoDirectoDetalleMapper")
class DocumentoDirectoDetalleMapperTest {

    private DocumentoDirectoDetalleMapper mapper;

    @BeforeEach
    void setUp() {
        mapper = new DocumentoDirectoDetalleMapper();
    }


    // ==== toEntity — otros ====

    @Test
    @DisplayName("toEntity - Debe mapear request a entidad")
    void toEntity_DebeMapearRequest() {
        DocumentoDirectoDetalleRequest request = new DocumentoDirectoDetalleRequest();
        request.setItem(1);
        request.setMonto(new BigDecimal("500.00"));
        request.setTipoMov("DIRECTO");
        request.setFechaMov(LocalDate.of(2026, 5, 1));

        CntasPagarDet entity = mapper.toEntity(request, 100L);

        assertThat(entity).isNotNull();
        assertThat(entity.getItem()).isEqualTo(1);
        assertThat(entity.getMonto()).isEqualTo(new BigDecimal("500.00"));
    }


    // ==== toResponse — otros ====

    @Test
    @DisplayName("toResponse - Debe mapear entidad a response")
    void toResponse_DebeMapearEntidad() {
        CntasPagarDet entity = new CntasPagarDet();
        entity.setId(1L);
        entity.setItem(2);
        entity.setMonto(new BigDecimal("1000.00"));
        entity.setFlagEstado("1");

        DocumentoDirectoDetalleResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getItem()).isEqualTo(2);
    }

    @Test
    @DisplayName("toResponse() con entity null -> retorna null")
    void toResponse_conEntityNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        assertThat(mapper.toEntity(null, 1L)).isNull();
    }
}
