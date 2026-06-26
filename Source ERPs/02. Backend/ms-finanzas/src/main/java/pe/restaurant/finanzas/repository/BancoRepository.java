package pe.restaurant.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.restaurant.finanzas.entity.Banco;

@Repository
public interface BancoRepository extends JpaRepository<Banco, Long> {
    
    boolean existsByCodBancoIgnoreCase(String codBanco);
    
    boolean existsByCodBancoIgnoreCaseAndIdNot(String codBanco, Long id);
}
