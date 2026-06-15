package com.sigre.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.auth.entity.Usuario;

import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    @Query("SELECT u FROM Usuario u WHERE u.email = :email AND u.flagEstado = '1'")
    Optional<Usuario> findByEmailAndActivoTrue(@Param("email") String email);

    @Query("SELECT u FROM Usuario u WHERE u.username = :username AND u.flagEstado = '1'")
    Optional<Usuario> findByUsernameAndActivoTrue(@Param("username") String username);

    boolean existsByEmail(String email);
}
