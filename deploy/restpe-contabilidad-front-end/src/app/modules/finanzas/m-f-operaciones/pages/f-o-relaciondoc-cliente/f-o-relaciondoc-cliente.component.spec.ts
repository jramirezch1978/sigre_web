import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FORelaciondocClienteComponent } from './f-o-relaciondoc-cliente.component';

describe('FORelaciondocClienteComponent', () => {
  let component: FORelaciondocClienteComponent;
  let fixture: ComponentFixture<FORelaciondocClienteComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FORelaciondocClienteComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FORelaciondocClienteComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
