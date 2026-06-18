import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IPanelDocumentoRepository } from '../../domain/repositories/ipanel-documento.repository';
import { PanelDocumentoEntity } from '../../domain/models/panel-documento.entity';

@Injectable({ providedIn: 'root' })
export class PanelDocumentoRepositoryImpl implements IPanelDocumentoRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/ventas/reportes/panel-documento.json';
  private readonly DELAY_MS = 500;

  obtenerTodos(): Observable<PanelDocumentoEntity[]> {
    return this.http.get<PanelDocumentoEntity[]>(this.JSON_PATH).pipe(delay(this.DELAY_MS));
  }
}
