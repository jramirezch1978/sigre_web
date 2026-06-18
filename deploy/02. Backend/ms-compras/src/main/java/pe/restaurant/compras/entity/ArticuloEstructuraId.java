package pe.restaurant.compras.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.Objects;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArticuloEstructuraId implements Serializable {

    private Long articuloPadreId;
    private Long articuloHijoId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ArticuloEstructuraId that = (ArticuloEstructuraId) o;
        return Objects.equals(articuloPadreId, that.articuloPadreId)
                && Objects.equals(articuloHijoId, that.articuloHijoId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(articuloPadreId, articuloHijoId);
    }
}
