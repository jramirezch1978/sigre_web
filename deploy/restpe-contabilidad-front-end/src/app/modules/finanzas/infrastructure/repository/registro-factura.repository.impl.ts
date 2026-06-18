import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay } from 'rxjs';
import { IRegistroFacturaRepository } from '../../domain/repositories/iregistro-factura.repository';
import { RegistroFacturaEntity } from '../../domain/models/registro-factura.entity';

@Injectable()
export class RegistroFacturaRepositoryImpl extends IRegistroFacturaRepository {
  private readonly _url = 'assets/data/finanzas/operaciones/registro-facturas.json';
  private _datos: RegistroFacturaEntity[] = [];

  constructor(private http: HttpClient) {
    super();
  }

  obtenerTodos(): Observable<RegistroFacturaEntity[]> {
    return this.http.get<RegistroFacturaEntity[]>(this._url).pipe(delay(800));
  }

  guardar(factura: RegistroFacturaEntity): Observable<RegistroFacturaEntity> {
    return new Observable<RegistroFacturaEntity>(observer => {
      this._datos.unshift(factura);
      setTimeout(() => {
        observer.next(factura);
        observer.complete();
      }, 800);
    });
  }

  actualizar(factura: RegistroFacturaEntity): Observable<RegistroFacturaEntity> {
    return new Observable<RegistroFacturaEntity>(observer => {
      const index = this._datos.findIndex(f => f.factura_nro_documento === factura.factura_nro_documento);
      if (index !== -1) {
        this._datos[index] = factura;
      }
      setTimeout(() => {
        observer.next(factura);
        observer.complete();
      }, 800);
    });
  }
}
