import { Observable } from 'rxjs';
import { GestionCatalogoEntity } from '../models/gestion-catalogo.entity';

export abstract class IGestionCatalogoRepository {
  abstract obtenerTodos(): Observable<GestionCatalogoEntity[]>;
  abstract guardar(documento: Partial<GestionCatalogoEntity>): Observable<{ success: boolean; data?: GestionCatalogoEntity }>;
  abstract actualizar(codigo: string, cambios: Partial<GestionCatalogoEntity>): Observable<{ success: boolean; data?: GestionCatalogoEntity }>;
  abstract eliminar(id: number): Observable<{ success: boolean }>;
}
