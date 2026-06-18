import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { RAEmisionBoletasComponent } from './r-a-emision-boletas.component';

describe('RAEmisionBoletasComponent', () => {
  let component: RAEmisionBoletasComponent;
  let fixture: ComponentFixture<RAEmisionBoletasComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ RAEmisionBoletasComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(RAEmisionBoletasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
