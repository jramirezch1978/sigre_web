package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

@Entity
@Table(name = "vendedor", schema = "ventas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Vendedor extends BaseEntity {
    
    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Column(name = "nombre", length = 150)
    private String nombre;

    @Column(name = "comision_porcentaje", precision = 8, scale = 4)
    private java.math.BigDecimal comisionPorcentaje;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false, insertable = false, updatable = false)
    private Usuario usuario;
    
    // Clase interna para Usuario (para evitar dependencias circulares)
    @Entity
    @Table(name = "usuario", schema = "auth")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Usuario extends BaseEntity {
        @Column(name = "username", nullable = false, length = 80)
        private String username;
        
        @Column(name = "nombres", length = 120)
        private String nombres;

        @Column(name = "apellidos", length = 120)
        private String apellidos;
        
        @Column(name = "flag_estado", length = 1)
        private String flagEstado;
    }
}
