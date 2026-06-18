import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasTablasGestionProveedoresComponent } from './compras-tablas-gestion-proveedores.component';

describe('ComprasTablasGestionProveedoresComponent', () => {
  let component: ComprasTablasGestionProveedoresComponent;
  let fixture: ComponentFixture<ComprasTablasGestionProveedoresComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasTablasGestionProveedoresComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasTablasGestionProveedoresComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
