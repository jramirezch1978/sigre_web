package com.sigre.seguridad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.seguridad.entity.Usuario;

import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    @Query("SELECT u FROM Usuario u WHERE LOWER(u.email) = LOWER(:email) AND u.flagEstado = '1'")
    Optional<Usuario> findByEmailAndActivoTrue(@Param("email") String email);

    @Query("SELECT u FROM Usuario u WHERE LOWER(u.username) = LOWER(:username) AND u.flagEstado = '1'")
    Optional<Usuario> findByUsernameAndActivoTrue(@Param("username") String username);

    boolean existsByEmail(String email);

    boolean existsByUsername(String username);

    @Query("SELECT u FROM Usuario u WHERE LOWER(u.email) = LOWER(:email)")
    Optional<Usuario> findByEmailIgnoreCase(@Param("email") String email);
}
