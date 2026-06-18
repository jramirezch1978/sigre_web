import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IRazonSocialRepository } from '../../domain/repositories/irazon-social.repository';
import { RazonSocialEntity } from '../../domain/models/razon-social.entity';

@Injectable({ providedIn: 'root' })
export class ObtenerRazonesSocialesUseCase {
  private readonly repository = inject(IRazonSocialRepository);

  execute(): Observable<RazonSocialEntity[]> {
    return this.repository.obtenerRazonesSociales();
  }
}
