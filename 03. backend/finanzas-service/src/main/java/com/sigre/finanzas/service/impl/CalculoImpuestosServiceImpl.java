package com.sigre.finanzas.service.impl;

import feign.FeignException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.TenantContext;
import com.sigre.finanzas.client.CoreMaestrosClient;
import com.sigre.finanzas.dto.request.CalcularImpuestosRequest;
import com.sigre.finanzas.dto.request.ImpuestoItemRequest;
import com.sigre.finanzas.dto.request.ItemCalculoRequest;
import com.sigre.finanzas.dto.response.CalcularImpuestosResponse;
import com.sigre.finanzas.dto.response.ConsolidadoResponse;
import com.sigre.finanzas.dto.response.DetraccionCalculadaResponse;
import com.sigre.finanzas.dto.response.ImpuestoCalculadoResponse;
import com.sigre.finanzas.dto.response.ItemCalculoResponse;
import com.sigre.finanzas.dto.response.PaisResponse;
import com.sigre.finanzas.dto.response.SucursalResponse;
import com.sigre.finanzas.dto.response.TiposImpuestoResponse;
import com.sigre.finanzas.service.CalculoImpuestosService;
import com.sigre.finanzas.service.FinanzasErrorCodes;
import com.sigre.finanzas.service.impl.tax.CalculadorDescuento;
import com.sigre.finanzas.service.impl.tax.CalculadorDetraccion;
import com.sigre.finanzas.service.impl.tax.CalculadorItem;
import com.sigre.finanzas.service.impl.tax.ConsolidadorImpuestos;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class CalculoImpuestosServiceImpl implements CalculoImpuestosService {

    private final CoreMaestrosClient coreMaestrosClient;

    @Override
    public CalcularImpuestosResponse calcular(CalcularImpuestosRequest request) {
        // 1. Resolve country from sucursal
        String paisCodigo = resolverPais();
        log.info("Calculando impuestos para país: {}, items: {}", paisCodigo, request.getItems().size());

        // 2. Resolve all unique tax IDs from ms-core-maestros (avoid N+1 per item)
        Map<Long, ImpuestoItemRequest> resolvedTaxes = resolverImpuestos(request.getItems());

        // 3. Enrich each item's impuestos with resolved data
        for (ItemCalculoRequest item : request.getItems()) {
            if (item.getImpuestos() != null) {
                for (ImpuestoItemRequest tax : item.getImpuestos()) {
                    ImpuestoItemRequest resolved = resolvedTaxes.get(tax.getTipoImpuestoId());
                    if (resolved != null) {
                        tax.setTasa(resolved.getTasa());
                        tax.setEsFiscalizado(resolved.getEsFiscalizado());
                        tax.setNombre(resolved.getNombre());
                        if (tax.getTipoCalculo() == null) {
                            tax.setTipoCalculo(resolved.getTipoCalculo() != null ? resolved.getTipoCalculo() : 1);
                        }
                    }
                }
            }
        }

        // [CORTAPUEGO] Validar máximo un impuesto fiscalizado por documento
        validarUnicoFiscalizado(request.getItems());

        // [CORTAPUEGO] Validar estructura uniforme de impuestos si hay descuento global
        if (request.getDescuentoGlobal() != null && request.getDescuentoGlobal().compareTo(BigDecimal.ZERO) > 0) {
            validarEstructuraUniforme(request.getItems());
        }

        // 4. Calculate each item (converting % discounts to amounts)
        boolean globalDsctEsPorc = "%".equals(request.getDsctoGlobalTipo());
        List<ItemCalculoResponse> itemsCalc = new ArrayList<>();
        for (ItemCalculoRequest item : request.getItems()) {
            // Convert per-item % discount to amount before calculation
            if ("%".equals(item.getDsctoTipo()) && item.getDescuento() != null) {
                BigDecimal precioTotal = item.getValorUnitario().multiply(item.getCantidad());
                item.setDescuento(precioTotal.multiply(item.getDescuento()).divide(new BigDecimal("100"), 10, RoundingMode.HALF_UP));
            }

            ItemCalculoResponse itemResp = CalculadorItem.calcular(item, paisCodigo);

            // Calculate per-item discount if applicable
            if (item.getDescuento() != null && item.getDescuento().compareTo(BigDecimal.ZERO) > 0) {
                List<ImpuestoCalculadoResponse> descuentos = CalculadorDescuento.calcularDescuentoItem(
                        item.getDescuento(),
                        itemResp.getImpuestos(),
                        item.getImpuestos(),
                        Boolean.TRUE.equals(item.getValorConIgv()),
                        item.getCantidad(),
                        paisCodigo);
                itemResp.setDescuentos(descuentos);
            }

            itemsCalc.add(itemResp);
        }

        // Convert global % discount to amount based on total before consolidating
        BigDecimal descuentoGlobal = request.getDescuentoGlobal();
        if (globalDsctEsPorc && descuentoGlobal != null && descuentoGlobal.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal totalConImpuestos = itemsCalc.stream()
                    .map(ItemCalculoResponse::getMontoTotal)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            descuentoGlobal = totalConImpuestos.multiply(descuentoGlobal).divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP);
        }

        // 5. Consolidate
        ConsolidadoResponse consolidado = ConsolidadorImpuestos.consolidar(
                itemsCalc, descuentoGlobal,
                Boolean.TRUE.equals(request.getDsctoGlobalConIgv()));

        // 6. Detraction (Peru only) — uses calculated totals, not raw request values
        DetraccionCalculadaResponse detraccion = null;
        if ("PE".equals(paisCodigo)) {
            detraccion = CalculadorDetraccion.calcular(
                    request.getItems(), itemsCalc,
                    consolidado.getTotalConImpuestos());
        }

        // 7. Build response
        return CalcularImpuestosResponse.builder()
                .pais(paisCodigo)
                .items(itemsCalc)
                .consolidado(consolidado)
                .detraccion(detraccion)
                .build();
    }

    private Map<Long, ImpuestoItemRequest> resolverImpuestos(List<ItemCalculoRequest> items) {
        // Collect all unique tax IDs from all items
        Set<Long> ids = new HashSet<>();
        for (ItemCalculoRequest item : items) {
            if (item.getImpuestos() != null) {
                for (ImpuestoItemRequest tax : item.getImpuestos()) {
                    ids.add(tax.getTipoImpuestoId());
                }
            }
        }

        // Resolve each tax ID from ms-core-maestros
        Map<Long, ImpuestoItemRequest> result = new HashMap<>();
        for (Long id : ids) {
            try {
                var resp = coreMaestrosClient.obtenerImpuestoPorId(id);
                if (resp.isSuccess() && resp.getData() != null) {
                    var data = resp.getData();
                    ImpuestoItemRequest req = new ImpuestoItemRequest();
                    req.setTipoImpuestoId(data.getId());
                    req.setTasa(data.getTasaImpuesto());
                    req.setEsFiscalizado("1".equals(data.getFlagIgv()));
                    req.setNombre(data.getDescImpuesto());
                    req.setTipoCalculo(data.getTipoCalculo() != null ? data.getTipoCalculo() : 1);
                    result.put(id, req);
                }
            } catch (FeignException.NotFound e) {
                throw new BusinessException("Impuesto con ID " + id + " no encontrado",
                        HttpStatus.NOT_FOUND, FinanzasErrorCodes.IMPUESTO_NO_ENCONTRADO);
            }
        }
        return result;
    }

    // [CORTAPUEGO] Valida que el documento no tenga más de un impuesto fiscalizado.
    // Si en el futuro se necesita permitir múltiples, eliminar este método y su llamada.
    private void validarUnicoFiscalizado(List<ItemCalculoRequest> items) {
        Long fiscalId = null;
        for (ItemCalculoRequest item : items) {
            if (item.getImpuestos() != null) {
                for (ImpuestoItemRequest tax : item.getImpuestos()) {
                    if (Boolean.TRUE.equals(tax.getEsFiscalizado())) {
                        if (fiscalId != null && !fiscalId.equals(tax.getTipoImpuestoId())) {
                            throw new BusinessException(
                                "No se permiten dos impuestos fiscalizados distintos en el mismo documento. " +
                                "Fiscalizado 1: ID " + fiscalId + ", Fiscalizado 2: ID " + tax.getTipoImpuestoId(),
                                HttpStatus.UNPROCESSABLE_ENTITY,
                                FinanzasErrorCodes.MULTIPLES_FISCALIZADOS);
                        }
                        fiscalId = tax.getTipoImpuestoId();
                    }
                }
            }
        }
    }

    // [CORTAPUEGO] Valida que todos los items con impuestos compartan la misma estructura
    // de tipos de impuesto cuando hay descuento global. Sin esto, el prorrateo es incorrecto.
    // Si en el futuro se necesita permitir estructuras mixtas, eliminar este método y su llamada.
    private void validarEstructuraUniforme(List<ItemCalculoRequest> items) {
        Set<Long> estructuraReferencia = null;
        for (ItemCalculoRequest item : items) {
            Set<Long> idsItem = item.getImpuestos() != null
                    ? item.getImpuestos().stream()
                        .map(ImpuestoItemRequest::getTipoImpuestoId)
                        .collect(Collectors.toSet())
                    : Set.of();

            if (idsItem.isEmpty()) continue;

            if (estructuraReferencia == null) {
                estructuraReferencia = idsItem;
            } else if (!estructuraReferencia.equals(idsItem)) {
                throw new BusinessException(
                    "Con descuento global activo, todos los items deben tener la misma estructura de impuestos. " +
                    "Item con IDs " + idsItem + " no coincide con la referencia " + estructuraReferencia,
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    FinanzasErrorCodes.ESTRUCTURA_IMPUESTOS_DIVERGENTE);
            }
        }
    }

    private String resolverPais() {
        Long sucursalId = TenantContext.getSucursalId();
        if (sucursalId == null) {
            throw new BusinessException("No se pudo determinar la sucursal del usuario",
                    HttpStatus.BAD_REQUEST, FinanzasErrorCodes.SUCURSAL_NO_ENCONTRADA);
        }

        try {
            // Get sucursal
            var sucursalResp = coreMaestrosClient.obtenerSucursalPorId(sucursalId);
            if (!sucursalResp.isSuccess() || sucursalResp.getData() == null) {
                throw new BusinessException("Sucursal no encontrada",
                        HttpStatus.BAD_REQUEST, FinanzasErrorCodes.SUCURSAL_NO_ENCONTRADA);
            }

            SucursalResponse sucursal = sucursalResp.getData();
            if (sucursal.getPaisId() == null) {
                throw new BusinessException("La sucursal no tiene un país asignado",
                        HttpStatus.BAD_REQUEST, FinanzasErrorCodes.SUCURSAL_SIN_PAIS);
            }

            // Get pais
            var paisResp = coreMaestrosClient.obtenerPaisPorId(sucursal.getPaisId());
            if (!paisResp.isSuccess() || paisResp.getData() == null) {
                throw new BusinessException("País no encontrado",
                        HttpStatus.BAD_REQUEST, FinanzasErrorCodes.PAIS_NO_ENCONTRADO);
            }

            String codigo = paisResp.getData().getCodigo();
            if (!"PE".equals(codigo) && !"CL".equals(codigo)) {
                log.warn("País {} no tiene lógica específica, usando DEFAULT", codigo);
                return "DEFAULT";
            }
            return codigo;

        } catch (FeignException e) {
            log.error("Error al comunicarse con ms-core-maestros para resolver país", e);
            throw new BusinessException("Error al determinar el país de la sucursal",
                    HttpStatus.SERVICE_UNAVAILABLE, FinanzasErrorCodes.ERROR_COMUNICACION_CORE);
        }
    }
}
