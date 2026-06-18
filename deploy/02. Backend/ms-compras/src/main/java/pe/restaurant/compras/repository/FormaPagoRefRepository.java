package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.FormaPagoRef;

public interface FormaPagoRefRepository extends JpaRepository<FormaPagoRef, Long> {
}
