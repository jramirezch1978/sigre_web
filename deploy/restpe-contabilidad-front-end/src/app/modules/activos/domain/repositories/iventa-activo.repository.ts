import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { VentaActivoEntity } from '../models/venta-activo.entity';

@Injectable()
export abstract class IVentaActivoRepository {
  abstract obtenerTodos(): Observable<VentaActivoEntity[]>;
}
