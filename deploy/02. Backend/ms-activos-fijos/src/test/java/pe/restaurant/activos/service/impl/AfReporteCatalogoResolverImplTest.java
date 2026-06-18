package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.activos.config.IntegracionProperties;
import pe.restaurant.activos.entity.AfClase;
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.entity.AfUbicacion;
import pe.restaurant.activos.repository.AfClaseRepository;
import pe.restaurant.activos.repository.AfSubClaseRepository;
import pe.restaurant.activos.repository.AfUbicacionRepository;

import java.util.Arrays;
import java.util.Collections;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AfReporteCatalogoResolverImplTest {

    @Mock
    private AfSubClaseRepository subClaseRepository;
    @Mock
    private AfClaseRepository claseRepository;
    @Mock
    private AfUbicacionRepository ubicacionRepository;
    @Mock
    private JdbcTemplate jdbcTemplate;
    @Mock
    private IntegracionProperties integracionProperties;

    @InjectMocks
    private AfReporteCatalogoResolverImpl resolver;

    private IntegracionProperties.Contabilidad contabilidadCfg;

    @BeforeEach
    void setUp() {
        contabilidadCfg = new IntegracionProperties.Contabilidad();
        lenient().when(integracionProperties.getContabilidad()).thenReturn(contabilidadCfg);
    }

    // ------------------------------------------------------------ subClase
    @Test
    void subClase_returnsEmptyWhenIdNull() {
        assertThat(resolver.subClase(null)).isEmpty();
        verify(subClaseRepository, never()).findById(any());
    }

    @Test
    void subClase_delegatesToRepository() {
        AfSubClase sc = new AfSubClase();
        sc.setCodigo("S1");
        when(subClaseRepository.findById(10L)).thenReturn(Optional.of(sc));

        Optional<AfSubClase> result = resolver.subClase(10L);
        assertThat(result).containsSame(sc);
    }

    @Test
    void subClase_returnsEmptyWhenRepoEmpty() {
        when(subClaseRepository.findById(99L)).thenReturn(Optional.empty());
        assertThat(resolver.subClase(99L)).isEmpty();
    }

    // ------------------------------------------------------------ clase
    @Test
    void clase_returnsEmptyWhenIdNull() {
        assertThat(resolver.clase(null)).isEmpty();
        verify(claseRepository, never()).findById(any());
    }

    @Test
    void clase_delegatesToRepository() {
        AfClase c = new AfClase();
        c.setCodigo("C1");
        when(claseRepository.findById(7L)).thenReturn(Optional.of(c));

        assertThat(resolver.clase(7L)).containsSame(c);
    }

    // ------------------------------------------------------------ ubicacion
    @Test
    void ubicacion_returnsEmptyWhenIdNull() {
        assertThat(resolver.ubicacion(null)).isEmpty();
        verify(ubicacionRepository, never()).findById(any());
    }

    @Test
    void ubicacion_delegatesToRepository() {
        AfUbicacion u = new AfUbicacion();
        u.setCodigo("U1");
        when(ubicacionRepository.findById(33L)).thenReturn(Optional.of(u));

        assertThat(resolver.ubicacion(33L)).containsSame(u);
    }

    // ------------------------------------------------------------ centroCostoEtiqueta
    @Test
    void centroCostoEtiqueta_returnsEmptyWhenIdNull() {
        assertThat(resolver.centroCostoEtiqueta(null)).isEmpty();
    }

    @Test
    void centroCostoEtiqueta_returnsLabelFromJdbc() {
        when(jdbcTemplate.queryForObject(anyString(), eq(String.class), eq(5L)))
                .thenReturn("CC01 — Administración");

        String etiqueta = resolver.centroCostoEtiqueta(5L);
        assertThat(etiqueta).isEqualTo("CC01 — Administración");
    }

    @Test
    void centroCostoEtiqueta_returnsIdAsStringWhenJdbcFails() {
        when(jdbcTemplate.queryForObject(anyString(), eq(String.class), eq(99L)))
                .thenThrow(new EmptyResultDataAccessException(1));

        String etiqueta = resolver.centroCostoEtiqueta(99L);
        assertThat(etiqueta).isEqualTo("99");
    }

    // ------------------------------------------------------------ monedaDefecto
    @Test
    void monedaDefecto_returnsPENWhenMonedaIdNull() {
        contabilidadCfg.setMonedaId(null);
        assertThat(resolver.monedaDefecto()).isEqualTo("PEN");
    }

    @Test
    void monedaDefecto_returnsValueFromJdbc() {
        contabilidadCfg.setMonedaId(1L);
        when(jdbcTemplate.queryForObject(anyString(), eq(String.class), eq(1L)))
                .thenReturn("USD");

        assertThat(resolver.monedaDefecto()).isEqualTo("USD");
    }

    @Test
    void monedaDefecto_returnsPENWhenJdbcFails() {
        contabilidadCfg.setMonedaId(2L);
        when(jdbcTemplate.queryForObject(anyString(), eq(String.class), eq(2L)))
                .thenThrow(new RuntimeException("DB down"));

        assertThat(resolver.monedaDefecto()).isEqualTo("PEN");
    }

    // ------------------------------------------------------------ etiquetasCentroCosto
    @Test
    void etiquetasCentroCosto_emptyIterableReturnsEmptyMap() {
        Map<Long, String> result = resolver.etiquetasCentroCosto(Collections.emptyList());
        assertThat(result).isEmpty();
    }

    @Test
    void etiquetasCentroCosto_filtersNullsAndDeduplicates() {
        when(jdbcTemplate.queryForObject(anyString(), eq(String.class), eq(10L)))
                .thenReturn("CC10 — Cocina");
        when(jdbcTemplate.queryForObject(anyString(), eq(String.class), eq(20L)))
                .thenReturn("CC20 — Sala");

        Map<Long, String> result = resolver.etiquetasCentroCosto(Arrays.asList(10L, null, 20L, 10L));

        assertThat(result).hasSize(2)
                .containsEntry(10L, "CC10 — Cocina")
                .containsEntry(20L, "CC20 — Sala");
    }

    @Test
    void etiquetasCentroCosto_usesIdAsLabelWhenJdbcFails() {
        when(jdbcTemplate.queryForObject(anyString(), eq(String.class), eq(77L)))
                .thenThrow(new RuntimeException("boom"));

        Map<Long, String> result = resolver.etiquetasCentroCosto(Set.of(77L));

        assertThat(result).containsEntry(77L, "77");
    }
}
