import { Injectable } from '@angular/core';

declare global {
  interface Window {
    jQuery?: unknown;
    PerfectScrollbar?: new (el: Element, opts?: object) => { destroy(): void };
  }
}

@Injectable({ providedIn: 'root' })
export class MetoxiInitService {
  private scrollers: Array<{ destroy(): void }> = [];

  activarShellErp(): void {
    document.documentElement.setAttribute('data-bs-theme', 'light');
    document.body.classList.add('sigre-metoxi-body');
    this.initPerfectScrollbar('.notify-list');
    this.initPerfectScrollbar('.search-content');
    this.initPerfectScrollbar('.sidebar-nav');
    this.initMetisMenu();
  }

  desactivarShellErp(): void {
    document.body.classList.remove('sigre-metoxi-body', 'toggled', 'sidebar-hovered');
    this.destruirScrollers();
  }

  private initMetisMenu(): void {
    const jq = window.jQuery as { (sel: string): { metisMenu?: () => void } } | undefined;
    if (!jq) return;
    try {
      jq('#sidenav').metisMenu?.();
    } catch {
      /* menú lateral ya controlado por Angular */
    }
  }

  private initPerfectScrollbar(selector: string): void {
    const PerfectScrollbar = window.PerfectScrollbar;
    if (!PerfectScrollbar) return;

    document.querySelectorAll(selector).forEach(el => {
      this.scrollers.push(new PerfectScrollbar(el, { suppressScrollX: true }));
    });
  }

  private destruirScrollers(): void {
    this.scrollers.forEach(s => s.destroy());
    this.scrollers = [];
  }
}
