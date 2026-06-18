import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IReporteTributarioRepository } from '../../domain/repositories/ireporte-tributario.repository';
import { ReporteTributarioDetalleEntity, ReporteTributarioConsolidadoEntity } from '../../domain/models/reporte-tributario.entity';

@Injectable({ providedIn: 'root' })
export class ReporteTributarioRepositoryImpl implements IReporteTributarioRepository {

  private readonly http = inject(HttpClient);
  private readonly PATH_VENTAS = 'assets/data/ventas/reportes/reporte-tributario-ventas.json';
  private readonly PATH_COMPRAS = 'assets/data/ventas/reportes/reporte-tributario-compras.json';
  private readonly PATH_CONSOLIDADO = 'assets/data/ventas/reportes/reporte-tributario-consolidado.json';

  private readonly DELAY_MS = 500;

  obtenerVentas(): Observable<ReporteTributarioDetalleEntity[]> {
    return this.http.get<ReporteTributarioDetalleEntity[]>(this.PATH_VENTAS).pipe(delay(this.DELAY_MS));
  }

  obtenerCompras(): Observable<ReporteTributarioDetalleEntity[]> {
    return this.http.get<ReporteTributarioDetalleEntity[]>(this.PATH_COMPRAS).pipe(delay(this.DELAY_MS));
  }

  obtenerConsolidado(): Observable<ReporteTributarioConsolidadoEntity[]> {
    return this.http.get<ReporteTributarioConsolidadoEntity[]>(this.PATH_CONSOLIDADO).pipe(delay(this.DELAY_MS));
  }
}
