import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FORelaciondocProveedorComponent } from './f-o-relaciondoc-proveedor.component';

describe('FORelaciondocProveedorComponent', () => {
  let component: FORelaciondocProveedorComponent;
  let fixture: ComponentFixture<FORelaciondocProveedorComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FORelaciondocProveedorComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FORelaciondocProveedorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
