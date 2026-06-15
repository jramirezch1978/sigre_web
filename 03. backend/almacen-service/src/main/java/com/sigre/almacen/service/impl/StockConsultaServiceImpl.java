package com.sigre.almacen.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.dto.StockArticuloAlmacenResponse;
import com.sigre.almacen.entity.ArticuloAlmacen;
import com.sigre.almacen.repository.ArticuloAlmacenRepository;
import com.sigre.almacen.service.StockConsultaService;

import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StockConsultaServiceImpl implements StockConsultaService {

    private final ArticuloAlmacenRepository articuloAlmacenRepository;

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
