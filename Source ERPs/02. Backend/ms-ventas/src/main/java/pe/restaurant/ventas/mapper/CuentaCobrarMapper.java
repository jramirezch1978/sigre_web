package pe.restaurant.ventas.mapper;

import org.springframework.stereotype.Component;
import pe.restaurant.ventas.dto.response.CuentaCobrarResponse;
import pe.restaurant.ventas.entity.CuentaCobrar;
import pe.restaurant.ventas.entity.CuentaCobrarDet;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Mapper para Cuentas por Cobrar
 * Convierte entre entidades y DTOs con campos derivados
 */
@Component
public class CuentaCobrarMapper {

    /**
     * Convierte entidad a response completo con movimientos
     */
    public CuentaCobrarResponse toResponse(CuentaCobrar entity, List<CuentaCobrarDet> movimientos) {
        if (entity == null) {
            return null;
        }

        return CuentaCobrarResponse.builder()
                .id(entity.getId())
                .sucursalId(entity.getSucursalId())
                .sucursalNombre(obtenerNombreSucursal(entity.getSucursalId()))
                .clienteId(entity.getClienteId())
                .clienteRazonSocial(obtenerRazonSocialCliente(entity.getClienteId()))
                .docTipoId(entity.getDocTipoId())
                .docTipoNombre(obtenerNombreDocTipo(entity.getDocTipoId()))
                .serie(entity.getSerie())
                .numero(entity.getNumero())
                .fechaEmision(formatDate(entity.getFechaEmision()))
                .fechaVencimiento(formatDate(entity.getFechaVencimiento()))
                .monedaId(entity.getMonedaId())
                .monedaSimbolo(obtenerSimboloMoneda(entity.getMonedaId()))
                .total(entity.getTotal())
                .saldo(entity.getSaldo())
                .ano(entity.getAno())
                .mes(entity.getMes())
                .cntblLibroId(entity.getCntblLibroId())
                .cntblAsientoId(entity.getCntblAsientoId())
                .flagEstado(entity.getFlagEstado())
                .createdBy(entity.getCreatedBy())
                .fecCreacion(formatTimestamp(entity.getFecCreacion()))
                .updatedBy(entity.getUpdatedBy())
                .fecModificacion(formatTimestamp(entity.getFecModificacion()))
                .movimientos(toMovimientosResponse(movimientos))
                .build();
    }

    /**
     * Convierte entidad a response simplificado para listados
     */
    public CuentaCobrarResponse.CuentaCobrarListItemResponse toListItemResponse(CuentaCobrar entity) {
        if (entity == null) {
            return null;
        }

        return CuentaCobrarResponse.CuentaCobrarListItemResponse.builder()
                .id(entity.getId())
                .sucursalId(entity.getSucursalId())
                .sucursalNombre(obtenerNombreSucursal(entity.getSucursalId()))
                .clienteId(entity.getClienteId())
                .clienteRazonSocial(obtenerRazonSocialCliente(entity.getClienteId()))
                .docTipoId(entity.getDocTipoId())
                .docTipoNombre(obtenerNombreDocTipo(entity.getDocTipoId()))
                .serie(entity.getSerie())
                .numero(entity.getNumero())
                .fechaEmision(formatDate(entity.getFechaEmision()))
                .fechaVencimiento(formatDate(entity.getFechaVencimiento()))
                .monedaId(entity.getMonedaId())
                .monedaSimbolo(obtenerSimboloMoneda(entity.getMonedaId()))
                .total(entity.getTotal())
                .saldo(entity.getSaldo())
                .ano(entity.getAno())
                .mes(entity.getMes())
                .cntblLibroId(entity.getCntblLibroId())
                .cntblAsientoId(entity.getCntblAsientoId())
                .flagEstado(entity.getFlagEstado())
                .createdBy(entity.getCreatedBy())
                .fecCreacion(formatTimestamp(entity.getFecCreacion()))
                .updatedBy(entity.getUpdatedBy())
                .fecModificacion(formatTimestamp(entity.getFecModificacion()))
                .build();
    }

