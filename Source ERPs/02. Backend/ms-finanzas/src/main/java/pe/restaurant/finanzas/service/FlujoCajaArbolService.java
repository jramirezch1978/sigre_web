package pe.restaurant.finanzas.service;

import pe.restaurant.finanzas.dto.FlujoCajaNodo;
import java.util.List;

public interface FlujoCajaArbolService {

    List<FlujoCajaNodo> obtenerArbol();

    List<FlujoCajaNodo> guardarArbol(List<FlujoCajaNodo> arbol);
}
