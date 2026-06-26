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
@Table(name = "af_venta", schema = "activos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AfVenta extends BaseEntity {

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(name = "cntas_cobrar_id", nullable = false)
    private Long cntasCobrarId;

    @Column(name = "doc_tipo_id")
    private Long docTipoId;

    @Column(name = "serie_doc", length = 4)
    private String serieDoc;

    @Column(name = "nro_doc", length = 10)
    private String nroDoc;

    @Column(name = "fecha_baja", nullable = false)
    private LocalDate fechaBaja;

    @Column(name = "motivo", length = 3000, nullable = false)
    private String motivo;

    @Column(name = "valor_venta", precision = 18, scale = 4)
    private BigDecimal valorVenta;

    @Column(name = "depreciacion_acumulada", precision = 18, scale = 4)
    private BigDecimal depreciacionAcumulada;

    @Column(name = "valor_neto_contable", precision = 18, scale = 4)
    private BigDecimal valorNetoContable;

    @Column(name = "comprador", length = 200)
    private String comprador;
}
