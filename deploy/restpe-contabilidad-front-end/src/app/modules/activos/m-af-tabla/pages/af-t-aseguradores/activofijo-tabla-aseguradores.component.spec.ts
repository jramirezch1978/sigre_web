import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ActivofijoTablaAseguradoresComponent } from './activofijo-tabla-aseguradores.component';

describe('ActivofijoTablaAseguradoresComponent', () => {
  let component: ActivofijoTablaAseguradoresComponent;
  let fixture: ComponentFixture<ActivofijoTablaAseguradoresComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoTablaAseguradoresComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoTablaAseguradoresComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
