package com.sigre.produccion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.produccion.entity.OtAdminUder;
import com.sigre.produccion.entity.OtAdministracion;

import java.util.List;

public interface OtAdministracionService {

    Page<OtAdministracion> findAll(String codigo, String nombre, String flagTipoCosto, String flagEstado,
                                   Pageable pageable);

    OtAdministracion findById(Long id);

    OtAdministracion create(OtAdministracion entity);

    OtAdministracion update(Long id, OtAdministracion entity);

    OtAdministracion activate(Long id);

    OtAdministracion deactivate(Long id);

    void delete(Long id);

    List<OtAdminUder> findUsuarios(Long otAdministracionId);

    OtAdminUder asignarUsuario(Long otAdministracionId, Long usuarioId);

    void desasignarUsuario(Long otAdministracionId, Long usuarioId);
}
