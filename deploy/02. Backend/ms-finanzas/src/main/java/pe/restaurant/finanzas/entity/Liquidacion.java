package pe.restaurant.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "liquidacion", schema = "finanzas",
    uniqueConstraints = {
        @UniqueConstraint(columnNames = "nro_liquidacion")
    }
)
public class Liquidacion extends BaseEntity {

    @Column(name = "solicitud_giro_id", nullable = false)
    private Long solicitudGiroId;

    @Column(name = "nro_liquidacion", nullable = false, unique = true, length = 12)
    private String nroLiquidacion;

    @Column(name = "sucursal_id")
    private Long sucursalId;

    @Column(name = "doc_tipo_id")
    private Long docTipoId;

    @Column(name = "proveedor_id")
    private Long proveedorId;

    @Column(name = "fecha_registro", nullable = false)
    private LocalDate fechaRegistro = LocalDate.now();

    @Column(name = "fecha_liquidacion")
    private LocalDate fechaLiquidacion;

    @Column(name = "tipo_liquidacion", length = 1)
    private String tipoLiquidacion;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "concepto_financiero_id", nullable = false)
    private Long conceptoFinancieroId;

    @Column(name = "importe_neto", nullable = false, precision = 18, scale = 4)
    private BigDecimal importeNeto = BigDecimal.ZERO;

    @Column(name = "saldo", precision = 18, scale = 4)
    private BigDecimal saldo;

    @Column(name = "tasa_cambio", nullable = false, precision = 11, scale = 8)
    private BigDecimal tasaCambio = BigDecimal.ZERO;

    @Column
    private Integer anio;

    @Column
    private Integer mes;

    @Column(name = "cntbl_libro_id")
    private Long cntblLibroId;

    @Column(name = "cntbl_asiento_id")
    private Long cntblAsientoId;


    @Column(name = "usuario_id")
    private Long usuarioId;

    @Column(length = 200)
    private String observacion;

    @OneToMany(mappedBy = "liquidacion", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<LiquidacionDet> detalles = new ArrayList<>();

    public void addDetalle(LiquidacionDet detalle) {
        detalles.add(detalle);
        detalle.setLiquidacion(this);
    }

    public void removeDetalle(LiquidacionDet detalle) {
        detalles.remove(detalle);
        detalle.setLiquidacion(null);
    }

    public void clearDetalles() {
        detalles.forEach(detalle -> detalle.setLiquidacion(null));
        detalles.clear();
    }
}
