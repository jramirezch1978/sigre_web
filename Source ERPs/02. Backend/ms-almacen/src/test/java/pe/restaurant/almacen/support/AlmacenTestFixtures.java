package pe.restaurant.almacen.support;

import pe.restaurant.almacen.dto.AlmacenRequest;
import pe.restaurant.almacen.testdata.AlmacenTestDataFactory;

/**
 * Rol C — cuerpos en RAM para IT/unitarios. Persistencia: {@link AlmacenTestDataFactory} (rol B).
 */
public final class AlmacenTestFixtures {

    private AlmacenTestFixtures() {}

    public static AlmacenRequest almacenRequestNuevo(String codigo, Long sucursalId, Long tipoId) {
        AlmacenRequest r = new AlmacenRequest();
        r.setCodigo(codigo);
        r.setNombre("Almacén IT " + codigo);
        r.setSucursalId(sucursalId);
        r.setAlmacenTipoId(tipoId);
        return r;
    }

    public static AlmacenRequest almacenRequestInvalido() {
        AlmacenRequest r = new AlmacenRequest();
        r.setCodigo("");
        r.setNombre("");
        return r;
    }

    public static String codigoAlmacenItUnico() {
        return "AL-IT-" + (System.nanoTime() % 1_000_000L);
    }
}
