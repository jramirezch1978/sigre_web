import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IReporteVentasRepository } from '../../domain/repositories/ireporte-ventas.repository';
import { ReporteVentasEntity } from '../../domain/models/reporte-ventas.entity';

@Injectable({ providedIn: 'root' })
export class ReporteVentasRepositoryImpl implements IReporteVentasRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/ventas/reportes/reporte-ventas.json';
  private readonly DELAY_MS = 500;

  obtenerTodos(): Observable<ReporteVentasEntity[]> {
    return this.http.get<ReporteVentasEntity[]>(this.JSON_PATH).pipe(delay(this.DELAY_MS));
  }
}
