package pe.restaurant.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.compras.entity.AprobadorConfigurado;

public interface AprobadorConfiguradoService {

    Page<AprobadorConfigurado> findAll(Pageable pageable);

    AprobadorConfigurado findById(Long id);

    AprobadorConfigurado create(AprobadorConfigurado entity);

    AprobadorConfigurado update(Long id, AprobadorConfigurado entity);

    void delete(Long id);

    AprobadorConfigurado activate(Long id);

    AprobadorConfigurado deactivate(Long id);
}
