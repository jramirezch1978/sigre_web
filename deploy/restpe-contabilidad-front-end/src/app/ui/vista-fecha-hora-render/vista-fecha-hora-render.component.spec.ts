import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { VistaFechaHoraRenderComponent } from './vista-fecha-hora-render.component';

describe('VistaFechaHoraRenderComponent', () => {
  let component: VistaFechaHoraRenderComponent;
  let fixture: ComponentFixture<VistaFechaHoraRenderComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ VistaFechaHoraRenderComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(VistaFechaHoraRenderComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
