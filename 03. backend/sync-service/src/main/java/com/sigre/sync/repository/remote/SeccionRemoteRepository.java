package com.sigre.sync.repository.remote;

import com.sigre.sync.entity.remote.SeccionRemote;
import com.sigre.sync.entity.remote.SeccionRemoteId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SeccionRemoteRepository extends JpaRepository<SeccionRemote, SeccionRemoteId> {
}
