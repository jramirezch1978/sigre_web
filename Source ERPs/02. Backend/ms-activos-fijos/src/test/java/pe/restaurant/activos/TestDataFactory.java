package pe.restaurant.activos;

import pe.restaurant.activos.client.dto.contabilidad.AsientoResponse;
import pe.restaurant.activos.dto.IntegracionContabilidadResult;
import pe.restaurant.activos.entity.AfAdaptacion;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.entity.AfClase;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfMatrizSubClase;
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.entity.AfTraslado;
import pe.restaurant.activos.entity.AfUbicacion;
import pe.restaurant.activos.integracion.AfIntegracionContableModulo;
import pe.restaurant.activos.testdata.ActivosTestDataFactory;

import java.math.BigDecimal;
import java.time.LocalDate;
/**
 * Fábrica estática de objetos de prueba para ms-activos-fijos (patrón ms-almacén / ms-compras).
 * Solo memoria — para unitarios Mockito. Persistencia JDBC: {@link ActivosTestDataFactory}.
 * Cuerpos HTTP en IT: {@link pe.restaurant.activos.support.ActivosTestFixtures}.
 */
public final class TestDataFactory {

    public static final String CODIGO_MAESTRO = ActivosTestDataFactory.CODIGO_MAESTRO;
    public static final String CODIGO_CLASE = ActivosTestDataFactory.CODIGO_CLASE;

    private TestDataFactory() {}

    public static AfClase afClase(Long id, String codigo) {
        AfClase c = new AfClase();
        c.setCodigo(codigo);
        c.setNombre("Clase " + codigo);
        return c;
    }

    public static AfSubClase afSubClase(Long id, Long claseId, String codigo) {
        AfSubClase s = new AfSubClase();
        s.setAfClaseId(claseId);
        s.setCodigo(codigo);
        s.setNombre("Subclase " + codigo);
        return s;
    }

    public static AfUbicacion afUbicacion(Long sucursalId, String codigo) {
        AfUbicacion u = new AfUbicacion();
        u.setSucursalId(sucursalId);
        u.setCodigo(codigo);
        u.setNombre("Ubicación " + codigo);
        return u;
    }

    public static AfMaestro afMaestro(Long id) {
        return afMaestro(id, CODIGO_MAESTRO, 2L);
    }

    public static AfMaestro afMaestro(Long id, String codigo, Long subClaseId) {
        AfMaestro m = new AfMaestro();
        m.setId(id);
        m.setCodigo(codigo);
        m.setAfSubClaseId(subClaseId);
        m.setValorAdquisicion(new BigDecimal("50000.0000"));
        m.setFechaAdquisicion(LocalDate.of(2024, 1, 10));
        m.setFlagEstado("0");
        return m;
    }

    public static AfMatrizSubClase afMatrizSubClaseCompleta() {
        AfMatrizSubClase m = new AfMatrizSubClase();
        m.setAfSubClaseId(2L);
        m.setCuentaGastoDepId(100L);
        m.setCuentaDepAcumId(101L);
        m.setCuentaActivoId(102L);
        m.setCuentaBajaId(103L);
        m.setCuentaResVentaId(104L);
        m.setCentroCostoId(5L);
        m.setCuentaProveedorTransitoriaId(105L);
        m.setCuentaCapitalizacionId(106L);
        return m;
    }

    public static AfCalculoCntbl afCalculoDepreciacion(Long id, Long maestroId) {
        AfCalculoCntbl c = new AfCalculoCntbl();
        c.setId(id);
        c.setAfMaestroId(maestroId);
        c.setAnio(2026);
        c.setMes(4);
        c.setDepreciacionPeriodo(new BigDecimal("100.0000"));
        return c;
    }

    public static AfAdaptacion afAdaptacionCapitalizada(Long id, Long maestroId) {
        AfAdaptacion a = new AfAdaptacion();
        a.setId(id);
        a.setAfMaestroId(maestroId);
        a.setMontoTotal(new BigDecimal("5000.0000"));
        a.setFecha(LocalDate.of(2026, 3, 1));
        return a;
    }

    public static AfTraslado afTrasladoEjecutado(Long id, Long maestroId) {
        AfTraslado t = new AfTraslado();
        t.setId(id);
        t.setAfMaestroId(maestroId);
        t.setFechaSolicitud(LocalDate.of(2026, 1, 1));
        return t;
    }

    public static AsientoResponse asientoResponse(Long id) {
        AsientoResponse r = new AsientoResponse();
        r.setId(id);
        r.setGlosa("Asiento test " + id);
        return r;
    }

    public static AsientoResponse asientoResponse(Long id, String modulo, Long docId) {
        AsientoResponse r = asientoResponse(id);
        r.setModuloOrigen(modulo);
        r.setDocumentoOrigenId(docId);
        return r;
    }

    public static IntegracionContabilidadResult integracionResultNuevo(Long asientoId, String modulo, Long docId) {
        return IntegracionContabilidadResult.builder()
                .asientoId(asientoId)
                .moduloOrigen(modulo)
                .documentoOrigenId(docId)
                .correlacion("corr-test")
                .yaExistia(false)
                .build();
    }

    public static IntegracionContabilidadResult integracionResultExistente(Long asientoId, String modulo, Long docId) {
        return IntegracionContabilidadResult.builder()
                .asientoId(asientoId)
                .moduloOrigen(modulo)
                .documentoOrigenId(docId)
                .yaExistia(true)
                .build();
    }
}
