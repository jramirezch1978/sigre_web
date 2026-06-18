import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import type { CentroCosto, DistribucionGasto, AnalisisRentabilidad } from '../models/costos.model';

@Injectable({ providedIn: 'root' })
export class CostosService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiBaseUrl}/costos`;

  getCentrosCosto(): Observable<CentroCosto[]> {
    return this.http.get<CentroCosto[]>(`${this.baseUrl}/centros`);
  }

  getCentroCosto(id: number): Observable<CentroCosto> {
    return this.http.get<CentroCosto>(`${this.baseUrl}/centros/${id}`);
  }

  getDistribuciones(centroId: number): Observable<DistribucionGasto[]> {
    return this.http.get<DistribucionGasto[]>(`${this.baseUrl}/centros/${centroId}/distribuciones`);
  }

  getAnalisisRentabilidad(periodo: string): Observable<AnalisisRentabilidad[]> {
    return this.http.get<AnalisisRentabilidad[]>(`${this.baseUrl}/analisis-rentabilidad`, {
      params: { periodo },
    });
  }
}
