package com.sigre.almacen.support;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import com.sigre.almacen.dto.AlmacenResponse;
import com.sigre.almacen.dto.UsuarioResumenDto;
import com.sigre.almacen.entity.Almacen;

import java.util.Map;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;
import static com.sigre.almacen.TestDataFactory.almacen;

@ExtendWith(MockitoExtension.class)
class AlmacenResponseEnricherTest {

    @Mock private JdbcTemplate jdbcTemplate;
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

        UsuarioResumenDto u1 = UsuarioResumenDto.builder().id(100L).nombreCompleto("Creador").build();
        UsuarioResumenDto u2 = UsuarioResumenDto.builder().id(101L).nombreCompleto("Editor").build();
        when(usuarioResumenLoader.loadByIds(any(Set.class))).thenReturn(Map.of(100L, u1, 101L, u2));
        when(jdbcTemplate.queryForObject(contains("auth.sucursal"), eq(String.class), eq(10L)))
                .thenReturn("Sucursal Lima");
        when(jdbcTemplate.queryForObject(contains("almacen_tipo"), eq(String.class), eq(5L)))
                .thenReturn("Tipo Principal");

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
