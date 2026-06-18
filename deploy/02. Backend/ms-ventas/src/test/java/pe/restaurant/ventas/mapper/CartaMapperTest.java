package pe.restaurant.ventas.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.ventas.VentasTestFixtures;
import pe.restaurant.ventas.dto.request.CartaRequest;
import pe.restaurant.ventas.dto.response.CartaResponse;
import pe.restaurant.ventas.entity.Carta;
import pe.restaurant.ventas.entity.CartaDet;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests unitarios para CartaMapper.
 * Valida mapeo de entidades a DTOs y viceversa.
 */
@DisplayName("CartaMapper — Pruebas Unitarias")
class CartaMapperTest {

    private final CartaMapper mapper = Mappers.getMapper(CartaMapper.class);

    // ==================== toEntity (CREATE) ====================

    @Test
    @DisplayName("toEntity() con request válido -> mapea correctamente")
    void toEntity_conRequestValido_mapeaCorrectamente() {
        // Arrange
        CartaRequest request = VentasTestFixtures.cartaRequest();
        request.setNombre("Carta Almuerzo");
        request.setDescripcion("Menú ejecutivo");

        // Act
        Carta entity = mapper.toEntity(request);

        // Assert
        assertThat(entity).isNotNull();
        assertThat(entity.getNombre()).isEqualTo("Carta Almuerzo");
        assertThat(entity.getDescripcion()).isEqualTo("Menú ejecutivo");
        assertThat(entity.getId()).isNull(); // No debe asignar ID en CREATE
    }

    @Test
    @DisplayName("toEntity() con detalles -> mapea lista de detalles")
    void toEntity_conDetalles_mapeaListaDetalles() {
        // Arrange
        CartaRequest request = VentasTestFixtures.cartaRequestConDetalles();

        // Act
        Carta entity = mapper.toEntity(request);

        // Assert
        assertThat(entity).isNotNull();
        assertThat(entity.getDetalles()).isNotNull();
        assertThat(entity.getDetalles()).hasSize(1);
        assertThat(entity.getDetalles().get(0).getArticulo().getId()).isEqualTo(100L);
    }

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        // Act
        Carta entity = mapper.toEntity(null);

