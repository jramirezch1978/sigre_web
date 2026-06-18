import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AoAlmacenamientoComponent } from './a-o-almacenamiento.component';

describe('AoAlmacenamientoComponent', () => {
  let component: AoAlmacenamientoComponent;
  let fixture: ComponentFixture<AoAlmacenamientoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AoAlmacenamientoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AoAlmacenamientoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
