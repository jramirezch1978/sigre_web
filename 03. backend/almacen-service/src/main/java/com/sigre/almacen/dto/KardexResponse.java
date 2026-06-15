package com.sigre.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Fila de kardex (movimiento valorizado) derivada de {@code almacen.articulo_saldo_mensual}.
 * Cada registro representa un asiento del kardex con su saldo acumulado.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class KardexResponse {

    private Long id;
    private Long almacenId;
    private Long articuloId;
    private String articuloCodigo;
    private String articuloNombre;
    private LocalDate fecha;
    private String tipo;
    private BigDecimal cantidad;
    private BigDecimal costoUnitario;
    private BigDecimal costoTotal;
    private BigDecimal saldoCantidad;
    private BigDecimal saldoCostoUnitario;
    private BigDecimal saldoCostoTotal;
    private Long valeMovDetId;
}
