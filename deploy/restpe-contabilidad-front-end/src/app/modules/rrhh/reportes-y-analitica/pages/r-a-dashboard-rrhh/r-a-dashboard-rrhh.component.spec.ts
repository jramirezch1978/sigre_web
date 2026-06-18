import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { RADashboardRrhhComponent } from './r-a-dashboard-rrhh.component';

describe('RADashboardRrhhComponent', () => {
  let component: RADashboardRrhhComponent;
  let fixture: ComponentFixture<RADashboardRrhhComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ RADashboardRrhhComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(RADashboardRrhhComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
