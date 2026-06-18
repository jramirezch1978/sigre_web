import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { PFrecuenciaCalendariosComponent } from './p-frecuencia-calendarios.component';

describe('PFrecuenciaCalendariosComponent', () => {
  let component: PFrecuenciaCalendariosComponent;
  let fixture: ComponentFixture<PFrecuenciaCalendariosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ PFrecuenciaCalendariosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(PFrecuenciaCalendariosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
