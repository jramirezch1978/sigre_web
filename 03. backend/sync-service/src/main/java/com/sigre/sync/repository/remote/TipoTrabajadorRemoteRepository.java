package com.sigre.sync.repository.remote;

import com.sigre.sync.entity.remote.TipoTrabajadorRemote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TipoTrabajadorRemoteRepository extends JpaRepository<TipoTrabajadorRemote, String> {
}
