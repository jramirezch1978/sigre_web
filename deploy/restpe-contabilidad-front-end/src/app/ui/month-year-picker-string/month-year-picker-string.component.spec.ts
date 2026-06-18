import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { MonthYearPickerStringComponent } from './month-year-picker-string.component';

describe('MonthYearPickerStringComponent', () => {
  let component: MonthYearPickerStringComponent;
  let fixture: ComponentFixture<MonthYearPickerStringComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ MonthYearPickerStringComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(MonthYearPickerStringComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
