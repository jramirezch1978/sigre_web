package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.entity.Departamento;
import com.sigre.core.entity.Distrito;
import com.sigre.core.entity.Pais;
import com.sigre.core.entity.Provincia;

public interface GeografiaService {

    // Pais
    Page<Pais> findAllPaises(Pageable pageable);
    Pais findPaisById(Long id);
    Pais createPais(Pais entity);
    Pais updatePais(Long id, Pais entity);
    Pais activatePais(Long id);
    Pais deactivatePais(Long id);
    void deletePais(Long id);

    // Departamento
    Page<Departamento> findAllDepartamentos(Long paisId, Pageable pageable);
    Departamento findDepartamentoById(Long id);
    Departamento createDepartamento(Departamento entity);
    Departamento updateDepartamento(Long id, Departamento entity);
    Departamento activateDepartamento(Long id);
    Departamento deactivateDepartamento(Long id);
    void deleteDepartamento(Long id);

    // Provincia
    Page<Provincia> findAllProvincias(Long departamentoId, Pageable pageable);
    Provincia findProvinciaById(Long id);
    Provincia createProvincia(Provincia entity);
    Provincia updateProvincia(Long id, Provincia entity);
    Provincia activateProvincia(Long id);
    Provincia deactivateProvincia(Long id);
    void deleteProvincia(Long id);

    // Distrito
    Page<Distrito> findAllDistritos(Long provinciaId, Pageable pageable);
    Distrito findDistritoById(Long id);
    Distrito createDistrito(Distrito entity);
    Distrito updateDistrito(Long id, Distrito entity);
    Distrito activateDistrito(Long id);
    Distrito deactivateDistrito(Long id);
    void deleteDistrito(Long id);
}
