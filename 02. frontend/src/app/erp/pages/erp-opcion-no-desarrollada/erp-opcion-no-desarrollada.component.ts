import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';

/**
 * Página que se muestra dentro del ERP cuando una opción del menú apunta a una ruta
 * que aún no ha sido desarrollada. Evita que el ERP rebote a la landing pública (/sigre/inicio).
 */
@Component({
  selector: 'app-erp-opcion-no-desarrollada',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="nd-wrap">
      <div class="nd-card">
        <i class="material-icons-outlined nd-icon">construction</i>
        <h2>Opción en construcción</h2>
        @if (nombreOpcion) {
          <p>La opción <strong>{{ nombreOpcion }}</strong> aún no ha sido desarrollada.</p>
        } @else {
          <p>Esta opción del menú aún no ha sido implementada o no existe.</p>
        }
        <p class="nd-ruta">{{ rutaActual }}</p>
        <button class="btn btn-primary" (click)="irADashboard()">Volver al inicio del ERP</button>
      </div>
    </div>
  `,
  styles: [`
    .nd-wrap { display: flex; justify-content: center; align-items: center; min-height: 60vh; padding: 2rem; }
    .nd-card {
      text-align: center; background: #fff; border: 1px solid #e4e9f0; border-radius: 1rem;
      padding: 2.5rem 2rem; max-width: 460px; box-shadow: 0 .5rem 1.5rem rgba(15,23,42,.08);
    }
    .nd-icon { font-size: 56px; color: #f5a623; }
    h2 { margin: .75rem 0 .5rem; color: #2a3f54; font-weight: 700; }
    p { color: #64748b; margin: .25rem 0; }
    .nd-ruta { font-family: monospace; font-size: .8rem; color: #94a3b8; margin: .5rem 0 1.25rem; word-break: break-all; }
  `],
})
export class ErpOpcionNoDesarrolladaComponent {
  private readonly router = inject(Router);
  private readonly route = inject(ActivatedRoute);
  readonly rutaActual = this.router.url;
  readonly nombreOpcion = this.route.snapshot.queryParamMap.get('op') ?? '';

  irADashboard(): void {
    void this.router.navigate(['/sigre/dashboard']);
  }
}
