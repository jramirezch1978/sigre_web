import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';

@Component({
  selector: 'app-comprobante-list',
  standalone: true,
  imports: [CommonModule, IonicModule],
  template: `
    <ion-header>
      <ion-toolbar>
        <ion-title>Facturación Electrónica</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content class="ion-padding">
      <p>Módulo de facturación electrónica — En desarrollo</p>
    </ion-content>
  `,
})
export class ComprobanteListComponent implements OnInit {
  ngOnInit(): void {}
}
