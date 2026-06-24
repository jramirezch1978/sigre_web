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
import com.sigre.almacen.entity.SucursalRef;
import com.sigre.almacen.repository.AlmacenTipoRepository;
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
        AlmacenResponse dto = new AlmacenResponse();
        dto.setId(1L);
        dto.setSucursalId(10L);
        dto.setAlmacenTipoId(5L);
        dto.setCreatedBy(100L);
        dto.setUpdatedBy(101L);

        SucursalRef sucursal = org.mockito.Mockito.mock(SucursalRef.class);
        when(sucursal.getNombre()).thenReturn("Sucursal Lima");

        AlmacenTipo tipo = new AlmacenTipo();
        tipo.setId(5L);
        tipo.setNombre("Tipo Principal");

        UsuarioResumenDto u1 = UsuarioResumenDto.builder().id(100L).nombreCompleto("Creador").build();
        UsuarioResumenDto u2 = UsuarioResumenDto.builder().id(101L).nombreCompleto("Editor").build();
        when(usuarioResumenLoader.loadByIds(any(Set.class))).thenReturn(Map.of(100L, u1, 101L, u2));
        when(sucursalRefRepository.findById(10L)).thenReturn(Optional.of(sucursal));
        when(almacenTipoRepository.findById(5L)).thenReturn(Optional.of(tipo));

        enricher.enrich(entity, dto);

        assertThat(dto.getSucursalNombre()).isEqualTo("Sucursal Lima");
        assertThat(dto.getAlmacenTipoNombre()).isEqualTo("Tipo Principal");
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
