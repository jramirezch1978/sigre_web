package pe.restaurant.compras.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.compras.entity.OrdenServicio;
import pe.restaurant.compras.entity.OrdenServicioDet;
import pe.restaurant.compras.entity.TiposImpuestoRef;
import pe.restaurant.compras.repository.TiposImpuestoRefRepository;

import java.math.BigDecimal;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("OrdenServicioCalculator — Pruebas Unitarias")
class OrdenServicioCalculatorTest {

    @Mock private TiposImpuestoRefRepository tiposImpuestoRefRepository;
    @InjectMocks private OrdenServicioCalculator calculator;

    @Test
    @DisplayName("calcularLinea() sin descuento ni impuestos")
    void calcularLinea_sinDescuentoNiImpuestos() {
        OrdenServicioDet linea = buildLinea(new BigDecimal("1000"), BigDecimal.ZERO, null, null);

        calculator.calcularLinea(linea);

        assertThat(linea.getDecuento()).isEqualByComparingTo("0");
        assertThat(linea.getImpuesto()).isEqualByComparingTo("0");
        assertThat(linea.getImpuesto2()).isEqualByComparingTo("0");
        assertThat(linea.getSubtotal()).isEqualByComparingTo("1000");
    }

    @Test
    @DisplayName("calcularLinea() con descuento 10 porciento")
    void calcularLinea_conDescuento10Porciento() {
        OrdenServicioDet linea = buildLinea(new BigDecimal("1000"), new BigDecimal("10"), null, null);

        calculator.calcularLinea(linea);

        assertThat(linea.getDecuento()).isEqualByComparingTo("100.0000");
        assertThat(linea.getSubtotal()).isEqualByComparingTo("900.0000");
    }

    @Test
    @DisplayName("calcularLinea() con impuesto 1")
    void calcularLinea_conImpuesto1() {
        Long tipoImpuestoId = 1L;
        OrdenServicioDet linea = buildLinea(new BigDecimal("1000"), BigDecimal.ZERO, tipoImpuestoId, null);

        TiposImpuestoRef ref = mock(TiposImpuestoRef.class);
        when(ref.getTasaImpuesto()).thenReturn(new BigDecimal("18"));
        when(ref.getSigno()).thenReturn("+");
        when(tiposImpuestoRefRepository.findById(tipoImpuestoId)).thenReturn(Optional.of(ref));

        calculator.calcularLinea(linea);

        assertThat(linea.getImpuesto()).isEqualByComparingTo("180.0000");
        assertThat(linea.getSubtotal()).isEqualByComparingTo("1180.0000");
    }

    @Test
    @DisplayName("calcularLinea() con impuesto 1 negativo")
    void calcularLinea_conImpuesto1Negativo() {
        Long tipoImpuestoId = 2L;
        OrdenServicioDet linea = buildLinea(new BigDecimal("1000"), BigDecimal.ZERO, tipoImpuestoId, null);

        TiposImpuestoRef ref = mock(TiposImpuestoRef.class);
        when(ref.getTasaImpuesto()).thenReturn(new BigDecimal("18"));
        when(ref.getSigno()).thenReturn("-");
        when(tiposImpuestoRefRepository.findById(tipoImpuestoId)).thenReturn(Optional.of(ref));

        calculator.calcularLinea(linea);

        assertThat(linea.getImpuesto()).isEqualByComparingTo("-180.0000");
        assertThat(linea.getSubtotal()).isEqualByComparingTo("820.0000");
    }

