import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { TablasContabilidadEntity } from '../models/tablas-contabilidad.entity';

/**
 * ITablasContabilidadRepository — Puerto del dominio (Abstracción).
 * Define el contrato de acceso a datos para los tipos de documento contable.
 * La implementación concreta vive en la capa de infraestructura.
 */
@Injectable()
export abstract class ITablasContabilidadRepository {
  abstract obtenerTodos(): Observable<TablasContabilidadEntity>;
}
