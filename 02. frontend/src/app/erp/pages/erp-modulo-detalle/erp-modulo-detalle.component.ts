import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { MODULOS_INFO, ModuloCompleto } from './modulos-data';

@Component({
  selector: 'app-erp-modulo-detalle',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './erp-modulo-detalle.component.html',
  styleUrls: ['./erp-modulo-detalle.component.scss'],
})
export class ErpModuloDetalleComponent implements OnInit {

  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly sanitizer = inject(DomSanitizer);

  modulo: ModuloCompleto | null = null;
  currentYear = new Date().getFullYear();

  ngOnInit(): void {
    const codigo = this.route.snapshot.paramMap.get('codigo')?.toUpperCase() ?? '';
    this.modulo = MODULOS_INFO.find(m => m.codigo === codigo) ?? null;
    if (!this.modulo) {
      void this.router.navigateByUrl('/sigre/inicio');
    }
  }

  volver(): void {
    void this.router.navigateByUrl('/sigre/inicio');
  }

  irALogin(): void {
    void this.router.navigateByUrl('/auth/signin');
  }

  renderDiagramaHTML(): SafeHtml {
    if (!this.modulo) return '';
    const lines = this.modulo.diagramaMermaid.trim().split('\n').slice(1);
    const nodes = new Map<string, string>();
    const edges: { from: string; to: string; label?: string }[] = [];

    for (const line of lines) {
      const nodeMatch = line.match(/(\w+)\[([^\]]+)\]/g);
      if (nodeMatch) {
        for (const nm of nodeMatch) {
          const m = nm.match(/(\w+)\[([^\]]+)\]/);
          if (m) nodes.set(m[1], m[2]);
        }
      }
      const nodeMatchBrace = line.match(/(\w+)\{([^}]+)\}/g);
      if (nodeMatchBrace) {
        for (const nm of nodeMatchBrace) {
          const m = nm.match(/(\w+)\{([^}]+)\}/);
          if (m) nodes.set(m[1], `◆ ${m[2]}`);
        }
      }
      const edgeMatch = line.match(/(\w+)\s*-->(?:\|([^|]*)\|)?\s*(\w+)/);
      if (edgeMatch) {
        edges.push({ from: edgeMatch[1], to: edgeMatch[3], label: edgeMatch[2] });
      }
    }

    let html = '<div class="flow-diagram">';
    const nodeList = Array.from(nodes.entries());
    for (let i = 0; i < nodeList.length; i++) {
      const [id, label] = nodeList[i];
      const isDecision = label.startsWith('◆');
      html += `<div class="flow-node ${isDecision ? 'decision' : ''}" data-id="${id}">`;
      html += `<span>${label.replace('◆ ', '')}</span>`;
      html += '</div>';
      if (i < nodeList.length - 1) {
        const edge = edges.find(e => e.from === id);
        html += '<div class="flow-arrow">';
        html += edge?.label ? `<small>${edge.label}</small>` : '';
        html += '<svg width="24" height="24" viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7" stroke="currentColor" stroke-width="2" fill="none"/></svg>';
        html += '</div>';
      }
    }
    html += '</div>';
    return this.sanitizer.bypassSecurityTrustHtml(html);
  }
}
