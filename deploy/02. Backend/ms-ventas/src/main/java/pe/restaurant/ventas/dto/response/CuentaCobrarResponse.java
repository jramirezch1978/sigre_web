package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.ventas.entity.CuentaCobrarDet;

import java.math.BigDecimal;
import java.util.List;

/**
 * DTO Response para Cuenta por Cobrar
 * Incluye campos derivados según contrato
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CuentaCobrarResponse {

    private Long id;
    private Long sucursalId;
    private String sucursalNombre; // Campo derivado
    private Long clienteId;
    private String clienteRazonSocial; // Campo derivado
    private Long docTipoId;
    private String docTipoNombre; // Campo derivado
    private String serie;
    private String numero;
    private String fechaEmision;
    private String fechaVencimiento;
    private Long monedaId;
    private String monedaSimbolo; // Campo derivado
    private BigDecimal total;
    private BigDecimal saldo;
    private Integer ano;
    private Integer mes;
    private Long cntblLibroId;
    private Long cntblAsientoId;
    private String flagEstado;
    private Long createdBy;
    private String fecCreacion;
    private Long updatedBy;
    private String fecModificacion;
    private List<CuentaCobrarDetResponse> movimientos;

    /**
     * Constructor desde entidad con campos derivados
     */
    public static CuentaCobrarResponse fromEntity(pe.restaurant.ventas.entity.CuentaCobrar entity) {
        if (entity == null) return null;

        return CuentaCobrarResponse.builder()
                .id(entity.getId())
                .sucursalId(entity.getSucursalId())
                .sucursalNombre("Sucursal " + entity.getSucursalId())
                .clienteId(entity.getClienteId())
                .clienteRazonSocial("Cliente " + entity.getClienteId())
                .docTipoId(entity.getDocTipoId())
                .docTipoNombre("DocTipo " + entity.getDocTipoId())
                .serie(entity.getSerie())
                .numero(entity.getNumero())
                .fechaEmision(entity.getFechaEmision() != null ? 
                    entity.getFechaEmision().toString() : null)
                .fechaVencimiento(entity.getFechaVencimiento() != null ? 
                    entity.getFechaVencimiento().toString() : null)
                .monedaId(entity.getMonedaId())
                .monedaSimbolo(entity.getMonedaId() != null ? "S/" : "")
                .total(entity.getTotal())
                .saldo(entity.getSaldo())
                .ano(entity.getAno())
                .mes(entity.getMes())
                .cntblLibroId(entity.getCntblLibroId())
                .cntblAsientoId(entity.getCntblAsientoId())
                .flagEstado(entity.getFlagEstado())
                .createdBy(entity.getCreatedBy())
                .fecCreacion(entity.getFecCreacion() != null ? 
                    entity.getFecCreacion().atZone(java.time.ZoneId.systemDefault())
                                       .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null)
                .updatedBy(entity.getUpdatedBy())
                .fecModificacion(entity.getFecModificacion() != null ? 
                    entity.getFecModificacion().atZone(java.time.ZoneId.systemDefault())
                                          .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null)
                .movimientos(null)
                .build();
    }

    /**
     * DTO Response para movimientos
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CuentaCobrarDetResponse {
        
        private Long id;
        private Long conceptoFinancieroId;
        private Integer nroItem;
        private String descripcion;
        private Long creditoFiscalId;
        private BigDecimal cantidad;
        private BigDecimal precioUnitario;
        private String fechaMov;
        private String tipoMov;
        private BigDecimal monto;
        private String referencia;
        private String flagEstado;
        private Long createdBy;
        private String fecCreacion;
        private Long updatedBy;
        private String fecModificacion;

        public static CuentaCobrarDetResponse fromEntity(CuentaCobrarDet entity) {
            if (entity == null) return null;

            return CuentaCobrarDetResponse.builder()
                    .id(entity.getId())
                    .conceptoFinancieroId(entity.getConceptoFinancieroId())
                    .nroItem(entity.getNroItem())
                    .descripcion(entity.getDescripcion())
                    .creditoFiscalId(entity.getCreditoFiscalId())
                    .cantidad(entity.getCantidad())
                    .precioUnitario(entity.getPrecioUnitario())
                    .fechaMov(entity.getFechaMov() != null ? 
                        entity.getFechaMov().toString() : null)
                    .tipoMov(entity.getTipoMov() != null ? entity.getTipoMov().toString() : null)
                    .monto(entity.getMonto())
                    .referencia(entity.getReferencia())
                    .flagEstado(entity.getFlagEstado())
                    .createdBy(entity.getCreatedBy())
                    .fecCreacion(entity.getFecCreacion() != null ? 
                        entity.getFecCreacion().atZone(java.time.ZoneId.systemDefault())
                                           .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null)
                    .updatedBy(entity.getUpdatedBy())
                    .fecModificacion(entity.getFecModificacion() != null ? 
                        entity.getFecModificacion().atZone(java.time.ZoneId.systemDefault())
                                              .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null)
                    .build();
        }
    }

    /**
     * DTO Response para listados (ListItem)
     * Versión simplificada sin movimientos para mejor rendimiento
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CuentaCobrarListItemResponse {
        
        private Long id;
        private Long sucursalId;
        private String sucursalNombre;
        private Long clienteId;
        private String clienteRazonSocial;
        private Long docTipoId;
        private String docTipoNombre;
        private String serie;
        private String numero;
        private String fechaEmision;
        private String fechaVencimiento;
        private Long monedaId;
        private String monedaSimbolo;
        private BigDecimal total;
        private BigDecimal saldo;
        private Integer ano;
        private Integer mes;
        private Long cntblLibroId;
        private Long cntblAsientoId;
        private String flagEstado;
        private Long createdBy;
        private String fecCreacion;
        private Long updatedBy;
        private String fecModificacion;

        public static CuentaCobrarListItemResponse fromEntity(pe.restaurant.ventas.entity.CuentaCobrar entity) {
            if (entity == null) return null;

            return CuentaCobrarListItemResponse.builder()
                    .id(entity.getId())
                    .sucursalId(entity.getSucursalId())
                    .sucursalNombre("Sucursal " + entity.getSucursalId())
                    .clienteId(entity.getClienteId())
                    .clienteRazonSocial("Cliente " + entity.getClienteId())
                    .docTipoId(entity.getDocTipoId())
                    .docTipoNombre("DocTipo " + entity.getDocTipoId())
                    .serie(entity.getSerie())
                    .numero(entity.getNumero())
                    .fechaEmision(entity.getFechaEmision() != null ? 
                        entity.getFechaEmision().toString() : null)
                    .fechaVencimiento(entity.getFechaVencimiento() != null ? 
                        entity.getFechaVencimiento().toString() : null)
                    .monedaId(entity.getMonedaId())
                    .monedaSimbolo(entity.getMonedaId() != null ? "S/" : "")
                    .total(entity.getTotal())
                    .saldo(entity.getSaldo())
                    .ano(entity.getAno())
                    .mes(entity.getMes())
                    .cntblLibroId(entity.getCntblLibroId())
                    .cntblAsientoId(entity.getCntblAsientoId())
                    .flagEstado(entity.getFlagEstado())
                    .createdBy(entity.getCreatedBy())
                    .fecCreacion(entity.getFecCreacion() != null ? 
                        entity.getFecCreacion().atZone(java.time.ZoneId.systemDefault())
                                           .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null)
                    .updatedBy(entity.getUpdatedBy())
                    .fecModificacion(entity.getFecModificacion() != null ? 
                        entity.getFecModificacion().atZone(java.time.ZoneId.systemDefault())
                                              .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null)
                    .build();
        }
    }
}
