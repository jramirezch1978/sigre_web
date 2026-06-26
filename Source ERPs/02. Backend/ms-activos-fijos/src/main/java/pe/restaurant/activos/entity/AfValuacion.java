package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "af_valuacion", schema = "activos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AfValuacion extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(name = "fecha_valuacion", nullable = false)
    private LocalDate fechaValuacion;

    @Column(name = "valor_anterior", nullable = false, precision = 18, scale = 4)
    private BigDecimal valorAnterior;

    @Column(name = "valor_nuevo", nullable = false, precision = 18, scale = 4)
    private BigDecimal valorNuevo;

    @Column(name = "metodo_valuacion", nullable = false, length = 50)
    private String metodoValuacion;

    @Column(name = "responsable_id", nullable = false)
    private Long responsableId;

    @Column(name = "observaciones", length = 500)
    private String observaciones;

    @Column(name = "fecha_aprobacion")
    private LocalDate fechaAprobacion;

    @Column(name = "aprobador_id")
    private Long aprobadorId;

    @Column(name = "cntbl_asiento_id")
    private Long cntblAsientoId;

    @Column(name = "estado", nullable = false, length = 20)
    private String estado = "EN_PROCESO";

    @Column(name = "tipo_revaluacion", length = 20)
    private String tipoRevaluacion;

    @Column(name = "fuente_revaluacion", length = 50)
    private String fuenteRevaluacion;

    @Column(name = "factor_revaluacion", precision = 10, scale = 6)
    private BigDecimal factorRevaluacion;

    @Column(name = "documento_soporte", length = 30)
    private String documentoSoporte;

    @Column(name = "nueva_vida_util")
    private Integer nuevaVidaUtil;

    @Column(name = "valor_residual", precision = 18, scale = 4)
    private BigDecimal valorResidual;
}
