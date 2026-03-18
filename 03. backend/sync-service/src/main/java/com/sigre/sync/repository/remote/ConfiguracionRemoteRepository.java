package com.sigre.sync.repository.remote;

import com.sigre.sync.entity.remote.ConfiguracionRemote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ConfiguracionRemoteRepository extends JpaRepository<ConfiguracionRemote, String> {
}
