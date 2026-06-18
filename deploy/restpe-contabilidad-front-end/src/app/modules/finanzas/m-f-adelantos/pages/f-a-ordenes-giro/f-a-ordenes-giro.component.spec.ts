import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FAOrdenesGiroComponent } from './f-a-ordenes-giro.component';

describe('FAOrdenesGiroComponent', () => {
  let component: FAOrdenesGiroComponent;
  let fixture: ComponentFixture<FAOrdenesGiroComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FAOrdenesGiroComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FAOrdenesGiroComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
