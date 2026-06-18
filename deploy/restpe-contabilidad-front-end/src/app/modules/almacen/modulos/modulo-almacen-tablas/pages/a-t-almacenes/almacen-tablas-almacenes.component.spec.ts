import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AlmacenTablasAlmacenesComponent } from './almacen-tablas-almacenes.component';

describe('AlmacenTablasAlmacenesComponent', () => {
  let component: AlmacenTablasAlmacenesComponent;
  let fixture: ComponentFixture<AlmacenTablasAlmacenesComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AlmacenTablasAlmacenesComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AlmacenTablasAlmacenesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
