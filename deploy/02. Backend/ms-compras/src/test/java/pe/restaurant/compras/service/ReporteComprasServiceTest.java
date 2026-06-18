package pe.restaurant.compras.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ReporteComprasService — Pruebas Unitarias")
class ReporteComprasServiceTest {

    @Mock private JdbcTemplate jdbcTemplate;
    @InjectMocks private ReporteComprasService service;

    @Test
    @DisplayName("gestionCompras llama al SP y remapea a camelCase con detalle vacío")
    void gestionComprasRemapeaCampos() {
        Map<String, Object> row = new HashMap<>();
        row.put("fecha_compra", LocalDate.of(2026, 1, 5));
        row.put("nro_orden", "OC-001");
        row.put("razon_social", "Proveedor SAC");
        row.put("cantidad", 10);
        lenient().when(jdbcTemplate.queryForList(anyString(), any(), any(), any()))
                .thenReturn(new ArrayList<>(List.of(row)));
        lenient().when(jdbcTemplate.queryForList(anyString(), any(Object[].class)))
                .thenReturn(new ArrayList<>(List.of(row)));

        List<Map<String, Object>> out = service.gestionCompras(null, null, null);

        assertThat(out).hasSize(1);
        Map<String, Object> r = out.get(0);
        assertThat(r).containsKeys("fechaCompra", "nroOrden", "razonSocial", "cantidad", "detalle");
        assertThat(r.get("nroOrden")).isEqualTo("OC-001");
        assertThat((List<?>) r.get("detalle")).isEmpty();
    }

    @Test
    @DisplayName("comprasTransito sin sucursal no agrega filtro ni parámetros")
    void comprasTransitoSinSucursal() {
        when(jdbcTemplate.queryForList(anyString(), any(Object[].class))).thenReturn(List.of());

        service.comprasTransito(null);

        ArgumentCaptor<String> sql = ArgumentCaptor.forClass(String.class);
        ArgumentCaptor<Object[]> args = ArgumentCaptor.forClass(Object[].class);
        verify(jdbcTemplate).queryForList(sql.capture(), args.capture());
        assertThat(sql.getValue()).doesNotContain("oc.sucursal_id = ?");
        assertThat(args.getValue()).isEmpty();
    }

    @Test
    @DisplayName("comprasTransito con sucursal agrega filtro y pasa el parámetro")
    void comprasTransitoConSucursal() {
        when(jdbcTemplate.queryForList(anyString(), any(Object[].class))).thenReturn(List.of());

        service.comprasTransito(7L);

        ArgumentCaptor<String> sql = ArgumentCaptor.forClass(String.class);
        ArgumentCaptor<Object[]> args = ArgumentCaptor.forClass(Object[].class);
        verify(jdbcTemplate).queryForList(sql.capture(), args.capture());
        assertThat(sql.getValue()).contains("oc.sucursal_id = ?");
        assertThat(args.getValue()).containsExactly(7L);
    }

    @Test
    @DisplayName("analisisProveedores agrega detalle vacío a cada fila")
    void analisisProveedoresDetalleVacio() {
        Map<String, Object> row = new HashMap<>();
        row.put("analisis_proveedor_razon_social", "Proveedor SAC");
        when(jdbcTemplate.queryForList(anyString(), any(Object[].class)))
                .thenReturn(new ArrayList<>(List.of(row)));

        List<Map<String, Object>> out = service.analisisProveedores(null);

        assertThat(out.get(0)).containsKey("analisis_proveedor_detalle");
        assertThat((List<?>) out.get(0).get("analisis_proveedor_detalle")).isEmpty();
    }
}
