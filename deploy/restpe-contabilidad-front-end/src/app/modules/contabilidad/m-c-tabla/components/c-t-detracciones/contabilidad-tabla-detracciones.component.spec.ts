import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ContabilidadTablaDetraccionesComponent } from './contabilidad-tabla-detracciones.component';

describe('ContabilidadTablaDetraccionesComponent', () => {
  let component: ContabilidadTablaDetraccionesComponent;
  let fixture: ComponentFixture<ContabilidadTablaDetraccionesComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ContabilidadTablaDetraccionesComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ContabilidadTablaDetraccionesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
