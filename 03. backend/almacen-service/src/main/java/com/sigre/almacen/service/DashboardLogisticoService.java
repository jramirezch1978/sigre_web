package com.sigre.almacen.service;

import com.sigre.almacen.dto.DashboardLogisticoResponse;
import com.sigre.almacen.dto.DiagnosticoAlmacenResponse;

import java.util.List;

public interface DashboardLogisticoService {

    /**
     * KPI logísticos de la sucursal (o todos si {@code sucursalId} es null).
     * Solo movimientos con {@code vale_mov.flag_estado = '1'} (activos).
     */
    DashboardLogisticoResponse resumen(Long sucursalId);
}
