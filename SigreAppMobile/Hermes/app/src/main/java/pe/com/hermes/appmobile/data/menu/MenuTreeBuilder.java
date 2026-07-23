package pe.com.hermes.appmobile.data.menu;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import pe.com.hermes.appmobile.data.remote.dto.MiMenuItemDto;
import pe.com.hermes.appmobile.data.remote.dto.MiMenuResponse;
import pe.com.hermes.appmobile.data.remote.dto.OpcionMenuDto;

/**
 * Transforma {@code GET /auth/seguridad/mi-menu} al árbol de módulos del ERP web.
 * <ul>
 *   <li>No incluye opciones desactivadas ({@code activo = false}).</li>
 *   <li>No incluye hojas sin {@code pathUrl} ni {@code rutaFrontend}.</li>
 *   <li>Poda secciones/módulos que queden vacíos tras el filtro.</li>
 * </ul>
 */
public final class MenuTreeBuilder {

    private static final Map<String, String> PREFIJO_A_MODULO = Map.ofEntries(
            Map.entry("ALMACEN", "ALMACEN"),
            Map.entry("COMPRAS", "COMPRAS"),
            Map.entry("APROV", "APROVISIONAMIENTO"),
            Map.entry("COMERC", "COMERCIALIZACION"),
            Map.entry("FINANZAS", "FINANZAS"),
            Map.entry("CONTABILIDAD", "CONTABILIDAD"),
            Map.entry("ACTIVOS", "ACTIVOS_FIJOS"),
            Map.entry("RRHH", "RRHH"),
            Map.entry("PRODUCCION", "PRODUCCION"),
            Map.entry("PRESUP", "PRESUPUESTO"),
            Map.entry("FLOTA", "FLOTA"),
            Map.entry("MANT", "MANTENIMIENTO"),
            Map.entry("AUDIT", "AUDITORIA"),
            Map.entry("CAMPO", "CAMPO"),
            Map.entry("COMEDOR", "COMEDOR"),
            Map.entry("SIG", "SIG"),
            Map.entry("OPER", "OPERACIONES"),
            Map.entry("HORECA", "HORECA"),
            Map.entry("SEGURIDAD", "SEGURIDAD")
    );

    private MenuTreeBuilder() {
    }

    public static List<MenuNodo> fromMiMenu(MiMenuResponse data) {
        if (data == null || data.items == null) {
            return List.of();
        }

        Map<Long, List<MiMenuItemDto>> hijosPorPadre = new HashMap<>();
        for (MiMenuItemDto item : data.items) {
            if (item == null || item.opcionMenu == null) continue;
            if (!esActivo(item.opcionMenu)) continue;
            Long pid = item.opcionMenu.opcionPadreId;
            hijosPorPadre.computeIfAbsent(pid, k -> new ArrayList<>()).add(item);
        }

        List<MiMenuItemDto> raices = new ArrayList<>(hijosPorPadre.getOrDefault(null, List.of()));
        raices.sort(Comparator.comparingInt(a -> a.opcionMenu.orden != null ? a.opcionMenu.orden : 0));

        Map<Long, List<MenuNodo>> seccionesPorModulo = new LinkedHashMap<>();
        Map<Long, String> codigoModuloPorId = new HashMap<>();

        for (MiMenuItemDto sec : raices) {
            OpcionMenuDto om = sec.opcionMenu;
            List<MenuNodo> hijos = construirHijos(om.id, hijosPorPadre);
            // Sección sin hijos navegables y sin path propio → no pintar
            if (hijos.isEmpty() && !tienePath(om)) {
                continue;
            }
            MenuNodo seccion = new MenuNodo(MenuNodo.Tipo.SECCION, om.id, om.codigo, om.nombre, resolverPath(om));
            seccion.hijos.addAll(hijos);
            seccionesPorModulo.computeIfAbsent(om.moduloId, k -> new ArrayList<>()).add(seccion);
            codigoModuloPorId.putIfAbsent(om.moduloId, codigoModuloDesdeSeccion(om.codigo));
        }

        List<MenuNodo> modulos = new ArrayList<>();
        for (Map.Entry<Long, List<MenuNodo>> e : seccionesPorModulo.entrySet()) {
            String cod = codigoModuloPorId.getOrDefault(e.getKey(), "");
            if (!esModuloHermes(cod)) {
                continue;
            }
            List<MenuNodo> secciones = e.getValue();
            if (secciones.isEmpty()) {
                continue;
            }
            MenuNodo mod = new MenuNodo(MenuNodo.Tipo.MODULO, e.getKey(), cod, nombreModulo(cod), null);
            mod.hijos.addAll(secciones);
            modulos.add(mod);
        }
        modulos.sort(Comparator.comparingLong(m -> m.id));
        return modulos;
    }

