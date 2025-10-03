package com.sigre.sync.repository.local;

import com.sigre.sync.entity.local.SeccionLocal;
import com.sigre.sync.entity.local.SeccionLocalId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SeccionLocalRepository extends JpaRepository<SeccionLocal, SeccionLocalId> {
}
