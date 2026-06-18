package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.entity.AfMaestro;

import java.math.BigDecimal;
import java.math.RoundingMode;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class DepreciacionServiceImplTest {

    @InjectMocks
    private DepreciacionServiceImpl service;

    private AfMaestro crearActivo(BigDecimal valorAdquisicion, BigDecimal valorResidual) {
        AfMaestro activo = new AfMaestro();
        activo.setCodigo("ACT-001");
        activo.setValorAdquisicion(valorAdquisicion);
        activo.setValorResidual(valorResidual);
        return activo;
    }

    @Test
    void calcularLinealReturnsMensualCorrect() {
        AfMaestro activo = crearActivo(new BigDecimal("12000.0000"), new BigDecimal("0.0000"));
        BigDecimal result = service.calcularDepreciacionLineal(activo, 60, 10);
        assertEquals(new BigDecimal("200.0000"), result);
    }

    @Test
    void calcularLinealWithResidualValue() {
        AfMaestro activo = crearActivo(new BigDecimal("10000.0000"), new BigDecimal("1000.0000"));
        BigDecimal result = service.calcularDepreciacionLineal(activo, 36, 5);
        BigDecimal expected = new BigDecimal("9000.0000").divide(new BigDecimal("36"), 4, RoundingMode.HALF_UP);
        assertEquals(expected, result);
    }

    @Test
    void calcularLinealReturnsZeroWhenFullyDepreciated() {
        AfMaestro activo = crearActivo(new BigDecimal("12000.0000"), new BigDecimal("0.0000"));
        BigDecimal result = service.calcularDepreciacionLineal(activo, 60, 60);
        assertEquals(BigDecimal.ZERO, result);
    }

    @Test
    void calcularLinealReturnsZeroWhenBeyondLifespan() {
        AfMaestro activo = crearActivo(new BigDecimal("12000.0000"), new BigDecimal("0.0000"));
        BigDecimal result = service.calcularDepreciacionLineal(activo, 60, 80);
        assertEquals(BigDecimal.ZERO, result);
    }

    @Test
    void calcularAceleradaReturnsCorrectValue() {
        AfMaestro activo = crearActivo(new BigDecimal("10000.0000"), new BigDecimal("1000.0000"));
        BigDecimal valorNetoActual = new BigDecimal("8000.0000");

        BigDecimal result = service.calcularDepreciacionAcelerada(activo, 60, valorNetoActual);

        BigDecimal tasaAnual = new BigDecimal("2").divide(new BigDecimal("5"), 4, RoundingMode.HALF_UP);
        BigDecimal tasaMensual = tasaAnual.divide(new BigDecimal("12"), 4, RoundingMode.HALF_UP);
        BigDecimal expected = valorNetoActual.multiply(tasaMensual).setScale(4, RoundingMode.HALF_UP);
        assertEquals(expected, result);
    }

    @Test
    void calcularAceleradaReturnsZeroWhenAtResidual() {
        AfMaestro activo = crearActivo(new BigDecimal("10000.0000"), new BigDecimal("1000.0000"));
        BigDecimal valorNetoActual = new BigDecimal("1000.0000");

        BigDecimal result = service.calcularDepreciacionAcelerada(activo, 60, valorNetoActual);
        assertEquals(BigDecimal.ZERO, result);
    }

    @Test
    void calcularAceleradaReturnsZeroWhenBelowResidual() {
        AfMaestro activo = crearActivo(new BigDecimal("10000.0000"), new BigDecimal("1000.0000"));
        BigDecimal valorNetoActual = new BigDecimal("500.0000");

        BigDecimal result = service.calcularDepreciacionAcelerada(activo, 60, valorNetoActual);
        assertEquals(BigDecimal.ZERO, result);
    }

    @Test
    void calcularAceleradaCapsAtResidualValue() {
        AfMaestro activo = crearActivo(new BigDecimal("10000.0000"), new BigDecimal("9900.0000"));
        BigDecimal valorNetoActual = new BigDecimal("9950.0000");

        BigDecimal result = service.calcularDepreciacionAcelerada(activo, 60, valorNetoActual);
        BigDecimal maxDepreciacion = valorNetoActual.subtract(activo.getValorResidual());
        assertTrue(result.compareTo(maxDepreciacion) <= 0);
    }

    @Test
    void calcularAceleradaWithVidaUtilMenorDoce() {
        AfMaestro activo = crearActivo(new BigDecimal("10000.0000"), new BigDecimal("0.0000"));
        BigDecimal valorNetoActual = new BigDecimal("8000.0000");

        BigDecimal result = service.calcularDepreciacionAcelerada(activo, 6, valorNetoActual);

        BigDecimal tasaAnual = new BigDecimal("2").divide(new BigDecimal("1"), 4, RoundingMode.HALF_UP);
        BigDecimal tasaMensual = tasaAnual.divide(new BigDecimal("12"), 4, RoundingMode.HALF_UP);
        BigDecimal expected = valorNetoActual.multiply(tasaMensual).setScale(4, RoundingMode.HALF_UP);
        assertEquals(expected, result);
    }

    @Test
    void calcularUnidadesProduccionReturnsCorrectValue() {
        AfMaestro activo = crearActivo(new BigDecimal("10000.0000"), new BigDecimal("1000.0000"));

        BigDecimal result = service.calcularDepreciacionUnidadesProduccion(activo, 1000, 50);

        BigDecimal valorDepreciable = new BigDecimal("9000.0000");
        BigDecimal porUnidad = valorDepreciable.divide(new BigDecimal("1000"), 4, RoundingMode.HALF_UP);
        BigDecimal expected = porUnidad.multiply(new BigDecimal("50")).setScale(4, RoundingMode.HALF_UP);
        assertEquals(expected, result);
    }

    @Test
    void calcularUnidadesProduccionReturnsZeroWhenUnidadesTotalesNull() {
        AfMaestro activo = crearActivo(new BigDecimal("10000.0000"), new BigDecimal("1000.0000"));
        BigDecimal result = service.calcularDepreciacionUnidadesProduccion(activo, null, 50);
        assertEquals(BigDecimal.ZERO, result);
    }

    @Test
    void calcularUnidadesProduccionReturnsZeroWhenUnidadesTotalesZero() {
        AfMaestro activo = crearActivo(new BigDecimal("10000.0000"), new BigDecimal("1000.0000"));
        BigDecimal result = service.calcularDepreciacionUnidadesProduccion(activo, 0, 50);
        assertEquals(BigDecimal.ZERO, result);
    }

    @Test
    void calcularUnidadesProduccionReturnsZeroWhenUnidadesProducidasNull() {
        AfMaestro activo = crearActivo(new BigDecimal("10000.0000"), new BigDecimal("1000.0000"));
        BigDecimal result = service.calcularDepreciacionUnidadesProduccion(activo, 1000, null);
        assertEquals(BigDecimal.ZERO, result);
    }

    @Test
    void calcularUnidadesProduccionReturnsZeroWhenUnidadesProducidasZero() {
        AfMaestro activo = crearActivo(new BigDecimal("10000.0000"), new BigDecimal("1000.0000"));
        BigDecimal result = service.calcularDepreciacionUnidadesProduccion(activo, 1000, 0);
        assertEquals(BigDecimal.ZERO, result);
    }
}
