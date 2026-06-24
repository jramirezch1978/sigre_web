package com.sigre.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.AuditOnlyMappedEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Detalle por tramos ({@code rrhh.permiso_licencia_det}).
 * Vinculado a cabecera {@link PermisoLicencia} por {@code permiso_licencia_id + item}.
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "permiso_licencia_det", schema = "rrhh")
public class PermisoLicenciaDet extends AuditOnlyMappedEntity {

    @Column(name = "permiso_licencia_id", nullable = false)
    private Long permisoLicenciaId;

    @Column(name = "item", nullable = false)
    private Integer item;

    @Column(name = "tipo_suspension_laboral_id")
    private Long tipoSuspensionLaboralId;

    @Column(name = "tipo_doc_identidad_id")
    private Long tipoDocIdentidadId;

    @Column(name = "numero_documento", length = 30)
    private String numeroDocumento;

    @Column(name = "periodo_inicio")
    private Integer periodoInicio;

    @Column(name = "mes_periodo")
    private Integer mesPeriodo;

    @Column(name = "fecha_solicitud", nullable = false)
    private LocalDate fechaSolicitud;

    @Column(name = "fecha_movimiento")
    private LocalDate fechaMovimiento;

    @Column(name = "fecha_inicio", nullable = false)
    private LocalDate fechaInicio;

    @Column(name = "fecha_fin")
    private LocalDate fechaFin;

    @Column(name = "dias", nullable = false)
    private BigDecimal dias = BigDecimal.ZERO;
}
