import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

@Component({
  selector: 'app-searchable-select-modal',
  template: `
    <ion-header>
      <ion-toolbar>
        <ion-title>{{ title }}</ion-title>
        <ion-buttons slot="end">
          <ion-button (click)="dismiss()">
            <ion-icon slot="icon-only" name="close-outline"></ion-icon>
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
      <ion-toolbar>
        <ion-searchbar
          [(ngModel)]="filtro"
          placeholder="Buscar..."
          animated="true"
          debounce="150">
        </ion-searchbar>
      </ion-toolbar>
    </ion-header>
    <ion-content>
      <ion-list>
        @for (item of filteredItems; track item.id) {
          <ion-item [button]="true" (click)="select(item.id)"
            [class.selected]="item.id === selectedId">
            <ion-label>{{ item.nombre }}</ion-label>
            @if (item.id === selectedId) {
              <ion-icon slot="end" name="checkmark" color="primary"></ion-icon>
            }
          </ion-item>
        } @empty {
          <ion-item>
            <ion-label class="ion-text-center" color="medium">Sin resultados</ion-label>
          </ion-item>
        }
      </ion-list>
    </ion-content>
  `,
  styles: [`
    ion-searchbar {
      --background: #f1f5f9;
      --border-radius: 8px;
      padding: 4px 8px;
    }
    .selected {
      --background: #eff6ff;
      font-weight: 600;
    }
    ion-content {
      --background: #fff;
    }
    ion-list {
      padding: 0;
    }
  `],
  standalone: false,
})
export class SearchableSelectModalComponent implements OnInit {
  @Input() items: { id: number; nombre: string }[] = [];
  @Input() selectedId: number | null = null;
  @Input() title = 'Seleccionar';

  filtro = '';

  constructor(private modalCtrl: ModalController) {}

  ngOnInit(): void {}

  get filteredItems(): { id: number; nombre: string }[] {
    if (!this.filtro.trim()) return this.items;
    const q = this.filtro.toLowerCase();
    return this.items.filter(i => i.nombre.toLowerCase().includes(q));
  }

  select(id: number): void {
    this.modalCtrl.dismiss(id);
  }

  dismiss(): void {
    this.modalCtrl.dismiss(undefined);
  }
}
