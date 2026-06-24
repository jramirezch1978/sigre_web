package com.sigre.almacen.support;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.almacen.dto.AlmacenResponse;
import com.sigre.almacen.dto.UsuarioResumenDto;
import com.sigre.almacen.entity.Almacen;
import com.sigre.almacen.entity.AlmacenTipo;
import com.sigre.almacen.entity.CentrosCostoRef;
import com.sigre.almacen.entity.EntidadContribuyenteRef;
import com.sigre.almacen.entity.SucursalRef;
import com.sigre.almacen.repository.AlmacenTipoRepository;
import com.sigre.almacen.repository.CentrosCostoRefRepository;
import com.sigre.almacen.repository.EntidadContribuyenteRefRepository;
import com.sigre.almacen.repository.SucursalRefRepository;

import java.util.Map;
import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static com.sigre.almacen.TestDataFactory.almacen;

@ExtendWith(MockitoExtension.class)
class AlmacenResponseEnricherTest {

    @Mock private AlmacenTipoRepository almacenTipoRepository;
    @Mock private CentrosCostoRefRepository centrosCostoRefRepository;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private SucursalRefRepository sucursalRefRepository;
    @Mock private UsuarioResumenLoader usuarioResumenLoader;
    @InjectMocks private AlmacenResponseEnricher enricher;

    @Test
    void enrich_nullSafe() {
        enricher.enrich(null, null);
        enricher.enrich(almacen(1L), null);
    }

    @Test
    void enrich_completaNombresYUsuarios() {
        Almacen entity = almacen(1L);
        entity.setAlmacenTipoId(5L);
        entity.setCentrosCostoId(7L);
        entity.setProveedorEntidadId(9L);
        AlmacenResponse dto = new AlmacenResponse();
        dto.setId(1L);
        dto.setSucursalId(10L);
        dto.setAlmacenTipoId(5L);
        dto.setCentrosCostoId(7L);
        dto.setProveedorEntidadId(9L);
        dto.setCreatedBy(100L);
        dto.setUpdatedBy(101L);

        SucursalRef sucursal = org.mockito.Mockito.mock(SucursalRef.class);
        when(sucursal.getCodigo()).thenReturn("LM");
        when(sucursal.getNombre()).thenReturn("LIMA");

        AlmacenTipo tipo = new AlmacenTipo();
        tipo.setId(5L);
        tipo.setCodigo("MP");
        tipo.setNombre("MATERIA PRIMA");

        CentrosCostoRef cencos = org.mockito.Mockito.mock(CentrosCostoRef.class);
        when(cencos.getCencos()).thenReturn("CC001");
        when(cencos.getDescCencos()).thenReturn("Centro operaciones");

        EntidadContribuyenteRef proveedor = org.mockito.Mockito.mock(EntidadContribuyenteRef.class);
        when(proveedor.getNroDocumento()).thenReturn("20123456789");
        when(proveedor.getNombreCompleto()).thenReturn("Proveedor SAC");

        UsuarioResumenDto u1 = UsuarioResumenDto.builder().id(100L).nombreCompleto("Creador").build();
        UsuarioResumenDto u2 = UsuarioResumenDto.builder().id(101L).nombreCompleto("Editor").build();
        when(usuarioResumenLoader.loadByIds(any(Set.class))).thenReturn(Map.of(100L, u1, 101L, u2));
        when(sucursalRefRepository.findById(10L)).thenReturn(Optional.of(sucursal));
        when(almacenTipoRepository.findById(5L)).thenReturn(Optional.of(tipo));
        when(centrosCostoRefRepository.findById(7L)).thenReturn(Optional.of(cencos));
        when(entidadContribuyenteRefRepository.findById(9L)).thenReturn(Optional.of(proveedor));

        enricher.enrich(entity, dto);

        assertThat(dto.getSucursalCodigo()).isEqualTo("LM");
        assertThat(dto.getSucursalNombre()).isEqualTo("LM — LIMA");
        assertThat(dto.getAlmacenTipoCodigo()).isEqualTo("MP");
        assertThat(dto.getAlmacenTipoNombre()).isEqualTo("MP — MATERIA PRIMA");
        assertThat(dto.getCentrosCostoCodigo()).isEqualTo("CC001");
        assertThat(dto.getCentrosCostoNombre()).isEqualTo("CC001 — Centro operaciones");
        assertThat(dto.getProveedorDocumento()).isEqualTo("20123456789");
        assertThat(dto.getProveedorNombre()).isEqualTo("20123456789 — Proveedor SAC");
        assertThat(dto.getCreatedByUsuario().getNombreCompleto()).isEqualTo("Creador");
        assertThat(dto.getUpdatedByUsuario().getNombreCompleto()).isEqualTo("Editor");
    }

    @Test
    void enrich_sinAlmacenTipo_dejaNombreNull() {
        Almacen entity = almacen(2L);
        AlmacenResponse dto = new AlmacenResponse();
        dto.setId(2L);
        dto.setSucursalId(1L);
        when(usuarioResumenLoader.loadByIds(any())).thenReturn(Map.of());

        enricher.enrich(entity, dto);

        assertThat(dto.getAlmacenTipoNombre()).isNull();
    }
}
