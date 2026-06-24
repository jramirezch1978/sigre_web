package com.sigre.rrhh.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import com.sigre.rrhh.dto.response.CalculoDetalleResponse;
import com.sigre.rrhh.dto.response.CalculoDetResponse;
import com.sigre.rrhh.dto.response.CalculoResponse;
import com.sigre.rrhh.entity.Calculo;
import com.sigre.rrhh.entity.CalculoDet;
import com.sigre.rrhh.repository.CalculoRepository;
import com.sigre.rrhh.repository.ConceptoPlanillaRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Mapper manual para convertir entidades Calculo/CalculoDet a DTOs de respuesta.
 * Resuelve FKs de trabajador y concepto consultando repositorios.
 */
@Component
@RequiredArgsConstructor
public class CalculoMapper {

    private static final ZoneId ZONA_LIMA = ZoneId.of("America/Lima");
    private static final DateTimeFormatter FMT_TIMESTAMP = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    private final TrabajadorRepository trabajadorRepo;
    private final ConceptoPlanillaRepository conceptoRepo;
    private final CalculoRepository calculoRepo;

    /**
     * Convierte un {@link Calculo} a su DTO de listado, incluyendo el conteo de trabajadores.
     */
    public CalculoResponse toResponse(Calculo c, int totalTrabajadores) {
        return CalculoResponse.builder()
                .id(c.getId())
                .anio(c.getAnio())
                .mes(c.getMes())
                .tipoPlanillaId(c.getTipoPlanillaId())
                .tipoPlanillaNombre(resolveTipoPlanillaNombre(c.getTipoPlanillaId()))
                .totalIngresos(c.getTotalIngresosSoles())
                .totalDescuentos(c.getTotalDescuentosSoles())
                .totalNeto(c.getTotalNetoSoles())
                .totalAportes(c.getTotalAportesSoles())
                .totalTrabajadores(totalTrabajadores)
                .createdBy(c.getCreatedBy())
                .fecCreacion(formatTimestamp(c.getFecCreacion()))
                .updatedBy(c.getUpdatedBy())
                .fecModificacion(formatTimestamp(c.getFecModificacion()))
                .build();
    }

    /**
     * Convierte un {@link Calculo} con sus detalles al DTO de detalle completo.
     */
    public CalculoDetalleResponse toDetalleResponse(Calculo c, List<CalculoDet> detalles) {
        return CalculoDetalleResponse.builder()
                .id(c.getId())
                .anio(c.getAnio())
                .mes(c.getMes())
                .tipoPlanillaId(c.getTipoPlanillaId())
                .tipoPlanillaNombre(resolveTipoPlanillaNombre(c.getTipoPlanillaId()))
                .totalIngresos(c.getTotalIngresosSoles())
                .totalDescuentos(c.getTotalDescuentosSoles())
                .totalNeto(c.getTotalNetoSoles())
                .totalAportes(c.getTotalAportesSoles())
                .totalTrabajadores(c.getTrabajadorId() != null ? 1 : 0)
                .createdBy(c.getCreatedBy())
                .fecCreacion(formatTimestamp(c.getFecCreacion()))
                .updatedBy(c.getUpdatedBy())
                .fecModificacion(formatTimestamp(c.getFecModificacion()))
                .detalles(detalles.stream().map(this::toDetResponse).toList())
                .build();
    }

    /**
     * Convierte un {@link CalculoDet} a su DTO de respuesta,
     * resolviendo nombres de trabajador y concepto.
     */
    public CalculoDetResponse toDetResponse(CalculoDet d) {
        Long trabajadorId = calculoRepo.findById(d.getCalculoId())
                .map(Calculo::getTrabajadorId)
                .orElse(null);
        String trabajadorNombres = resolveTrabajadorNombres(trabajadorId);
        String conceptoNombre = resolveConceptoNombre(d.getConceptoId());

        return CalculoDetResponse.builder()
                .id(d.getId())
                .calculoId(d.getCalculoId())
                .trabajadorId(trabajadorId)
                .trabajadorNombres(trabajadorNombres)
                .conceptoId(d.getConceptoId())
                .conceptoNombre(conceptoNombre)
                .monto(d.getImpSoles())
                .tipoConceptoCalculoId(d.getTipoConceptoCalculoId())
                .tipoConceptoCalculoNombre(resolveTipoConceptoCalculoNombre(d.getTipoConceptoCalculoId()))
                .build();
    }

    private String resolveTipoPlanillaNombre(Long tipoPlanillaId) {
        if (tipoPlanillaId == null) return null;
        return calculoRepo.findTipoPlanillaNombreById(tipoPlanillaId);
    }

    private String resolveTipoConceptoCalculoNombre(Long tipoConceptoCalculoId) {
        if (tipoConceptoCalculoId == null) return null;
        return calculoRepo.findTipoConceptoCalculoNombreById(tipoConceptoCalculoId);
    }

    private String resolveTrabajadorNombres(Long trabajadorId) {
        if (trabajadorId == null) return null;
        return trabajadorRepo.findById(trabajadorId)
                .map(t -> {
                    String full = t.getNombres();
                    if (t.getApellidoPaterno() != null) full = t.getApellidoPaterno() + " " + full;
                    if (t.getApellidoMaterno() != null) full = full + " " + t.getApellidoMaterno();
                    return full.trim();
                })
                .orElse(null);
    }

    private String resolveConceptoNombre(Long conceptoId) {
        if (conceptoId == null) return null;
        return conceptoRepo.findById(conceptoId)
                .map(cp -> cp.getNombre())
                .orElse(null);
    }

    private String formatTimestamp(Instant ts) {
        return ts != null ? ts.atZone(ZONA_LIMA).format(FMT_TIMESTAMP) : null;
    }
}