    private static boolean esActivo(OpcionMenuDto om) {
        // null = activo (misma convención que web: solo se omiten activo === false)
        return om.activo == null || Boolean.TRUE.equals(om.activo);
    }

    private static boolean tienePath(OpcionMenuDto om) {
        return (om.pathUrl != null && !om.pathUrl.isBlank())
                || (om.rutaFrontend != null && !om.rutaFrontend.isBlank());
    }

    /** Preferir pathUrl; si falta, rutaFrontend. */
    private static String resolverPath(OpcionMenuDto om) {
        if (om.pathUrl != null && !om.pathUrl.isBlank()) {
            return om.pathUrl.trim();
        }
        if (om.rutaFrontend != null && !om.rutaFrontend.isBlank()) {
            return om.rutaFrontend.trim();
        }
        return null;
    }

    private static boolean esModuloHermes(String codigoModulo) {
        if (codigoModulo == null) {
            return false;
        }
        String c = codigoModulo.trim().toUpperCase();
        return "ALMACEN".equals(c) || "COMPRAS".equals(c);
    }

    private static List<MenuNodo> construirHijos(long padreId, Map<Long, List<MiMenuItemDto>> hijosPorPadre) {
        List<MiMenuItemDto> hijos = new ArrayList<>(hijosPorPadre.getOrDefault(padreId, List.of()));
        hijos.sort(Comparator.comparingInt(a -> a.opcionMenu.orden != null ? a.opcionMenu.orden : 0));
        List<MenuNodo> out = new ArrayList<>();
        for (MiMenuItemDto h : hijos) {
            OpcionMenuDto om = h.opcionMenu;
            if (!esActivo(om)) {
                continue;
            }
            List<MenuNodo> nietos = construirHijos(om.id, hijosPorPadre);
            String path = resolverPath(om);
            // Hoja sin path → no cargar (aunque exista en seed)
            if (nietos.isEmpty() && (path == null || path.isBlank())) {
                continue;
            }
            MenuNodo n = new MenuNodo(MenuNodo.Tipo.OPCION, om.id, om.codigo, om.nombre, path);
            n.hijos.addAll(nietos);
            out.add(n);
        }
        return out;
    }

    private static String codigoModuloDesdeSeccion(String codigoSeccion) {
        if (codigoSeccion == null || codigoSeccion.isBlank()) return "";
        String prefijo = codigoSeccion.split("_")[0].toUpperCase();
        return PREFIJO_A_MODULO.getOrDefault(prefijo, prefijo);
    }

    private static String nombreModulo(String codigo) {
        return switch (codigo) {
            case "ALMACEN" -> "Almacén";
            case "COMPRAS" -> "Compras";
            case "APROVISIONAMIENTO" -> "Aprovisionamiento";
            case "COMERCIALIZACION", "VENTAS" -> "Comercialización";
            case "FINANZAS" -> "Finanzas";
            case "CONTABILIDAD" -> "Contabilidad";
            case "ACTIVOS", "ACTIVOS_FIJOS" -> "Activos Fijos";
            case "RRHH" -> "RR.HH.";
            case "PRODUCCION" -> "Producción";
            case "PRESUPUESTO" -> "Presupuesto";
            case "FLOTA" -> "Flota";
            case "MANTENIMIENTO" -> "Mantenimiento";
            case "AUDITORIA" -> "Auditoría";
            case "CAMPO" -> "Campo";
            case "COMEDOR" -> "Comedor";
            case "SEGURIDAD" -> "Configuración";
            default -> codigo.isEmpty() ? "Módulo" : codigo;
        };
    }
}
