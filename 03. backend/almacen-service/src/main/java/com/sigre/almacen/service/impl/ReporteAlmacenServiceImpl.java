package com.sigre.almacen.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.dto.ComparacionInventarioResponse;
import com.sigre.almacen.dto.DiagnosticoAlmacenResponse;
import com.sigre.almacen.dto.KardexResponse;
import com.sigre.almacen.dto.LoteVencimientoResponse;
import com.sigre.almacen.dto.PerdidaResponse;
import com.sigre.almacen.dto.StockAFechaResponse;
import com.sigre.almacen.dto.ValorizacionResponse;
import com.sigre.almacen.entity.Almacen;
import com.sigre.almacen.entity.ArticuloAlmacen;
import com.sigre.almacen.entity.ArticuloRef;
import com.sigre.almacen.entity.ArticuloSaldoMensual;
import com.sigre.almacen.entity.InventarioConteo;
import com.sigre.almacen.entity.LotePallet;
import com.sigre.almacen.entity.ValeMov;
import com.sigre.almacen.entity.ValeMovDet;
import com.sigre.almacen.repository.AlmacenRepository;
import com.sigre.almacen.repository.ArticuloAlmacenRepository;
import com.sigre.almacen.repository.ArticuloMovTipoRepository;
import com.sigre.almacen.repository.ArticuloRefRepository;
import com.sigre.almacen.repository.ArticuloSaldoMensualRepository;
import com.sigre.almacen.repository.InventarioConteoRepository;
import com.sigre.almacen.repository.LotePalletRepository;
import com.sigre.almacen.repository.ValeMovDetRepository;
import com.sigre.almacen.service.ReporteAlmacenService;
import org.springframework.data.domain.PageImpl;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ReporteAlmacenServiceImpl implements ReporteAlmacenService {

    private final ArticuloSaldoMensualRepository saldoMensualRepository;
    private final ArticuloAlmacenRepository articuloAlmacenRepository;
    private final LotePalletRepository lotePalletRepository;
    private final ArticuloRefRepository articuloRefRepository;
    private final InventarioConteoRepository inventarioConteoRepository;
    private final AlmacenRepository almacenRepository;
    private final ValeMovDetRepository valeMovDetRepository;
    private final ArticuloMovTipoRepository articuloMovTipoRepository;

    /**
     * Códigos de tipo de movimiento considerados pérdida/merma:
     * S15 (merma PPTT), S25 (mermas), S14 (baja), S18 (pérdidas extraordinarias).
     */
    private static final List<String> CODIGOS_MERMA = List.of("S15", "S25", "S14", "S18");

    @Override
    public Page<KardexResponse> kardex(Long almacenId, Long articuloId,
                                       LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable) {
        Page<ArticuloSaldoMensual> page =
                saldoMensualRepository.buscarKardex(almacenId, articuloId, fechaDesde, fechaHasta, pageable);
        Map<Long, ArticuloRef> articulos = cargarArticulos(
                page.getContent().stream().map(ArticuloSaldoMensual::getArticuloId).toList());
        return page.map(s -> toKardex(s, articulos.get(s.getArticuloId())));
    }

    @Override
    public Page<ValorizacionResponse> valorizacion(Long almacenId, Long articuloId, Pageable pageable) {
        Page<ArticuloAlmacen> page = articuloAlmacenRepository.buscarStock(almacenId, articuloId, pageable);
        Map<Long, ArticuloRef> articulos = cargarArticulos(
                page.getContent().stream().map(ArticuloAlmacen::getArticuloId).toList());
        return page.map(a -> toValorizacion(a, articulos.get(a.getArticuloId())));
    }

    @Override
    public Page<LoteVencimientoResponse> lotesPorVencer(Long almacenId, Long articuloId, int dias, Pageable pageable) {
        LocalDate hoy = LocalDate.now();
        LocalDate hasta = hoy.plusDays(Math.max(dias, 0));
        Page<LotePallet> page = lotePalletRepository.buscarPorVencer(almacenId, articuloId, hasta, pageable);
        Map<Long, ArticuloRef> articulos = cargarArticulos(
                page.getContent().stream().map(LotePallet::getArticuloId).toList());
        return page.map(l -> toLoteVencimiento(l, articulos.get(l.getArticuloId()), hoy));
    }

    // ── Enriquecimiento de nombres de artículo (batch, evita N+1) ─────────────

    private Map<Long, ArticuloRef> cargarArticulos(List<Long> ids) {
        List<Long> distintos = ids.stream().filter(java.util.Objects::nonNull).distinct().toList();
        if (distintos.isEmpty()) {
            return Map.of();
        }
        return articuloRefRepository.findAllById(distintos).stream()
                .collect(Collectors.toMap(ArticuloRef::getId, Function.identity()));
    }

    // ── Mappers ───────────────────────────────────────────────────────────────

    private KardexResponse toKardex(ArticuloSaldoMensual s, ArticuloRef art) {
        return KardexResponse.builder()
                .id(s.getId())
                .almacenId(s.getAlmacenId())
                .articuloId(s.getArticuloId())
                .articuloCodigo(art != null ? art.getCodigo() : null)
                .articuloNombre(art != null ? art.getNombre() : null)
                .fecha(s.getFecha())
                .tipo(s.getTipo())
                .cantidad(s.getCantidad())
                .costoUnitario(s.getCostoUnitario())
                .costoTotal(s.getCostoTotal())
                .saldoCantidad(s.getSaldoCantidad())
                .saldoCostoUnitario(s.getSaldoCostoUnitario())
                .saldoCostoTotal(s.getSaldoCostoTotal())
                .valeMovDetId(s.getValeMovDetId())
                .build();
    }

    private ValorizacionResponse toValorizacion(ArticuloAlmacen a, ArticuloRef art) {
        BigDecimal cantidad = a.getCantidadDisponible() != null ? a.getCantidadDisponible() : BigDecimal.ZERO;
        BigDecimal costo = a.getCostoPromedio() != null ? a.getCostoPromedio() : BigDecimal.ZERO;
        return ValorizacionResponse.builder()
                .almacenId(a.getAlmacenId())
                .articuloId(a.getArticuloId())
                .articuloCodigo(art != null ? art.getCodigo() : null)
                .articuloNombre(art != null ? art.getNombre() : null)
                .cantidadDisponible(cantidad)
                .costoPromedio(costo)
                .valorTotal(cantidad.multiply(costo))
                .ultimaActualizacion(a.getUltimaActualizacion())
                .build();
    }

    private LoteVencimientoResponse toLoteVencimiento(LotePallet l, ArticuloRef art, LocalDate hoy) {
        Long dias = l.getFechaVencimiento() != null
                ? ChronoUnit.DAYS.between(hoy, l.getFechaVencimiento())
                : null;
        return LoteVencimientoResponse.builder()
                .id(l.getId())
                .almacenId(l.getAlmacenId())
                .articuloId(l.getArticuloId())
                .articuloCodigo(art != null ? art.getCodigo() : null)
                .articuloNombre(art != null ? art.getNombre() : null)
                .nroLote(l.getNroLote())
                .fechaProduccion(l.getFechaProduccion())
                .fechaVencimiento(l.getFechaVencimiento())
                .diasParaVencer(dias)
                .observacion(l.getObservacion())
                .flagEstado(l.getFlagEstado())
                .build();
    }

    // ── Stock a la fecha ───────────────────────────────────────────────────

    @Override
    public Page<StockAFechaResponse> stockAFecha(Long almacenId, Long articuloId,
                                                 LocalDate fecha, Pageable pageable) {
        LocalDate corte = fecha != null ? fecha : LocalDate.now();
        Page<ArticuloSaldoMensual> page = saldoMensualRepository.stockAFecha(almacenId, articuloId, corte, pageable);
        Map<Long, ArticuloRef> articulos = cargarArticulos(
                page.getContent().stream().map(ArticuloSaldoMensual::getArticuloId).toList());
        return page.map(s -> {
            ArticuloRef art = articulos.get(s.getArticuloId());
            BigDecimal cant = s.getSaldoCantidad() != null ? s.getSaldoCantidad() : BigDecimal.ZERO;
            BigDecimal costo = s.getSaldoCostoUnitario() != null ? s.getSaldoCostoUnitario() : BigDecimal.ZERO;
            return StockAFechaResponse.builder()
                    .almacenId(s.getAlmacenId())
                    .articuloId(s.getArticuloId())
                    .articuloCodigo(art != null ? art.getCodigo() : null)
                    .articuloNombre(art != null ? art.getNombre() : null)
                    .fechaCorte(corte)
                    .ultimoMovimiento(s.getFecha())
                    .cantidad(cant)
                    .costoUnitario(costo)
                    .valorTotal(s.getSaldoCostoTotal() != null ? s.getSaldoCostoTotal() : cant.multiply(costo))
                    .build();
        });
    }

    // ── Diagnóstico por almacén ────────────────────────────────────────────

    @Override
    public List<DiagnosticoAlmacenResponse> diagnostico(Long almacenId) {
        List<Object[]> filas = articuloAlmacenRepository.diagnosticoPorAlmacen(almacenId);
        List<Long> ids = filas.stream().map(f -> (Long) f[0]).filter(java.util.Objects::nonNull).distinct().toList();
        Map<Long, Almacen> almacenes = ids.isEmpty()
                ? Map.of()
                : almacenRepository.findAllById(ids).stream()
                        .collect(Collectors.toMap(Almacen::getId, Function.identity()));
        return filas.stream().map(f -> {
            Long almId = (Long) f[0];
            Almacen alm = almacenes.get(almId);
            return DiagnosticoAlmacenResponse.builder()
                    .almacenId(almId)
                    .almacenCodigo(alm != null ? alm.getCodigo() : null)
                    .almacenNombre(alm != null ? alm.getNombre() : null)
                    .totalArticulos(f[1] != null ? ((Number) f[1]).longValue() : 0L)
                    .totalUnidades(toBigDecimal(f[2]))
                    .valorInventario(toBigDecimal(f[3]))
                    .build();
        }).toList();
    }

    // ── Comparación de inventario (físico vs sistema) ──────────────────────

    @Override
    public Page<ComparacionInventarioResponse> comparacionInventario(Long almacenId, Long articuloId,
                                                                      LocalDate fechaDesde, LocalDate fechaHasta,
                                                                      Pageable pageable) {
        Page<InventarioConteo> page = inventarioConteoRepository.comparacion(
                almacenId, articuloId, fechaDesde, fechaHasta, pageable);
        Map<Long, ArticuloRef> articulos = cargarArticulos(
                page.getContent().stream().map(InventarioConteo::getArticuloId).toList());
        return page.map(c -> {
            ArticuloRef art = articulos.get(c.getArticuloId());
            BigDecimal diferencia = c.getDiferencia() != null ? c.getDiferencia() : BigDecimal.ZERO;
            BigDecimal costo = c.getCostoUnitario() != null ? c.getCostoUnitario() : BigDecimal.ZERO;
            BigDecimal conteo = c.getCantidadConteo2() != null ? c.getCantidadConteo2() : c.getCantidadConteo1();
            return ComparacionInventarioResponse.builder()
                    .id(c.getId())
                    .almacenId(c.getAlmacenId())
                    .articuloId(c.getArticuloId())
                    .articuloCodigo(art != null ? art.getCodigo() : null)
                    .articuloNombre(art != null ? art.getNombre() : null)
                    .fechaConteo(c.getFechaConteo())
                    .saldoSistema(c.getSaldoSistema())
                    .cantidadConteo(conteo)
                    .diferencia(diferencia)
                    .costoUnitario(costo)
                    .diferenciaValorizada(diferencia.multiply(costo))
                    .flagEstado(c.getFlagEstado())
                    .build();
        });
    }

    private BigDecimal toBigDecimal(Object value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }
        if (value instanceof BigDecimal bd) {
            return bd;
        }
        return BigDecimal.valueOf(((Number) value).doubleValue());
    }

    // ── Registro de pérdidas/mermas (consulta histórica) ───────────────────

    @Override
    public Page<PerdidaResponse> perdidas(Long almacenId, Long articuloId,
                                          LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable) {
        List<Long> tipoIds = articuloMovTipoRepository.findIdsByTipoMovCodes(CODIGOS_MERMA);
        if (tipoIds.isEmpty()) {
            return new PageImpl<>(List.of(), pageable, 0);
        }
        Page<ValeMovDet> page = valeMovDetRepository.buscarPerdidas(
                tipoIds, almacenId, articuloId, fechaDesde, fechaHasta, pageable);

        Map<Long, ArticuloRef> articulos = cargarArticulos(
                page.getContent().stream().map(ValeMovDet::getArticuloId).toList());
        // Proyección [id, tipoMov, descTipoMov] (no carga la entidad completa para
        // evitar columnas ausentes en tenants migrados, p. ej. cnta_cntbl).
        Map<Long, Object[]> tipos = articuloMovTipoRepository.findResumenByIds(tipoIds).stream()
                .collect(Collectors.toMap(r -> (Long) r[0], r -> r));

        return page.map(d -> toPerdida(d, articulos.get(d.getArticuloId()), tipos));
    }

    private PerdidaResponse toPerdida(ValeMovDet d, ArticuloRef art, Map<Long, Object[]> tipos) {
        ValeMov v = d.getValeMov();
        Object[] tipo = (v != null && v.getArticuloMovTipoId() != null)
                ? tipos.get(v.getArticuloMovTipoId())
                : null;
        String tipoMov = (tipo != null && tipo[1] != null) ? tipo[1].toString().trim() : null;
        String descTipoMov = (tipo != null) ? (String) tipo[2] : null;
        BigDecimal cantidad = d.getCantProcesada() != null ? d.getCantProcesada() : BigDecimal.ZERO;
        BigDecimal costo = d.getCostoUnitario() != null ? d.getCostoUnitario() : BigDecimal.ZERO;
        return PerdidaResponse.builder()
                .valeMovId(v != null ? v.getId() : null)
                .valeMovDetId(d.getId())
                .nroVale(v != null ? v.getNroVale() : null)
                .fecha(v != null ? v.getFechaMov() : null)
                .almacenId(v != null ? v.getAlmacenId() : null)
                .articuloId(d.getArticuloId())
                .articuloCodigo(art != null ? art.getCodigo() : null)
                .articuloNombre(art != null ? art.getNombre() : null)
                .articuloMovTipoId(v != null ? v.getArticuloMovTipoId() : null)
                .tipoMov(tipoMov)
                .descTipoMov(descTipoMov)
                .cantidadPerdida(cantidad)
                .costoUnitario(costo)
                .valorPerdida(cantidad.multiply(costo))
                .observacion(v != null ? v.getObservaciones() : null)
                .build();
    }
}
