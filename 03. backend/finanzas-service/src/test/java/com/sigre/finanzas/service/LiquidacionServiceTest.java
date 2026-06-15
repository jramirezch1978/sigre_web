package com.sigre.finanzas.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.finanzas.dto.request.LiquidacionDetalleRequest;
import com.sigre.finanzas.dto.request.LiquidacionRequest;
import com.sigre.finanzas.dto.response.LiquidacionDetalleResponse;
import com.sigre.finanzas.dto.response.LiquidacionResponse;
import com.sigre.finanzas.dto.response.ValidacionCierreResponse;
import com.sigre.finanzas.entity.Liquidacion;
import com.sigre.finanzas.entity.LiquidacionDet;
import com.sigre.finanzas.entity.SolicitudGiro;
import com.sigre.finanzas.mapper.LiquidacionDetMapper;
import com.sigre.finanzas.mapper.LiquidacionMapper;
import com.sigre.finanzas.repository.LiquidacionDetRepository;
import com.sigre.finanzas.repository.LiquidacionRepository;
import com.sigre.finanzas.repository.SolicitudGiroRepository;
import com.sigre.common.service.NumeradorDocumentoService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class LiquidacionServiceTest {

    @Mock
    private LiquidacionRepository repository;

    @Mock
    private LiquidacionDetRepository detRepository;

    @Mock
    private SolicitudGiroRepository solicitudGiroRepository;

    @Mock
    private LiquidacionMapper mapper;

    @Mock
    private LiquidacionDetMapper detMapper;

    @Mock
    private NumeradorDocumentoService numeradorDocumentoService;

    @InjectMocks
    private LiquidacionService service;

    private Liquidacion liquidacion;
    private LiquidacionRequest request;
    private LiquidacionResponse response;
    private LiquidacionDetalleResponse detalleResponse;
    private SolicitudGiro solicitudGiro;

    @BeforeEach
    void setUp() {
        liquidacion = new Liquidacion();
        liquidacion.setId(1L);
        liquidacion.setSolicitudGiroId(4L);
        liquidacion.setFlagEstado("1");
        liquidacion.setImporteNeto(new BigDecimal("4800.00"));
        liquidacion.setTasaCambio(BigDecimal.ONE);
        liquidacion.setFechaRegistro(LocalDate.now());
        liquidacion.setConceptoFinancieroId(1L);
        // nroLiquidacion NO se setea — se genera vía NumeradorDocumentoService

        solicitudGiro = new SolicitudGiro();
        solicitudGiro.setId(4L);
        solicitudGiro.setNumero("SG-20260429-0001");
        solicitudGiro.setFlagEstado("1");

        request = new LiquidacionRequest();
        request.setSolicitudGiroId(4L);
        request.setSucursalId(1L);
        request.setCntblLibroId(1L);
        request.setImporteNeto(new BigDecimal("4800.00"));
        request.setTasaCambio(BigDecimal.ONE);
        request.setConceptoFinancieroId(1L);
        
        List<LiquidacionDetalleRequest> detalles = new ArrayList<>();
        LiquidacionDetalleRequest det1 = new LiquidacionDetalleRequest();
        det1.setItem(1);
        det1.setImporte(new BigDecimal("2500.00"));
        det1.setFactorSigno((short) 1);
        det1.setConceptoFinancieroId(1L);
        detalles.add(det1);
        
        LiquidacionDetalleRequest det2 = new LiquidacionDetalleRequest();
        det2.setItem(2);
        det2.setImporte(new BigDecimal("2300.00"));
        det2.setFactorSigno((short) 1);
        det2.setConceptoFinancieroId(1L);
        detalles.add(det2);
        
        request.setDetalles(detalles);

        response = new LiquidacionResponse();
        response.setId(1L);
        response.setNroLiquidacion("LQ-20260429-0001");

        detalleResponse = new LiquidacionDetalleResponse();
        detalleResponse.setId(1L);
        detalleResponse.setNroLiquidacion("LQ-20260429-0001");
        detalleResponse.setFlagEstado("1");
    }


    // ==== listarLiquidaciones — otros ====

    @Test
    void listarLiquidaciones_DebeRetornarPaginaDeResultados() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<Liquidacion> page = new PageImpl<>(List.of(liquidacion));
        
        when(repository.findAll(any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any(Liquidacion.class))).thenReturn(response);

        Page<LiquidacionResponse> result = service.listarLiquidaciones(pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findAll(any(Pageable.class));
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    void obtenerPorId_DebeRetornarLiquidacion_CuandoExiste() {
        when(repository.findById(eq(1L))).thenReturn(Optional.of(liquidacion));
        when(mapper.toDetalleResponse(any(Liquidacion.class))).thenReturn(detalleResponse);

        LiquidacionDetalleResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getNroLiquidacion()).isEqualTo("LQ-20260429-0001");
        verify(repository).findById(eq(1L));
    }


    // ==== obtenerPorId — otros ====

    @Test
    void obtenerPorId_DebeLanzarExcepcion_CuandoNoExiste() {
        when(repository.findById(eq(999L))).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L)).isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(eq(999L));
    }


    // ==== crearLiquidacion — escenarios felices ====

    @Test
    void crearLiquidacion_DebeCrearYRetornarLiquidacion() {
        when(solicitudGiroRepository.findById(eq(4L))).thenReturn(Optional.of(solicitudGiro));
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), anyLong(), anyInt())).thenReturn("LQ-20260429-0001");
        when(mapper.toEntity(any(LiquidacionRequest.class))).thenReturn(liquidacion);
        when(repository.save(any(Liquidacion.class))).thenReturn(liquidacion);
        when(detMapper.toEntity(any(LiquidacionDetalleRequest.class))).thenReturn(new LiquidacionDet());
        when(mapper.toDetalleResponse(any(Liquidacion.class))).thenReturn(detalleResponse);

        LiquidacionDetalleResponse result = service.crearLiquidacion(request);

        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("1");
        verify(solicitudGiroRepository).findById(eq(4L));
        verify(repository, times(2)).save(any(Liquidacion.class));
    }


    // ==== crearLiquidacion — otros ====

    @Test
    void crearLiquidacion_DebeLanzarExcepcion_CuandoSolicitudGiroNoExiste() {
        when(solicitudGiroRepository.findById(eq(4L))).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.crearLiquidacion(request)).isInstanceOf(ResourceNotFoundException.class);
        verify(solicitudGiroRepository).findById(eq(4L));
        verify(repository, never()).save(any());
    }


    // ==== crearLiquidacion — escenarios felices ====

    @Test
    void crearLiquidacion_DebeLanzarExcepcion_CuandoSolicitudGiroInactiva() {
        solicitudGiro.setFlagEstado("0");
        when(solicitudGiroRepository.findById(eq(4L))).thenReturn(Optional.of(solicitudGiro));

        assertThatThrownBy(() -> service.crearLiquidacion(request)).isInstanceOf(BusinessException.class);
        verify(solicitudGiroRepository).findById(eq(4L));
        verify(repository, never()).save(any());
    }

    @Test
    void crearLiquidacion_DebeLanzarExcepcion_CuandoTotalesNoCuadran() {
        request.setImporteNeto(new BigDecimal("5000.00"));
        when(solicitudGiroRepository.findById(eq(4L))).thenReturn(Optional.of(solicitudGiro));

        assertThatThrownBy(() -> service.crearLiquidacion(request)).isInstanceOf(BusinessException.class);
        verify(repository, never()).save(any());
    }


    // ==== actualizarLiquidacion — escenarios felices ====

    @Test
    void actualizarLiquidacion_DebeActualizarYRetornar() {
        when(repository.findById(eq(1L))).thenReturn(Optional.of(liquidacion));
        when(repository.save(any(Liquidacion.class))).thenReturn(liquidacion);
        when(repository.saveAndFlush(any(Liquidacion.class))).thenReturn(liquidacion);
        when(detMapper.toEntity(any(LiquidacionDetalleRequest.class))).thenReturn(new LiquidacionDet());
        when(mapper.toDetalleResponse(any(Liquidacion.class))).thenReturn(detalleResponse);

        LiquidacionDetalleResponse result = service.actualizarLiquidacion(1L, request);

        assertThat(result).isNotNull();
        verify(repository).findById(eq(1L));
        verify(repository).saveAndFlush(any(Liquidacion.class));
        verify(repository).save(any(Liquidacion.class));
    }

    @Test
    void actualizarLiquidacion_DebeLanzarExcepcion_CuandoEstadoNoCorrecto() {
        liquidacion.setFlagEstado("2");
        when(repository.findById(eq(1L))).thenReturn(Optional.of(liquidacion));

        assertThatThrownBy(() -> service.actualizarLiquidacion(1L, request)).isInstanceOf(BusinessException.class);
        verify(repository).findById(eq(1L));
        verify(repository, never()).save(any());
    }


    // ==== anularLiquidacion — otros ====

    @Test
    void anularLiquidacion_DebeAnularYRetornar() {
        when(repository.findById(eq(1L))).thenReturn(Optional.of(liquidacion));
        when(repository.save(any(Liquidacion.class))).thenReturn(liquidacion);

        Map<String, Object> result = service.anularLiquidacion(1L);

        assertThat(result).isNotNull();
        assertThat(result.get("id")).isEqualTo(1L);
        assertThat(result.get("flagEstado")).isEqualTo("0");
        verify(repository).findById(eq(1L));
        verify(repository).save(argThat(liq -> "0".equals(liq.getFlagEstado())));
    }

    @Test
    void anularLiquidacion_DebeLanzarExcepcion_CuandoEstaCerrada() {
        liquidacion.setFlagEstado("2");
        when(repository.findById(eq(1L))).thenReturn(Optional.of(liquidacion));

        assertThatThrownBy(() -> service.anularLiquidacion(1L)).isInstanceOf(BusinessException.class);
        verify(repository).findById(eq(1L));
        verify(repository, never()).save(any());
    }


    // ==== validarCierre — escenarios felices ====

    @Test
    void validarCierre_DebeRetornarValidacion() {
        when(repository.findById(eq(1L))).thenReturn(Optional.of(liquidacion));
        when(detRepository.calcularSumaImportes(eq(1L))).thenReturn(new BigDecimal("4800.00"));
        when(solicitudGiroRepository.findById(eq(4L))).thenReturn(Optional.of(solicitudGiro));

        ValidacionCierreResponse result = service.validarCierre(1L);

        assertThat(result).isNotNull();
        assertThat(result.getCuadrado()).isTrue();
        assertThat(result.getPuedeCerrar()).isTrue();
        verify(repository).findById(eq(1L));
        verify(detRepository).calcularSumaImportes(eq(1L));
    }


    // ==== validarCierre — otros ====

    @Test
    void validarCierre_DebeRetornarNoCuadrado_CuandoImportesNoCuadran() {
        when(repository.findById(eq(1L))).thenReturn(Optional.of(liquidacion));
        when(detRepository.calcularSumaImportes(eq(1L))).thenReturn(new BigDecimal("5000.00"));
        when(solicitudGiroRepository.findById(eq(4L))).thenReturn(Optional.of(solicitudGiro));

        ValidacionCierreResponse result = service.validarCierre(1L);

        assertThat(result).isNotNull();
        assertThat(result.getCuadrado()).isFalse();
        assertThat(result.getPuedeCerrar()).isFalse();
    }


    // ==== cerrarLiquidacion — otros ====

    @Test
    void cerrarLiquidacion_DebeCerrar() {
        when(repository.findById(eq(1L))).thenReturn(Optional.of(liquidacion));
        when(detRepository.calcularSumaImportes(eq(1L))).thenReturn(new BigDecimal("4800.00"));
        when(repository.save(any(Liquidacion.class))).thenReturn(liquidacion);
        when(mapper.toDetalleResponse(any(Liquidacion.class))).thenReturn(detalleResponse);

        LiquidacionDetalleResponse result = service.cerrarLiquidacion(1L, "Cierre aprobado");

        assertThat(result).isNotNull();
        verify(repository).findById(eq(1L));
        verify(repository).save(argThat(liq -> "2".equals(liq.getFlagEstado())));
    }

    @Test
    void cerrarLiquidacion_DebeLanzarExcepcion_CuandoEstadoIncorrecto() {
        liquidacion.setFlagEstado("0");
        when(repository.findById(eq(1L))).thenReturn(Optional.of(liquidacion));

        assertThatThrownBy(() -> service.cerrarLiquidacion(1L, "Test")).isInstanceOf(BusinessException.class);
        verify(repository).findById(eq(1L));
        verify(repository, never()).save(any());
    }

    @Test
    void cerrarLiquidacion_DebeLanzarExcepcion_CuandoTotalesNoCuadran() {
        when(repository.findById(eq(1L))).thenReturn(Optional.of(liquidacion));
        when(detRepository.calcularSumaImportes(eq(1L))).thenReturn(new BigDecimal("5000.00"));

        assertThatThrownBy(() -> service.cerrarLiquidacion(1L, "Test")).isInstanceOf(BusinessException.class);
        verify(repository).findById(eq(1L));
        verify(repository, never()).save(any());
    }


    // ==== crearLiquidacion — otros ====

    @Test
    void crearLiquidacion_DebeLanzarExcepcion_CuandoAmbosCamposSonNull() {
        // Crear detalle con ambos campos nulos
        LiquidacionDetalleRequest detInvalido = new LiquidacionDetalleRequest();
        detInvalido.setItem(1);
        detInvalido.setImporte(new BigDecimal("2500.00"));
        detInvalido.setFactorSigno((short) 1);
        detInvalido.setConceptoFinancieroId(1L);
        detInvalido.setCntasPagarId(null);
        detInvalido.setCntasCobrarId(null);
        
        request.setDetalles(List.of(detInvalido));
        
        // La validación debe ocurrir antes de llegar al servicio
        // Este test verifica que la validación personalizada funciona
        assertThatThrownBy(() -> {
            jakarta.validation.Validator validator = jakarta.validation.Validation.buildDefaultValidatorFactory().getValidator();
            var violations = validator.validate(detInvalido);
            if (!violations.isEmpty()) {
                throw new jakarta.validation.ConstraintViolationException(violations);
            }
        }).isInstanceOf(jakarta.validation.ConstraintViolationException.class);
    }

    @Test
    void crearLiquidacion_DebePermitir_CuandoSoloCntasPagarIdNoEsNull() {
        // Crear detalle con solo cntasPagarId no nulo
        LiquidacionDetalleRequest detValido = new LiquidacionDetalleRequest();
        detValido.setItem(1);
        detValido.setImporte(new BigDecimal("2500.00"));
        detValido.setFactorSigno((short) 1);
        detValido.setCntasPagarId(100L);
        detValido.setCntasCobrarId(null);
        detValido.setConceptoFinancieroId(1L);
        
        request.setDetalles(List.of(detValido));
        
        // La validación debe pasar
        jakarta.validation.Validator validator = jakarta.validation.Validation.buildDefaultValidatorFactory().getValidator();
        var violations = validator.validate(detValido);
        assertThat(violations.isEmpty()).isTrue();
    }

    @Test
    void crearLiquidacion_DebePermitir_CuandoSoloCntasCobrarIdNoEsNull() {
        // Crear detalle con solo cntasCobrarId no nulo
        LiquidacionDetalleRequest detValido = new LiquidacionDetalleRequest();
        detValido.setItem(1);
        detValido.setImporte(new BigDecimal("2500.00"));
        detValido.setFactorSigno((short) 1);
        detValido.setCntasPagarId(null);
        detValido.setCntasCobrarId(200L);
        detValido.setConceptoFinancieroId(1L);
        
        request.setDetalles(List.of(detValido));
        
        // La validación debe pasar
        jakarta.validation.Validator validator = jakarta.validation.Validation.buildDefaultValidatorFactory().getValidator();
        var violations = validator.validate(detValido);
        assertThat(violations.isEmpty()).isTrue();
    }
}
