import { Component, inject } from '@angular/core';
import { CommonModule, Location } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';

/**
 * Página que se muestra en el módulo de asistencia cuando se hace clic en una
 * opción del menú que aún no ha sido desarrollada (mismo patrón usado en el
 * ERP con ErpOpcionNoDesarrolladaComponent, para mantener consistencia).
 */
@Component({
  selector: 'app-opcion-no-desarrollada',
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
          <p>Esta opción del menú aún no ha sido implementada.</p>
        }
        <p class="nd-detalle">Nuestro equipo está trabajando en esta característica. Estará disponible próximamente.</p>
        <div class="nd-actions">
          <button class="btn btn-outline" (click)="volver()">Volver</button>
          <button class="btn btn-primary" (click)="irADashboard()">Ir al Dashboard</button>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .nd-wrap { display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 2rem; background: #F7F7F7; }
    .nd-card {
      text-align: center; background: #fff; border: 1px solid #e4e9f0; border-radius: 1rem;
      padding: 2.5rem 2rem; max-width: 460px; box-shadow: 0 .5rem 1.5rem rgba(15,23,42,.08);
    }
    .nd-icon { font-size: 56px; color: #f5a623; }
    h2 { margin: .75rem 0 .5rem; color: #2a3f54; font-weight: 700; }
    p { color: #64748b; margin: .25rem 0; }
    .nd-detalle { font-size: .85rem; margin: .5rem 0 1.25rem; }
    .nd-actions { display: flex; gap: .75rem; justify-content: center; margin-top: .5rem; }
    .btn { border: none; border-radius: .5rem; padding: .6rem 1.25rem; font-weight: 600; cursor: pointer; }
    .btn-primary { background: #1ABB9C; color: #fff; }
    .btn-primary:hover { background: #17a589; }
    .btn-outline { background: transparent; color: #2a3f54; border: 1px solid #cbd5e1; }
    .btn-outline:hover { background: #f1f5f9; }
  `],
})
export class OpcionNoDesarrolladaComponent {
  private readonly router = inject(Router);
  private readonly route = inject(ActivatedRoute);
  private readonly location = inject(Location);

  readonly nombreOpcion = this.route.snapshot.queryParamMap.get('op') ?? '';

  volver(): void {
    this.location.back();
  }

  irADashboard(): void {
    void this.router.navigate(['/dashboard']);
  }
}
