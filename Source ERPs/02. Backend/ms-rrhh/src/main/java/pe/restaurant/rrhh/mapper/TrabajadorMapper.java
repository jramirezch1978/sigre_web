package pe.restaurant.rrhh.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import pe.restaurant.rrhh.dto.response.*;
import pe.restaurant.rrhh.entity.Contrato;
import pe.restaurant.rrhh.entity.HorarioTrabajador;
import pe.restaurant.rrhh.entity.Trabajador;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
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
                .nombre1(t.getNombre1())
                .nombre2(t.getNombre2())
                .apellidoPaterno(t.getApellidoPaterno())
                .apellidoMaterno(t.getApellidoMaterno())
                .tipoDocIdentidad(buildRef(t.getTipoDocIdentidadId(), repository::findTipoDocIdentidadNombreById))
                .numeroDocumento(t.getNumeroDocumento())
                .area(buildRef(t.getAreaId(), repository::findAreaNombreById))
                .seccion(buildRef(t.getSeccionId(), repository::findSeccionNombreById))
                .cargo(buildRef(t.getCargoId(), repository::findCargoNombreById))
                .centroCosto(buildRef(t.getCentroCostoId(), repository::findCentroCostoNombreById))
                .sucursal(buildRef(t.getSucursalId(), repository::findSucursalNombreById))
                .tipoTrabajador(buildRef(t.getTipoTrabajadorId(), repository::findTipoTrabajadorNombreById))
                .adminAfp(buildRef(t.getAdminAfpId(), repository::findAdminAfpNombreById))
                .fecIniAfilAfp(formatDate(t.getFecIniAfilAfp()))
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
                .nombre1(t.getNombre1())
                .nombre2(t.getNombre2())
                .apellidoPaterno(t.getApellidoPaterno())
                .apellidoMaterno(t.getApellidoMaterno())
                .tipoDocIdentidad(buildRef(t.getTipoDocIdentidadId(), repository::findTipoDocIdentidadNombreById))
                .numeroDocumento(t.getNumeroDocumento())
                .fechaNacimiento(formatDate(t.getFechaNacimiento()))
                .sexo(buildRef(t.getSexoId(), repository::findSexoNombreById))
                .estadoCivil(buildRef(t.getEstadoCivilId(), repository::findEstadoCivilNombreById))
                .direccion(t.getDireccion())
                .telefonoFijo(t.getTelefonoFijo())
                .celular1(t.getCelular1())
                .celular2(t.getCelular2())
                .codigoTelCiudad(t.getCodigoTelCiudad())
                .alergias(t.getAlergias())
                .tipoSangre(buildRef(t.getTipoSangreId(), repository::findTipoSangreNombreById))
                .nroBrevete(t.getNroBrevete())
                .autogeneradoEssalud(t.getAutogeneradoEssalud())
                .flagDiscapacidad(t.getFlagDiscapacidad())
                .flagDomiciliado(t.getFlagDomiciliado())
                .flagComisionAfp(t.getFlagComisionAfp())
                .flagPensionista(t.getFlagPensionista())
                .flagAfiliadoEps(t.getFlagAfiliadoEps())
                .flagEssaludVida(t.getFlagEssaludVida())
                .flagSctrPension(t.getFlagSctrPension())
                .flagSctrSalud(t.getFlagSctrSalud())
                .flagQuintaExonerado(t.getFlagQuintaExonerado())
                .distrito(buildRef(t.getDistritoId(), repository::findDistritoNombreById))
                .tipoVia(buildRef(t.getTipoViaId(), repository::findTipoViaNombreById))
                .nombreVia(t.getNombreVia())
                .numeroVia(t.getNumeroVia())
                .tipoZona(buildRef(t.getTipoZonaId(), repository::findTipoZonaNombreById))
                .nombreZona(t.getNombreZona())
                .tipoVivienda(buildRef(t.getTipoViviendaId(), repository::findTipoViviendaNombreById))
                .interior(t.getInterior())
                .referencia(t.getReferencia())
                .email(t.getEmail())
                .cuentaBancariaSueldo(t.getCuentaBancariaSueldo())
                .cuentaCts(t.getCuentaCts())
                .adminAfp(buildRef(t.getAdminAfpId(), repository::findAdminAfpNombreById))
                .cuspp(t.getCuspp())
                .pensionRtps(buildRef(t.getPensionRtpsId(), repository::findPensionRtpsNombreById))
                .regimenPensionario(buildRef(t.getRegimenPensionarioId(), repository::findRegimenPensionarioNombreById))
                .fecIniAfilAfp(formatDate(t.getFecIniAfilAfp()))
                .fecFinAfilAfp(formatDate(t.getFecFinAfilAfp()))
                .regimenLaboral(buildRef(t.getRegimenLaboralId(), repository::findRegimenLaboralNombreById))
                .tipoTrabajador(buildRef(t.getTipoTrabajadorId(), repository::findTipoTrabajadorNombreById))
                .tipoTrabajadorRtps(buildRef(t.getTipoTrabajadorRtpsId(), repository::findTipoTrabajadorRtpsNombreById))
                .ocupacionRtps(buildRef(t.getOcupacionRtpsId(), repository::findOcupacionRtpsNombreById))
                .area(buildRef(t.getAreaId(), repository::findAreaNombreById))
                .seccion(buildRef(t.getSeccionId(), repository::findSeccionNombreById))
                .cargo(buildRef(t.getCargoId(), repository::findCargoNombreById))
                .centroCosto(buildRef(t.getCentroCostoId(), repository::findCentroCostoNombreById))
                .sucursal(buildRef(t.getSucursalId(), repository::findSucursalNombreById))
                .bancoSueldo(buildRef(t.getBancoSueldoId(), repository::findBancoNombreById))
                .bancoCts(buildRef(t.getBancoCtsId(), repository::findBancoNombreById))
                .monedaSueldo(buildRef(t.getMonedaSueldoId(), repository::findMonedaNombreById))
                .monedaCts(buildRef(t.getMonedaCtsId(), repository::findMonedaNombreById))
                .fechaIngreso(formatDate(t.getFechaIngreso()))
                .fechaCese(formatDate(t.getFechaCese()))
                .motivoCeseRef(buildRef(t.getMotivoCeseId(), repository::findMotivoCeseNombreById))
                .motivoCese(t.getMotivoCese())
                .comentario(t.getComentario())
                .procedencia(t.getProcedencia())
                .flagEstado(t.getFlagEstado())
                .createdBy(t.getCreatedBy())
                .fecCreacion(formatTimestamp(t.getFecCreacion()))
                .updatedBy(t.getUpdatedBy())
                .fecModificacion(formatTimestamp(t.getFecModificacion()))
                .contratos(contratos.stream().map(this::toContratoResponse).toList())
                .horarios(horarios.stream().map(this::toHorarioResponse).toList())
                .fotoBlobBase64(encodeBase64(t.getFotoBlob()))
                .dniBlobBase64(encodeBase64(t.getDniBlob()))
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

    private String encodeBase64(byte[] data) {
        if (data == null || data.length == 0) {
            return null;
        }
        return Base64.getEncoder().encodeToString(data);
    }
}
