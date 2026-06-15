package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.ContratoRequest;
import com.sigre.rrhh.dto.request.HorarioRequest;
import com.sigre.rrhh.dto.request.TrabajadorRequest;
import com.sigre.rrhh.dto.response.*;

import java.time.LocalDate;
import java.util.List;

public interface TrabajadorService {

    Page<TrabajadorListResponse> listar(String codigoTrabajador, String nombres, String apellidoPaterno,
                                        String numeroDocumento, Long areaId, Long cargoId,
                                        Long sucursalId, String flagEstado, Pageable pageable);

    TrabajadorDetailResponse obtenerPorId(Long id);

    TrabajadorDetailResponse crear(TrabajadorRequest request);

    TrabajadorDetailResponse actualizar(Long id, TrabajadorRequest request);

    TrabajadorDetailResponse activar(Long id);

    TrabajadorDetailResponse desactivar(Long id);

    TrabajadorDetailResponse cesar(Long id, LocalDate fechaCese, String motivoCese);

    List<ContratoResponse> listarContratos(Long trabajadorId, String flagEstado);

    ContratoResponse obtenerContrato(Long trabajadorId, Long contratoId);

    ContratoResponse crearContrato(Long trabajadorId, ContratoRequest request);

    ContratoResponse actualizarContrato(Long trabajadorId, Long contratoId, ContratoRequest request);

    ContratoResponse desactivarContrato(Long trabajadorId, Long contratoId);

    List<HorarioResponse> listarHorarios(Long trabajadorId, String flagEstado);

    HorarioResponse obtenerHorario(Long trabajadorId, Long horarioId);

    HorarioResponse crearHorario(Long trabajadorId, HorarioRequest request);

    HorarioResponse actualizarHorario(Long trabajadorId, Long horarioId, HorarioRequest request);

    HorarioResponse desactivarHorario(Long trabajadorId, Long horarioId);
}
