import { Component, EventEmitter, Input, Output } from '@angular/core';

@Component({
  selector: 'app-empty-state',
  templateUrl: './empty-state.component.html',
  styleUrls: ['./empty-state.component.scss'],
  standalone: false
})
export class EmptyStateComponent {
  // @Input() img: string = 'assets/image/img-enty-no-register.png';
  // @Input() titulo: string = '';
  // @Input() descripcion: string = '';
  @Input() class: string = 'grow flex items-center justify-center';
  @Input() imageSrc: string = "";
  @Input() imageAlt: string = "Empty state";
  @Input() title: string = "";
  @Input() textBoton: string = "Agregar";
  @Input() deleteBoton!: string;
  @Input() description: string = "";
  @Input() imageWidth: string = "112px";
  @Input() imageHeight: string = "112px";

  @Output() agregar = new EventEmitter<void>();
  @Output() delete = new EventEmitter<void>();

    constructor() {}

  Agregar(){
    this.agregar.emit();
  }

  Delete(){
    this.delete.emit();
  }
}
