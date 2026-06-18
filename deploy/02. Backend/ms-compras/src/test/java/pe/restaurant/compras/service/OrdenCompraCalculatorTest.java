package pe.restaurant.compras.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.compras.entity.OrdenCompra;
import pe.restaurant.compras.entity.OrdenCompraDet;
import pe.restaurant.compras.entity.TipoPercepcion;
import pe.restaurant.compras.entity.TiposImpuestoRef;
import pe.restaurant.compras.repository.TipoPercepcionRepository;
import pe.restaurant.compras.repository.TiposImpuestoRefRepository;

import java.math.BigDecimal;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class OrdenCompraCalculatorTest {

    @Mock private TiposImpuestoRefRepository tiposImpuestoRefRepository;
    @Mock private TipoPercepcionRepository tipoPercepcionRepository;
    @InjectMocks private OrdenCompraCalculator calculator;

    @Test
    void calcularLinea_sinDescuentoNiImpuestos() {
        OrdenCompraDet linea = buildLinea(new BigDecimal("10"), new BigDecimal("100"),
                BigDecimal.ZERO, null, null);

        calculator.calcularLinea(linea);

        assertThat(linea.getDescuentoMonto()).isEqualByComparingTo("0");
        assertThat(linea.getValorImpuesto()).isEqualByComparingTo("0");
        assertThat(linea.getPercepcionMonto()).isEqualByComparingTo("0");
        assertThat(linea.getSubtotal()).isEqualByComparingTo("1000.0000");
    }

    @Test
    void calcularLinea_conDescuento10Porciento() {
        OrdenCompraDet linea = buildLinea(new BigDecimal("10"), new BigDecimal("100"),
                new BigDecimal("10"), null, null);

        calculator.calcularLinea(linea);

        assertThat(linea.getDescuentoMonto()).isEqualByComparingTo("100.0000");
        assertThat(linea.getSubtotal()).isEqualByComparingTo("900.0000");
    }

    @Test
    void calcularLinea_conIgv18() {
        Long tipoImpuestoId = 1L;
        OrdenCompraDet linea = buildLinea(new BigDecimal("10"), new BigDecimal("100"),
                BigDecimal.ZERO, tipoImpuestoId, null);

        TiposImpuestoRef ref = mock(TiposImpuestoRef.class);
        when(ref.getTasaImpuesto()).thenReturn(new BigDecimal("18"));
        when(ref.getSigno()).thenReturn("+");
        when(tiposImpuestoRefRepository.findById(tipoImpuestoId)).thenReturn(Optional.of(ref));

        calculator.calcularLinea(linea);

        assertThat(linea.getValorImpuesto()).isEqualByComparingTo("180.0000");
        assertThat(linea.getSubtotal()).isEqualByComparingTo("1180.0000");
    }

    @Test
    void calcularLinea_conIgvNegativo_retencion() {
        Long tipoImpuestoId = 2L;
        OrdenCompraDet linea = buildLinea(new BigDecimal("10"), new BigDecimal("100"),
                BigDecimal.ZERO, tipoImpuestoId, null);

        TiposImpuestoRef ref = mock(TiposImpuestoRef.class);
        when(ref.getTasaImpuesto()).thenReturn(new BigDecimal("10"));
        when(ref.getSigno()).thenReturn("-");
        when(tiposImpuestoRefRepository.findById(tipoImpuestoId)).thenReturn(Optional.of(ref));

        calculator.calcularLinea(linea);

        assertThat(linea.getValorImpuesto()).isEqualByComparingTo("-100.0000");
        assertThat(linea.getSubtotal()).isEqualByComparingTo("900.0000");
    }

    @Test
    void calcularLinea_tipoImpuestoNull_sinImpuesto() {
        OrdenCompraDet linea = buildLinea(new BigDecimal("10"), new BigDecimal("100"),
                BigDecimal.ZERO, null, null);

        calculator.calcularLinea(linea);

        assertThat(linea.getValorImpuesto()).isEqualByComparingTo("0");
    }

    @Test
    void calcularLinea_tipoImpuestoNoExisteEnBd_impuestoCero() {
        Long tipoImpuestoId = 999L;
        OrdenCompraDet linea = buildLinea(new BigDecimal("10"), new BigDecimal("100"),
                BigDecimal.ZERO, tipoImpuestoId, null);

        when(tiposImpuestoRefRepository.findById(tipoImpuestoId)).thenReturn(Optional.empty());

        calculator.calcularLinea(linea);

        assertThat(linea.getValorImpuesto()).isEqualByComparingTo("0");
    }

    @Test
    void calcularLinea_conPercepcion() {
        Long tipoImpuestoId = 1L;
        Long tipoPercepcionId = 1L;
        OrdenCompraDet linea = buildLinea(new BigDecimal("10"), new BigDecimal("100"),
                BigDecimal.ZERO, tipoImpuestoId, tipoPercepcionId);

        TiposImpuestoRef impRef = mock(TiposImpuestoRef.class);
        when(impRef.getTasaImpuesto()).thenReturn(new BigDecimal("18"));
        when(impRef.getSigno()).thenReturn("+");
        when(tiposImpuestoRefRepository.findById(tipoImpuestoId)).thenReturn(Optional.of(impRef));

        TipoPercepcion percRef = mock(TipoPercepcion.class);
        when(percRef.getTasa()).thenReturn(new BigDecimal("2"));
        when(tipoPercepcionRepository.findById(tipoPercepcionId)).thenReturn(Optional.of(percRef));

        calculator.calcularLinea(linea);

        assertThat(linea.getValorImpuesto()).isEqualByComparingTo("180.0000");
        assertThat(linea.getPercepcionMonto()).isEqualByComparingTo("23.6000");
        assertThat(linea.getSubtotal()).isEqualByComparingTo("1203.6000");
    }

    @Test
    void calcularLinea_conDescuentoEIgvYPercepcion() {
        Long tipoImpuestoId = 1L;
        Long tipoPercepcionId = 1L;
        OrdenCompraDet linea = buildLinea(new BigDecimal("100"), new BigDecimal("25.50"),
                new BigDecimal("5"), tipoImpuestoId, tipoPercepcionId);

        TiposImpuestoRef impRef = mock(TiposImpuestoRef.class);
        when(impRef.getTasaImpuesto()).thenReturn(new BigDecimal("18"));
        when(impRef.getSigno()).thenReturn("+");
        when(tiposImpuestoRefRepository.findById(tipoImpuestoId)).thenReturn(Optional.of(impRef));

        TipoPercepcion percRef = mock(TipoPercepcion.class);
        when(percRef.getTasa()).thenReturn(new BigDecimal("2"));
        when(tipoPercepcionRepository.findById(tipoPercepcionId)).thenReturn(Optional.of(percRef));

        calculator.calcularLinea(linea);

        assertThat(linea.getDescuentoMonto()).isEqualByComparingTo("127.5000");
        assertThat(linea.getValorImpuesto()).isNotNull();
        assertThat(linea.getPercepcionMonto()).isNotNull();
        assertThat(linea.getSubtotal().compareTo(BigDecimal.ZERO)).isPositive();
    }

    @Test
    void calcularTotales_multipleLineas() {
        Long tipoImpuestoId = 1L;

        TiposImpuestoRef impRef = mock(TiposImpuestoRef.class);
        when(impRef.getTasaImpuesto()).thenReturn(new BigDecimal("18"));
        when(impRef.getSigno()).thenReturn("+");
        when(tiposImpuestoRefRepository.findById(tipoImpuestoId)).thenReturn(Optional.of(impRef));

        OrdenCompra oc = new OrdenCompra();
        oc.addLinea(buildLinea(new BigDecimal("10"), new BigDecimal("100"),
                BigDecimal.ZERO, tipoImpuestoId, null));
        oc.addLinea(buildLinea(new BigDecimal("5"), new BigDecimal("200"),
                new BigDecimal("10"), tipoImpuestoId, null));

        calculator.calcularTotales(oc);

        assertThat(oc.getSubtotal()).isEqualByComparingTo("2000.0000");
        assertThat(oc.getTotal().compareTo(BigDecimal.ZERO)).isPositive();
        assertThat(oc.getIgvTotal().compareTo(BigDecimal.ZERO)).isPositive();
    }

    @Test
    void calcularTotales_ignoraLineasInactivas() {
        OrdenCompra oc = new OrdenCompra();
        OrdenCompraDet activa = buildLinea(new BigDecimal("10"), new BigDecimal("100"),
                BigDecimal.ZERO, null, null);
        OrdenCompraDet inactiva = buildLinea(new BigDecimal("5"), new BigDecimal("200"),
                BigDecimal.ZERO, null, null);
        inactiva.setFlagEstado("0");

        oc.addLinea(activa);
        oc.addLinea(inactiva);

        calculator.calcularTotales(oc);

        assertThat(oc.getSubtotal()).isEqualByComparingTo("1000.0000");
        assertThat(oc.getTotal()).isEqualByComparingTo("1000.0000");
    }

    @Test
    void calcularTotales_sinLineas() {
        OrdenCompra oc = new OrdenCompra();
        calculator.calcularTotales(oc);
        assertThat(oc.getTotal()).isEqualByComparingTo("0");
    }

    @Test
    void precioSinIgv_conIgv18() {
        BigDecimal resultado = calculator.precioSinIgv(new BigDecimal("118"), new BigDecimal("18"));
        assertThat(resultado).isEqualByComparingTo("100.000000");
    }

    @Test
    void precioSinIgv_tasaCero() {
        BigDecimal resultado = calculator.precioSinIgv(new BigDecimal("100"), BigDecimal.ZERO);
        assertThat(resultado).isEqualByComparingTo("100");
    }

    @Test
    void precioSinIgv_tasaNull() {
        BigDecimal resultado = calculator.precioSinIgv(new BigDecimal("100"), null);
        assertThat(resultado).isEqualByComparingTo("100");
    }

    private OrdenCompraDet buildLinea(BigDecimal cant, BigDecimal precio,
                                      BigDecimal dscto, Long tipoImpuestoId,
                                      Long tipoPercepcionId) {
        OrdenCompraDet l = new OrdenCompraDet();
        l.setCantProyectada(cant);
        l.setValorUnitario(precio);
        l.setDescuentoPorcentaje(dscto);
        l.setTipoImpuestoId(tipoImpuestoId);
        l.setTipoPercepcionId(tipoPercepcionId);
        l.setFlagEstado("1");
        return l;
    }
}
