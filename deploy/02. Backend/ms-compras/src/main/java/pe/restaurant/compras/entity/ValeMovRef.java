package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "vale_mov", schema = "almacen")
public class ValeMovRef {

    @Id
    private Long id;

    @Column(name = "nro_vale", length = 50)
    private String nroVale;

    @Column(name = "fecha_mov")
    private LocalDate fecha;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;

    @Column(name = "almacen_id")
    private Long almacenId;

    @Column(name = "orden_compra_id")
    private Long ordenCompraId;
}
