import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IPanelReenvioRepository } from '../../domain/repositories/ipanel-reenvio.repository';
import { PanelReenvioEntity } from '../../domain/models/panel-reenvio.entity';

@Injectable({ providedIn: 'root' })
export class PanelReenvioRepositoryImpl implements IPanelReenvioRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/ventas/reportes/panel-reenvio.json';
  private readonly DELAY_MS = 500;

  obtenerTodos(): Observable<PanelReenvioEntity[]> {
    return this.http.get<PanelReenvioEntity[]>(this.JSON_PATH).pipe(delay(this.DELAY_MS));
  }
}
