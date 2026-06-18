import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ActivofijoTablaParamoperacionesComponent } from './activofijo-tabla-paramoperaciones.component';

describe('ActivofijoTablaParamoperacionesComponent', () => {
  let component: ActivofijoTablaParamoperacionesComponent;
  let fixture: ComponentFixture<ActivofijoTablaParamoperacionesComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoTablaParamoperacionesComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoTablaParamoperacionesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
