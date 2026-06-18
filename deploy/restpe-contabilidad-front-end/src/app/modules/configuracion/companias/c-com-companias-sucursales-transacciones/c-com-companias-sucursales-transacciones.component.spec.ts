import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { CComCompaniasSucursalesTransaccionesComponent } from './c-com-companias-sucursales-transacciones.component';

describe('CComCompaniasSucursalesTransaccionesComponent', () => {
  let component: CComCompaniasSucursalesTransaccionesComponent;
  let fixture: ComponentFixture<CComCompaniasSucursalesTransaccionesComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ CComCompaniasSucursalesTransaccionesComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(CComCompaniasSucursalesTransaccionesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
