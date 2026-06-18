import { Injectable, signal } from '@angular/core';

/**
 * Servicio de modo para la ficha de relaciones comerciales.
 * Permite que el mismo componente/repositorio opere como "Proveedor" o "Cliente"
 * (esProveedor vs esCliente) según la ruta activa.
 */
@Injectable({ providedIn: 'root' })
export class RelacionComercialModeService {
  /** true => la pantalla gestiona Clientes; false => Proveedores. */
  readonly esCliente = signal<boolean>(false);

  setModo(modo: 'proveedor' | 'cliente'): void {
    this.esCliente.set(modo === 'cliente');
  }
}
