import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AJCalendariosLaboralesComponent } from './a-j-calendarios-laborales.component';

describe('AJCalendariosLaboralesComponent', () => {
  let component: AJCalendariosLaboralesComponent;
  let fixture: ComponentFixture<AJCalendariosLaboralesComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AJCalendariosLaboralesComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AJCalendariosLaboralesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
