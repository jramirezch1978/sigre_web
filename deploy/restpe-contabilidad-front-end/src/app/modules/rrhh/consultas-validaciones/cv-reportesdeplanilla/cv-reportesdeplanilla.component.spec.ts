import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { CvReportesdeplanillaComponent } from './cv-reportesdeplanilla.component';

describe('CvReportesdeplanillaComponent', () => {
  let component: CvReportesdeplanillaComponent;
  let fixture: ComponentFixture<CvReportesdeplanillaComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ CvReportesdeplanillaComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(CvReportesdeplanillaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
