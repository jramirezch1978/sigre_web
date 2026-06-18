import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ActivofijoTablaUbicacionactivosComponent } from './activofijo-tabla-ubicacionactivos.component';

describe('ActivofijoTablaUbicacionactivosComponent', () => {
  let component: ActivofijoTablaUbicacionactivosComponent;
  let fixture: ComponentFixture<ActivofijoTablaUbicacionactivosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoTablaUbicacionactivosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoTablaUbicacionactivosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
