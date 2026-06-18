package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "af_venta", schema = "activos")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class AfVenta extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(name = "fecha_baja", nullable = false)
    private LocalDate fechaBaja;

    @Column(name = "motivo", length = 30, nullable = false)
    private String motivo;

    @Column(name = "valor_venta", precision = 18, scale = 4)
    private BigDecimal valorVenta;

    @Column(name = "comprador", length = 200)
    private String comprador;

    @Column(name = "cntbl_asiento_id")
    private Long cntblAsientoId;

    @Column(name = "estado", nullable = false, length = 20)
    private String estado = "EN_PROCESO";

    @Column(name = "tipo_baja", length = 20)
    private String tipoBaja;

    @Column(name = "tipo_documento_venta", length = 30)
    private String tipoDocumentoVenta;

    @Column(name = "numero_documento", length = 30)
    private String numeroDocumento;

    @Column(name = "depreciacion_acumulada", precision = 18, scale = 4)
    private BigDecimal depreciacionAcumulada;

    @Column(name = "valor_neto_contable", precision = 18, scale = 4)
    private BigDecimal valorNetoContable;

    @Column(name = "resultado_baja", precision = 18, scale = 4)
    private BigDecimal resultadoBaja;

    @Column(name = "tipo_siniestro", length = 50)
    private String tipoSiniestro;

    @Column(name = "monto_indemnizacion", precision = 18, scale = 4)
    private BigDecimal montoIndemnizacion;

    @Column(name = "motivo_obsolescencia", length = 50)
    private String motivoObsolescencia;

    @Column(name = "descripcion_detalle", columnDefinition = "TEXT")
    private String descripcionDetalle;

}
