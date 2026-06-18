import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AsignacionFondoFijoCajaComponent } from './asignacion-fondo-fijo-caja.component';

describe('AsignacionFondoFijoCajaComponent', () => {
  let component: AsignacionFondoFijoCajaComponent;
  let fixture: ComponentFixture<AsignacionFondoFijoCajaComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AsignacionFondoFijoCajaComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AsignacionFondoFijoCajaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
