package com.sigre.sync.entity.local;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "tipo_trabajador")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "tipoTrabajador")
public class TipoTrabajadorLocal {

    @Id
    @Column(name = "TIPO_TRABAJADOR", length = 3, nullable = false)
    private String tipoTrabajador;

    @Column(name = "DESC_TIPO_TRA", length = 30)
    private String descripcionTipoTrabajador;

    @Column(name = "FLAG_EMISION_BOLETA", length = 1)
    private String flagEmisionBoleta;

    @Column(name = "FLAG_ESTADO", length = 1)
    private String flagEstado;

    @Column(name = "LIBRO_PLANILLA", precision = 3, scale = 0)
    private Integer libroPlanilla;

    @Column(name = "LIBRO_INT_GRATI", precision = 3, scale = 0)
    private Integer libroIntGrati;

    @Column(name = "LIBRO_INT_REMUN", precision = 3, scale = 0)
    private Integer libroIntRemun;

    @Column(name = "LIBRO_INT_PAGO_GRATI", precision = 3, scale = 0)
    private Integer libroIntPagoGrati;

    @Column(name = "LIBRO_INT_PAGO_REMUN", precision = 3, scale = 0)
    private Integer libroIntPagoRemun;

    @Column(name = "LIBRO_PROV_CTS", precision = 3, scale = 0)
    private Integer libroProvCts;

    @Column(name = "LIBRO_PROV_GRATI", precision = 3, scale = 0)
    private Integer libroProvGrati;

    @Column(name = "FLAG_REPLICACION", length = 1)
    private String flagReplicacion;

    @Column(name = "DIA_MIN_DESCANSO", precision = 2, scale = 0)
    private Integer diaMinDescanso;

    @Column(name = "DIAS_TRAB_HAB_FIJO", precision = 2, scale = 0)
    private Integer diasTrabHabFijo;

    @Column(name = "FACTOR_COSTO_HR", precision = 6, scale = 4)
    private BigDecimal factorCostoHr;

    @Column(name = "CNTA_CTBL_CTS_CARGO", length = 10)
    private String cuentaContableCtsCargo;

    @Column(name = "CNTA_CTBL_CTS_ABONO", length = 10)
    private String cuentaContableCtsAbono;

    @Column(name = "FLAG_TABLA_ORIGEN", length = 1)
    private String flagTablaOrigen;

    @Column(name = "DOC_AFEC_PRESUP", length = 4)
    private String documentoAfectaPresupuesto;

    @Column(name = "CNTA_PRSP_AFEC_CTS", length = 10)
    private String cuentaPresupAfectaCts;

    @Column(name = "DOC_AFEC_PRESUP_CTS", length = 4)
    private String documentoAfectaPresupCts;

    @Column(name = "FLAG_DESTAJO_JORNAL", length = 1)
    private String flagDestajoJornal;

    @Column(name = "LIBRO_PROV_VACAC", precision = 3, scale = 0)
    private Integer libroProvVacac;

    @Column(name = "FLAG_INGRESO_BOLETA", length = 1)
    private String flagIngresoBoleta;

    @Column(name = "CNTA_PRSP_LBS", length = 10)
    private String cuentaPresupLbs;

    @Column(name = "FLAG_SECTOR_AGRARIO", length = 1, nullable = false)
    private String flagSectorAgrario;

    @Column(name = "PERIODO_BOLETA", length = 1, nullable = false)
    private String periodoBoleta;

    // Campos de auditoría para sincronización
    @Column(name = "FECHA_SYNC")
    private LocalDate fechaSync;

    @Column(name = "ESTADO_SYNC", length = 1)
    @Builder.Default
    private String estadoSync = "P"; // P=Pendiente, S=Sincronizado, E=Error

    // Método helper para verificar si está activo
    public boolean isActivo() {
        return "1".equals(flagEstado);
    }
}
