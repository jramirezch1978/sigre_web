import { Component, ElementRef, OnDestroy, ViewChild, AfterViewInit } from '@angular/core';
import lottie, { AnimationItem } from 'lottie-web';

// Cache estático del JSON para evitar fetch HTTP en cada instancia
let cachedAnimationData: any = null;
let loadingPromise: Promise<any> | null = null;

function getAnimationData(): Promise<any> {
  if (cachedAnimationData) {
    return Promise.resolve(cachedAnimationData);
  }
  if (!loadingPromise) {
    loadingPromise = fetch('assets/imagenes/Loading-conta.json')
      .then(res => res.json())
      .then(data => {
        cachedAnimationData = data;
        return data;
      });
  }
  return loadingPromise;
}

@Component({
  selector: 'app-loader',
  templateUrl: './loader.component.html',
  styleUrls: ['./loader.component.scss'],
  standalone: false
})
export class LoaderComponent implements AfterViewInit, OnDestroy {
  @ViewChild('lottieContainer', { static: false }) lottieContainer!: ElementRef;

  private animation!: AnimationItem;

  ngAfterViewInit(): void {
    getAnimationData().then(data => {
      if (this.lottieContainer) {
        this.animation = lottie.loadAnimation({
          container: this.lottieContainer.nativeElement,
          renderer: 'svg',
          loop: true,
          autoplay: true,
          animationData: data,
        });
      }
    });
  }

  ngOnDestroy(): void {
    if (this.animation) {
      this.animation.destroy();
    }
  }
}
