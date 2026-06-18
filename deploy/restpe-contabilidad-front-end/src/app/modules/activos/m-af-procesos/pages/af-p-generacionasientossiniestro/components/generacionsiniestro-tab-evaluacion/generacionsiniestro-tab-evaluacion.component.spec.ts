import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { GeneracionsiniestroTabEvaluacionComponent } from './generacionsiniestro-tab-evaluacion.component';

describe('GeneracionsiniestroTabEvaluacionComponent', () => {
  let component: GeneracionsiniestroTabEvaluacionComponent;
  let fixture: ComponentFixture<GeneracionsiniestroTabEvaluacionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ GeneracionsiniestroTabEvaluacionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(GeneracionsiniestroTabEvaluacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
