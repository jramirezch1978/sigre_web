package pe.restaurant.almacen.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.StockArticuloAlmacenResponse;
import pe.restaurant.almacen.entity.ArticuloAlmacen;
import pe.restaurant.almacen.repository.ArticuloAlmacenRepository;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class StockConsultaServiceImplTest {

    @Mock
    private ArticuloAlmacenRepository repository;

    @InjectMocks
    private StockConsultaServiceImpl service;

    private ArticuloAlmacen stock(Long almacenId, Long articuloId, String disp, String reserv, String costo) {
        ArticuloAlmacen e = new ArticuloAlmacen();
        e.setId(10L);
        e.setAlmacenId(almacenId);
        e.setArticuloId(articuloId);
        e.setCantidadDisponible(new BigDecimal(disp));
        e.setCantidadReservada(new BigDecimal(reserv));
        e.setCostoPromedio(new BigDecimal(costo));
        e.setUltimaActualizacion(OffsetDateTime.now());
        return e;
    }

    @Test
    void consultarStock_mapeaYCalculaTotal() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<ArticuloAlmacen> page = new PageImpl<>(List.of(stock(1L, 5L, "8.0000", "2.0000", "12.500000")));
        when(repository.buscarStock(1L, 5L, pageable)).thenReturn(page);

        Page<StockArticuloAlmacenResponse> out = service.consultarStock(1L, 5L, pageable);

        assertThat(out.getContent()).hasSize(1);
        StockArticuloAlmacenResponse r = out.getContent().get(0);
        assertThat(r.getAlmacenId()).isEqualTo(1L);
        assertThat(r.getArticuloId()).isEqualTo(5L);
        assertThat(r.getCantidadDisponible()).isEqualByComparingTo("8.0000");
        assertThat(r.getCantidadReservada()).isEqualByComparingTo("2.0000");
        assertThat(r.getCantidadTotal()).isEqualByComparingTo("10.0000");
        assertThat(r.getCostoPromedio()).isEqualByComparingTo("12.500000");
    }

    @Test
    void consultarStockPorAlmacenYArticulo_existente_retornaStock() {
        when(repository.findByAlmacenIdAndArticuloId(1L, 5L))
                .thenReturn(Optional.of(stock(1L, 5L, "3.0000", "0.0000", "7.000000")));

        StockArticuloAlmacenResponse r = service.consultarStockPorAlmacenYArticulo(1L, 5L);

        assertThat(r.getCantidadTotal()).isEqualByComparingTo("3.0000");
        assertThat(r.getCostoPromedio()).isEqualByComparingTo("7.000000");
    }

    @Test
    void consultarStockPorAlmacenYArticulo_inexistente_retornaCeros() {
        when(repository.findByAlmacenIdAndArticuloId(2L, 9L)).thenReturn(Optional.empty());

        StockArticuloAlmacenResponse r = service.consultarStockPorAlmacenYArticulo(2L, 9L);

        assertThat(r.getAlmacenId()).isEqualTo(2L);
        assertThat(r.getArticuloId()).isEqualTo(9L);
        assertThat(r.getCantidadDisponible()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(r.getCantidadReservada()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(r.getCantidadTotal()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(r.getCostoPromedio()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(r.getId()).isNull();
    }
}
