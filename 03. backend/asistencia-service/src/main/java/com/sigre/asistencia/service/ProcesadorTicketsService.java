package com.sigre.asistencia.service;

import com.sigre.asistencia.entity.TicketAsistencia;
import com.sigre.asistencia.repository.TicketAsistenciaRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

/**
 * Servicio para procesar la cola de tickets de forma asíncrona
 * Se ejecuta en background procesando tickets pendientes
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ProcesadorTicketsService {
    
    private final TicketAsistenciaRepository ticketRepository;
    private final TicketAsistenciaService ticketService;
    
    @Value("${asistencia.config.procesamiento.async-enabled:true}")
    private boolean procesamientoHabilitado;
    
    @Value("${asistencia.config.procesamiento.intervalo-procesamiento-segundos:10}")
    private int intervaloProcesamiento;
    
    @Value("${asistencia.config.procesamiento.max-reintentos:3}")
    private int maxReintentos;
    
    private boolean procesadorActivo = false;
    
    /**
     * Iniciar el procesador de tickets cuando la aplicación esté lista
     */
    @EventListener(ApplicationReadyEvent.class)
    public void iniciarProcesadorTickets() {
        if (!procesamientoHabilitado) {
            log.info("⭕ Procesamiento asíncrono de tickets deshabilitado por configuración");
            return;
        }
        
        log.info("🚀 Iniciando procesador de tickets asíncrono");
        log.info("   - Intervalo de procesamiento: {} segundos", intervaloProcesamiento);
        log.info("   - Máximo reintentos: {}", maxReintentos);
        
        iniciarCicloProcesamiento();
    }
    
    /**
     * Ciclo continuo de procesamiento de tickets
     */
    private void iniciarCicloProcesamiento() {
        Thread procesadorThread = new Thread(() -> {
            log.info("🧵 PROCESADOR DE TICKETS INICIADO");
            procesadorActivo = true;
            
            try {
                int ciclo = 1;
                while (procesadorActivo) {
                    try {
                        // Procesar tickets pendientes
                        int ticketsProcesados = procesarTicketsPendientes();
                        
                        // Procesar tickets con error para reintento
                        int ticketsReintentados = procesarTicketsParaReintento();
                        
                        if (ticketsProcesados > 0 || ticketsReintentados > 0) {
                            log.info("📊 [CICLO {}] Procesados: {} | Reintentados: {}", 
                                    ciclo, ticketsProcesados, ticketsReintentados);
                        } else {
                            log.debug("🔍 [CICLO {}] No hay tickets pendientes", ciclo);
                        }
                        
                        // Esperar antes del siguiente ciclo
                        Thread.sleep(intervaloProcesamiento * 1000L);
                        ciclo++;
                        
                    } catch (InterruptedException e) {
                        log.info("⚠️ Procesador de tickets interrumpido");
                        Thread.currentThread().interrupt();
                        break;
                    } catch (Exception e) {
                        log.error("❌ Error en ciclo de procesamiento", e);
                        // Continuar con el siguiente ciclo
                    }
                }
                
            } catch (Exception e) {
                log.error("❌ Error crítico en procesador de tickets", e);
            } finally {
                procesadorActivo = false;
                log.info("🏁 Procesador de tickets finalizado");
            }
            
        }, "TicketProcessor-Thread");
        
        procesadorThread.setDaemon(false);
        procesadorThread.start();
        log.info("🧵 Thread TicketProcessor-Thread iniciado");
    }
    
    /**
     * Procesar tickets pendientes
     */
    private int procesarTicketsPendientes() {
        try {
            List<TicketAsistencia> ticketsPendientes = ticketRepository.findTicketsPendientes();
            
            if (ticketsPendientes.isEmpty()) {
                return 0;
            }
            
            log.info("🔄 Procesando {} tickets pendientes", ticketsPendientes.size());
            
            int procesados = 0;
            for (TicketAsistencia ticket : ticketsPendientes) {
                try {
                    // Procesar cada ticket de forma asíncrona
                    ticketService.procesarTicketAsync(ticket.getTicketId());
                    procesados++;
                    
                } catch (Exception e) {
                    log.error("❌ Error procesando ticket: {}", ticket.getTicketId(), e);
                }
            }
            
            return procesados;
            
        } catch (Exception e) {
            log.error("❌ Error obteniendo tickets pendientes", e);
            return 0;
        }
    }
    
    /**
     * Procesar tickets con error para reintento
     */
    private int procesarTicketsParaReintento() {
        try {
            List<TicketAsistencia> ticketsError = ticketRepository.findTicketsParaReintento();
            
            if (ticketsError.isEmpty()) {
                return 0;
            }
            
            log.info("🔄 Reintentando {} tickets con error", ticketsError.size());
            
            int reintentados = 0;
            for (TicketAsistencia ticket : ticketsError) {
                try {
                    log.info("🔄 Reintentando ticket: {} (Intento: {}/{})", 
                            ticket.getTicketId(), ticket.getIntentosProcesamiento() + 1, maxReintentos);
                    
                    // Reiniciar estado para reintento
                    ticket.setEstadoProcesamiento("PENDIENTE");
                    ticket.setMensajeError(null);
                    ticketRepository.save(ticket);
                    
                    // Procesar de forma asíncrona
                    ticketService.procesarTicketAsync(ticket.getTicketId());
                    reintentados++;
                    
                } catch (Exception e) {
                    log.error("❌ Error reintentando ticket: {}", ticket.getTicketId(), e);
                }
            }
            
            return reintentados;
            
        } catch (Exception e) {
            log.error("❌ Error obteniendo tickets para reintento", e);
            return 0;
        }
    }
    
    /**
     * Detener el procesador (para shutdown graceful)
     */
    public void detenerProcesador() {
        procesadorActivo = false;
        log.info("🛑 Deteniendo procesador de tickets...");
    }
    
    /**
     * Obtener estado del procesador
     */
    public boolean isProcesadorActivo() {
        return procesadorActivo;
    }
    
    /**
     * Obtener estadísticas de la cola
     */
    public EstadisticasCola obtenerEstadisticas() {
        try {
            long pendientes = ticketRepository.countByEstadoProcesamiento("PENDIENTE");
            long procesando = ticketRepository.countByEstadoProcesamiento("PROCESANDO");
            long completados = ticketRepository.countByEstadoProcesamiento("COMPLETADO");
            long errores = ticketRepository.countByEstadoProcesamiento("ERROR");
            
            return EstadisticasCola.builder()
                    .ticketsPendientes(pendientes)
                    .ticketsProcesando(procesando)
                    .ticketsCompletados(completados)
                    .ticketsError(errores)
                    .procesadorActivo(procesadorActivo)
                    .build();
                    
        } catch (Exception e) {
            log.error("Error obteniendo estadísticas de cola", e);
            return EstadisticasCola.builder().build();
        }
    }
    
    /**
     * DTO para estadísticas de la cola
     */
    @lombok.Data
    @lombok.Builder
    public static class EstadisticasCola {
        private long ticketsPendientes;
        private long ticketsProcesando;
        private long ticketsCompletados;
        private long ticketsError;
        private boolean procesadorActivo;
    }
}
