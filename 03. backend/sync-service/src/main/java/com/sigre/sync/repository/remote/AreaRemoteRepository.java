package com.sigre.sync.repository.remote;

import com.sigre.sync.entity.remote.AreaRemote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AreaRemoteRepository extends JpaRepository<AreaRemote, String> {
}
