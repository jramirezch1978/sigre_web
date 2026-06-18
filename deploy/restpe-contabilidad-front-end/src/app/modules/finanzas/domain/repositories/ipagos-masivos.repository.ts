import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { PagosMasivosEntity } from '../models/pagos-masivos.entity';
import { PagosMasivosDocumentoEntity } from '../models/pagos-masivos-documento.entity';

@Injectable()
export abstract class IPagosMasivosRepository {
  abstract obtenerTodos(): Observable<PagosMasivosEntity[]>;
  abstract obtenerDocumentos(): Observable<PagosMasivosDocumentoEntity[]>;
  abstract guardar(entity: PagosMasivosEntity): Observable<PagosMasivosEntity>;
}
