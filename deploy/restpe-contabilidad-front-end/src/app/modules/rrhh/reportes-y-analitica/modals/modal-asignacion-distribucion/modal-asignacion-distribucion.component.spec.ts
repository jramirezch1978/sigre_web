import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ModalAsignacionDistribucionComponent } from './modal-asignacion-distribucion.component';

describe('ModalAsignacionDistribucionComponent', () => {
  let component: ModalAsignacionDistribucionComponent;
  let fixture: ComponentFixture<ModalAsignacionDistribucionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ModalAsignacionDistribucionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ModalAsignacionDistribucionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
