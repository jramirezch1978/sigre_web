package pe.restaurant.activos.service;

public interface AfHistorialRegistroService {

    void registrar(Long afMaestroId, String tipoEvento, String descripcion,
                   String valorAnterior, String valorNuevo, String modulo);
}
