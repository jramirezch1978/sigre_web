import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FTProyeccionIngresosEgresosComponent } from './f-t-proyeccion-ingresos-egresos.component';

describe('FTProyeccionIngresosEgresosComponent', () => {
  let component: FTProyeccionIngresosEgresosComponent;
  let fixture: ComponentFixture<FTProyeccionIngresosEgresosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FTProyeccionIngresosEgresosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FTProyeccionIngresosEgresosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
