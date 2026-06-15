package com.sigre.comercializacion.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.entity.Carta;
import com.sigre.comercializacion.entity.CartaDet;
import com.sigre.comercializacion.mapper.CartaMapper;
import com.sigre.comercializacion.repository.ArticuloRepository;
import com.sigre.comercializacion.repository.CartaDetRepository;
import com.sigre.comercializacion.repository.CartaRepository;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CartaServiceImplTest {

    private static final Pageable PAGE = PageRequest.of(0, 20);

    @Mock
    private CartaRepository repository;
    @Mock
    private CartaDetRepository detalleRepository;
    @Mock
    private CartaMapper mapper;
    @Mock
    private ArticuloRepository articuloRepository;
    @InjectMocks
    private CartaServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    @Test
    void findById_ok() {
        Carta c = carta(1L, "Menú", "1");
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        assertThat(service.findById(1L).getNombre()).isEqualTo("Menú");
    }

    @Test
    void findById_notFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(99L));
    }

    @Test
    void findAll_y_findAllWithFilters() {
        when(repository.findAll(PAGE)).thenReturn(new PageImpl<>(List.of()));
        when(repository.findAllWithFilters(eq(1L), eq("Men"), eq("1"), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));
        assertThat(service.findAll(PAGE).getContent()).isEmpty();
        assertThat(service.findAllWithFilters(1L, "Men", "1", PAGE).getContent()).isEmpty();
    }

    @Test
    void create_ok_conItems() {
        Carta input = carta(null, "Nueva", null);
        CartaDet det = detalle(input, 100L);
        input.setDetalles(new ArrayList<>(List.of(det)));
        when(repository.existsByNombreAndSucursalIdAndFlagEstado("Nueva", 1L, "1")).thenReturn(false);
        when(articuloRepository.existsByIdAndFlagEstado(100L, "1")).thenReturn(true);
        when(repository.save(any())).thenAnswer(inv -> {
            Carta e = inv.getArgument(0);
            e.setId(10L);
            return e;
        });
        Carta out = service.create(input);
        assertThat(out.getFlagEstado()).isEqualTo("1");
        assertThat(out.getDetalles()).hasSize(1);
    }

    @Test
    void create_articuloInactivo_throws() {
        Carta input = carta(null, "X", null);
        CartaDet det = detalle(input, 999L);
        input.setDetalles(new ArrayList<>(List.of(det)));
        when(repository.existsByNombreAndSucursalIdAndFlagEstado("X", 1L, "1")).thenReturn(false);
        when(articuloRepository.existsByIdAndFlagEstado(999L, "1")).thenReturn(false);
        assertThrows(BusinessException.class, () -> service.create(input));
    }

    @Test
    void create_nombreDuplicado_throws() {
        Carta input = carta(null, "Dup", null);
        when(repository.existsByNombreAndSucursalIdAndFlagEstado("Dup", 1L, "1")).thenReturn(true);
        assertThrows(BusinessException.class, () -> service.create(input));
    }

    @Test
    void update_ok() {
        Carta existing = carta(5L, "Old", "1");
        existing.setDetalles(new ArrayList<>());
        Carta patch = carta(null, "New", null);
        CartaDet det = detalle(patch, 100L);
        patch.setDetalles(new ArrayList<>(List.of(det)));
        when(repository.findById(5L)).thenReturn(Optional.of(existing));
        when(repository.existsByNombreAndSucursalIdAndFlagEstadoAndIdNot("New", 1L, "1", 5L)).thenReturn(false);
        when(articuloRepository.existsByIdAndFlagEstado(100L, "1")).thenReturn(true);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        assertThat(service.update(5L, patch).getNombre()).isEqualTo("New");
    }

    @Test
    void update_notFound() {
        when(repository.findById(5L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.update(5L, carta(null, "X", null)));
    }

    @Test
    void activate_deactivate_delete() {
        Carta c = carta(3L, "C3", "1");
        when(repository.findById(3L)).thenReturn(Optional.of(c));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        assertThat(service.activate(3L).getFlagEstado()).isEqualTo("1");
        assertThat(service.deactivate(3L).getFlagEstado()).isEqualTo("0");
        service.delete(3L);
        verify(repository).delete(c);
    }

    @Test
    void addItem_ok() {
        Carta c = carta(1L, "Menú", "1");
        CartaDet item = detalle(c, 100L);
        item.setPrecio(new BigDecimal("15.00"));
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(articuloRepository.existsByIdAndFlagEstado(100L, "1")).thenReturn(true);
        when(detalleRepository.existsByCartaIdAndArticuloIdAndActivo(1L, 100L)).thenReturn(false);
        when(detalleRepository.save(any())).thenAnswer(inv -> {
            CartaDet d = inv.getArgument(0);
            d.setId(50L);
            return d;
        });
        assertThat(service.addItem(1L, item).getId()).isEqualTo(50L);
    }

    @Test
    void addItem_articuloDuplicado_throws() {
        Carta c = carta(1L, "Menú", "1");
        CartaDet item = detalle(c, 100L);
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(articuloRepository.existsByIdAndFlagEstado(100L, "1")).thenReturn(true);
        when(detalleRepository.existsByCartaIdAndArticuloIdAndActivo(1L, 100L)).thenReturn(true);
        assertThrows(BusinessException.class, () -> service.addItem(1L, item));
    }

    @Test
    void findItemsByCartaId_ok() {
        Carta c = carta(2L, "Lunch", "1");
        when(repository.findById(2L)).thenReturn(Optional.of(c));
        when(detalleRepository.findByCartaIdAndActivo(2L)).thenReturn(List.of(detalle(c, 10L)));
        assertThat(service.findItemsByCartaId(2L)).hasSize(1);
    }

    @Test
    void updateItem_y_deleteItem_ok() {
        Carta c = carta(1L, "Menú", "1");
        CartaDet existing = detalle(c, 100L);
        existing.setId(60L);
        CartaDet patch = detalle(c, 100L);
        patch.setPrecio(new BigDecimal("20.00"));
        patch.setOrden(2);
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(detalleRepository.findById(60L)).thenReturn(Optional.of(existing));
        when(detalleRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        assertThat(service.updateItem(1L, 60L, patch).getPrecio()).isEqualByComparingTo("20.00");
        service.deleteItem(1L, 60L);
        assertThat(existing.getFlagEstado()).isEqualTo("0");
    }

    @Test
    void updateItemFields_ok() {
        Carta c = carta(1L, "Menú", "1");
        CartaDet existing = detalle(c, 100L);
        existing.setId(61L);
        when(detalleRepository.findById(61L)).thenReturn(Optional.of(existing));
        when(detalleRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        assertThat(service.updateItemFields(1L, 61L, new BigDecimal("25.00"), 3).getOrden()).isEqualTo(3);
    }

    @Test
    void create_sinDetalles() {
        Carta input = carta(null, "SinDet", null);
        when(repository.existsByNombreAndSucursalIdAndFlagEstado("SinDet", 1L, "1")).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> {
            Carta e = inv.getArgument(0);
            e.setId(20L);
            return e;
        });
        Carta out = service.create(input);
        assertThat(out.getId()).isEqualTo(20L);
    }

    @Test
    void findAllWithFilters_conValoresNormalizados() {
        when(repository.findAllWithFilters(eq(1L), isNull(), isNull(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));
        assertThat(service.findAllWithFilters(1L, "  ", "", PAGE).getContent()).isEmpty();
    }

    @Test
    void update_sinDetallesEnPatch() {
        Carta existing = carta(10L, "Old", "1");
        existing.setDetalles(new ArrayList<>());
        Carta patch = carta(null, "New", null);
        when(repository.findById(10L)).thenReturn(Optional.of(existing));
        when(repository.existsByNombreAndSucursalIdAndFlagEstadoAndIdNot("New", 1L, "1", 10L)).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        assertThat(service.update(10L, patch).getNombre()).isEqualTo("New");
    }

    @Test
    void update_conPatchDetallesVacioYExistingDetallesNull() {
        Carta existing = carta(15L, "Vieja", "1");
        Carta patch = carta(null, "Renamed", null);
        patch.setDetalles(List.of());
        when(repository.findById(15L)).thenReturn(Optional.of(existing));
        when(repository.existsByNombreAndSucursalIdAndFlagEstadoAndIdNot("Renamed", 1L, "1", 15L)).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        assertThat(service.update(15L, patch).getNombre()).isEqualTo("Renamed");
    }

    @Test
    void addItem_precioNull() {
        Carta c = carta(1L, "Menú", "1");
        CartaDet item = detalle(c, 200L);
        item.setPrecio(null);
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(articuloRepository.existsByIdAndFlagEstado(200L, "1")).thenReturn(true);
        when(detalleRepository.existsByCartaIdAndArticuloIdAndActivo(1L, 200L)).thenReturn(false);
        when(detalleRepository.save(any())).thenAnswer(inv -> {
            CartaDet d = inv.getArgument(0);
            d.setId(70L);
            return d;
        });
        assertThat(service.addItem(1L, item).getId()).isEqualTo(70L);
    }

    @Test
    void addItem_precioNegativo_throws() {
        Carta c = carta(1L, "Menú", "1");
        CartaDet item = detalle(c, 200L);
        item.setPrecio(new BigDecimal("-5"));
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(articuloRepository.existsByIdAndFlagEstado(200L, "1")).thenReturn(true);
        when(detalleRepository.existsByCartaIdAndArticuloIdAndActivo(1L, 200L)).thenReturn(false);
        assertThrows(BusinessException.class, () -> service.addItem(1L, item));
    }

    @Test
    void updateItem_precioNull() {
        Carta c = carta(1L, "Menú", "1");
        CartaDet existing = detalle(c, 100L);
        existing.setId(80L);
        CartaDet patch = detalle(c, 100L);
        patch.setPrecio(null);
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(detalleRepository.findById(80L)).thenReturn(Optional.of(existing));
        when(detalleRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        assertThat(service.updateItem(1L, 80L, patch).getPrecio()).isNull();
    }

    @Test
    void updateItem_precioNegativo_throws() {
        Carta c = carta(1L, "Menú", "1");
        CartaDet existing = detalle(c, 100L);
        existing.setId(81L);
        CartaDet patch = detalle(c, 100L);
        patch.setPrecio(new BigDecimal("-1"));
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(detalleRepository.findById(81L)).thenReturn(Optional.of(existing));
        assertThrows(BusinessException.class, () -> service.updateItem(1L, 81L, patch));
    }

    @Test
    void updateItem_itemNoPerteneceACarta_throws() {
        Carta c1 = carta(1L, "Menú", "1");
        CartaDet existing = detalle(c1, 100L);
        existing.setId(82L);
        CartaDet patch = detalle(c1, 100L);
        patch.setPrecio(new BigDecimal("10"));
        when(repository.findById(2L)).thenReturn(Optional.of(carta(2L, "Otra", "1")));
        when(detalleRepository.findById(82L)).thenReturn(Optional.of(existing));
        assertThrows(BusinessException.class, () -> service.updateItem(2L, 82L, patch));
    }

    @Test
    void deleteItem_itemNoPerteneceACarta_throws() {
        Carta c1 = carta(1L, "Menú", "1");
        CartaDet existing = detalle(c1, 100L);
        existing.setId(83L);
        when(repository.findById(2L)).thenReturn(Optional.of(carta(2L, "Otra", "1")));
        when(detalleRepository.findById(83L)).thenReturn(Optional.of(existing));
        assertThrows(BusinessException.class, () -> service.deleteItem(2L, 83L));
    }

    @Test
    void updateItemFields_soloOrdenSinPrecio() {
        Carta c = carta(1L, "Menú", "1");
        CartaDet existing = detalle(c, 100L);
        existing.setId(90L);
        when(detalleRepository.findById(90L)).thenReturn(Optional.of(existing));
        when(detalleRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        CartaDet result = service.updateItemFields(1L, 90L, null, 5);
        assertThat(result.getOrden()).isEqualTo(5);
        assertThat(result.getPrecio()).isEqualByComparingTo("10.00");
    }

    @Test
    void updateItemFields_precioNegativo_throws() {
        Carta c = carta(1L, "Menú", "1");
        CartaDet existing = detalle(c, 100L);
        existing.setId(91L);
        when(detalleRepository.findById(91L)).thenReturn(Optional.of(existing));
        assertThrows(BusinessException.class, () -> service.updateItemFields(1L, 91L, new BigDecimal("-1"), null));
    }

    @Test
    void updateItemFields_itemNoPerteneceACarta_throws() {
        Carta c1 = carta(1L, "Menú", "1");
        CartaDet existing = detalle(c1, 100L);
        existing.setId(92L);
        when(detalleRepository.findById(92L)).thenReturn(Optional.of(existing));
        assertThrows(BusinessException.class, () -> service.updateItemFields(2L, 92L, new BigDecimal("10"), null));
    }

    private static Carta carta(Long id, String nombre, String flag) {
        Carta c = new Carta();
        c.setId(id);
        c.setSucursalId(1L);
        c.setNombre(nombre);
        c.setDescripcion("Desc");
        if (flag != null) {
            c.setFlagEstado(flag);
        }
        return c;
    }

    private static CartaDet detalle(Carta carta, Long articuloId) {
        CartaDet det = new CartaDet();
        det.setCarta(carta);
        CartaDet.Articulo art = new CartaDet.Articulo();
        art.setId(articuloId);
        det.setArticulo(art);
        det.setPrecio(new BigDecimal("10.00"));
        det.setOrden(1);
        return det;
    }
}
