import { Component, OnInit, inject } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-admin-cuenta',
  templateUrl: './admin-cuenta.component.html',
  styleUrls: ['../admin-page-common.scss'],
  standalone: false,
})
export class AdminCuentaComponent implements OnInit {

  private readonly route = inject(ActivatedRoute);

  titulo = 'Cuenta';
  descripcion = '';

  ngOnInit(): void {
    this.titulo = this.route.snapshot.data['titulo'] ?? 'Cuenta';
    this.descripcion = this.route.snapshot.data['descripcion'] ?? 'Esta sección estará disponible próximamente.';
  }
}
