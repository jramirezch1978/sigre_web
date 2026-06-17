import { Component, EventEmitter, Input, Output } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { SearchableSelectModalComponent } from './searchable-select-modal.component';

@Component({
  selector: 'app-searchable-select',
  template: `
    <div class="searchable-select" (click)="openModal()" [class.disabled]="disabled">
      <span class="searchable-select__value" [class.placeholder]="!selectedLabel">
        {{ selectedLabel || placeholder }}
      </span>
      <ion-icon name="chevron-down-outline" class="searchable-select__icon"></ion-icon>
    </div>
  `,
  styles: [`
    .searchable-select {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 10px 12px;
      border: 1px solid #e2e8f0;
      border-radius: 8px;
      cursor: pointer;
      background: #fff;
      min-height: 42px;
      transition: border-color 0.2s;

      &:hover:not(.disabled) {
        border-color: #94a3b8;
      }

      &.disabled {
        opacity: 0.5;
        pointer-events: none;
        background: #f8fafc;
      }
    }

    .searchable-select__value {
      font-size: 0.875rem;
      color: #0f172a;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;

      &.placeholder {
        color: #94a3b8;
      }
    }

    .searchable-select__icon {
      font-size: 0.875rem;
      color: #64748b;
      flex-shrink: 0;
      margin-left: 8px;
    }
  `],
  standalone: false,
})
export class SearchableSelectComponent {
  @Input() items: { id: number; nombre: string }[] = [];
  @Input() value: number | null = null;
  @Input() placeholder = 'Seleccione';
  @Input() title = 'Seleccionar';
  @Input() disabled = false;
  @Output() valueChange = new EventEmitter<number | null>();

  private modalCtrl: ModalController;

  constructor(modalCtrl: ModalController) {
    this.modalCtrl = modalCtrl;
  }

  get selectedLabel(): string {
    if (this.value == null) return '';
    const item = this.items.find(i => i.id === this.value);
    return item?.nombre ?? '';
  }

  async openModal(): Promise<void> {
    if (this.disabled) return;
    const modal = await this.modalCtrl.create({
      component: SearchableSelectModalComponent,
      cssClass: 'searchable-select-modal',
      componentProps: {
        items: this.items,
        selectedId: this.value,
        title: this.title,
      },
    });
    await modal.present();
    const { data } = await modal.onDidDismiss<number | null>();
    if (data !== undefined) {
      this.value = data;
      this.valueChange.emit(data);
    }
  }
}
