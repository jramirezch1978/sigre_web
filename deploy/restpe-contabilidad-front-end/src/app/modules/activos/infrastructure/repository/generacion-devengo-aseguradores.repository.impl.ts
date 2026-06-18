import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IGeneracionDevengoAseguradoresRepository } from '../../domain/repositories/igeneracion-devengo-aseguradores.repository';
import { GeneracionDevengoAseguradoresEntity } from '../../domain/models/generacion-devengo-aseguradores.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

const GDA_JSON_PATH = 'assets/data/activo-fijo/tabla/generacion-devengo-aseguradores.json';

@Injectable()
export class GeneracionDevengoAseguradoresRepositoryImpl extends IGeneracionDevengoAseguradoresRepository {

  private readonly http = inject(HttpClient);

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<GeneracionDevengoAseguradoresEntity[]> {
    return this.http.get<GeneracionDevengoAseguradoresEntity[]>(GDA_JSON_PATH).pipe(
      delay(800),
    );
  }

  obtenerPorCodigo(codigo: string): Observable<GeneracionDevengoAseguradoresEntity> {
    return this.http.get<GeneracionDevengoAseguradoresEntity[]>(GDA_JSON_PATH).pipe(
      delay(200),
      map((jsonItems: GeneracionDevengoAseguradoresEntity[]) => {
        const encontrado = jsonItems.find(a => a.gda_codigo === codigo);
        if (!encontrado) throw new Error(`Devengo con código ${codigo} no encontrado`);
        return encontrado;
      })
    );
  }

  // ── Escritura ────────────────────────────────────────────────────────────────

  guardar(item: GeneracionDevengoAseguradoresEntity): Observable<ApiResponse> {
    return of({ success: true, message: 'Devengo guardado correctamente', data: item })
      .pipe(delay(400));
  }

  actualizar(item: GeneracionDevengoAseguradoresEntity): Observable<ApiResponse> {
    return of({ success: true, message: 'Devengo actualizado correctamente', data: item })
      .pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    return of({ success: true, message: 'Devengo eliminado correctamente', data: null })
      .pipe(delay(400));
  }
}