    /**
     * Convierte lista de entidades a lista de responses para listados
     */
    public List<CuentaCobrarResponse.CuentaCobrarListItemResponse> toListItemResponseList(List<CuentaCobrar> entities) {
        if (entities == null || entities.isEmpty()) {
            return List.of();
        }

        return entities.stream()
                .map(this::toListItemResponse)
                .collect(Collectors.toList());
    }

    /**
     * Convierte movimientos a response
     */
    private List<CuentaCobrarResponse.CuentaCobrarDetResponse> toMovimientosResponse(List<CuentaCobrarDet> movimientos) {
        if (movimientos == null || movimientos.isEmpty()) {
            return List.of();
        }

        return movimientos.stream()
                .map(this::toMovimientoResponse)
                .collect(Collectors.toList());
    }

    /**
     * Convierte movimiento individual a response
     */
    private CuentaCobrarResponse.CuentaCobrarDetResponse toMovimientoResponse(CuentaCobrarDet movimiento) {
        if (movimiento == null) {
            return null;
        }

        return CuentaCobrarResponse.CuentaCobrarDetResponse.builder()
                .id(movimiento.getId())
                .conceptoFinancieroId(movimiento.getConceptoFinancieroId())
                .fechaMov(formatDate(movimiento.getFechaMov()))
                .tipoMov(movimiento.getTipoMov() != null ? movimiento.getTipoMov().toString() : null)
                .monto(movimiento.getMonto())
                .referencia(movimiento.getReferencia())
                .flagEstado(movimiento.getFlagEstado())
                .createdBy(movimiento.getCreatedBy())
                .fecCreacion(formatTimestamp(movimiento.getFecCreacion()))
                .updatedBy(movimiento.getUpdatedBy())
                .fecModificacion(formatTimestamp(movimiento.getFecModificacion()))
                .build();
    }

    // ==================== MÉTODOS AUXILIARES ====================

    /**
     * Formatea fecha a string
     */
    private String formatDate(java.time.LocalDate date) {
        if (date == null) {
            return null;
        }
        return date.toString(); // yyyy-MM-dd
    }

    /**
     * Formatea timestamp a string dd/MM/yyyy HH:mm:ss
     */
    private String formatTimestamp(java.time.Instant timestamp) {
        if (timestamp == null) {
            return null;
        }
        return timestamp.atZone(java.time.ZoneId.systemDefault())
                      .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
    }

    /**
     * Obtiene nombre de sucursal (simulado - TODO: integrar con ms-auth)
     */
    private String obtenerNombreSucursal(Long sucursalId) {
        if (sucursalId == null) {
            return null;
        }
        // TODO: Llamar a ms-auth para obtener nombre real
        return "Sucursal " + sucursalId;
    }

    /**
     * Obtiene razón social de cliente (simulado - TODO: integrar con ms-core)
     */
    private String obtenerRazonSocialCliente(Long clienteId) {
        if (clienteId == null) {
            return null;
        }
        // TODO: Llamar a ms-core para obtener nombre real
        return "Cliente " + clienteId;
    }

    /**
     * Obtiene nombre de tipo de documento (simulado - TODO: integrar con ms-core)
     */
    private String obtenerNombreDocTipo(Long docTipoId) {
        if (docTipoId == null) {
            return null;
        }
        // TODO: Llamar a ms-core para obtener nombre real
        switch (docTipoId.intValue()) {
            case 1: return "Boleta";
            case 2: return "Factura";
            case 3: return "Nota de Crédito";
            case 4: return "Nota de Débito";
            default: return "DocTipo " + docTipoId;
        }
    }

    /**
     * Obtiene símbolo de moneda (simulado - TODO: integrar con ms-core)
     */
    private String obtenerSimboloMoneda(Long monedaId) {
        if (monedaId == null) {
            return null;
        }
        // TODO: Llamar a ms-core para obtener símbolo real
        switch (monedaId.intValue()) {
            case 1: return "S/";
            case 2: return "$";
            case 3: return "€";
            default: return "";
        }
    }
}
