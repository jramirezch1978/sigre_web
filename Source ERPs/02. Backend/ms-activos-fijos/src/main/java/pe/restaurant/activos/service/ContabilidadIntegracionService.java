package pe.restaurant.activos.service;

import pe.restaurant.activos.dto.IntegracionContabilidadResult;

public interface ContabilidadIntegracionService {

    IntegracionContabilidadResult contabilizarDepreciacion(Long calculoId);

    IntegracionContabilidadResult contabilizarDevengoPrima(Long devengoId);

    IntegracionContabilidadResult contabilizarVenta(Long ventaId);

    IntegracionContabilidadResult contabilizarValuacion(Long valuacionId);

    IntegracionContabilidadResult contabilizarAltaActivo(Long maestroId);

    IntegracionContabilidadResult contabilizarAdaptacion(Long adaptacionId);

    IntegracionContabilidadResult contabilizarBajaActivo(Long maestroId);

    IntegracionContabilidadResult consultarTrazabilidad(String moduloOrigen, Long documentoOrigenId);
}
