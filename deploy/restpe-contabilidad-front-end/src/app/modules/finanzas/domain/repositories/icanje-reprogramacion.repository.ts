import { Observable } from 'rxjs';
import { CanjeReprogramacionEntity } from '../models/canje-reprogramacion.entity';

export abstract class ICanjeReprogramacionRepository {
  abstract obtenerTodos(): Observable<CanjeReprogramacionEntity[]>;
  abstract aplicarCanje(nroDocumento: string): Observable<{ success: boolean }>;
  abstract reprogramarVencimiento(nroDocumento: string, nuevaFechaVencimiento: string): Observable<{ success: boolean }>;
}
