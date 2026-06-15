package com.sigre.rrhh.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import com.sigre.rrhh.dto.response.*;
import com.sigre.rrhh.entity.Contrato;
import com.sigre.rrhh.entity.HorarioTrabajador;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.repository.TrabajadorRepository;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Mapper manual para convertir entidades del dominio Trabajador
 * a DTOs de respuesta. Resuelve FKs cruzadas (área, cargo, sucursal,
 * AFP, turno) consultando directamente al repositorio.
 */
@Component
@RequiredArgsConstructor
public class TrabajadorMapper {

    private static final ZoneId ZONA_LIMA = ZoneId.of("America/Lima");
    private static final DateTimeFormatter FMT_TIMESTAMP = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    private final TrabajadorRepository repository;

    /**
     * Convierte un {@link Trabajador} a un DTO resumido para listados paginados.
     * Resuelve área, cargo y sucursal a objetos {@link RefResponse} con id y nombre.
     */
    public TrabajadorListResponse toListResponse(Trabajador t) {
        return TrabajadorListResponse.builder()
                .id(t.getId())
                .codigoTrabajador(t.getCodigoTrabajador())
                .nombres(t.getNombres())
                .apellidoPaterno(t.getApellidoPaterno())
                .apellidoMaterno(t.getApellidoMaterno())
                .tipoDocIdentidad(buildRef(t.getTipoDocIdentidadId(), repository::findTipoDocIdentidadNombreById))
                .numeroDocumento(t.getNumeroDocumento())
                .area(buildRef(t.getAreaId(), repository::findAreaNombreById))
                .cargo(buildRef(t.getCargoId(), repository::findCargoNombreById))
                .sucursal(buildRef(t.getSucursalId(), repository::findSucursalNombreById))
                .fechaIngreso(formatDate(t.getFechaIngreso()))
                .flagEstado(t.getFlagEstado())
                .fecCreacion(formatTimestamp(t.getFecCreacion()))
                .build();
    }

    /**
     * Convierte un {@link Trabajador} a un DTO de detalle completo,
     * incluyendo listas de contratos y horarios ya mapeados.
     */
    public TrabajadorDetailResponse toDetailResponse(Trabajador t,
                                                     List<Contrato> contratos,
                                                     List<HorarioTrabajador> horarios) {
        return TrabajadorDetailResponse.builder()
                .id(t.getId())
                .entidadContribuyente(buildRef(t.getEntidadContribuyenteId(), id -> null))
                .codigoTrabajador(t.getCodigoTrabajador())
                .nombres(t.getNombres())
                .apellidoPaterno(t.getApellidoPaterno())
                .apellidoMaterno(t.getApellidoMaterno())
                .tipoDocIdentidad(buildRef(t.getTipoDocIdentidadId(), repository::findTipoDocIdentidadNombreById))
                .numeroDocumento(t.getNumeroDocumento())
                .fechaNacimiento(formatDate(t.getFechaNacimiento()))
                .sexo(buildRef(t.getSexoId(), repository::findSexoNombreById))
                .estadoCivil(buildRef(t.getEstadoCivilId(), repository::findEstadoCivilNombreById))
                .direccion(t.getDireccion())
                .telefono(t.getTelefono())
                .email(t.getEmail())
                .cuentaBancariaSueldo(t.getCuentaBancariaSueldo())
                .cuentaCts(t.getCuentaCts())
                .adminAfp(buildRef(t.getAdminAfpId(), repository::findAdminAfpNombreById))
                .cuspp(t.getCuspp())
                .regimenLaboral(buildRef(t.getRegimenLaboralId(), repository::findRegimenLaboralNombreById))
                .area(buildRef(t.getAreaId(), repository::findAreaNombreById))
                .cargo(buildRef(t.getCargoId(), repository::findCargoNombreById))
                .sucursal(buildRef(t.getSucursalId(), repository::findSucursalNombreById))
                .fechaIngreso(formatDate(t.getFechaIngreso()))
                .fechaCese(formatDate(t.getFechaCese()))
                .motivoCese(t.getMotivoCese())
                .flagEstado(t.getFlagEstado())
                .createdBy(t.getCreatedBy())
                .fecCreacion(formatTimestamp(t.getFecCreacion()))
                .updatedBy(t.getUpdatedBy())
                .fecModificacion(formatTimestamp(t.getFecModificacion()))
                .contratos(contratos.stream().map(this::toContratoResponse).toList())
                .horarios(horarios.stream().map(this::toHorarioResponse).toList())
                .build();
    }

    /**
     * Convierte un {@link Contrato} a su DTO de respuesta.
     * Incluye todos los campos de auditoría.
     */
    public ContratoResponse toContratoResponse(Contrato c) {
        return ContratoResponse.builder()
                .id(c.getId())
                .trabajadorId(c.getTrabajadorId())
                .tipoContrato(buildRef(c.getTipoContratoId(), repository::findTipoContratoNombreById))
                .fechaInicio(formatDate(c.getFechaInicio()))
                .fechaFin(formatDate(c.getFechaFin()))
                .remuneracion(c.getRemuneracion())
                .asignacionFamiliar(c.getAsignacionFamiliar())
                .flagEstado(c.getFlagEstado())
                .createdBy(c.getCreatedBy())
                .fecCreacion(formatTimestamp(c.getFecCreacion()))
                .updatedBy(c.getUpdatedBy())
                .fecModificacion(formatTimestamp(c.getFecModificacion()))
                .build();
    }

    /**
     * Convierte un {@link HorarioTrabajador} a su DTO de respuesta.
     * Resuelve el turno a un {@link RefResponse} con id y nombre.
     */
    public HorarioResponse toHorarioResponse(HorarioTrabajador h) {
        return HorarioResponse.builder()
                .id(h.getId())
                .trabajadorId(h.getTrabajadorId())
                .turno(buildRef(h.getTurnoId(), repository::findTurnoNombreById))
                .fechaDesde(formatDate(h.getFechaDesde()))
                .fechaHasta(formatDate(h.getFechaHasta()))
                .flagEstado(h.getFlagEstado())
                .createdBy(h.getCreatedBy())
                .fecCreacion(formatTimestamp(h.getFecCreacion()))
                .updatedBy(h.getUpdatedBy())
                .fecModificacion(formatTimestamp(h.getFecModificacion()))
                .build();
    }

    // ── helpers ──────────────────────────────────────────────────

    /**
     * Construye un {@link RefResponse} resolviendo el nombre a través
     * de la función suministrada. Retorna {@code null} si el id es nulo.
     */
    private RefResponse buildRef(Long id, java.util.function.Function<Long, String> nameFn) {
        if (id == null) return null;
        return RefResponse.builder().id(id).nombre(nameFn.apply(id)).build();
    }

    /** Formatea {@link LocalDate} a {@code yyyy-MM-dd}; retorna {@code null} si es nulo. */
    private String formatDate(LocalDate d) {
        return d != null ? d.toString() : null;
    }

    /** Formatea {@link Instant} a {@code dd/MM/yyyy HH:mm:ss} en zona Lima; retorna {@code null} si es nulo. */
    private String formatTimestamp(Instant ts) {
        return ts != null ? ts.atZone(ZONA_LIMA).format(FMT_TIMESTAMP) : null;
    }
}
