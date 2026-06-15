package com.sigre.almacen.support;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.almacen.dto.AlmacenUsuarioResponse;
import com.sigre.almacen.dto.UsuarioResumenDto;
import com.sigre.almacen.entity.AlmacenUser;

import java.time.OffsetDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anySet;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AlmacenUsuarioResponseAssemblerTest {

    @Mock
    private UsuarioResumenLoader usuarioResumenLoader;
    @InjectMocks
    private AlmacenUsuarioResponseAssembler assembler;

    @Test
    void toResponse_null() {
        assertThat(assembler.toResponse(null)).isNull();
    }

    @Test
    void toResponse_enriqueceUsuarios() {
        AlmacenUser user = new AlmacenUser();
        user.setId(1L);
        user.setAlmacenId(10L);
        user.setUsuarioId(100L);
        user.setCreatedBy(101L);
        user.setUpdatedBy(102L);
        user.setFlagEstado("1");
        user.setFecCreacion(OffsetDateTime.now());
        user.setFecModificacion(OffsetDateTime.now());

        UsuarioResumenDto resumen = UsuarioResumenDto.builder()
                .id(100L)
                .numeroDocumento("jdoe")
                .nombreCompleto("John Doe")
                .build();
        when(usuarioResumenLoader.loadByIds(anySet())).thenReturn(Map.of(100L, resumen));

        AlmacenUsuarioResponse resp = assembler.toResponse(user);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getUsuario()).isNotNull();
        assertThat(resp.getUsuario().getId()).isEqualTo(100L);
    }

    @Test
    void toResponseList_vacio() {
        assertThat(assembler.toResponseList(null)).isEmpty();
        assertThat(assembler.toResponseList(Collections.emptyList())).isEmpty();
    }

    @Test
    void toResponseList_multiples() {
        AlmacenUser u1 = new AlmacenUser();
        u1.setId(1L);
        u1.setAlmacenId(10L);
        u1.setUsuarioId(5L);
        when(usuarioResumenLoader.loadByIds(anySet())).thenReturn(Collections.emptyMap());

        List<AlmacenUsuarioResponse> list = assembler.toResponseList(List.of(u1));

        assertThat(list).hasSize(1);
        assertThat(list.get(0).getAlmacenId()).isEqualTo(10L);
    }
}
