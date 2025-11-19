package com.sigre.sync.repository.remote;

import com.sigre.sync.entity.remote.OrigenRemote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrigenRemoteRepository extends JpaRepository<OrigenRemote, String> {
}

