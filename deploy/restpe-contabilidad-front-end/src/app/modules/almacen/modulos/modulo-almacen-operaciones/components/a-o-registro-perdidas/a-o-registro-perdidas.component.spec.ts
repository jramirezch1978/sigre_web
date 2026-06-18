import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AORegistroPerdidasComponent } from './a-o-registro-perdidas.component';

describe('AORegistroPerdidasComponent', () => {
  let component: AORegistroPerdidasComponent;
  let fixture: ComponentFixture<AORegistroPerdidasComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AORegistroPerdidasComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AORegistroPerdidasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
