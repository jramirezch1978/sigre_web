import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IObligacionVencerRepository } from '../../domain/repositories/iobligacion-vencer.repository';
import { ObligacionVencerEntity } from '../../domain/models/obligacion-vencer.entity';

@Injectable()
export class ObtenerObligacionVencerUseCase {
  private readonly repository = inject(IObligacionVencerRepository);

  execute(): Observable<ObligacionVencerEntity[]> {
    return this.repository.obtenerObligaciones();
  }
}
