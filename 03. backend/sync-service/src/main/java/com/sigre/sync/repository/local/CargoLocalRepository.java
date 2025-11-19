package com.sigre.sync.repository.local;

import com.sigre.sync.entity.local.CargoLocal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CargoLocalRepository extends JpaRepository<CargoLocal, String> {
}

