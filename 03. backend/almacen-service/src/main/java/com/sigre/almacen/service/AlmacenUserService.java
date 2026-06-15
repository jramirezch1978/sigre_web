package com.sigre.almacen.service;

import com.sigre.almacen.entity.AlmacenUser;

import java.util.List;

/**
 * Asignación de {@link com.sigre.almacen.entity.Almacen} ↔ usuario (tabla {@code almacen.almacen_user}).
 */
public interface AlmacenUserService {

    List<AlmacenUser> listarPorAlmacenId(Long almacenId);

    /**
     * Lista asignaciones; {@code flagEstado} y {@code usuarioId} son filtros opcionales (contrato GET usuarios por almacén).
     */
    List<AlmacenUser> listarPorAlmacenId(Long almacenId, String flagEstado, Long usuarioId);

    AlmacenUser asignar(Long almacenId, Long usuarioId);

    /** Baja lógica: {@code flag_estado = '0'} y auditoría actualizada. */
    AlmacenUser desasignar(Long almacenId, Long usuarioId);
}
