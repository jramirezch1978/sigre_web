import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { PNProcesosEspecialesComponent } from './p-n-procesos-especiales.component';

describe('PNProcesosEspecialesComponent', () => {
  let component: PNProcesosEspecialesComponent;
  let fixture: ComponentFixture<PNProcesosEspecialesComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ PNProcesosEspecialesComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(PNProcesosEspecialesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
