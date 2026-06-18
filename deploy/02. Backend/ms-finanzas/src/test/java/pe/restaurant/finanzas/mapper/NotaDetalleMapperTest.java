package pe.restaurant.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import pe.restaurant.finanzas.dto.request.NotaDetalleRequest;
import pe.restaurant.finanzas.dto.response.NotaDetalleResponse;
import pe.restaurant.finanzas.entity.CntasPagarDet;

import java.math.BigDecimal;


@DisplayName("Pruebas Unitarias - NotaDetalleMapper")
class NotaDetalleMapperTest {

    private NotaDetalleMapper mapper;

    @BeforeEach
    void setUp() {
        mapper = new NotaDetalleMapper();
    }


    // ==== toEntity — otros ====

    @Test
    @DisplayName("toEntity - Debe mapear request a entidad")
    void toEntity_DebeMapearRequest() {
        NotaDetalleRequest request = new NotaDetalleRequest();
        request.setItem(1);
        request.setMonto(new BigDecimal("300.00"));
        request.setTipoMov("NOTA_DEBITO");

        CntasPagarDet entity = mapper.toEntity(request, 200L);

        assertThat(entity).isNotNull();
        assertThat(entity.getItem()).isEqualTo(1);
        assertThat(entity.getMonto()).isEqualTo(new BigDecimal("300.00"));
    }


    // ==== toResponse — otros ====

    @Test
    @DisplayName("toResponse - Debe mapear entidad a response")
    void toResponse_DebeMapearEntidad() {
        CntasPagarDet entity = new CntasPagarDet();
        entity.setId(5L);
        entity.setItem(3);
        entity.setMonto(new BigDecimal("750.00"));
        entity.setFlagEstado("1");

        NotaDetalleResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(5L);
        assertThat(response.getItem()).isEqualTo(3);
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
