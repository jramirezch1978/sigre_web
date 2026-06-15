package com.sigre.almacen.service;

import java.math.BigDecimal;

/**
 * Validación OC ↔ factura ↔ conteo físico (HU-ALM-OP-TRA-001 / auditoría ERP).
 */
public interface RecepcionTresViasValidator {

    void validarRecepcionOc(Long ordenCompraId, Long almacenId, Long inventarioConteoId, BigDecimal tolerancia);
}
