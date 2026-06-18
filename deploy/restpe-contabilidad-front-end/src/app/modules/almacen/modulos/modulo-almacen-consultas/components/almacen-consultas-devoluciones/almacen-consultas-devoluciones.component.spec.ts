import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AlmacenConsultasDevolucionesComponent } from './almacen-consultas-devoluciones.component';

describe('AlmacenConsultasDevolucionesComponent', () => {
  let component: AlmacenConsultasDevolucionesComponent;
  let fixture: ComponentFixture<AlmacenConsultasDevolucionesComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AlmacenConsultasDevolucionesComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AlmacenConsultasDevolucionesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
