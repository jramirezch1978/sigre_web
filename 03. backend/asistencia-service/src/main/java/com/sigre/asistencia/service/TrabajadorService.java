package com.sigre.asistencia.service;

import com.sigre.asistencia.dto.TrabajadorResponseDto;
import com.sigre.asistencia.entity.Maestro;
import com.sigre.asistencia.entity.RrhhAsignaTrjtReloj;
import com.sigre.asistencia.repository.MaestroRepository;
import com.sigre.asistencia.repository.RrhhAsignaTrjtRelojRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class TrabajadorService {
    
    private final MaestroRepository maestroRepository;
    private final RrhhAsignaTrjtRelojRepository tarjetaRepository;
    
    /**
     * Buscar trabajador por código de trabajador, DNI o código de tarjeta
     */
    public Optional<TrabajadorResponseDto> buscarTrabajadorPorCodigo(String codigo) {
        log.info("Buscando trabajador por código: {}", codigo);
        
        try {
            // Buscar por código de trabajador directo
            Optional<Maestro> trabajadorPorCodigo = maestroRepository.findByCodTrabajadorAndFlagEstado(codigo, "1");
            if (trabajadorPorCodigo.isPresent()) {
                log.info("Trabajador encontrado por código: {}", trabajadorPorCodigo.get().getCodTrabajador());
                return Optional.of(new TrabajadorResponseDto(trabajadorPorCodigo.get()));
            }
            
            // Buscar por DNI
            Optional<Maestro> trabajadorPorDni = maestroRepository.findByDniAndFlagEstado(codigo, "1");
            if (trabajadorPorDni.isPresent()) {
                log.info("Trabajador encontrado por DNI: {}", trabajadorPorDni.get().getCodTrabajador());
                return Optional.of(new TrabajadorResponseDto(trabajadorPorDni.get()));
            }
            
            // Buscar por código de tarjeta vigente
            Optional<RrhhAsignaTrjtReloj> tarjetaVigente = tarjetaRepository.findTarjetaVigente(codigo, LocalDate.now());
            if (tarjetaVigente.isPresent()) {
                String codTrabajador = tarjetaVigente.get().getCodTrabajador();
                Optional<Maestro> trabajadorPorTarjeta = maestroRepository.findByCodTrabajadorAndFlagEstado(codTrabajador, "1");
                if (trabajadorPorTarjeta.isPresent()) {
                    log.info("Trabajador encontrado por tarjeta: {} -> {}", codigo, trabajadorPorTarjeta.get().getCodTrabajador());
                    return Optional.of(new TrabajadorResponseDto(trabajadorPorTarjeta.get()));
                }
            }
            
            log.warn("No se encontró trabajador para el código: {}", codigo);
            return Optional.empty();
            
        } catch (Exception e) {
            log.error("Error al buscar trabajador por código: {}", codigo, e);
            return Optional.empty();
        }
    }
    
    /**
     * Validar que un trabajador puede marcar asistencia
     */
    public boolean puedeMarcarAsistencia(String codTrabajador) {
        try {
            Optional<Maestro> trabajador = maestroRepository.findByCodTrabajadorAndFlagEstado(codTrabajador, "1");
            if (trabajador.isEmpty()) {
                log.warn("Trabajador no encontrado o inactivo: {}", codTrabajador);
                return false;
            }
            
            // Verificar si está habilitado para marcar reloj
            boolean puedeMarcar = trabajador.get().isMarcaReloj();
            log.info("Trabajador {} puede marcar asistencia: {}", codTrabajador, puedeMarcar);
            return puedeMarcar;
            
        } catch (Exception e) {
            log.error("Error al validar si trabajador puede marcar asistencia: {}", codTrabajador, e);
            return false;
        }
    }
    
    /**
     * Verificar integridad de tarjetas asignadas
     */
    public void verificarIntegridadTarjetas(String codTrabajador) {
        try {
            Long tarjetasActivas = tarjetaRepository.countTarjetasActivasByTrabajador(codTrabajador, LocalDate.now());
            if (tarjetasActivas > 1) {
                log.warn("ALERTA: Trabajador {} tiene {} tarjetas activas. Debería tener máximo 1.", 
                        codTrabajador, tarjetasActivas);
            }
        } catch (Exception e) {
            log.error("Error al verificar integridad de tarjetas para trabajador: {}", codTrabajador, e);
        }
    }
}
