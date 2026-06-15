import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IRazonSocialRepository } from '../../domain/repositories/irazon-social.repository';
import { RazonSocialEntity } from '../../domain/models/razon-social.entity';

@Injectable({ providedIn: 'root' })
export class RazonSocialRepositoryImpl extends IRazonSocialRepository {
  private readonly http = inject(HttpClient);

  private readonly JSON_PATH = 'assets/data/auth/razones-sociales.json';

  obtenerRazonesSociales(): Observable<RazonSocialEntity[]> {
    return this.http.get<RazonSocialEntity[]>(this.JSON_PATH).pipe(
      delay(500)
    );
  }
}
