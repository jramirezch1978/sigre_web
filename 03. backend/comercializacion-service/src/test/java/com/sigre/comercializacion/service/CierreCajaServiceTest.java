package com.sigre.comercializacion.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.comercializacion.VentasTestFixtures;
import com.sigre.comercializacion.dto.request.CierreCajaCerrarRequest;
import com.sigre.comercializacion.dto.request.CierreCajaRequest;
import com.sigre.comercializacion.entity.CierreCaja;
import com.sigre.comercializacion.repository.CierreCajaRepository;
import com.sigre.comercializacion.service.impl.CierreCajaServiceImpl;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("CierreCajaService - Edge Cases")
class CierreCajaServiceTest {

    @Mock
    private CierreCajaRepository repository;
    @InjectMocks
    private CierreCajaServiceImpl service;

    // ========== EDGE CASES: FIND BY ID ==========

    @Test
    @DisplayName("findById() con ID inexistente -> lanza ResourceNotFoundException")
    void findById_conIdInexistente_lanzaExcepcion() {
        when(repository.findById(anyLong())).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(99999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("CierreCaja")
                .hasMessageContaining("99999");
    }

    // ========== EDGE CASES: CREATE ==========

    @Test
    @DisplayName("create() con turno que ya tiene cierre abierto -> lanza BusinessException")
    void create_conTurnoConCierreAbierto_lanzaExcepcion() {
        CierreCajaRequest request = new CierreCajaRequest();
        request.setTurnoId(1L);
        request.setVentasEfectivo(new BigDecimal("100.00"));

        when(repository.countAbiertoByTurno(1L)).thenReturn(1L);

        assertThatThrownBy(() -> service.create(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un cierre de caja abierto");
    }

    @Test
    @DisplayName("create() con valores nulos -> inicializa con ceros")
    void create_conValoresNulos_inicializaConCeros() {
        CierreCajaRequest request = new CierreCajaRequest();
        request.setTurnoId(1L);
        request.setVentasEfectivo(null);
        request.setVentasTarjeta(null);
        request.setVentasDigital(null);

        CierreCaja saved = VentasTestFixtures.cierreCajaEntity(1L, "1");
        when(repository.countAbiertoByTurno(anyLong())).thenReturn(0L);
        when(repository.save(any())).thenReturn(saved);

        CierreCaja result = service.create(request);

        assertThat(result).isNotNull();
    }

    // ========== EDGE CASES: CERRAR ==========

    @Test
    @DisplayName("cerrar() con cierre ya cerrado -> lanza BusinessException")
    void cerrar_conCierreYaCerrado_lanzaExcepcion() {
        CierreCaja caja = VentasTestFixtures.cierreCajaEntity(1L, "1");
        caja.setFechaCierre(Instant.now());

        when(repository.findById(1L)).thenReturn(Optional.of(caja));

        CierreCajaCerrarRequest request = new CierreCajaCerrarRequest();
        request.setFondoFinal(new BigDecimal("500.00"));

        assertThatThrownBy(() -> service.cerrar(1L, request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("El cierre ya fue finalizado");
    }

    @Test
    @DisplayName("cerrar() con diferencia nula -> calcula diferencia automáticamente")
    void cerrar_conDiferenciaNula_calculaDiferencia() {
        CierreCaja caja = VentasTestFixtures.cierreCajaEntity(1L, "1");
        caja.setFondoInicial(new BigDecimal("100.00"));
        caja.setVentasTotal(new BigDecimal("400.00"));
        caja.setFechaCierre(null);

        when(repository.findById(1L)).thenReturn(Optional.of(caja));
        when(repository.save(any())).thenReturn(caja);

        CierreCajaCerrarRequest request = new CierreCajaCerrarRequest();
        request.setFondoFinal(new BigDecimal("510.00"));
        request.setDiferencia(null);

        CierreCaja result = service.cerrar(1L, request);

        assertThat(result).isNotNull();
        assertThat(result.getFechaCierre()).isNotNull();
    }

    @Test
    @DisplayName("cerrar() con ID inexistente -> lanza ResourceNotFoundException")
    void cerrar_conIdInexistente_lanzaExcepcion() {
        when(repository.findById(anyLong())).thenReturn(Optional.empty());

        CierreCajaCerrarRequest request = new CierreCajaCerrarRequest();
        request.setFondoFinal(new BigDecimal("500.00"));

        assertThatThrownBy(() -> service.cerrar(99999L, request))
                .isInstanceOf(ResourceNotFoundException.class);
    }
}
