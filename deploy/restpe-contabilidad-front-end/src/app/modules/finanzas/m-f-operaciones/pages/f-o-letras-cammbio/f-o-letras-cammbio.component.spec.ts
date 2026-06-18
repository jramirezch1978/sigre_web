import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FOLetrasCammbioComponent } from './f-o-letras-cammbio.component';

describe('FOLetrasCammbioComponent', () => {
  let component: FOLetrasCammbioComponent;
  let fixture: ComponentFixture<FOLetrasCammbioComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FOLetrasCammbioComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FOLetrasCammbioComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
