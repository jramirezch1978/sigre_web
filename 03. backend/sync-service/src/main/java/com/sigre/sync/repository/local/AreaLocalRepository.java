package com.sigre.sync.repository.local;

import com.sigre.sync.entity.local.AreaLocal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AreaLocalRepository extends JpaRepository<AreaLocal, String> {
}
