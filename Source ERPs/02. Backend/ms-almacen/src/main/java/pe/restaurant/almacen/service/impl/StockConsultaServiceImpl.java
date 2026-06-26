package pe.restaurant.almacen.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.almacen.dto.StockArticuloAlmacenResponse;
import pe.restaurant.almacen.dto.StockLoteResponse;
import pe.restaurant.almacen.entity.ArticuloAlmacen;
import pe.restaurant.almacen.entity.ArticuloAlmacenLote;
import pe.restaurant.almacen.repository.ArticuloAlmacenLoteRepository;
import pe.restaurant.almacen.repository.ArticuloAlmacenRepository;
import pe.restaurant.almacen.service.StockConsultaService;

import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StockConsultaServiceImpl implements StockConsultaService {

    private final ArticuloAlmacenRepository articuloAlmacenRepository;
    private final ArticuloAlmacenLoteRepository articuloAlmacenLoteRepository;

    @Override
    public Page<StockArticuloAlmacenResponse> consultarStock(Long almacenId, Long articuloId, Pageable pageable) {
        return articuloAlmacenRepository.buscarStock(almacenId, articuloId, pageable)
                .map(this::toResponse);
    }

    @Override
    public StockArticuloAlmacenResponse consultarStockPorAlmacenYArticulo(Long almacenId, Long articuloId) {
        return articuloAlmacenRepository.findByAlmacenIdAndArticuloId(almacenId, articuloId)
                .map(this::toResponse)
                .orElseGet(() -> StockArticuloAlmacenResponse.builder()
                        .almacenId(almacenId)
                        .articuloId(articuloId)
                        .cantidadDisponible(BigDecimal.ZERO)
                        .cantidadReservada(BigDecimal.ZERO)
                        .cantidadTotal(BigDecimal.ZERO)
                        .costoPromedio(BigDecimal.ZERO)
                        .build());
    }

    @Override
    public Page<StockLoteResponse> consultarStockLote(Long almacenId, Long articuloId,
                                                      Long lotePalletId, Pageable pageable) {
        return articuloAlmacenLoteRepository.buscarStockLote(almacenId, articuloId, lotePalletId, pageable)
                .map(this::toResponse);
    }

    private StockLoteResponse toResponse(ArticuloAlmacenLote entity) {
        return StockLoteResponse.builder()
                .id(entity.getId())
                .almacenId(entity.getAlmacenId())
                .articuloId(entity.getArticuloId())
                .lotePalletId(entity.getLotePalletId())
                .cantidadTotal(entity.getCantidadTotal())
                .saldo(entity.getSaldo())
                .costoPromedio(entity.getCostoPromedio())
                .ultimaActualizacion(entity.getUltimaActualizacion())
                .build();
    }

    private StockArticuloAlmacenResponse toResponse(ArticuloAlmacen entity) {
        BigDecimal disponible = entity.getCantidadDisponible() != null
                ? entity.getCantidadDisponible() : BigDecimal.ZERO;
        BigDecimal reservada = entity.getCantidadReservada() != null
                ? entity.getCantidadReservada() : BigDecimal.ZERO;
        return StockArticuloAlmacenResponse.builder()
                .id(entity.getId())
                .almacenId(entity.getAlmacenId())
                .articuloId(entity.getArticuloId())
                .cantidadDisponible(disponible)
                .cantidadReservada(reservada)
                .cantidadTotal(disponible.add(reservada))
                .costoPromedio(entity.getCostoPromedio())
                .ultimaActualizacion(entity.getUltimaActualizacion())
                .build();
    }
}
