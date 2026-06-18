import { Observable } from 'rxjs';
import { LibroMayorEntity, LibroDiarioEntity, BalanceComprobEntity } from '../models/libros-asientos.entity';

/**
 * ILibrosAsientosRepository — Contrato de dominio (SRP).
 * Define operaciones de lectura por cada tipo de reporte.
 */
export abstract class ILibrosAsientosRepository {
  abstract obtenerLibroMayor(): Observable<LibroMayorEntity>;
  abstract obtenerLibroDiario(): Observable<LibroDiarioEntity>;
  abstract obtenerBalanceComprobacion(): Observable<BalanceComprobEntity>;
}
