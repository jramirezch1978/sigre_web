package pe.restaurant.activos.support;

import pe.restaurant.activos.dto.AfClaseRequest;
import pe.restaurant.activos.dto.AfMaestroRequest;
import pe.restaurant.activos.testdata.ActivosTestDataFactory;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Rol C — cuerpos y valores en RAM para IT/ unitarios (sin JDBC).
 * Persistencia y FKs reales: {@link ActivosTestDataFactory} (rol B).
 */
public final class ActivosTestFixtures {

    private ActivosTestFixtures() {}

    public static AfMaestroRequest maestroRequestValido(
            String codigo,
            Long subClaseId,
            Long ubicacionId,
            Long proveedorId) {
        AfMaestroRequest r = new AfMaestroRequest();
        r.setCodigo(codigo);
        r.setNombre("Activo IT " + codigo);
        r.setAfSubClaseId(subClaseId);
        r.setAfUbicacionId(ubicacionId);
        r.setProveedorId(proveedorId);
        r.setFechaAdquisicion(LocalDate.of(2024, 6, 1));
        r.setValorAdquisicion(new BigDecimal("15000.0000"));
        r.setValorResidual(new BigDecimal("1500.0000"));
        return r;
    }

    public static AfMaestroRequest maestroRequestInvalidoSinCodigo(Long subClaseId) {
        AfMaestroRequest r = new AfMaestroRequest();
        r.setCodigo("");
        r.setNombre("Sin código");
        r.setAfSubClaseId(subClaseId);
        r.setFechaAdquisicion(LocalDate.of(2024, 1, 1));
        r.setValorAdquisicion(new BigDecimal("100.0000"));
        r.setValorResidual(BigDecimal.ZERO);
        return r;
    }

    public static AfClaseRequest claseRequestNueva(String codigo) {
        AfClaseRequest r = new AfClaseRequest();
        r.setCodigo(codigo);
        r.setNombre("Clase IT " + codigo);
        r.setMetodoDepreciacion("LINEAL");
        r.setVidaUtilMeses(60);
        return r;
    }

    public static String codigoMaestroItUnico() {
        return "FACTORY-AF-IT-" + System.nanoTime();
    }

    public static String codigoClaseItUnico() {
        return "AF-IT-C" + (System.nanoTime() % 1_000_000L);
    }
}
