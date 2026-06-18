import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FCCruceExtractoComponent } from './f-c-cruce-extracto.component';

describe('FCCruceExtractoComponent', () => {
  let component: FCCruceExtractoComponent;
  let fixture: ComponentFixture<FCCruceExtractoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FCCruceExtractoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FCCruceExtractoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
