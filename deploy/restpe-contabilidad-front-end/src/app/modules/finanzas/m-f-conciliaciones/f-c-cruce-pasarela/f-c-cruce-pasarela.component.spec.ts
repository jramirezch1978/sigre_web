import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FCCrucePasarelaComponent } from './f-c-cruce-pasarela.component';

describe('FCCrucePasarelaComponent', () => {
  let component: FCCrucePasarelaComponent;
  let fixture: ComponentFixture<FCCrucePasarelaComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FCCrucePasarelaComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FCCrucePasarelaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
