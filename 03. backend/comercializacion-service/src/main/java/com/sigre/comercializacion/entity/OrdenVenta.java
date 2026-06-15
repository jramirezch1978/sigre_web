package com.sigre.comercializacion.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "orden_venta", schema = "ventas")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class OrdenVenta extends BaseEntity {

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "nro_orden_venta", nullable = false, length = 50, unique = true)
    private String nroOrdenVenta;

    @Column(name = "cliente_id")
    private Long clienteId;

    @Column(name = "comprador_final_id")
    private Long compradorFinalId;

    @Column(name = "vendedor_id")
    private Long vendedorId;

    @Column(name = "fecha_emision", nullable = false)
    private LocalDate fechaEmision;

    @Column(name = "fecha_registro")
    private Instant fechaRegistro;

    @Column(name = "fecha_embarque")
    private LocalDate fechaEmbarque;

    @Column(name = "fecha_doc")
    private LocalDate fechaDoc;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "forma_pago_id")
    private Long formaPagoId;

    @Column(name = "doc_tipo_id")
    private Long docTipoId;

    @Column(name = "nro_doc", length = 20)
    private String nroDoc;

    @Column(name = "forma_embarque", length = 4)
    private String formaEmbarque;

    @Column(name = "monto_total", nullable = false, precision = 18, scale = 4)
    private BigDecimal montoTotal = BigDecimal.ZERO;

    @Column(name = "monto_facturado", nullable = false, precision = 18, scale = 4)
    private BigDecimal montoFacturado = BigDecimal.ZERO;

    @Column(name = "monto_flete", precision = 18, scale = 4)
    private BigDecimal montoFlete;

    @Column(name = "monto_seguro", precision = 18, scale = 4)
    private BigDecimal montoSeguro;

    @Column(name = "observaciones", length = 2000)
    private String observaciones;

    @Column(name = "destino", columnDefinition = "TEXT")
    private String destino;

    @Column(name = "punto_partida", columnDefinition = "TEXT")
    private String puntoPartida;

    @Column(name = "pais_destino", length = 4)
    private String paisDestino;

    @Column(name = "ubigeo_dst", length = 6)
    private String ubigeoDst;

    @Column(name = "puerto_org", length = 8)
    private String puertoOrg;

    @Column(name = "puerto_dst", length = 8)
    private String puertoDst;

    @Column(name = "flag_mercado", length = 1)
    private String flagMercado;

    @Column(name = "flag_despacho", length = 1)
    private String flagDespacho;

    @OneToMany(mappedBy = "ordenVenta", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrdenVentaDet> detalles = new ArrayList<>();
}
