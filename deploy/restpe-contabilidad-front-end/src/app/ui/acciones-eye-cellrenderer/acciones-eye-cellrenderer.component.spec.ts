import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AccionesEyeCellrendererComponent } from './acciones-eye-cellrenderer.component';

describe('AccionesEyeCellrendererComponent', () => {
  let component: AccionesEyeCellrendererComponent;
  let fixture: ComponentFixture<AccionesEyeCellrendererComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AccionesEyeCellrendererComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AccionesEyeCellrendererComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
