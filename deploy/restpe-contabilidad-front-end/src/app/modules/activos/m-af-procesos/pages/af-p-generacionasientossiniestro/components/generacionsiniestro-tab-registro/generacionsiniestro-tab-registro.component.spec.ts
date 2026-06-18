import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { GeneracionsiniestroTabRegistroComponent } from './generacionsiniestro-tab-registro.component';

describe('GeneracionsiniestroTabRegistroComponent', () => {
  let component: GeneracionsiniestroTabRegistroComponent;
  let fixture: ComponentFixture<GeneracionsiniestroTabRegistroComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ GeneracionsiniestroTabRegistroComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(GeneracionsiniestroTabRegistroComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
