package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.FormaPagoRef;

public interface FormaPagoRefRepository extends JpaRepository<FormaPagoRef, Long> {
}
