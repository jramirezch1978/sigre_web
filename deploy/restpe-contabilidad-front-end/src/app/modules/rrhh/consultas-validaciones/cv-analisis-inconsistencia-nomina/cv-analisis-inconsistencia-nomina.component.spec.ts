import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { CvAnalisisInconsistenciaNominaComponent } from './cv-analisis-inconsistencia-nomina.component';

describe('CvAnalisisInconsistenciaNominaComponent', () => {
  let component: CvAnalisisInconsistenciaNominaComponent;
  let fixture: ComponentFixture<CvAnalisisInconsistenciaNominaComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ CvAnalisisInconsistenciaNominaComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(CvAnalisisInconsistenciaNominaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
