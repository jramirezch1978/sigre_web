package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "usuario", schema = "auth")
public class UsuarioRef {

    @Id
    private Long id;

    @Column(length = 50)
    private String username;
}
