package com.sigre.almacen.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.entity.FormaEmbarque;
import com.sigre.almacen.repository.FormaEmbarqueRepository;
import com.sigre.almacen.service.FormaEmbarqueService;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class FormaEmbarqueServiceImpl implements FormaEmbarqueService {

    private final FormaEmbarqueRepository repository;

    @Override
    public Page<FormaEmbarque> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Override
    public FormaEmbarque findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FormaEmbarque", id));
    }

    @Override
    @Transactional
    public FormaEmbarque create(FormaEmbarque entity) {
        validateUnique(entity.getFormaEmbarque(), null);
        return repository.save(entity);
    }

    @Override
    @Transactional
    public FormaEmbarque update(Long id, FormaEmbarque entity) {
        FormaEmbarque existing = findById(id);
        validateUnique(entity.getFormaEmbarque(), id);
        existing.setFormaEmbarque(entity.getFormaEmbarque());
        existing.setDescripcion(entity.getDescripcion());
        if (entity.getFlagEstado() != null) {
            existing.setFlagEstado(entity.getFlagEstado());
        }
        return repository.save(existing);
    }

    @Override
    @Transactional
    public FormaEmbarque activate(Long id) {
        FormaEmbarque existing = findById(id);
        existing.setFlagEstado("1");
        return repository.save(existing);
    }

    @Override
    @Transactional
    public FormaEmbarque deactivate(Long id) {
        FormaEmbarque existing = findById(id);
        existing.setFlagEstado("0");
        return repository.save(existing);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        repository.delete(findById(id));
    }

    private void validateUnique(String formaEmbarque, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByFormaEmbarqueIgnoreCase(formaEmbarque)
                : repository.existsByFormaEmbarqueIgnoreCaseAndIdNot(formaEmbarque, excludeId);
        if (exists) {
            throw new BusinessException("Ya existe una forma de embarque con código: " + formaEmbarque,
                    HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
    }
}
