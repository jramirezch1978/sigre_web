import { Observable } from 'rxjs';
import { GestionGrupoEntity } from '../models/gestion-grupo.entity';

export abstract class IGestionGrupoRepository {
  abstract obtenerTodos(): Observable<GestionGrupoEntity[]>;
  abstract guardar(grupo: Partial<GestionGrupoEntity>): Observable<{ success: boolean; data?: GestionGrupoEntity }>;
  abstract actualizar(codigo: string, cambios: Partial<GestionGrupoEntity>): Observable<{ success: boolean; data?: GestionGrupoEntity }>;
}
