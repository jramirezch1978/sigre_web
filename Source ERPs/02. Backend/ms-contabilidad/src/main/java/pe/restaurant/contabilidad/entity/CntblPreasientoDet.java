package pe.restaurant.contabilidad.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.Instant;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "cntbl_preasiento_det", schema = "contabilidad")
@EntityListeners(AuditingEntityListener.class)
public class CntblPreasientoDet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cntbl_preasiento_id", nullable = false)
    private CntblPreasiento cntblPreasiento;

    @Column(nullable = false)
    private Integer secuencia;

    @Column(name = "plan_contable_det_id")
    private Long planContableDetId;

    @Column(name = "centros_costo_id")
    private Long centrosCostoId;

    @Column(name = "entidad_contribuyente_id")
    private Long entidadContribuyenteId;

    @Column(name = "doc_tipo_id")
    private Long docTipoId;

    @Column(name = "nro_referencia", length = 12)
    private String nroReferencia;

    @Column(name = "cntas_pagar_id")
    private Long cntasPagarId;

    @Column(name = "cntas_cobrar_id")
    private Long cntasCobrarId;

    @Column(name = "solicitud_giro_id")
    private Long solicitudGiroId;

    @Column(name = "af_maestro_id")
    private Long afMaestroId;

    @Column(name = "caja_bancos_id")
    private Long cajaBancosId;

    @Column(name = "liquidacion_id")
    private Long liquidacionId;

    @Column(name = "flag_debe_haber", nullable = false, length = 1)
    private String flagDebeHaber;

    @Column(name = "importe_sol", precision = 18, scale = 4)
    private BigDecimal importeSol = BigDecimal.ZERO;

    @Column(name = "importe_dol", precision = 18, scale = 4)
    private BigDecimal importeDol = BigDecimal.ZERO;

    @Column(length = 3000)
    private String glosa;

    @CreatedBy
    @Column(name = "created_by", updatable = false)
    private Long createdBy;

    @CreatedDate
    @Column(name = "fec_creacion", updatable = false)
    private Instant fecCreacion;

    @LastModifiedBy
    @Column(name = "updated_by")
    private Long updatedBy;

    @LastModifiedDate
    @Column(name = "fec_modificacion")
    private Instant fecModificacion;
}
