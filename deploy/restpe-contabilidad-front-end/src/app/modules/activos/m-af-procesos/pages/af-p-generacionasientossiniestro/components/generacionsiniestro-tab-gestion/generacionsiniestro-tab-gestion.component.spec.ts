import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { GeneracionsiniestroTabGestionComponent } from './generacionsiniestro-tab-gestion.component';

describe('GeneracionsiniestroTabGestionComponent', () => {
  let component: GeneracionsiniestroTabGestionComponent;
  let fixture: ComponentFixture<GeneracionsiniestroTabGestionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ GeneracionsiniestroTabGestionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(GeneracionsiniestroTabGestionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
