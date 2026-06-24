package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.ContratoRequest;

import java.time.Instant;
import com.sigre.rrhh.dto.request.HorarioRequest;
import com.sigre.rrhh.dto.request.TrabajadorRequest;
import com.sigre.rrhh.dto.response.*;
import com.sigre.rrhh.entity.Contrato;
import com.sigre.rrhh.entity.HorarioTrabajador;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.mapper.TrabajadorMapper;
import com.sigre.rrhh.repository.ContratoRepository;
import com.sigre.rrhh.repository.HorarioTrabajadorRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;
import com.sigre.rrhh.service.TrabajadorService;

import java.time.LocalDate;
import java.time.Period;
import java.util.Base64;
import java.util.List;
import java.util.regex.Pattern;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class TrabajadorServiceImpl implements TrabajadorService {

    private final TrabajadorRepository trabajadorRepo;
    private final ContratoRepository contratoRepo;
    private final HorarioTrabajadorRepository horarioRepo;
    private final TrabajadorMapper mapper;

    private static final Pattern EMAIL_REGEX = Pattern.compile("^[\\w.+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");

    @Override
    @Transactional(readOnly = true)
    public Page<TrabajadorListResponse> listar(String codigoTrabajador, String nombres, String apellidoPaterno,
                                               String numeroDocumento, Long areaId, Long cargoId,
                                               Long sucursalId, String flagEstado, Pageable pageable) {
        return trabajadorRepo.findWithFilters(
                        codigoTrabajador, nombres, apellidoPaterno, numeroDocumento,
                        areaId, cargoId, sucursalId, flagEstado, pageable)
                .map(mapper::toListResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public TrabajadorDetailResponse obtenerPorId(Long id) {
        Trabajador t = buscarOrThrow(id);
        List<Contrato> contratos = contratoRepo.findByTrabajadorIdOrderByFecCreacionDesc(id);
        List<HorarioTrabajador> horarios = horarioRepo.findByTrabajadorIdOrderByFecCreacionDesc(id);
        return mapper.toDetailResponse(t, contratos, horarios);
    }

    @Override
    @Timed("rrhh.trabajador.crear")
    public TrabajadorDetailResponse crear(TrabajadorRequest request) {
        Trabajador t = toEntity(request);
        validarCatalogos(t);
        validarEmail(t.getEmail());
        validarEdad(t.getFechaNacimiento());
        validarUnicidadCreacion(t);
        validarFKs(t);
        t.setCreatedBy(TenantContext.getUsuarioId());
        t.setFecCreacion(Instant.now());
        t.setFlagEstado("1");
        Trabajador saved = trabajadorRepo.save(t);
        return mapper.toDetailResponse(saved, List.of(), List.of());
    }

    @Override
    @Timed("rrhh.trabajador.actualizar")
    public TrabajadorDetailResponse actualizar(Long id, TrabajadorRequest request) {
        Trabajador existing = buscarOrThrow(id);
        validarActivo(existing);
        Trabajador datos = toEntity(request);
        validarCatalogos(datos);
        validarEmail(datos.getEmail());
        validarEdad(datos.getFechaNacimiento());
        validarUnicidadActualizacion(datos, id);
        validarFKs(datos);

        existing.setEntidadContribuyenteId(datos.getEntidadContribuyenteId());
        existing.setCodigoTrabajador(datos.getCodigoTrabajador());
        existing.setNombres(datos.getNombres());
        existing.setApellidoPaterno(datos.getApellidoPaterno());
        existing.setApellidoMaterno(datos.getApellidoMaterno());
        existing.setTipoDocIdentidadId(datos.getTipoDocIdentidadId());
        existing.setNumeroDocumento(datos.getNumeroDocumento());
        existing.setFechaNacimiento(datos.getFechaNacimiento());
        existing.setSexoId(datos.getSexoId());
        existing.setEstadoCivilId(datos.getEstadoCivilId());
        existing.setDireccion(datos.getDireccion());
        applyExtendedFields(existing, request);
        existing.setEmail(datos.getEmail());
        existing.setCuentaBancariaSueldo(datos.getCuentaBancariaSueldo());
        existing.setCuentaCts(datos.getCuentaCts());
        existing.setAdminAfpId(datos.getAdminAfpId());
        existing.setCuspp(datos.getCuspp());
        existing.setRegimenLaboralId(datos.getRegimenLaboralId());
        existing.setAreaId(datos.getAreaId());
        existing.setCargoId(datos.getCargoId());
        existing.setSucursalId(datos.getSucursalId());
        existing.setFechaIngreso(datos.getFechaIngreso());
        existing.setFechaCese(datos.getFechaCese());
        existing.setMotivoCese(datos.getMotivoCese());

        Trabajador saved = trabajadorRepo.save(existing);
        List<Contrato> contratos = contratoRepo.findByTrabajadorIdOrderByFecCreacionDesc(id);
        List<HorarioTrabajador> horarios = horarioRepo.findByTrabajadorIdOrderByFecCreacionDesc(id);
        return mapper.toDetailResponse(saved, contratos, horarios);
    }

    @Override
    public TrabajadorDetailResponse activar(Long id) {
        Trabajador t = buscarOrThrow(id);
        t.setFlagEstado("1");
        Trabajador saved = trabajadorRepo.save(t);
        return mapper.toDetailResponse(saved, List.of(), List.of());
    }

    @Override
    public TrabajadorDetailResponse desactivar(Long id) {
        Trabajador t = buscarOrThrow(id);
        t.setFlagEstado("0");
        Trabajador saved = trabajadorRepo.save(t);
        return mapper.toDetailResponse(saved, List.of(), List.of());
    }

    @Override
    public TrabajadorDetailResponse cesar(Long id, LocalDate fechaCese, String motivoCese) {
        Trabajador t = buscarOrThrow(id);
        validarActivo(t);

        if (t.getFechaIngreso() != null && fechaCese.isBefore(t.getFechaIngreso())) {
            throw new BusinessException(
                    "La fecha de cese no puede ser anterior a la fecha de ingreso",
                    HttpStatus.BAD_REQUEST, "RH-TR-009");
        }

        t.setFechaCese(fechaCese);
        t.setMotivoCese(motivoCese);
        t.setFlagEstado("0");
        Trabajador saved = trabajadorRepo.save(t);
        return mapper.toDetailResponse(saved, List.of(), List.of());
    }

    @Override
    @Transactional(readOnly = true)
    public List<ContratoResponse> listarContratos(Long trabajadorId, String flagEstado) {
        verificarTrabajadorExiste(trabajadorId);
        List<Contrato> contratos;
        if (flagEstado != null && !flagEstado.isBlank()) {
            contratos = contratoRepo.findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(trabajadorId, flagEstado);
        } else {
            contratos = contratoRepo.findByTrabajadorIdOrderByFecCreacionDesc(trabajadorId);
        }
        return contratos.stream().map(mapper::toContratoResponse).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public ContratoResponse obtenerContrato(Long trabajadorId, Long contratoId) {
        verificarTrabajadorExiste(trabajadorId);
        Contrato c = contratoRepo.findByIdAndTrabajadorId(contratoId, trabajadorId)
                .orElseThrow(() -> new ResourceNotFoundException("Contrato", contratoId));
        return mapper.toContratoResponse(c);
    }

    @Override
    @Timed("rrhh.trabajador.crear")
    public ContratoResponse crearContrato(Long trabajadorId, ContratoRequest request) {
        verificarTrabajadorExiste(trabajadorId);
        validarTipoContrato(request.getTipoContratoId());

        Contrato contrato = new Contrato();
        contrato.setTipoContratoId(request.getTipoContratoId());
        contrato.setFechaInicio(request.getFechaInicio());
        contrato.setFechaFin(request.getFechaFin());
        contrato.setRemuneracion(request.getRemuneracion());
        contrato.setAsignacionFamiliar(request.getAsignacionFamiliar() != null ? request.getAsignacionFamiliar() : false);

        validarFechasContrato(contrato);

        if (contratoRepo.existsByTrabajadorIdAndFlagEstado(trabajadorId, "1")) {
            throw new BusinessException(
                    "Ya existe un contrato activo para este trabajador",
                    HttpStatus.CONFLICT, "RH-CL-003");
        }

        contrato.setTrabajadorId(trabajadorId);
        contrato.setFlagEstado("1");
        contrato.setCreatedBy(TenantContext.getUsuarioId());
        contrato.setFecCreacion(Instant.now());
        return mapper.toContratoResponse(contratoRepo.save(contrato));
    }

    @Override
    @Timed("rrhh.trabajador.actualizar")
    public ContratoResponse actualizarContrato(Long trabajadorId, Long contratoId, ContratoRequest request) {
        Contrato existing = contratoRepo.findByIdAndTrabajadorId(contratoId, trabajadorId)
                .orElseThrow(() -> new ResourceNotFoundException("Contrato", contratoId));
        validarTipoContrato(request.getTipoContratoId());

        existing.setTipoContratoId(request.getTipoContratoId());
        existing.setFechaInicio(request.getFechaInicio());
        existing.setFechaFin(request.getFechaFin());
        existing.setRemuneracion(request.getRemuneracion());
        existing.setAsignacionFamiliar(request.getAsignacionFamiliar() != null ? request.getAsignacionFamiliar() : false);

        validarFechasContrato(existing);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toContratoResponse(contratoRepo.save(existing));
    }

    @Override
    public ContratoResponse desactivarContrato(Long trabajadorId, Long contratoId) {
        Contrato c = contratoRepo.findByIdAndTrabajadorId(contratoId, trabajadorId)
                .orElseThrow(() -> new ResourceNotFoundException("Contrato", contratoId));
        c.setFlagEstado("0");
        c.setUpdatedBy(TenantContext.getUsuarioId());
        c.setFecModificacion(Instant.now());
        return mapper.toContratoResponse(contratoRepo.save(c));
    }

    @Override
    @Transactional(readOnly = true)
    public List<HorarioResponse> listarHorarios(Long trabajadorId, String flagEstado) {
        verificarTrabajadorExiste(trabajadorId);
        List<HorarioTrabajador> horarios;
        if (flagEstado != null && !flagEstado.isBlank()) {
            horarios = horarioRepo.findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(trabajadorId, flagEstado);
        } else {
            horarios = horarioRepo.findByTrabajadorIdOrderByFecCreacionDesc(trabajadorId);
        }
        return horarios.stream().map(mapper::toHorarioResponse).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public HorarioResponse obtenerHorario(Long trabajadorId, Long horarioId) {
        verificarTrabajadorExiste(trabajadorId);
        HorarioTrabajador h = horarioRepo.findByIdAndTrabajadorId(horarioId, trabajadorId)
                .orElseThrow(() -> new ResourceNotFoundException("Horario", horarioId));
        return mapper.toHorarioResponse(h);
    }

    @Override
    @Timed("rrhh.trabajador.crear")
    public HorarioResponse crearHorario(Long trabajadorId, HorarioRequest request) {
        verificarTrabajadorExiste(trabajadorId);
        validarTurnoExiste(request.getTurnoId());

        if (horarioRepo.existsByTrabajadorIdAndFlagEstado(trabajadorId, "1")) {
            throw new BusinessException(
                    "Ya existe un horario activo para este trabajador",
                    HttpStatus.CONFLICT, "RH-HT-003");
        }

        validarSolapamientoHorario(trabajadorId, request.getFechaDesde(), request.getFechaHasta(), null);

        HorarioTrabajador horario = new HorarioTrabajador();
        horario.setTrabajadorId(trabajadorId);
        horario.setTurnoId(request.getTurnoId());
        horario.setFechaDesde(request.getFechaDesde());
        horario.setFechaHasta(request.getFechaHasta());
        horario.setFlagEstado("1");
        horario.setCreatedBy(TenantContext.getUsuarioId());
        horario.setFecCreacion(Instant.now());
        return mapper.toHorarioResponse(horarioRepo.save(horario));
    }

    @Override
    @Timed("rrhh.trabajador.actualizar")
    public HorarioResponse actualizarHorario(Long trabajadorId, Long horarioId, HorarioRequest request) {
        HorarioTrabajador existing = horarioRepo.findByIdAndTrabajadorId(horarioId, trabajadorId)
                .orElseThrow(() -> new ResourceNotFoundException("Horario", horarioId));
        validarTurnoExiste(request.getTurnoId());
        validarSolapamientoHorario(trabajadorId, request.getFechaDesde(), request.getFechaHasta(), horarioId);

        existing.setTurnoId(request.getTurnoId());
        existing.setFechaDesde(request.getFechaDesde());
        existing.setFechaHasta(request.getFechaHasta());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toHorarioResponse(horarioRepo.save(existing));
    }

    @Override
    public HorarioResponse desactivarHorario(Long trabajadorId, Long horarioId) {
        HorarioTrabajador h = horarioRepo.findByIdAndTrabajadorId(horarioId, trabajadorId)
                .orElseThrow(() -> new ResourceNotFoundException("Horario", horarioId));
        h.setFlagEstado("0");
        h.setUpdatedBy(TenantContext.getUsuarioId());
        h.setFecModificacion(Instant.now());
        return mapper.toHorarioResponse(horarioRepo.save(h));
    }

    // ── Validaciones privadas ────────────────────────────────────

    private Trabajador buscarOrThrow(Long id) {
        return trabajadorRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Trabajador", id));
    }

    private void verificarTrabajadorExiste(Long trabajadorId) {
        if (!trabajadorRepo.existsById(trabajadorId)) {
            throw new ResourceNotFoundException("Trabajador", trabajadorId);
        }
    }

    private void validarActivo(Trabajador t) {
        if ("0".equals(t.getFlagEstado())) {
            throw new BusinessException(
                    "El trabajador está inactivo; debe reactivarlo primero",
                    HttpStatus.CONFLICT, "RH-TR-010");
        }
    }

    private void validarCatalogos(Trabajador t) {
        if (t.getSexoId() != null && !trabajadorRepo.existsSexoById(t.getSexoId())) {
            throw badRequest("Sexo no encontrado con ID: " + t.getSexoId(), "RH-TR-007");
        }
        if (t.getEstadoCivilId() != null && !trabajadorRepo.existsEstadoCivilById(t.getEstadoCivilId())) {
            throw badRequest("Estado civil no encontrado con ID: " + t.getEstadoCivilId(), "RH-TR-007");
        }
        if (t.getTipoDocIdentidadId() != null && !trabajadorRepo.existsTipoDocIdentidadById(t.getTipoDocIdentidadId())) {
            throw badRequest("Tipo de documento no encontrado con ID: " + t.getTipoDocIdentidadId(), "RH-TR-007");
        }
        if (t.getRegimenLaboralId() != null && !trabajadorRepo.existsRegimenLaboralById(t.getRegimenLaboralId())) {
            throw badRequest("Régimen laboral no encontrado con ID: " + t.getRegimenLaboralId(), "RH-TR-007");
        }
    }

    private void validarEmail(String email) {
        if (email != null && !email.isBlank() && !EMAIL_REGEX.matcher(email).matches()) {
            throw badRequest("Formato de email inválido: " + email, "RH-TR-008");
        }
    }

    private void validarEdad(LocalDate fechaNacimiento) {
        if (fechaNacimiento == null) return;
        int edad = Period.between(fechaNacimiento, LocalDate.now()).getYears();
        if (edad < 18 || edad > 100) {
            throw badRequest("Edad fuera del rango permitido (18-100): " + edad + " años", "RH-TR-005");
        }
    }

    private void validarUnicidadCreacion(Trabajador t) {
        if (trabajadorRepo.existsByCodigoTrabajadorAndFlagEstado(t.getCodigoTrabajador(), "1")) {
            throw new BusinessException("Código de trabajador duplicado: " + t.getCodigoTrabajador(),
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-TR-003");
        }
        if (t.getNumeroDocumento() != null
                && trabajadorRepo.existsByNumeroDocumentoAndFlagEstado(t.getNumeroDocumento(), "1")) {
            throw new BusinessException("Número de documento duplicado: " + t.getNumeroDocumento(),
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-TR-004");
        }
    }

    private void validarUnicidadActualizacion(Trabajador t, Long id) {
        if (trabajadorRepo.existsByCodigoTrabajadorAndIdNotAndFlagEstado(t.getCodigoTrabajador(), id, "1")) {
            throw new BusinessException("Código de trabajador duplicado: " + t.getCodigoTrabajador(),
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-TR-003");
        }
        if (t.getNumeroDocumento() != null
                && trabajadorRepo.existsByNumeroDocumentoAndIdNotAndFlagEstado(t.getNumeroDocumento(), id, "1")) {
            throw new BusinessException("Número de documento duplicado: " + t.getNumeroDocumento(),
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-TR-004");
        }
    }

    private void validarFKs(Trabajador t) {
        if (t.getEntidadContribuyenteId() != null && !trabajadorRepo.existsEntidadContribuyenteById(t.getEntidadContribuyenteId())) {
            throw unprocessable("Entidad contribuyente no encontrada con ID: " + t.getEntidadContribuyenteId());
        }
        if (t.getAreaId() != null && !trabajadorRepo.existsAreaById(t.getAreaId())) {
            throw unprocessable("Área no encontrada con ID: " + t.getAreaId());
        }
        if (t.getCargoId() != null && !trabajadorRepo.existsCargoById(t.getCargoId())) {
            throw unprocessable("Cargo no encontrado con ID: " + t.getCargoId());
        }
        if (t.getSucursalId() != null && !trabajadorRepo.existsSucursalById(t.getSucursalId())) {
            throw unprocessable("Sucursal no encontrada o inactiva con ID: " + t.getSucursalId());
        }
        if (t.getAdminAfpId() != null && !trabajadorRepo.existsAdminAfpById(t.getAdminAfpId())) {
            throw unprocessable("Administradora AFP no encontrada con ID: " + t.getAdminAfpId());
        }
    }

    private void validarTipoContrato(Long tipoContratoId) {
        if (tipoContratoId == null || !trabajadorRepo.existsTipoContratoById(tipoContratoId)) {
            throw badRequest("Tipo de contrato no encontrado con ID: " + tipoContratoId, "RH-CL-002");
        }
    }

    private void validarFechasContrato(Contrato c) {
        if (c.getFechaFin() != null && c.getFechaFin().isBefore(c.getFechaInicio())) {
            throw badRequest("La fecha de fin no puede ser anterior a la fecha de inicio", "RH-CL-004");
        }
    }

    private void validarTurnoExiste(Long turnoId) {
        if (!trabajadorRepo.existsTurnoById(turnoId)) {
            throw new BusinessException("Turno no encontrado con ID: " + turnoId,
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-HT-002");
        }
    }

    private void validarSolapamientoHorario(Long trabajadorId, LocalDate fechaDesde, LocalDate fechaHasta, Long excludeId) {
        LocalDate hasta = fechaHasta != null ? fechaHasta : LocalDate.of(9999, 12, 31);
        if (horarioRepo.existsSolapamiento(trabajadorId, fechaDesde, hasta, excludeId)) {
            throw new BusinessException(
                    "Solapamiento de fechas con otro horario del trabajador",
                    HttpStatus.CONFLICT, "RH-HT-004");
        }
    }

    private Trabajador toEntity(TrabajadorRequest r) {
        Trabajador t = new Trabajador();
        t.setEntidadContribuyenteId(r.getEntidadContribuyenteId());
        t.setCodigoTrabajador(r.getCodigoTrabajador());
        t.setNombres(r.getNombres());
        t.setApellidoPaterno(r.getApellidoPaterno());
        t.setApellidoMaterno(r.getApellidoMaterno());
        t.setTipoDocIdentidadId(r.getTipoDocIdentidadId());
        t.setNumeroDocumento(r.getNumeroDocumento());
        t.setFechaNacimiento(r.getFechaNacimiento());
        t.setSexoId(r.getSexoId());
        t.setEstadoCivilId(r.getEstadoCivilId());
        t.setDireccion(r.getDireccion());
        applyExtendedFields(t, r);
        t.setEmail(r.getEmail());
        t.setCuentaBancariaSueldo(r.getCuentaBancariaSueldo());
        t.setCuentaCts(r.getCuentaCts());
        t.setAdminAfpId(r.getAdminAfpId());
        t.setCuspp(r.getCuspp());
        t.setRegimenLaboralId(r.getRegimenLaboralId());
        t.setAreaId(r.getAreaId());
        t.setCargoId(r.getCargoId());
        t.setSucursalId(r.getSucursalId());
        t.setFechaIngreso(r.getFechaIngreso());
        t.setFechaCese(r.getFechaCese());
        t.setMotivoCese(r.getMotivoCese());
        return t;
    }

    private void applyExtendedFields(Trabajador t, TrabajadorRequest r) {
        t.setNombre1(r.getNombre1());
        t.setNombre2(r.getNombre2());
        t.setAlergias(r.getAlergias());
        t.setTipoSangreId(r.getTipoSangreId());
        t.setNroBrevete(r.getNroBrevete());
        t.setAutogeneradoEssalud(r.getAutogeneradoEssalud());
        t.setTelefonoFijo(r.getTelefonoFijo());
        t.setCelular1(r.getCelular1());
        t.setCelular2(r.getCelular2());
        t.setCodigoTelCiudad(r.getCodigoTelCiudad());
        t.setFlagDiscapacidad(r.getFlagDiscapacidad());
        t.setFlagDomiciliado(r.getFlagDomiciliado());
        t.setFlagComisionAfp(r.getFlagComisionAfp());
        t.setFlagPensionista(r.getFlagPensionista());
        t.setFlagAfiliadoEps(r.getFlagAfiliadoEps());
        t.setFlagEssaludVida(r.getFlagEssaludVida());
        t.setFlagSctrPension(r.getFlagSctrPension());
        t.setFlagSctrSalud(r.getFlagSctrSalud());
        t.setFlagQuintaExonerado(r.getFlagQuintaExonerado());
        t.setDistritoId(r.getDistritoId());
        t.setTipoViaId(r.getTipoViaId());
        t.setNombreVia(r.getNombreVia());
        t.setNumeroVia(r.getNumeroVia());
        t.setTipoZonaId(r.getTipoZonaId());
        t.setNombreZona(r.getNombreZona());
        t.setTipoViviendaId(r.getTipoViviendaId());
        t.setInterior(r.getInterior());
        t.setReferencia(r.getReferencia());
        t.setBancoSueldoId(r.getBancoSueldoId());
        t.setBancoCtsId(r.getBancoCtsId());
        t.setMonedaSueldoId(r.getMonedaSueldoId());
        t.setMonedaCtsId(r.getMonedaCtsId());
        t.setPensionRtpsId(r.getPensionRtpsId());
        t.setRegimenPensionarioId(r.getRegimenPensionarioId());
        t.setFecIniAfilAfp(r.getFecIniAfilAfp());
        t.setFecFinAfilAfp(r.getFecFinAfilAfp());
        t.setTipoTrabajadorId(r.getTipoTrabajadorId());
        t.setTipoTrabajadorRtpsId(r.getTipoTrabajadorRtpsId());
        t.setOcupacionRtpsId(r.getOcupacionRtpsId());
        t.setSeccionId(r.getSeccionId());
        t.setCentroCostoId(r.getCentroCostoId());
        t.setMotivoCeseId(r.getMotivoCeseId());
        t.setComentario(r.getComentario());
        t.setProcedencia(r.getProcedencia());
        applyBlobFields(t, r);
    }

    private void applyBlobFields(Trabajador t, TrabajadorRequest r) {
        if (r.getFotoBlobBase64() != null) {
            t.setFotoBlob(decodeBase64OrNull(r.getFotoBlobBase64()));
        }
        if (r.getDniBlobBase64() != null) {
            t.setDniBlob(decodeBase64OrNull(r.getDniBlobBase64()));
        }
    }

    private byte[] decodeBase64OrNull(String base64) {
        if (base64 == null || base64.isBlank()) {
            return null;
        }
        return Base64.getDecoder().decode(base64);
    }

    private BusinessException badRequest(String msg, String code) {
        return new BusinessException(msg, HttpStatus.BAD_REQUEST, code);
    }

    private BusinessException unprocessable(String msg) {
        return new BusinessException(msg, HttpStatus.UNPROCESSABLE_ENTITY, "RH-TR-002");
    }
}