    @Test
    @DisplayName("calcularLinea() con dos impuestos")
    void calcularLinea_conDosImpuestos() {
        Long tipoImpuesto1Id = 1L;
        Long tipoImpuesto2Id = 3L;
        OrdenServicioDet linea = buildLinea(new BigDecimal("1000"), BigDecimal.ZERO, tipoImpuesto1Id, tipoImpuesto2Id);

        TiposImpuestoRef refIgv = mock(TiposImpuestoRef.class);
        when(refIgv.getTasaImpuesto()).thenReturn(new BigDecimal("18"));
        when(refIgv.getSigno()).thenReturn("+");
        when(tiposImpuestoRefRepository.findById(tipoImpuesto1Id)).thenReturn(Optional.of(refIgv));

        TiposImpuestoRef refPerc = mock(TiposImpuestoRef.class);
        when(refPerc.getTasaImpuesto()).thenReturn(new BigDecimal("2"));
        when(refPerc.getSigno()).thenReturn("+");
        when(tiposImpuestoRefRepository.findById(tipoImpuesto2Id)).thenReturn(Optional.of(refPerc));

        calculator.calcularLinea(linea);

        assertThat(linea.getImpuesto()).isEqualByComparingTo("180.0000");
        assertThat(linea.getImpuesto2()).isEqualByComparingTo("20.0000");
        assertThat(linea.getSubtotal()).isEqualByComparingTo("1200.0000");
    }

    @Test
    @DisplayName("calcularLinea() sin tipo impuesto -> no calcula")
    void calcularLinea_sinTipoImpuesto_noCalcula() {
        OrdenServicioDet linea = buildLinea(new BigDecimal("1000"), BigDecimal.ZERO, null, null);

        calculator.calcularLinea(linea);

        assertThat(linea.getImpuesto()).isEqualByComparingTo("0");
        assertThat(linea.getImpuesto2()).isEqualByComparingTo("0");
        assertThat(linea.getSubtotal()).isEqualByComparingTo("1000");
    }

    @Test
    @DisplayName("calcularTotales() multiple líneas")
    void calcularTotales_multipleLineas() {
        OrdenServicio os = new OrdenServicio();
        os.addLinea(buildLinea(new BigDecimal("1000"), BigDecimal.ZERO, null, null));
        os.addLinea(buildLinea(new BigDecimal("500"), BigDecimal.ZERO, null, null));

        calculator.calcularTotales(os);

        assertThat(os.getMontoTotal()).isEqualByComparingTo("1500");
    }

    @Test
    @DisplayName("calcularTotales() ignora líneas inactivas")
    void calcularTotales_ignoraLineasInactivas() {
        OrdenServicio os = new OrdenServicio();
        OrdenServicioDet activa = buildLinea(new BigDecimal("1000"), BigDecimal.ZERO, null, null);
        OrdenServicioDet inactiva = buildLinea(new BigDecimal("500"), BigDecimal.ZERO, null, null);
        inactiva.setFlagEstado("0");

        os.addLinea(activa);
        os.addLinea(inactiva);

        calculator.calcularTotales(os);

        assertThat(os.getMontoTotal()).isEqualByComparingTo("1000");
    }

    @Test
    @DisplayName("calcularTotales() sin líneas")
    void calcularTotales_sinLineas() {
        OrdenServicio os = new OrdenServicio();
        calculator.calcularTotales(os);
        assertThat(os.getMontoTotal()).isEqualByComparingTo("0");
    }

    @Test
    @DisplayName("calcularLinea() tipo no existe impuesto cero")
    void calcularLinea_tipoNoExiste_impuestoCero() {
        Long tipoImpuestoId = 999L;
        OrdenServicioDet linea = buildLinea(new BigDecimal("1000"), BigDecimal.ZERO, tipoImpuestoId, null);

        when(tiposImpuestoRefRepository.findById(tipoImpuestoId)).thenReturn(Optional.empty());

        calculator.calcularLinea(linea);

        assertThat(linea.getImpuesto()).isEqualByComparingTo("0");
        assertThat(linea.getSubtotal()).isEqualByComparingTo("1000");
    }

    private OrdenServicioDet buildLinea(BigDecimal importe, BigDecimal dsctoPct,
                                        Long tiposImpuestoId, Long tiposImpuesto2Id) {
        OrdenServicioDet l = new OrdenServicioDet();
        l.setImporte(importe);
        l.setDsctoPorcentaje(dsctoPct);
        l.setTiposImpuestoId(tiposImpuestoId);
        l.setTiposImpuesto2Id(tiposImpuesto2Id);
        l.setFlagEstado("1");
        return l;
    }
}
