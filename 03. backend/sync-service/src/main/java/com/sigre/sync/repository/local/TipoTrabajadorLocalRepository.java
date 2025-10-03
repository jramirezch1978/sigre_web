package com.sigre.sync.repository.local;

import com.sigre.sync.entity.local.TipoTrabajadorLocal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TipoTrabajadorLocalRepository extends JpaRepository<TipoTrabajadorLocal, String> {
}
