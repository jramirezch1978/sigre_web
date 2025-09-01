package com.sigre.asistencia.service;

import com.sigre.asistencia.entity.Maestro;
import com.sigre.asistencia.entity.RrhhAsignaTrjtReloj;
import com.sigre.asistencia.repository.MaestroRepository;
import com.sigre.asistencia.repository.RrhhAsignaTrjtRelojRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

/**
 * Servicio para validar códigos de entrada (DNI, código trabajador, código tarjeta)
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ValidacionTrabajadorService {
    
    private final MaestroRepository maestroRepository;
    private final RrhhAsignaTrjtRelojRepository tarjetaRepository;
    
    /**
     * Validar código de entrada y retornar información del trabajador
     */
    public ResultadoValidacion validarCodigo(String codigoInput) {
        log.info("🔍 Validando código de entrada: {}", codigoInput);
        
        // Intentar validar como DNI
        Optional<Maestro> porDni = maestroRepository.findByDniAndFlagEstado(codigoInput, "1");
        if (porDni.isPresent()) {
            Maestro trabajador = porDni.get();
            log.info("✅ Trabajador encontrado por DNI: {} - {}", trabajador.getCodTrabajador(), trabajador.getNombreCompleto());
            return ResultadoValidacion.exitoso(trabajador, "DNI");
        }
        
        // Intentar validar como código de trabajador
        Optional<Maestro> porCodigo = maestroRepository.findByCodTrabajadorAndFlagEstado(codigoInput, "1");
        if (porCodigo.isPresent()) {
            Maestro trabajador = porCodigo.get();
            log.info("✅ Trabajador encontrado por código: {} - {}", trabajador.getCodTrabajador(), trabajador.getNombreCompleto());
            return ResultadoValidacion.exitoso(trabajador, "CODIGO_TRABAJADOR");
        }
        
        // Intentar validar como código de tarjeta
        Optional<RrhhAsignaTrjtReloj> tarjetaOpt = tarjetaRepository.findTarjetaVigente(codigoInput, LocalDateTime.now().toLocalDate());
        if (tarjetaOpt.isPresent()) {
            RrhhAsignaTrjtReloj tarjeta = tarjetaOpt.get();
            
            // Buscar el trabajador asociado a la tarjeta
            Optional<Maestro> trabajadorOpt = maestroRepository.findByCodTrabajadorAndFlagEstado(tarjeta.getCodTrabajador(), "1");
            if (trabajadorOpt.isPresent()) {
                Maestro trabajador = trabajadorOpt.get();
                log.info("✅ Trabajador encontrado por tarjeta: {} - {} (Tarjeta: {})", 
                        trabajador.getCodTrabajador(), trabajador.getNombreCompleto(), codigoInput);
                return ResultadoValidacion.exitoso(trabajador, "CODIGO_TARJETA");
            } else {
                log.error("❌ Tarjeta {} válida pero trabajador {} no encontrado", codigoInput, tarjeta.getCodTrabajador());
                return ResultadoValidacion.error("Tarjeta válida pero trabajador asociado no encontrado. Contacte RRHH.");
            }
        }
        
        // No se encontró en ninguna opción
        log.warn("❌ Código {} no encontrado en ninguna tabla", codigoInput);
        return ResultadoValidacion.error("El código ingresado no existe. Por favor validar con Recursos Humanos. Código: " + codigoInput);
    }
    
    /**
     * DTO para resultado de validación
     */
    @lombok.Data
    @lombok.Builder
    @lombok.AllArgsConstructor
    public static class ResultadoValidacion {
        private boolean valido;
        private Maestro trabajador;
        private String tipoInput; // "DNI", "CODIGO_TRABAJADOR", "CODIGO_TARJETA"
        private String mensajeError;
        
        public static ResultadoValidacion exitoso(Maestro trabajador, String tipoInput) {
            return ResultadoValidacion.builder()
                    .valido(true)
                    .trabajador(trabajador)
                    .tipoInput(tipoInput)
                    .mensajeError(null)
                    .build();
        }
        
        public static ResultadoValidacion error(String mensajeError) {
            return ResultadoValidacion.builder()
                    .valido(false)
                    .trabajador(null)
                    .tipoInput(null)
                    .mensajeError(mensajeError)
                    .build();
        }
    }
}