        // Assert
        assertThat(entity).isNull();
    }

    // ==================== toResponse ====================

    @Test
    @DisplayName("toResponse() con entity válida -> mapea correctamente")
    void toResponse_conEntityValida_mapeaCorrectamente() {
        // Arrange
        Carta entity = VentasTestFixtures.cartaEntity(1L, "1");
        entity.setCreatedBy(10L);
        entity.setFecCreacion(Instant.now());

        // Act
        CartaResponse response = mapper.toResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("Carta Test 1");
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(10L);
        assertThat(response.getFecCreacion()).isNotNull();
        assertThat(response.getSucursalNombre()).isEqualTo("Sucursal 1");
    }

    @Test
    @DisplayName("toResponse() con entity null -> retorna null")
    void toResponse_conEntityNull_retornaNull() {
        // Act
        CartaResponse response = mapper.toResponse(null);

        // Assert
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toResponseList() con lista de entities -> mapea correctamente")
    void toResponseList_conListaEntities_mapeaCorrectamente() {
        // Arrange
        List<Carta> entities = List.of(
            VentasTestFixtures.cartaEntity(1L, "1"),
            VentasTestFixtures.cartaEntity(2L, "1")
        );

        // Act
        List<CartaResponse> responses = mapper.toResponseList(entities);

        // Assert
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    // ==================== updateEntity ====================

    @Test
    @DisplayName("updateEntity() actualiza campos modificables")
    void updateEntity_actualizaCamposModificables() {
        // Arrange
        Carta existing = VentasTestFixtures.cartaEntity(5L, "1");
        existing.setCreatedBy(1L);
        existing.setFecCreacion(Instant.now().minusSeconds(3600));

        CartaRequest request = new CartaRequest();
        request.setNombre("Carta Modificada");
        request.setDescripcion("Nueva descripción");

        // Act
        mapper.updateEntity(request, existing);

        // Assert
        assertThat(existing.getId()).isEqualTo(5L); // ID no cambia
        assertThat(existing.getNombre()).isEqualTo("Carta Modificada");
        assertThat(existing.getDescripcion()).isEqualTo("Nueva descripción");
        assertThat(existing.getCreatedBy()).isEqualTo(1L); // No cambia
        assertThat(existing.getFlagEstado()).isEqualTo("1"); // No cambia
    }

    // ==================== toDetEntity (CartaDet) ====================

    @Test
    @DisplayName("toDetEntity() con request válido -> mapea correctamente")
    void toDetEntity_conRequestValido_mapeaCorrectamente() {
        // Arrange
        CartaRequest.CartaDetRequest request = new CartaRequest.CartaDetRequest();
        request.setArticuloId(100L);
        request.setPrecio(new BigDecimal("25.50"));
        request.setOrden(1);

        // Act
        CartaDet entity = mapper.toDetEntity(request);

        // Assert
        assertThat(entity).isNotNull();
        assertThat(entity.getArticulo()).isNotNull();
        assertThat(entity.getArticulo().getId()).isEqualTo(100L);
        assertThat(entity.getPrecio()).isEqualByComparingTo("25.50");
        assertThat(entity.getOrden()).isEqualTo(1);
        assertThat(entity.getId()).isNull(); // No asigna ID en CREATE
    }

    @Test
    @DisplayName("toDetEntity() con articuloId null -> articulo null")
    void toDetEntity_conArticuloIdNull_articuloNull() {
        // Arrange
        CartaRequest.CartaDetRequest request = new CartaRequest.CartaDetRequest();
        request.setArticuloId(null);
        request.setPrecio(new BigDecimal("10.00"));

        // Act
        CartaDet entity = mapper.toDetEntity(request);

        // Assert
        assertThat(entity).isNotNull();
        assertThat(entity.getArticulo()).isNull();
    }

    // ==================== toDetResponse ====================

    @Test
    @DisplayName("toDetResponse() con entity válida -> mapea correctamente")
    void toDetResponse_conEntityValida_mapeaCorrectamente() {
        // Arrange
        Carta carta = VentasTestFixtures.cartaEntity(1L, "1");
        CartaDet entity = VentasTestFixtures.cartaDetEntity(10L, carta, 100L);
        entity.getArticulo().setCodigo("ART-001");
        entity.getArticulo().setNombre("Artículo Test");
        entity.setCreatedBy(5L);
        entity.setFecCreacion(Instant.now());

        // Act
        CartaResponse.CartaDetResponse response = mapper.toDetResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(10L);
        assertThat(response.getCartaId()).isEqualTo(1L);
        assertThat(response.getArticuloId()).isEqualTo(100L);
        assertThat(response.getArticuloCodigo()).isEqualTo("ART-001");
        assertThat(response.getArticuloNombre()).isEqualTo("Artículo Test");
        assertThat(response.getPrecio()).isEqualByComparingTo("10.00");
        assertThat(response.getCreatedBy()).isEqualTo(5L);
        assertThat(response.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("toDetResponseList() con lista -> mapea correctamente")
    void toDetResponseList_conLista_mapeaCorrectamente() {
        // Arrange
        Carta carta = VentasTestFixtures.cartaEntity(1L, "1");
        List<CartaDet> entities = List.of(
            VentasTestFixtures.cartaDetEntity(1L, carta, 100L),
            VentasTestFixtures.cartaDetEntity(2L, carta, 101L)
        );

        // Act
        List<CartaResponse.CartaDetResponse> responses = mapper.toDetResponseList(entities);

        // Assert
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    // ==================== Helpers ====================

    @Test
    @DisplayName("createArticuloWithId() con ID válido -> crea Articulo")
    void createArticuloWithId_conIdValido_creaArticulo() {
        // Act
        CartaDet.Articulo articulo = mapper.createArticuloWithId(100L);

        // Assert
        assertThat(articulo).isNotNull();
        assertThat(articulo.getId()).isEqualTo(100L);
    }

    @Test
    @DisplayName("createArticuloWithId() con ID null -> retorna null")
    void createArticuloWithId_conIdNull_retornaNull() {
        // Act
        CartaDet.Articulo articulo = mapper.createArticuloWithId(null);

        // Assert
        assertThat(articulo).isNull();
    }

    @Test
    @DisplayName("formatTimestamp() con Instant válido -> formatea correctamente")
    void formatTimestamp_conInstantValido_formateaCorrectamente() {
        // Arrange
        Instant timestamp = Instant.parse("2026-05-22T14:30:00Z");

        // Act
        String formatted = mapper.formatTimestamp(timestamp);

        // Assert
        assertThat(formatted).isNotNull();
        assertThat(formatted).matches("\\d{2}/\\d{2}/\\d{4} \\d{2}:\\d{2}:\\d{2}");
    }

    @Test
    @DisplayName("formatTimestamp() con null -> retorna null")
    void formatTimestamp_conNull_retornaNull() {
        // Act
        String formatted = mapper.formatTimestamp(null);

        // Assert
        assertThat(formatted).isNull();
    }

    @Test
    @DisplayName("loadSucursalNombre() con ID válido -> retorna nombre")
    void loadSucursalNombre_conIdValido_retornaNombre() {
        // Act
        String nombre = mapper.loadSucursalNombre(1L);

        // Assert
        assertThat(nombre).isEqualTo("Sucursal 1");
    }

    @Test
    @DisplayName("loadSucursalNombre() con null -> retorna null")
    void loadSucursalNombre_conNull_retornaNull() {
        // Act
        String nombre = mapper.loadSucursalNombre(null);

        // Assert
        assertThat(nombre).isNull();
    }
}
