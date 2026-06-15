package com.sigre.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "cntas_pagar", schema = "finanzas", 
    uniqueConstraints = {
        @UniqueConstraint(columnNames = {"proveedor_id", "doc_tipo_id", "serie", "numero"})
    }
)
public class CntasPagar extends BaseEntity {

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "proveedor_id", nullable = false)
    private Long proveedorId;

    @Column(name = "doc_tipo_id", nullable = false)
    private Long docTipoId;

    @Column(length = 4)
    private String serie;

    @Column(length = 20)
    private String numero;

    @Column(name = "fecha_emision", nullable = false)
    private LocalDate fechaEmision;

    @Column(name = "fecha_vencimiento")
    private LocalDate fechaVencimiento;

    @Column(name = "fecha_registro")
    private LocalDate fechaRegistro;

    @Column(name = "moneda_id", nullable = false)
    private Long monedaId;

    @Column(name = "tasa_cambio", nullable = false, precision = 11, scale = 4)
    private BigDecimal tasaCambio;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal total;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal saldo;

    @Column(length = 2000)
    private String descripcion;

    @Column(name = "forma_pago_id")
    private Long formaPagoId;

    @Column(name = "ano", nullable = false)
    private Integer ano;

    @Column(name = "mes", nullable = false)
    private Integer mes;

    @Column(name = "cntbl_libro_id", nullable = false)
    private Long cntblLibroId;

    @Column(name = "cod_origen", length = 2)
    private String codOrigen;

    @Column(name = "oper_detr", length = 2)
    private String operDetr;

    @Column(name = "detr_bien_serv_id")
    private Long detrBienServId;

    @Column(name = "nro_detraccion", length = 12)
    private String nroDetraccion;

    @Column(name = "flag_detraccion", length = 1)
    private String flagDetraccion;

    @Column(name = "importe_detraccion", precision = 18, scale = 4)
    private BigDecimal importeDetraccion;

    @Column(name = "flag_retencion", length = 1)
    private String flagRetencion;

    @Column(name = "porc_ret_igv", precision = 5, scale = 2)
    private BigDecimal porcRetIgv;

    @Column(name = "cntbl_asiento_id")
    private Long cntblAsientoId;

    @OneToMany(mappedBy = "cntasPagar", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CntasPagarDet> detalles = new ArrayList<>();

    public void addDetalle(CntasPagarDet detalle) {
        detalles.add(detalle);
        detalle.setCntasPagar(this);
    }

    public void removeDetalle(CntasPagarDet detalle) {
        detalles.remove(detalle);
        detalle.setCntasPagar(null);
    }
}
