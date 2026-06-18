import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasOperacionesFacturasProveedoresComponent } from './compras-operaciones-facturas-proveedores.component';

describe('ComprasOperacionesFacturasProveedoresComponent', () => {
  let component: ComprasOperacionesFacturasProveedoresComponent;
  let fixture: ComponentFixture<ComprasOperacionesFacturasProveedoresComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasOperacionesFacturasProveedoresComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasOperacionesFacturasProveedoresComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
