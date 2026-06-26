package pe.restaurant.almacen.support;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.almacen.dto.AlmacenTipoResponse;
import pe.restaurant.almacen.dto.UsuarioResumenDto;

import java.util.Map;

import static org.mockito.ArgumentMatchers.anySet;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AlmacenTipoResponseEnricherTest {

    @Mock
    private UsuarioResumenLoader usuarioResumenLoader;
    @InjectMocks
    private AlmacenTipoResponseEnricher enricher;

    @Test
    void enrich_nullSafe() {
        enricher.enrich(null);
    }

    @Test
    void enrich_cargaUsuarios() {
        AlmacenTipoResponse dto = new AlmacenTipoResponse();
        dto.setId(1L);
        dto.setCreatedBy(10L);
        dto.setUpdatedBy(11L);
        when(usuarioResumenLoader.loadByIds(anySet()))
                .thenReturn(Map.of(10L, UsuarioResumenDto.builder().id(10L).nombreCompleto("A").build()));

        enricher.enrich(dto);

        verify(usuarioResumenLoader).loadByIds(anySet());
    }
}
