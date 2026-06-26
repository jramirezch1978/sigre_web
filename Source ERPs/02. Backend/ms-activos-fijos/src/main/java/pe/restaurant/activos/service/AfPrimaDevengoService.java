package pe.restaurant.activos.service;

import pe.restaurant.activos.entity.AfPrimaDevengo;

import java.util.List;

public interface AfPrimaDevengoService {

    AfPrimaDevengo registrarDevengoMensual(Long polizaSeguroId, Integer anio, Integer mes);

    List<AfPrimaDevengo> listByPoliza(Long polizaSeguroId);

    List<AfPrimaDevengo> registrarDevengoMasivo(Integer anio, Integer mes);
}
