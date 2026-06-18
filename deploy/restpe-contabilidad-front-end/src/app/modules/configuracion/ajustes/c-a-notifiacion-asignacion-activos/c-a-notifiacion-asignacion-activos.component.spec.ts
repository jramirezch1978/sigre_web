import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { CANotifiacionAsignacionActivosComponent } from './c-a-notifiacion-asignacion-activos.component';

describe('CANotifiacionAsignacionActivosComponent', () => {
  let component: CANotifiacionAsignacionActivosComponent;
  let fixture: ComponentFixture<CANotifiacionAsignacionActivosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ CANotifiacionAsignacionActivosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(CANotifiacionAsignacionActivosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
