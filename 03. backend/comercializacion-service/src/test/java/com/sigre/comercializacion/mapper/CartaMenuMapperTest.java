package com.sigre.comercializacion.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import com.sigre.comercializacion.VentasTestFixtures;
import com.sigre.comercializacion.dto.request.CartaRequest;
import com.sigre.comercializacion.dto.response.CartaMenuListItemResponse;
import com.sigre.comercializacion.dto.response.CartaMenuResponse;
import com.sigre.comercializacion.entity.Carta;
import com.sigre.comercializacion.entity.CartaDet;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("CartaMenuMapper — Pruebas Unitarias")
class CartaMenuMapperTest {

    private final CartaMenuMapper mapper = Mappers.getMapper(CartaMenuMapper.class);

    // ==================== TESTS DE LISTADO ====================

    @Test
    @DisplayName("toListItemResponse() con entity válida -> mapea correctamente")
    void toListItemResponse_conEntityValida_mapeaCorrectamente() {
        // Arrange
        Carta entity = VentasTestFixtures.cartaEntity(1L, "1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-05-22T15:00:00Z")); // UTC
        entity.setUpdatedBy(2L);
        entity.setFecModificacion(Instant.parse("2026-05-22T16:00:00Z")); // UTC

        // Act
        CartaMenuListItemResponse response = mapper.toListItemResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getSucursalId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("Carta Test 1");
        assertThat(response.getDescripcion()).isEqualTo("Descripción de prueba");
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isEqualTo("22/05/2026 10:00:00"); // America/Lima (UTC-5)
        assertThat(response.getUpdatedBy()).isEqualTo(2L);
        assertThat(response.getFecModificacion()).isEqualTo("22/05/2026 11:00:00"); // America/Lima (UTC-5)
        
