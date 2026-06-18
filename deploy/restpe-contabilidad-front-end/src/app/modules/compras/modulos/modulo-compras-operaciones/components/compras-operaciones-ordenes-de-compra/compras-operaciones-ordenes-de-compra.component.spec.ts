import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasOperacionesOrdenesDeCompraComponent } from './compras-operaciones-ordenes-de-compra.component';

describe('ComprasOperacionesOrdenesDeCompraComponent', () => {
  let component: ComprasOperacionesOrdenesDeCompraComponent;
  let fixture: ComponentFixture<ComprasOperacionesOrdenesDeCompraComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasOperacionesOrdenesDeCompraComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasOperacionesOrdenesDeCompraComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
