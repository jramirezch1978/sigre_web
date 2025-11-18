package com.sigre.seguridad.repository;

import com.sigre.seguridad.model.entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Repositorio para Usuario
 */
@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, String> {

    Optional<Usuario> findByCodUser(String codUser);

    Optional<Usuario> findByEmail(String email);

    @Query("SELECT u FROM Usuario u LEFT JOIN FETCH u.roles r LEFT JOIN FETCH r.permisos " +
           "WHERE u.codUser = :codUser")
    Optional<Usuario> findByIdWithRolesAndPermissions(@Param("codUser") String codUser);

    boolean existsByCodUser(String codUser);

    boolean existsByEmail(String email);
}

