package pe.restaurant.finanzas.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.response.MonedaResponse;
import pe.restaurant.finanzas.dto.response.PlanContableDetResponse;
import pe.restaurant.finanzas.entity.BancoCnta;
import pe.restaurant.finanzas.repository.BancoCntaRepository;
import pe.restaurant.finanzas.service.impl.CuentaBancariaServiceImpl;
import pe.restaurant.common.dto.ApiResponse;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - CuentaBancariaService")
class CuentaBancariaServiceTest {

    @Mock
    private BancoCntaRepository cuentaBancariaRepository;

    @Mock
    private pe.restaurant.finanzas.repository.BancoRepository bancoRepository;

    @Mock
    private JdbcTemplate jdbcTemplate;

    @Mock
    private CoreMaestrosClient coreMaestrosClient;

    @InjectMocks
    private CuentaBancariaServiceImpl cuentaBancariaService;

    private BancoCnta cuentaBancaria;
    private Pageable pageable;

    @BeforeEach
    void setUp() {
        // Setup mock for BancoRepository (validación de foreign key)
        pe.restaurant.finanzas.entity.Banco banco = new pe.restaurant.finanzas.entity.Banco();
        banco.setId(1L);
        banco.setCodBanco("001");
        banco.setNomBanco("BANCO DE LA NACION");
        
        lenient().when(bancoRepository.findById(anyLong()))
                .thenReturn(Optional.of(banco));
        
        // Setup mock for CoreMaestrosClient (lenient para evitar UnnecessaryStubbingException)
        MonedaResponse monedaResponse = new MonedaResponse();
        monedaResponse.setId(1L);
        monedaResponse.setCodigo("PEN");
        monedaResponse.setNombre("Soles");
        monedaResponse.setSimbolo("S/");
        monedaResponse.setFlagEstado("1"); // Moneda activa
        
        lenient().when(coreMaestrosClient.obtenerMonedaPorId(anyLong()))
                .thenReturn(ApiResponse.ok(monedaResponse));

        lenient().when(coreMaestrosClient.obtenerPlanContableDetPorId(anyLong()))
                .thenAnswer(inv -> {
                    Long id = inv.getArgument(0);
                    PlanContableDetResponse p = new PlanContableDetResponse();
                    p.setId(id);
                    p.setCntaCtbl("10101101");
                    p.setNombre("STUB");
                    p.setFlagEstado("1");
                    return ApiResponse.ok(p);
                });
        
        // Setup test entity
        cuentaBancaria = new BancoCnta();
        cuentaBancaria.setId(1L);
        cuentaBancaria.setBancoId(1L);
        cuentaBancaria.setCodigo("CTA001");
        cuentaBancaria.setPlanContableDetId(101L);
        cuentaBancaria.setTipoCtaBco("AHORROS");
        cuentaBancaria.setDescripcion("CUENTA PRINCIPAL");
        cuentaBancaria.setCorrelativoCheque(100);
        cuentaBancaria.setMonedaId(1L);
        cuentaBancaria.setSaldoContable(BigDecimal.valueOf(1000.00));
        cuentaBancaria.setNroCci("001-123-0012345678");
        cuentaBancaria.setNroCuenta("001-123456-78");
        cuentaBancaria.setFlagEstado("1");

        // Setup pageable
        pageable = PageRequest.of(0, 10);
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("findAll - Debe retornar página de cuentas bancarias")
    void listar_conPaginacion_retornaPagina() {
        // Arrange
        Page<BancoCnta> expectedPage = new PageImpl<>(List.of(cuentaBancaria), pageable, 1);
        when(cuentaBancariaRepository.findAll(pageable)).thenReturn(expectedPage);

        // Act
        Page<BancoCnta> result = cuentaBancariaService.findAll(pageable);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        assertThat(result.getContent().get(0).getCodigo()).isEqualTo("CTA001");
        verify(cuentaBancariaRepository, times(1)).findAll(pageable);
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    @DisplayName("findById - Debe retornar cuenta bancaria cuando existe")
    void obtenerPorId_cuandoExiste_retornaEntidad() {
        // Arrange
        when(cuentaBancariaRepository.findById(1L)).thenReturn(Optional.of(cuentaBancaria));

        // Act
        BancoCnta result = cuentaBancariaService.findById(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getCodigo()).isEqualTo("CTA001");
        assertThat(result.getDescripcion()).isEqualTo("CUENTA PRINCIPAL");
        verify(cuentaBancariaRepository, times(1)).findById(1L);
    }


    // ==== obtenerPorId — otros ====

    @Test
    @DisplayName("findById - lanza ResourceNotFoundException cuando no existe")
    void obtenerPorId_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(cuentaBancariaRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Then
        assertThatThrownBy(() -> cuentaBancariaService.findById(1L)).isInstanceOf(RuntimeException.class);
        verify(cuentaBancariaRepository, times(1)).findById(1L);
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("create - Debe crear cuenta bancaria exitosamente")
    void crear_conDatosValidos_creaEntidad() {
        // Arrange
        BancoCnta newCuenta = new BancoCnta();
        newCuenta.setBancoId(1L);
        newCuenta.setCodigo("CTA002");
        newCuenta.setPlanContableDetId(102L);
        newCuenta.setTipoCtaBco("CORRIENTE");
        newCuenta.setDescripcion("CUENTA SECUNDARIA");
        newCuenta.setMonedaId(1L);
        newCuenta.setSaldoContable(BigDecimal.valueOf(500.00));
        newCuenta.setNroCci("002-987-0098765432");
        newCuenta.setNroCuenta("002-987654-32");

        when(cuentaBancariaRepository.save(any(BancoCnta.class))).thenReturn(newCuenta);
        when(cuentaBancariaRepository.existsByCodigoIgnoreCase(anyString())).thenReturn(false);

        // Act
        BancoCnta result = cuentaBancariaService.create(newCuenta);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getCodigo()).isEqualTo("CTA002");
        assertThat(result.getDescripcion()).isEqualTo("CUENTA SECUNDARIA");
        assertThat(result.getSaldoContable()).isEqualTo(BigDecimal.valueOf(500.00));
        verify(cuentaBancariaRepository, times(1)).save(any(BancoCnta.class));
    }


    // ==== crear — otros ====

    @Test
    @DisplayName("create - Debe lanzar excepción cuando código ya existe")
    void crear_conCodigoDuplicado_lanzaBusinessException() {
        // Arrange
        BancoCnta newCuenta = new BancoCnta();
        newCuenta.setBancoId(1L);
        newCuenta.setPlanContableDetId(500L);
        newCuenta.setCodigo("CTA001");
        newCuenta.setDescripcion("DUPLICADO");
        newCuenta.setTipoCtaBco("AHORROS");

        when(cuentaBancariaRepository.existsByCodigoIgnoreCase("CTA001")).thenReturn(true);

        // Act & Then
        assertThatThrownBy(() -> cuentaBancariaService.create(newCuenta)).isInstanceOf(RuntimeException.class);
        verify(cuentaBancariaRepository, never()).save(any(BancoCnta.class));
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("update - Debe actualizar cuenta bancaria exitosamente")
    void actualizar_conDatosValidos_actualizaEntidad() {
        // Arrange
        BancoCnta updateData = new BancoCnta();
        updateData.setBancoId(2L);
        updateData.setCodigo("CTA003");
        updateData.setPlanContableDetId(103L);
        updateData.setTipoCtaBco("PLAZO FIJO");
        updateData.setDescripcion("CUENTA ACTUALIZADA");
        updateData.setMonedaId(2L);
        updateData.setSaldoContable(BigDecimal.valueOf(2000.00));
        updateData.setNroCci("003-654-0034567890");
        updateData.setNroCuenta("003-654321-09");

        when(cuentaBancariaRepository.findById(1L)).thenReturn(Optional.of(cuentaBancaria));
        when(cuentaBancariaRepository.save(any(BancoCnta.class))).thenReturn(cuentaBancaria);
        when(cuentaBancariaRepository.existsByCodigoIgnoreCaseAndIdNot(anyString(), anyLong())).thenReturn(false);

        // Act
        BancoCnta result = cuentaBancariaService.update(1L, updateData);

        // Assert
        assertThat(result).isNotNull();
        verify(cuentaBancariaRepository, times(1)).findById(1L);
        verify(cuentaBancariaRepository, times(1)).save(any(BancoCnta.class));
    }


    // ==== actualizar — otros ====

    @Test
    @DisplayName("update - lanza ResourceNotFoundException cuando no existe")
    void actualizar_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        BancoCnta updateData = new BancoCnta();
        updateData.setCodigo("CTA003");
        updateData.setDescripcion("NO EXISTE");
        updateData.setTipoCtaBco("AHORROS");

        when(cuentaBancariaRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Then
        assertThatThrownBy(() -> cuentaBancariaService.update(1L, updateData)).isInstanceOf(RuntimeException.class);
        verify(cuentaBancariaRepository, never()).save(any(BancoCnta.class));
    }


    // ==== activar — escenarios felices ====

    @Test
    @DisplayName("activate - Debe activar cuenta bancaria")
    void activar_conIdValido_activaEntidad() {
        // Arrange
        cuentaBancaria.setFlagEstado("0");
        when(cuentaBancariaRepository.findById(1L)).thenReturn(Optional.of(cuentaBancaria));
        when(cuentaBancariaRepository.save(any(BancoCnta.class))).thenReturn(cuentaBancaria);

        // Act
        BancoCnta result = cuentaBancariaService.activate(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("1");
        verify(cuentaBancariaRepository, times(1)).save(any(BancoCnta.class));
    }


    // ==== desactivar — escenarios felices ====

    @Test
    @DisplayName("deactivate - Debe desactivar cuenta bancaria")
    void desactivar_conIdValido_desactivaEntidad() {
        // Arrange
        when(cuentaBancariaRepository.findById(1L)).thenReturn(Optional.of(cuentaBancaria));
        when(cuentaBancariaRepository.save(any(BancoCnta.class))).thenReturn(cuentaBancaria);

        // Act
        BancoCnta result = cuentaBancariaService.deactivate(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("0");
        verify(cuentaBancariaRepository, times(1)).save(any(BancoCnta.class));
    }


    // ==== eliminar — escenarios felices ====

    @Test
    @DisplayName("delete - Debe eliminar cuenta bancaria")
    void eliminar_conIdValido_eliminaEntidad() {
        // Arrange
        when(cuentaBancariaRepository.findById(1L)).thenReturn(Optional.of(cuentaBancaria));
        doNothing().when(cuentaBancariaRepository).delete(any(BancoCnta.class));

        // Act
        cuentaBancariaService.delete(1L);

        // Assert
        verify(cuentaBancariaRepository, times(1)).findById(1L);
        verify(cuentaBancariaRepository, times(1)).delete(any(BancoCnta.class));
    }


    // ==== eliminar — otros ====

    @Test
    @DisplayName("delete - lanza ResourceNotFoundException cuando no existe")
    void eliminar_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(cuentaBancariaRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Then
        assertThatThrownBy(() -> cuentaBancariaService.delete(1L)).isInstanceOf(RuntimeException.class);
        verify(cuentaBancariaRepository, never()).delete(any(BancoCnta.class));
    }


    // ==== getSaldoActual — escenarios felices ====

    @Test
    @DisplayName("getSaldoActual - Debe retornar saldo contable")
    void getSaldoActual_cuandoExiste_retornaSaldo() {
        // Arrange
        BigDecimal expectedSaldo = BigDecimal.valueOf(1500.50);
        when(cuentaBancariaRepository.findSaldoContableById(1L)).thenReturn(expectedSaldo);

        // Act
        BigDecimal result = cuentaBancariaService.getSaldoActual(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result).isEqualTo(expectedSaldo);
        verify(cuentaBancariaRepository, times(1)).findSaldoContableById(1L);
    }


    // ==== getSaldoActual — otros ====

    @Test
    @DisplayName("getSaldoActual - lanza ResourceNotFoundException cuando no existe")
    void getSaldoActual_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(cuentaBancariaRepository.findSaldoContableById(1L)).thenReturn(null);

        // Act & Then
        assertThatThrownBy(() -> cuentaBancariaService.getSaldoActual(1L)).isInstanceOf(RuntimeException.class);
        verify(cuentaBancariaRepository, times(1)).findSaldoContableById(1L);
    }
}
