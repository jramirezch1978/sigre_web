import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { GeneracionsiniestroTabReclamoComponent } from './generacionsiniestro-tab-reclamo.component';

describe('GeneracionsiniestroTabReclamoComponent', () => {
  let component: GeneracionsiniestroTabReclamoComponent;
  let fixture: ComponentFixture<GeneracionsiniestroTabReclamoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ GeneracionsiniestroTabReclamoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(GeneracionsiniestroTabReclamoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
