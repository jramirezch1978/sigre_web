import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { CPGenerarlibrosComponent } from './c-p-generarlibros.component';

describe('CPGenerarlibrosComponent', () => {
  let component: CPGenerarlibrosComponent;
  let fixture: ComponentFixture<CPGenerarlibrosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ CPGenerarlibrosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(CPGenerarlibrosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
