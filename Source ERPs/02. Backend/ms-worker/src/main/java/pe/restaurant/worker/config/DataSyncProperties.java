package pe.restaurant.worker.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Getter
@Setter
@Component
@ConfigurationProperties(prefix = "app.schema-sync.data-sync")
public class DataSyncProperties {

    private boolean enabled;
    private String tables;

    private static final String TABLE_AUTH_USUARIO = "auth.usuario";
    private static final String TABLE_DETRACCION_BIEN_SERV = "core.detr_bien_serv";
    private static final Map<String, String> UNIQUE_KEY_MAP = buildUniqueKeyMap();

    public List<String> getTableList() {
        if (tables == null || tables.isBlank()) {
            return Collections.emptyList();
        }
        // El orden de sincronizacion se toma exactamente desde config-server.
        Set<String> configuredTables = new LinkedHashSet<>(Arrays.stream(tables.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .toList());
        return Collections.unmodifiableList(new ArrayList<>(configuredTables));
    }

    /**
     * Devuelve la columna (o columnas separadas por coma) que sirven como
     * clave natural para el upsert (ON CONFLICT).
     */
    public String getUniqueKeyForTable(String qualifiedTable) {
        String key = UNIQUE_KEY_MAP.get(qualifiedTable.toLowerCase());
        return key != null ? key : "codigo";
    }

    private static Map<String, String> buildUniqueKeyMap() {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("core.articulo_categ", "cat_art");
        m.put("core.articulo_clase", "cod_clase");
        m.put("core.articulo_sub_categ", "cod_sub_cat");
        m.put("core.tipos_impuesto", "tipo_impuesto");
        m.put("core.calendario_feriado", "fecha");
        m.put("core.pais", "codigo");
        m.put("core.departamento", "pais_id,codigo");
        m.put("core.provincia", "departamento_id,codigo");
        m.put("core.distrito", "provincia_id,codigo");
        m.put("core.conversion_unidad", "unidad_origen_id,unidad_destino_id");
        m.put("core.forma_pago", "codigo");
        m.put("core.motivo_nota", "codigo");
        m.put("core.doc_tipo", "codigo");
        m.put("core.unidad_medida", "codigo");
        m.put("core.color", "codigo");
        m.put("auth.sucursal", "codigo");
        m.put("almacen.articulo_mov_tipo", "tipo_mov");
        m.put("almacen.motivo_traslado", "codigo");
        m.put("almacen.almacen_tipo", "codigo");
        m.put("almacen.almacen", "sucursal_id,codigo");
        m.put("almacen.almacen_tipo_mov", "almacen_id,articulo_mov_tipo_id");
        m.put("contabilidad.grupo_contable", "codigo");
        m.put("contabilidad.cntbl_libro", "codigo");
        m.put("contabilidad.grupo_matriz_cntbl", "codigo");
        m.put("contabilidad.matriz_cntbl_finan", "codigo");
        m.put("contabilidad.tipo_mov_matriz_subcat", "tipo_mov,grp_cntbl,cod_sub_cat,item");
        m.put("contabilidad.cencos_niv1", "cod_n1");
        m.put("contabilidad.cencos_niv2", "cod_n2");
        m.put("contabilidad.cencos_niv3", "cod_n3");
        m.put("contabilidad.centros_costo", "cencos");
        m.put("core.catalogo_sunat", "codigo_catalogo");
        m.put("core.catalogo_sunat_det", "catalogo_sunat_id,codigo_item");
        m.put("core.sunat_cubso", "cod_cubso");
        m.put(TABLE_AUTH_USUARIO, "id");
        m.put("auth.usuario_sucursal", "usuario_id,sucursal_id");
        m.put(TABLE_DETRACCION_BIEN_SERV, "bien_serv");
        m.put("core.moneda", "codigo");
        m.put("core.tipo_cambio", "moneda_id,fecha");
        m.put("rrhh.admin_afp", "nombre");
        return Collections.unmodifiableMap(m);
    }
}
