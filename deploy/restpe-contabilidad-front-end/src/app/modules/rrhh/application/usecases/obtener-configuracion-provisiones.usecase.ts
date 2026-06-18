import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IParametrosRepository } from '../../domain/repositories/iparametros.repository';
import { ConfiguracionProvisionesEntity } from '../../domain/models/configuracion-provisiones.entity';

@Injectable()
export class ObtenerConfiguracionProvisionesUseCase {
  private readonly repository = inject(IParametrosRepository);

  execute(): Observable<ConfiguracionProvisionesEntity[]> {
    return this.repository.obtenerConfiguracionProvisiones();
  }
}
