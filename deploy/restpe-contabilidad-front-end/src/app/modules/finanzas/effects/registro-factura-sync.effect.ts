import { Injectable } from '@angular/core';

// Los toasts de éxito se gestionan directamente en el componente
// ya que cada acción (registrar, pagar, anular) tiene un mensaje contextual distinto.
// Este efecto existe por consistencia estructural con el patrón de clean architecture.
@Injectable()
export class RegistroFacturaSyncEffects {}
