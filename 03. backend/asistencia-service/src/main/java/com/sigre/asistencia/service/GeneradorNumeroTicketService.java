package com.sigre.asistencia.service;

import com.sigre.asistencia.entity.NumDocTipo;
import com.sigre.asistencia.entity.NumDocTipoId;
import com.sigre.asistencia.repository.NumDocTipoRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Servicio para generar números de ticket únicos y secuenciales
 * Usa tabla numeradora num_doc_tipo para evitar colisiones
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class GeneradorNumeroTicketService {
    
    private final NumDocTipoRepository numDocTipoRepository;
    
    private static final String TIPO_DOC_TICKET = "TICKET_ASISTENCIA";
    
    /**
     * Generar siguiente número de ticket hexadecimal
     * Formato: [cod_origen][padding_zeros][numero_secuencial_hex]
     * Ejemplo: WEB0000001, MOB000000A, KIO0000FF3
     */
    @Transactional
    public String generarNumeroTicket(String codOrigen) {
        try {
            log.info("🎫 Generando número de ticket para origen: {}", codOrigen);
            
            // Crear PK compuesta
            NumDocTipoId pkCompuesta = new NumDocTipoId(TIPO_DOC_TICKET, codOrigen);
            
            // Buscar o crear numerador para este tipo y origen
            NumDocTipo numerador = numDocTipoRepository
                    .findByTipoDocAndCodOrigenWithLock(TIPO_DOC_TICKET, codOrigen)
                    .orElse(null);
            
            if (numerador == null) {
                // Crear nuevo numerador si no existe
                log.info("📋 Creando nuevo numerador para tipo: {} | origen: {}", TIPO_DOC_TICKET, codOrigen);
                numerador = NumDocTipo.builder()
                        .id(pkCompuesta)
                        .ultNro(0L)
                        .build();
                numerador = numDocTipoRepository.save(numerador);
            }
            
            // Generar siguiente número
            String numeroTicket = numerador.generarSiguienteTicket();
            
            // Guardar numerador actualizado
            numDocTipoRepository.save(numerador);
            
            log.info("✅ Número de ticket generado: {} | Secuencial: {}", numeroTicket, numerador.getUltNro());
            
            return numeroTicket;
            
        } catch (Exception e) {
            log.error("❌ Error generando número de ticket para origen: {}", codOrigen, e);
            
            // Fallback: generar número temporal único
            String numeroFallback = codOrigen + System.currentTimeMillis() % 10000000L;
            log.warn("⚠️ Usando número fallback: {}", numeroFallback);
            
            return numeroFallback;
        }
    }
    
    /**
     * Obtener estadísticas de numeración para un origen
     */
    public NumDocTipo obtenerEstadisticasNumeracion(String codOrigen) {
        return numDocTipoRepository
                .findByTipoDocAndCodOrigen(TIPO_DOC_TICKET, codOrigen)
                .orElse(null);
    }
    
    /**
     * Inicializar numerador con valor específico (útil para migración)
     */
    @Transactional
    public void inicializarNumerador(String codOrigen, Long valorInicial) {
        NumDocTipoId pkCompuesta = new NumDocTipoId(TIPO_DOC_TICKET, codOrigen);
        
        NumDocTipo numerador = numDocTipoRepository
                .findByTipoDocAndCodOrigen(TIPO_DOC_TICKET, codOrigen)
                .orElse(null);
        
        if (numerador == null) {
            numerador = NumDocTipo.builder()
                    .id(pkCompuesta)
                    .ultNro(valorInicial)
                    .build();
            numDocTipoRepository.save(numerador);
            log.info("📋 Numerador inicializado: {} | {} | Valor inicial: {}", 
                    TIPO_DOC_TICKET, codOrigen, valorInicial);
        } else {
            log.info("ℹ️ Numerador ya existe: {} | {} | Valor actual: {}", 
                    TIPO_DOC_TICKET, codOrigen, numerador.getUltNro());
        }
    }
}
