import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';

@Component({
  selector: 'app-movimiento-caja-list',
  standalone: true,
  imports: [CommonModule, IonicModule],
  template: `
    <ion-header>
      <ion-toolbar>
        <ion-title>Movimientos de Caja</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content class="ion-padding">
      <p>Módulo de movimientos de caja — En desarrollo</p>
    </ion-content>
  `,
})
export class MovimientoCajaListComponent implements OnInit {
  ngOnInit(): void {}
}
