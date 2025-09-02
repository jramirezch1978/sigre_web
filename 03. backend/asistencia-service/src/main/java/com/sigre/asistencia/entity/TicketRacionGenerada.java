package com.sigre.asistencia.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

/**
 * Entidad intermedia para relacionar TicketAsistencia con RacionesSeleccionadas
 * Tabla: ticket_raciones_generadas
 */
@Entity
@Table(name = "ticket_raciones_generadas")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TicketRacionGenerada {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    
    @Column(name = "numero_ticket", nullable = false, length = 10)
    private String numeroTicket; // FK hacia tickets_asistencia.numero_ticket
    
    @Column(name = "racion_comedor_id", nullable = false)
    private Long racionComedorId; // FK hacia raciones_seleccionadas
    
    @CreationTimestamp
    @Column(name = "fecha_asociacion", nullable = false)
    private LocalDateTime fechaAsociacion;
    
    // ===== RELACIONES JPA =====
    
    /**
     * Relación con el ticket que generó esta ración
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "numero_ticket", referencedColumnName = "numero_ticket", insertable = false, updatable = false)
    private TicketAsistencia ticket;
    
    /**
     * Relación con la ración generada
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "racion_comedor_id", referencedColumnName = "id_racion_comedor", insertable = false, updatable = false)
    private RacionesSeleccionadas racionGenerada;
}
