import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';

@Component({
  selector: 'app-centro-costo-list',
  standalone: true,
  imports: [CommonModule, IonicModule],
  template: `
    <ion-header>
      <ion-toolbar>
        <ion-title>Centros de Costos</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content class="ion-padding">
      <p>Módulo de centros de costos — En desarrollo</p>
    </ion-content>
  `,
})
export class CentroCostoListComponent implements OnInit {
  ngOnInit(): void {}
}
