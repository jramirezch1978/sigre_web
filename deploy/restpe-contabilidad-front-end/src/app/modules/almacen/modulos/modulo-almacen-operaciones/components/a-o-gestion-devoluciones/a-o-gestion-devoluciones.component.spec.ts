import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AOGestionDevolucionesComponent } from './a-o-gestion-devoluciones.component';

describe('AOGestionDevolucionesComponent', () => {
  let component: AOGestionDevolucionesComponent;
  let fixture: ComponentFixture<AOGestionDevolucionesComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AOGestionDevolucionesComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AOGestionDevolucionesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
