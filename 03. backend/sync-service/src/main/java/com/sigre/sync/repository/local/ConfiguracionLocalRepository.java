package com.sigre.sync.repository.local;

import com.sigre.sync.entity.local.ConfiguracionLocal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ConfiguracionLocalRepository extends JpaRepository<ConfiguracionLocal, String> {
}
