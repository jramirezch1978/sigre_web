package com.sigre.almacen.support;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import com.sigre.almacen.dto.UsuarioResumenDto;

import java.util.Map;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UsuarioResumenLoaderTest {

    @Mock private JdbcTemplate jdbcTemplate;
    @InjectMocks private UsuarioResumenLoader loader;

    @Test
    void loadByIds_vacioRetornaMapaVacio() {
        assertThat(loader.loadByIds(null)).isEmpty();
        assertThat(loader.loadByIds(Set.of())).isEmpty();
    }

    @Test
    void loadByIds_retornaUsuarios() {
        UsuarioResumenDto dto = UsuarioResumenDto.builder()
                .id(5L)
                .nombreCompleto("Ana Test")
                .numeroDocumento("ana@test")
                .build();
        when(jdbcTemplate.query(anyString(), any(Object[].class), any(RowMapper.class)))
                .thenReturn(java.util.List.of(dto));

        Map<Long, UsuarioResumenDto> map = loader.loadByIds(Set.of(5L));

        assertThat(map).containsKey(5L);
        assertThat(map.get(5L).getNombreCompleto()).isEqualTo("Ana Test");
    }

    @Test
    void loadOne_yHelpers() {
        assertThat(loader.loadOne(null)).isNull();
        assertThat(UsuarioResumenLoader.fromMap(Map.of(), 1L)).isNull();

        UsuarioResumenDto dto = UsuarioResumenDto.builder().id(9L).nombreCompleto("X").build();
        assertThat(UsuarioResumenLoader.fromMap(Map.of(9L, dto), 9L).getNombreCompleto()).isEqualTo("X");

        Set<Long> ids = new java.util.HashSet<>();
        UsuarioResumenLoader.addId(ids, null);
        UsuarioResumenLoader.addId(ids, 3L);
        assertThat(ids).containsExactly(3L);
    }
}
