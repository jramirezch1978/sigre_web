import { Observable } from 'rxjs';
import { ConceptoFinancieroEntity } from '../models/concepto-financiero.entity';

export abstract class IConceptoFinancieroRepository {
  abstract obtenerTodos(): Observable<ConceptoFinancieroEntity[]>;
  abstract guardar(
    concepto: Partial<ConceptoFinancieroEntity>,
  ): Observable<ConceptoFinancieroEntity>;
  abstract actualizar(
    codigo: string,
    cambios: Partial<ConceptoFinancieroEntity>,
  ): Observable<ConceptoFinancieroEntity>;
  abstract eliminar(id: number): Observable<{ success: boolean }>;
}
