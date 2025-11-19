package com.sigre.sync.repository.remote;

import com.sigre.sync.entity.remote.CargoRemote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CargoRemoteRepository extends JpaRepository<CargoRemote, String> {
}