        // Campo ignorado
        assertThat(response.getSucursalNombre()).isNull();
    }

    @Test
    @DisplayName("toListItemResponse() con entity nula -> retorna null")
    void toListItemResponse_conEntityNula_retornaNull() {
        // Act
        CartaMenuListItemResponse response = mapper.toListItemResponse(null);

        // Assert
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toListItemResponseList() con lista válida -> mapea correctamente")
    void toListItemResponseList_conListaValida_mapeaCorrectamente() {
        // Arrange
        Carta entity1 = VentasTestFixtures.cartaEntity(1L, "1");
        Carta entity2 = VentasTestFixtures.cartaEntity(2L, "1");
        List<Carta> entities = List.of(entity1, entity2);

        // Act
        List<CartaMenuListItemResponse> responses = mapper.toListItemResponseList(entities);

        // Assert
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("toListItemResponseList() con lista nula -> retorna null")
    void toListItemResponseList_conListaNula_retornaNull() {
        // Act
        List<CartaMenuListItemResponse> responses = mapper.toListItemResponseList(null);

        // Assert
        assertThat(responses).isNull();
    }

    @Test
    @DisplayName("toListItemResponsePage() con page válido -> mapea correctamente")
    void toListItemResponsePage_conPageValido_mapeaCorrectamente() {
        // Arrange
        Carta entity1 = VentasTestFixtures.cartaEntity(1L, "1");
        Carta entity2 = VentasTestFixtures.cartaEntity(2L, "1");
        List<Carta> entities = List.of(entity1, entity2);
        Page<Carta> page = new PageImpl<>(entities, PageRequest.of(0, 10), 2);

        // Act
        Page<CartaMenuListItemResponse> responsePage = mapper.toListItemResponsePage(page);

        // Assert
        assertThat(responsePage).isNotNull();
        assertThat(responsePage.getContent()).hasSize(2);
        assertThat(responsePage.getTotalElements()).isEqualTo(2);
        assertThat(responsePage.getTotalPages()).isEqualTo(1);
        assertThat(responsePage.getContent().get(0).getId()).isEqualTo(1L);
    }

    // ==================== TESTS DE DETALLE ====================

    @Test
    @DisplayName("toResponse() con entity válida y detalles -> mapea correctamente")
    void toResponse_conEntityValidaYDetalles_mapeaCorrectamente() {
        // Arrange
        Carta entity = VentasTestFixtures.cartaEntity(1L, "1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-05-22T15:00:00Z")); // UTC
        entity.setUpdatedBy(2L);
        entity.setFecModificacion(Instant.parse("2026-05-22T16:00:00Z")); // UTC

        // Agregar detalles
        CartaDet detalle1 = VentasTestFixtures.cartaDetEntity(1L, entity, 100L);
        detalle1.setCreatedBy(1L);
        detalle1.setFecCreacion(Instant.parse("2026-05-22T15:00:00Z"));
        CartaDet detalle2 = VentasTestFixtures.cartaDetEntity(2L, entity, 200L);
        detalle2.setCreatedBy(1L);
        detalle2.setFecCreacion(Instant.parse("2026-05-22T15:00:00Z"));
        entity.setDetalles(List.of(detalle1, detalle2));

        // Act
        CartaMenuResponse response = mapper.toResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getSucursalId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("Carta Test 1");
        assertThat(response.getDescripcion()).isEqualTo("Descripción de prueba");
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isEqualTo("22/05/2026 10:00:00");
        assertThat(response.getUpdatedBy()).isEqualTo(2L);
        assertThat(response.getFecModificacion()).isEqualTo("22/05/2026 11:00:00");

        // Validar items
        assertThat(response.getItems()).hasSize(2);
        CartaMenuResponse.CartaItemResponse item1 = response.getItems().get(0);
        assertThat(item1.getId()).isEqualTo(1L);
        assertThat(item1.getCartaId()).isEqualTo(1L);
        assertThat(item1.getArticuloId()).isEqualTo(100L);
        assertThat(item1.getPrecio()).isEqualByComparingTo("10.00");
        assertThat(item1.getOrden()).isEqualTo(1);
        assertThat(item1.getFlagEstado()).isEqualTo("1");
        
        // Campo ignorado
        assertThat(response.getSucursalNombre()).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity válida sin detalles -> mapea correctamente")
    void toResponse_conEntityValidaSinDetalles_mapeaCorrectamente() {
        // Arrange
        Carta entity = VentasTestFixtures.cartaEntity(1L, "1");
        entity.setDetalles(null); // Sin detalles

        // Act
        CartaMenuResponse response = mapper.toResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getItems()).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity nula -> retorna null")
    void toResponse_conEntityNula_retornaNull() {
        // Act
        CartaMenuResponse response = mapper.toResponse(null);

        // Assert
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toResponseList() con lista válida -> mapea correctamente")
    void toResponseList_conListaValida_mapeaCorrectamente() {
        // Arrange
        Carta entity1 = VentasTestFixtures.cartaEntity(1L, "1");
        Carta entity2 = VentasTestFixtures.cartaEntity(2L, "1");
        List<Carta> entities = List.of(entity1, entity2);

        // Act
        List<CartaMenuResponse> responses = mapper.toResponseList(entities);

        // Assert
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    // ==================== TESTS DE ITEMS ====================

    @Test
    @DisplayName("toItemResponse() con CartaDet válida -> mapea correctamente")
    void toItemResponse_conCartaDetValida_mapeaCorrectamente() {
        // Arrange
        Carta carta = VentasTestFixtures.cartaEntity(1L, "1");
        CartaDet entity = VentasTestFixtures.cartaDetEntity(1L, carta, 100L);
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-05-22T15:00:00Z")); // UTC
        entity.setUpdatedBy(2L);
        entity.setFecModificacion(Instant.parse("2026-05-22T16:00:00Z")); // UTC

        // Act
        CartaMenuResponse.CartaItemResponse response = mapper.toItemResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCartaId()).isEqualTo(1L);
        assertThat(response.getArticuloId()).isEqualTo(100L);
        assertThat(response.getPrecio()).isEqualByComparingTo("10.00");
        assertThat(response.getOrden()).isEqualTo(1);
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isEqualTo("22/05/2026 10:00:00");
        assertThat(response.getUpdatedBy()).isEqualTo(2L);
        assertThat(response.getFecModificacion()).isEqualTo("22/05/2026 11:00:00");
    }

    @Test
    @DisplayName("toItemResponse() con CartaDet nula -> retorna null")
    void toItemResponse_conCartaDetNula_retornaNull() {
        // Act
        CartaMenuResponse.CartaItemResponse response = mapper.toItemResponse(null);

        // Assert
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toItemResponseList() con lista válida -> mapea correctamente")
    void toItemResponseList_conListaValida_mapeaCorrectamente() {
        // Arrange
        Carta carta = VentasTestFixtures.cartaEntity(1L, "1");
        CartaDet det1 = VentasTestFixtures.cartaDetEntity(1L, carta, 100L);
        CartaDet det2 = VentasTestFixtures.cartaDetEntity(2L, carta, 200L);
        List<CartaDet> entities = List.of(det1, det2);

        // Act
        List<CartaMenuResponse.CartaItemResponse> responses = mapper.toItemResponseList(entities);

        // Assert
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    // ==================== TESTS DE CREACIÓN/ACTUALIZACIÓN ====================

    @Test
    @DisplayName("toEntity() con request válido -> mapea correctamente para CREATE")
    void toEntity_conRequestValido_mapeaCorrectamenteParaCreate() {
        // Arrange
        CartaRequest request = VentasTestFixtures.cartaRequestConDetalles();

        // Act
        Carta entity = mapper.toEntity(request);

        // Assert
        assertThat(entity).isNotNull();
        assertThat(entity.getId()).isNull(); // No se mapea en CREATE
        assertThat(entity.getSucursalId()).isNull(); // No viene en el request existente
        assertThat(entity.getNombre()).isEqualTo("Carta Test Request");
        assertThat(entity.getDescripcion()).isEqualTo("Descripción de prueba");
        assertThat(entity.getDetalles()).hasSize(1);
        
        // Campos que deben ser ignorados en CREATE
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
        assertThat(entity.getUpdatedBy()).isNull();
        assertThat(entity.getFecModificacion()).isNull();
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toEntity() con request nulo -> retorna null")
    void toEntity_conRequestNulo_retornaNull() {
        // Act
        Carta entity = mapper.toEntity(null);

        // Assert
        assertThat(entity).isNull();
    }

    @Test
    @DisplayName("updateEntity() con request válido -> actualiza correctamente")
    void updateEntity_conRequestValido_actualizaCorrectamente() {
        // Arrange
        Carta entity = VentasTestFixtures.cartaEntity(1L, "1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-05-22T10:00:00Z"));
        
        CartaRequest request = VentasTestFixtures.cartaRequest();
        request.setNombre("Carta Actualizada");
        request.setDescripcion("Descripción Actualizada");

        // Act
        mapper.updateEntity(request, entity);

        // Assert
        assertThat(entity.getId()).isEqualTo(1L); // No se modifica
        assertThat(entity.getNombre()).isEqualTo("Carta Actualizada");
        assertThat(entity.getDescripcion()).isEqualTo("Descripción Actualizada");
        
        // Campos que deben mantenerse en UPDATE
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getFecCreacion()).isEqualTo(Instant.parse("2026-05-22T10:00:00Z"));
        
        // Campos que no se deben modificar (se ignoran)
        assertThat(entity.getUpdatedBy()).isNull();
        assertThat(entity.getFecModificacion()).isNull();
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("updateEntity() con request nulo -> no modifica entity")
    void updateEntity_conRequestNulo_noModificaEntity() {
        // Arrange
        Carta entity = VentasTestFixtures.cartaEntity(1L, "1");
        String nombreOriginal = entity.getNombre();

        // Act
        mapper.updateEntity(null, entity);

        // Assert
        assertThat(entity.getNombre()).isEqualTo(nombreOriginal);
    }

    // ==================== TESTS DE DETALLES (ENTIDADES) ====================

    @Test
    @DisplayName("toDetEntity() con request válido -> mapea correctamente")
    void toDetEntity_conRequestValido_mapeaCorrectamente() {
        // Arrange
        CartaRequest.CartaDetRequest request = new CartaRequest.CartaDetRequest();
        request.setArticuloId(100L);
        request.setPrecio(new BigDecimal("50.00"));
        request.setOrden(1);

        // Act
        CartaDet entity = mapper.toDetEntity(request);

        // Assert
        assertThat(entity).isNotNull();
        assertThat(entity.getId()).isNull(); // No se mapea en CREATE
        assertThat(entity.getArticulo()).isNotNull();
        assertThat(entity.getArticulo().getId()).isEqualTo(100L);
        assertThat(entity.getPrecio()).isEqualByComparingTo("50.00");
        assertThat(entity.getOrden()).isEqualTo(1);
        
        // Campos que deben ser ignorados en CREATE
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
        assertThat(entity.getUpdatedBy()).isNull();
        assertThat(entity.getFecModificacion()).isNull();
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCarta()).isNull();
    }

    @Test
    @DisplayName("toDetEntity() con request nulo -> retorna null")
    void toDetEntity_conRequestNulo_retornaNull() {
        // Act
        CartaDet entity = mapper.toDetEntity(null);

        // Assert
        assertThat(entity).isNull();
    }

    // ==================== TESTS DE UTILIDADES ====================

    @Test
    @DisplayName("formatTimestamp() con timestamp válido -> formatea correctamente")
    void formatTimestamp_conTimestampValido_formateaCorrectamente() {
        // Arrange
        Instant timestamp = Instant.parse("2026-05-22T15:30:45Z"); // UTC

        // Act
        String formatted = mapper.formatTimestamp(timestamp);

        // Assert
        assertThat(formatted).isEqualTo("22/05/2026 10:30:45"); // America/Lima (UTC-5)
    }

    @Test
    @DisplayName("formatTimestamp() con timestamp nulo -> retorna null")
    void formatTimestamp_conTimestampNulo_retornaNull() {
        // Act
        String formatted = mapper.formatTimestamp(null);

        // Assert
        assertThat(formatted).isNull();
    }

    @Test
    @DisplayName("createArticuloWithId() con ID válido -> crea articulo correctamente")
    void createArticuloWithId_conIdValido_creaArticuloCorrectamente() {
        // Act
        CartaDet.Articulo articulo = mapper.createArticuloWithId(100L);

        // Assert
        assertThat(articulo).isNotNull();
        assertThat(articulo.getId()).isEqualTo(100L);
    }

    @Test
    @DisplayName("createArticuloWithId() con ID nulo -> retorna null")
    void createArticuloWithId_conIdNulo_retornaNull() {
        // Act
        CartaDet.Articulo articulo = mapper.createArticuloWithId(null);

        // Assert
        assertThat(articulo).isNull();
    }
}
