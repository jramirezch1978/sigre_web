import { Component, Input, OnInit, ElementRef, Renderer2, HostListener, OnDestroy } from '@angular/core';

@Component({
  selector: 'app-tooltip',
  templateUrl: './tooltip.component.html',
  styleUrls: ['./tooltip.component.scss'],
  standalone:false,
})
export class TooltipComponent  implements OnInit, OnDestroy {

  @Input() text: string = 'Información adicional aquí';
  @Input() color: string = 'text-danger';
  @Input() position: 'top' | 'bottom' | 'left' | 'right' = 'top';
  @Input() icon: string = 'info-circle';
  @Input() iconPrefix: 'far' | 'fas' = 'far';
  @Input() width: string = '200px';
  
  private tooltipElement: HTMLElement | null = null;
  
  constructor(private elementRef: ElementRef, private renderer: Renderer2) { }

  ngOnInit() {}

  ngOnDestroy() {
    this.removeTooltip();
  }

  @HostListener('mouseenter')
  onMouseEnter() {
    this.showTooltip();
  }

  @HostListener('mouseleave')
  onMouseLeave() {
    this.removeTooltip();
  }

  private showTooltip() {
    // Crear tooltip en el body
    this.tooltipElement = this.renderer.createElement('div');
    this.renderer.addClass(this.tooltipElement, 'tooltip-floating');
    this.renderer.addClass(this.tooltipElement, `tooltip-${this.position}`);
    this.renderer.setStyle(this.tooltipElement, 'width', this.width);
    
    const textNode = this.renderer.createText(this.text);
    this.renderer.appendChild(this.tooltipElement, textNode);
    this.renderer.appendChild(document.body, this.tooltipElement);

    // Calcular posición
    const iconElement = this.elementRef.nativeElement.querySelector('.tooltip-icon');
    const rect = iconElement.getBoundingClientRect();
    const tooltipRect = (this.tooltipElement as HTMLElement).getBoundingClientRect();

    let left = 0;
    let top = 0;

    switch (this.position) {
      case 'top':
        left = rect.left + (rect.width / 2) - (tooltipRect.width / 2);
        top = rect.top - tooltipRect.height - 8;
        break;
      case 'bottom':
        left = rect.left + (rect.width / 2) - (tooltipRect.width / 2);
        top = rect.bottom + 8;
        break;
      case 'left':
        left = rect.left - tooltipRect.width - 8;
        top = rect.top + (rect.height / 2) - (tooltipRect.height / 2);
        break;
      case 'right':
        left = rect.right + 8;
        top = rect.top + (rect.height / 2) - (tooltipRect.height / 2);
        break;
    }

    this.renderer.setStyle(this.tooltipElement, 'left', `${left}px`);
    this.renderer.setStyle(this.tooltipElement, 'top', `${top}px`);
    this.renderer.setStyle(this.tooltipElement, 'opacity', '1');
    this.renderer.setStyle(this.tooltipElement, 'visibility', 'visible');
  }

  private removeTooltip() {
    if (this.tooltipElement) {
      this.renderer.removeChild(document.body, this.tooltipElement);
      this.tooltipElement = null;
    }
  }

}
