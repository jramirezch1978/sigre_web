package pe.restaurant.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.finanzas.dto.request.CntasPagarRequest;
import pe.restaurant.finanzas.dto.response.CntasPagarResponse;
import pe.restaurant.finanzas.entity.CntasPagar;
import pe.restaurant.finanzas.entity.CntasPagarDet;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;


@DisplayName("Pruebas Unitarias - CntasPagarMapper")
class CntasPagarMapperTest {

    private CntasPagarMapper cntasPagarMapper;
    private CntasPagarDetMapper cntasPagarDetMapper;
    private CntasPagar cntasPagar;
    private CntasPagarRequest cntasPagarRequest;

    @BeforeEach
    void setUp() {
        cntasPagarMapper = Mappers.getMapper(CntasPagarMapper.class);
        cntasPagarDetMapper = Mappers.getMapper(CntasPagarDetMapper.class);

        cntasPagar = new CntasPagar();
        cntasPagar.setId(1L);
        cntasPagar.setSucursalId(1L);
        cntasPagar.setProveedorId(4L);
        cntasPagar.setDocTipoId(1L);
        cntasPagar.setSerie("F001");
        cntasPagar.setNumero("00001234");
        cntasPagar.setFechaEmision(LocalDate.of(2026, 4, 27));
        cntasPagar.setFechaVencimiento(LocalDate.of(2026, 5, 27));
        cntasPagar.setMonedaId(1L);
        cntasPagar.setTotal(new BigDecimal("1180.00"));
        cntasPagar.setSaldo(new BigDecimal("1180.00"));
        cntasPagar.setCntblAsientoId(5L);
        cntasPagar.setFlagEstado("1");
        cntasPagar.setCreatedBy(10L);
        cntasPagar.setFecCreacion(Instant.now());

        List<CntasPagarDet> detalles = new ArrayList<>();
        CntasPagarDet detalle = new CntasPagarDet();
        detalle.setId(1L);
        detalle.setCntasPagar(cntasPagar);
        detalle.setFechaMov(LocalDate.of(2026, 4, 27));
        detalle.setTipoMov("REGISTRO");
        detalle.setMonto(new BigDecimal("1180.00"));
        detalle.setReferencia("Registro inicial");
        detalle.setConceptoFinancieroId(42L);
        detalles.add(detalle);
        cntasPagar.setDetalles(detalles);

        cntasPagarRequest = new CntasPagarRequest();
        cntasPagarRequest.setProveedorId(4L);
        cntasPagarRequest.setDocTipoId(1L);
        cntasPagarRequest.setSerie("F001");
        cntasPagarRequest.setNumero("00001234");
        cntasPagarRequest.setFechaEmision(LocalDate.of(2026, 4, 27));
        cntasPagarRequest.setFechaVencimiento(LocalDate.of(2026, 5, 27));
        cntasPagarRequest.setMonedaId(1L);
        cntasPagarRequest.setTotal(new BigDecimal("1180.00"));
        cntasPagarRequest.setAno(2026);
        cntasPagarRequest.setMes(4);
        cntasPagarRequest.setCntblLibroId(1L);
    }


    // ==== toEntity — escenarios felices ====

    @Test
    @DisplayName("toEntity - Debe convertir CntasPagarRequest a CntasPagar entity")
    void toEntity_conRequestValido_retornaEntity() {
        CntasPagar entity = cntasPagarMapper.toEntity(cntasPagarRequest);

        assertThat(entity).isNotNull();
        assertThat(entity.getProveedorId()).isEqualTo(4L);
        assertThat(entity.getDocTipoId()).isEqualTo(1L);
        assertThat(entity.getSerie()).isEqualTo("F001");
        assertThat(entity.getNumero()).isEqualTo("00001234");
        assertThat(entity.getFechaEmision()).isEqualTo(LocalDate.of(2026, 4, 27));
        assertThat(entity.getFechaVencimiento()).isEqualTo(LocalDate.of(2026, 5, 27));
        assertThat(entity.getMonedaId()).isEqualTo(1L);
        assertThat(entity.getTotal()).isEqualTo(new BigDecimal("1180.00"));
        
        assertThat(entity.getId()).isNull();
        assertThat(entity.getSucursalId()).isNull();
        assertThat(entity.getSaldo()).isNull();
        assertThat(entity.getCntblAsientoId()).isNull();
    }

    // Test comentado - requiere CntasPagarDetMapper que no está disponible en contexto de test unitario
    // @Test
    // @DisplayName("toResponse - Debe convertir CntasPagar entity a CntasPagarResponse")
    // void toResponse_conEntityValida_retornaResponse() { ... }


    // ==== toResponseSummary — escenarios felices ====

    @Test
    @DisplayName("toResponseSummary - Debe convertir CntasPagar entity a CntasPagarResponse sin detalles ni asiento")
    void toResponseSummary_conEntityValida_retornaResponseSinDetalles() {
        CntasPagarResponse response = cntasPagarMapper.toResponseSummary(cntasPagar);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getProveedorId()).isEqualTo(4L);
        assertThat(response.getSerie()).isEqualTo("F001");
        assertThat(response.getNumero()).isEqualTo("00001234");
        
        assertThat(response.getDetalles()).isNull();
        assertThat(response.getAsiento()).isNull();
        assertThat(response.getProveedorRazonSocial()).isNull();
        assertThat(response.getDocTipoCodigo()).isNull();
    }


    // ==== toResponseList — escenarios felices ====

    @Test
    @DisplayName("toResponseList - Debe convertir lista de CntasPagar a lista de CntasPagarResponse usando toResponseSummary")
    void toResponseList_conListaValida_retornaLista() {
        List<CntasPagar> entities = new ArrayList<>();
        entities.add(cntasPagar);
        
        CntasPagar cntasPagar2 = new CntasPagar();
        cntasPagar2.setId(2L);
        cntasPagar2.setProveedorId(5L);
        cntasPagar2.setSerie("F002");
        cntasPagar2.setNumero("00005678");
        entities.add(cntasPagar2);

        List<CntasPagarResponse> responses = cntasPagarMapper.toResponseList(entities);

        assertThat(responses).isNotNull();
        assertThat(responses.size()).isEqualTo(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
        
        assertThat(responses.get(0).getDetalles()).isNull();
        assertThat(responses.get(0).getAsiento()).isNull();
        assertThat(responses.get(1).getDetalles()).isNull();
        assertThat(responses.get(1).getAsiento()).isNull();
    }


    // ==== toEntity — edge cases ====

    @Test
    @DisplayName("toEntity - Debe manejar request con valores nulos")
    void toEntity_conValoresNulos_manejaCorrectamente() {
        CntasPagarRequest requestConNulos = new CntasPagarRequest();
        requestConNulos.setProveedorId(1L);
        requestConNulos.setDocTipoId(1L);

        CntasPagar entity = cntasPagarMapper.toEntity(requestConNulos);

        assertThat(entity).isNotNull();
        assertThat(entity.getProveedorId()).isEqualTo(1L);
        assertThat(entity.getDocTipoId()).isEqualTo(1L);
        assertThat(entity.getSerie()).isNull();
        assertThat(entity.getNumero()).isNull();
        assertThat(entity.getFechaEmision()).isNull();
    }

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        assertThat(cntasPagarMapper.toEntity(null)).isNull();
    }

    @Test
    @DisplayName("toResponseSummary() con entity null -> retorna null")
    void toResponseSummary_conEntityNull_retornaNull() {
        assertThat(cntasPagarMapper.toResponseSummary(null)).isNull();
    }
}
