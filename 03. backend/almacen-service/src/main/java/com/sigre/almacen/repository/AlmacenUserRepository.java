package com.sigre.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.almacen.entity.AlmacenUser;

import java.util.List;
import java.util.Optional;

public interface AlmacenUserRepository extends JpaRepository<AlmacenUser, Long> {

    List<AlmacenUser> findByAlmacenId(Long almacenId);

    List<AlmacenUser> findByAlmacenIdAndFlagEstado(Long almacenId, String flagEstado);

    List<AlmacenUser> findAllByAlmacenIdAndUsuarioId(Long almacenId, Long usuarioId);

    List<AlmacenUser> findByAlmacenIdAndFlagEstadoAndUsuarioId(Long almacenId, String flagEstado, Long usuarioId);

    Optional<AlmacenUser> findFirstByAlmacenIdAndUsuarioId(Long almacenId, Long usuarioId);

    void deleteByAlmacenIdAndUsuarioId(Long almacenId, Long usuarioId);
}
