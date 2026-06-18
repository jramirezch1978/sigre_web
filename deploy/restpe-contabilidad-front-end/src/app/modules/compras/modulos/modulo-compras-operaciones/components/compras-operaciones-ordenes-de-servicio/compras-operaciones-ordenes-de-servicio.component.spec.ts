import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasOperacionesOrdenesDeServicioComponent } from './compras-operaciones-ordenes-de-servicio.component';

describe('ComprasOperacionesOrdenesDeServicioComponent', () => {
  let component: ComprasOperacionesOrdenesDeServicioComponent;
  let fixture: ComponentFixture<ComprasOperacionesOrdenesDeServicioComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasOperacionesOrdenesDeServicioComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasOperacionesOrdenesDeServicioComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
