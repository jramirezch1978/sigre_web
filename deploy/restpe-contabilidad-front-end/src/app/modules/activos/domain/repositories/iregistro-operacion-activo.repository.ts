import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RegistroOperacionActivoEntity } from '../models/registro-operacion-activo.entity';

/**
 * Contrato (puerto) del repositorio de Registro de Operaciones de Activos.
 * SRP: solo define el contrato de acceso a datos para operaciones sobre activos fijos.
 */
@Injectable()
export abstract class IRegistroOperacionActivoRepository {
  abstract obtenerTodos(): Observable<RegistroOperacionActivoEntity[]>;
}
