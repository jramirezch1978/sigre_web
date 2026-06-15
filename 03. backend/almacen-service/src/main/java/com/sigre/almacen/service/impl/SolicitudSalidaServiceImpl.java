package com.sigre.almacen.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.dto.*;
import com.sigre.almacen.entity.Almacen;
import com.sigre.almacen.entity.SolSalida;
import com.sigre.almacen.entity.SolSalidaDet;
import com.sigre.almacen.repository.AlmacenRepository;
import com.sigre.almacen.repository.SolSalidaDetRepository;
import com.sigre.almacen.repository.SolSalidaRepository;
import com.sigre.almacen.service.SolicitudSalidaService;
import com.sigre.almacen.spec.SolSalidaSpecifications;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.service.NumeradorDocumentoService;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SolicitudSalidaServiceImpl implements SolicitudSalidaService {

    private static final String NOMBRE_TABLA_DOCUMENTO = "almacen.sol_salida";

    private final SolSalidaRepository solSalidaRepository;
    private final SolSalidaDetRepository solSalidaDetRepository;
    private final AlmacenRepository almacenRepository;
    private final NumeradorDocumentoService numeradorDocumentoService;
    private final JdbcTemplate jdbcTemplate;

    @Override
    public Page<SolSalidaResponse> buscar(Long almacenId, String estado, Pageable pageable) {
        return solSalidaRepository.findAll(SolSalidaSpecifications.conFiltros(almacenId, estado), pageable)
                .map(this::toResponseSinLineas);
    }

    @Override
    public SolSalidaResponse obtener(Long id) {
        SolSalida s = solSalidaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolSalida", id));
        return toResponseCompleto(s);
    }

    @Override
    @Transactional
    public SolSalidaResponse crear(SolSalidaRequest request) {
        if (!almacenRepository.existsById(request.getAlmacenId())) {
            throw new ResourceNotFoundException("Almacen", request.getAlmacenId());
        }
        for (SolSalidaLineaRequest lr : request.getLineas()) {
            assertArticuloExiste(lr.getArticuloId());
            if (lr.getCantidad() == null || lr.getCantidad().compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException("Cada línea debe tener cantidad mayor a cero.",
                        HttpStatus.UNPROCESSABLE_ENTITY, "ALM-SS-001");
            }
        }
        Almacen alm = almacenRepository.findById(request.getAlmacenId())
                .orElseThrow(() -> new ResourceNotFoundException("Almacen", request.getAlmacenId()));

        SolSalida s = new SolSalida();
        s.setAlmacenId(request.getAlmacenId());
        s.setFecha(request.getFecha());
        s.setSolicitanteId(request.getSolicitanteId());
        s.setObservacion(request.getObservacion());

        s.setNumero(numeradorDocumentoService.siguienteNroDocumento(
                NOMBRE_TABLA_DOCUMENTO, alm.getSucursalId(), request.getFecha().getYear()));

        SolSalida guardado = solSalidaRepository.save(s);
        for (SolSalidaLineaRequest lr : request.getLineas()) {
            SolSalidaDet det = new SolSalidaDet();
            det.setSolSalidaId(guardado.getId());
            det.setArticuloId(lr.getArticuloId());
            det.setCantidad(lr.getCantidad());
            solSalidaDetRepository.save(det);
        }
        return toResponseCompleto(guardado);
    }

    @Override
    @Transactional
    public SolSalidaResponse actualizar(Long id, SolSalidaRequest request) {
        SolSalida s = solSalidaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolSalida", id));
        if (!"1".equals(s.getFlagEstado())) {
            throw new BusinessException("Solo se puede editar una solicitud activa.",
                    HttpStatus.CONFLICT, "ALM-SS-002");
        }
        if (!almacenRepository.existsById(request.getAlmacenId())) {
            throw new ResourceNotFoundException("Almacen", request.getAlmacenId());
        }
        for (SolSalidaLineaRequest lr : request.getLineas()) {
            assertArticuloExiste(lr.getArticuloId());
            if (lr.getCantidad() == null || lr.getCantidad().compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException("Cada línea debe tener cantidad mayor a cero.",
                        HttpStatus.UNPROCESSABLE_ENTITY, "ALM-SS-001");
            }
        }
        s.setAlmacenId(request.getAlmacenId());
        s.setFecha(request.getFecha());
        s.setSolicitanteId(request.getSolicitanteId());
        s.setObservacion(request.getObservacion());
        solSalidaRepository.save(s);
        solSalidaDetRepository.deleteBySolSalidaId(id);
        for (SolSalidaLineaRequest lr : request.getLineas()) {
            SolSalidaDet det = new SolSalidaDet();
            det.setSolSalidaId(id);
            det.setArticuloId(lr.getArticuloId());
            det.setCantidad(lr.getCantidad());
            solSalidaDetRepository.save(det);
        }
        return toResponseCompleto(s);
    }

    @Override
    @Transactional
    public void eliminar(Long id) {
        SolSalida s = solSalidaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolSalida", id));
        if (!"1".equals(s.getFlagEstado())) {
            throw new BusinessException("Solo se puede eliminar una solicitud activa.",
                    HttpStatus.CONFLICT, "ALM-SS-003");
        }
        solSalidaDetRepository.deleteBySolSalidaId(id);
        solSalidaRepository.delete(s);
    }

    @Override
    @Transactional
    public SolSalidaResponse cambiarEstado(Long id, String nuevoEstado) {
        if (nuevoEstado == null || nuevoEstado.isBlank()) {
            throw new BusinessException("Estado requerido.", HttpStatus.BAD_REQUEST, "ALM-SS-004");
        }
        SolSalida s = solSalidaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolSalida", id));
        s.setFlagEstado(nuevoEstado.trim());
        return toResponseCompleto(solSalidaRepository.save(s));
    }

    private void assertArticuloExiste(Long articuloId) {
        Integer c = jdbcTemplate.queryForObject(
                "SELECT COUNT(*)::int FROM core.articulo WHERE id = ?", Integer.class, articuloId);
        if (c == null || c == 0) {
            throw new ResourceNotFoundException("Articulo", articuloId);
        }
    }

    private SolSalidaResponse toResponseSinLineas(SolSalida s) {
        return SolSalidaResponse.builder()
                .id(s.getId())
                .almacenId(s.getAlmacenId())
                .numero(s.getNumero())
                .fecha(s.getFecha())
                .solicitanteId(s.getSolicitanteId())
                .flagEstado(s.getFlagEstado())
                .observacion(s.getObservacion())
                .lineas(List.of())
                .build();
    }

    private SolSalidaResponse toResponseCompleto(SolSalida s) {
        List<SolSalidaDet> dets = solSalidaDetRepository.findBySolSalidaIdOrderById(s.getId());
        List<SolSalidaLineaResponse> lineas = new ArrayList<>();
        for (SolSalidaDet d : dets) {
            lineas.add(SolSalidaLineaResponse.builder()
                    .id(d.getId())
                    .articuloId(d.getArticuloId())
                    .cantidad(d.getCantidad())
                    .cantidadDespachada(d.getCantidadDespachada())
                    .build());
        }
        return SolSalidaResponse.builder()
                .id(s.getId())
                .almacenId(s.getAlmacenId())
                .numero(s.getNumero())
                .fecha(s.getFecha())
                .solicitanteId(s.getSolicitanteId())
                .flagEstado(s.getFlagEstado())
                .observacion(s.getObservacion())
                .lineas(lineas)
                .build();
    }
}
