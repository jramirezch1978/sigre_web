import { Provider } from '@angular/core';
import { ICuentaVsSubcategoriaRepository } from '../../domain/repositories/icuenta-vs-subcategoria.repository';
import { CuentaVsSubcategoriasRepositoryImpl } from '../repository/cuenta-vs-subcategorias.impl';
import { CuentaVsSubcategoriaStore } from '../../store/cuenta-vs-subcategoria.store';
import { CuentaVsSubcategoriaFacade } from '../../application/facades/cuenta-vs-subcategoria.facade';
import { ObtenerCuentasVsSubcategoriasUseCase } from '../../application/usecases/obtener-cuentas-vs-subcategorias.usecase';
import { ActualizarCuentaVsSubcategoriaUseCase } from '../../application/usecases/actualizar-cuenta-vs-subcategoria.usecase';
import { CuentaVsSubcategoriaFeedbackEffects } from '../../effects/cuenta-vs-subcategoria-feedback.effect';
import { CuentaVsSubcategoriaSyncEffects } from '../../effects/cuenta-vs-subcategoria-sync.effect';

export const CUENTA_VS_SUBCATEGORIA_PROVIDERS: Provider[] = [
  { provide: ICuentaVsSubcategoriaRepository, useClass: CuentaVsSubcategoriasRepositoryImpl },
  CuentaVsSubcategoriaStore,
  CuentaVsSubcategoriaFacade,
  ObtenerCuentasVsSubcategoriasUseCase,
  ActualizarCuentaVsSubcategoriaUseCase,
  CuentaVsSubcategoriaFeedbackEffects,
  CuentaVsSubcategoriaSyncEffects,
];
