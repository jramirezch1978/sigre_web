import { ComponentFactoryResolver, ComponentRef, Directive, DoCheck, ElementRef, Injector, Input, OnChanges, SimpleChanges, ViewContainerRef } from '@angular/core';
import { LoaderComponent } from '../loader/loader.component';

@Directive({
  selector: '[appLoader]',
  standalone: false
})
export class LoaderDirective implements OnChanges, DoCheck{
  @Input() appLoader: boolean = false;
  // private componentRef: ComponentRef<LoaderComponent> | null = null;
  private isVisible: boolean = false;

  constructor(
    private elementRef: ElementRef,
    private componentFactoryResolver: ComponentFactoryResolver,
    private viewContainerRef: ViewContainerRef,
    private injector: Injector,
  ) {}

  ngOnChanges(changes: SimpleChanges): void {
    if(this.appLoader){
    //   this.showSpinner();
    // } else {
    //   this.removeSpinner();
    // }
    }
  }

  ngDoCheck(): void {
    if (this.appLoader && !this.isVisible) {
      this.showSpinner();
      this.isVisible = true;
    } else if (!this.appLoader && this.isVisible) {
      this.removeSpinner();
      this.isVisible = false;
    }
  }


  private showSpinner(): void {
    const div = document.createElement('div');
    div.setAttribute('id', 'loading');

    div.style.position = 'absolute';
    div.style.top = '0';
    div.style.left = '0';
    div.style.width = '100%';
    div.style.height = '100%';
    div.style.backgroundColor = 'rgba(255, 255, 255, 0.4)';
    div.style.display = 'flex';
    div.style.justifyContent = 'center';
    div.style.alignItems = 'center';
    div.style.zIndex = '5000';

    // Crear una instancia de tu componente
    const componentFactory = this.componentFactoryResolver.resolveComponentFactory(LoaderComponent);
    const componentRef = componentFactory.create(this.injector);
    this.viewContainerRef.insert(componentRef.hostView);

    div.appendChild(componentRef.location.nativeElement);

    this.elementRef.nativeElement.appendChild(div);
  }

  private removeSpinner(): void {
    const div = this.elementRef.nativeElement.querySelector('#loading');
    if (div) {
      div.remove();
    }
  }

}
