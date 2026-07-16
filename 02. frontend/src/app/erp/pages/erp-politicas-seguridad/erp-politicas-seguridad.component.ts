import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { AuthService } from '../../../auth/services/auth.service';

interface NormaLegal {
  titulo: string;
  articulo: string;
  texto: string;
}

@Component({
  selector: 'app-erp-politicas-seguridad',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './erp-politicas-seguridad.component.html',
  styleUrls: ['./erp-politicas-seguridad.component.scss'],
})
export class ErpPoliticasSeguridadComponent {

  currentYear = new Date().getFullYear();

  readonly normativaPeru: NormaLegal[] = [
    {
      titulo: 'Objeto de la ley',
      articulo: 'Ley N.º 29733, Art. 1',
      texto: 'La presente Ley tiene el objeto de garantizar el derecho fundamental a la protección de los datos personales, previsto en el artículo 2 numeral 6 de la Constitución Política del Perú, a través de su adecuado tratamiento, en un marco de respeto de los demás derechos fundamentales que en ella se reconocen.',
    },
    {
      titulo: 'Principio de seguridad',
      articulo: 'Ley N.º 29733, Art. 9',
      texto: 'El titular del banco de datos personales y el encargado de su tratamiento deben adoptar las medidas técnicas, organizativas y legales necesarias para garantizar la seguridad de los datos personales. Las medidas de seguridad deben ser apropiadas y acordes con el tratamiento que se vaya a efectuar y con la categoría de datos personales de que se trate.',
    },
    {
      titulo: 'Confidencialidad',
      articulo: 'Ley N.º 29733, Art. 17',
      texto: 'El titular del banco de datos personales, el encargado y quienes intervengan en cualquier parte de su tratamiento están obligados a guardar confidencialidad respecto de los mismos.',
    },
    {
      titulo: 'Flujo transfronterizo de datos',
      articulo: 'Ley N.º 29733, Art. 15',
      texto: 'El titular y el encargado del banco de datos personales deben realizar el flujo transfronterizo de datos personales solo si el país destinatario mantiene niveles de protección adecuados.',
    },
    {
      titulo: 'Autoridad competente',
      articulo: 'Ley N.º 29733, Art. 32',
      texto: 'El Ministerio de Justicia, a través de la Autoridad Nacional de Protección de Datos Personales, es el ente rector en materia de protección de datos personales en el Perú.',
    },
  ];

  readonly derechosArco: { letra: string; nombre: string; articulo: string; desc: string }[] = [
    { letra: 'A', nombre: 'Acceso', articulo: 'Art. 18', desc: 'Solicitar qué datos personales se tienen registrados y con qué finalidad se tratan.' },
    { letra: 'R', nombre: 'Rectificación', articulo: 'Art. 19', desc: 'Solicitar la corrección de datos inexactos, incompletos o desactualizados.' },
    { letra: 'C', nombre: 'Cancelación', articulo: 'Art. 20', desc: 'Solicitar la supresión de datos cuando ya no sean necesarios para la finalidad con la que fueron recabados.' },
    { letra: 'O', nombre: 'Oposición', articulo: 'Art. 21', desc: 'Oponerse al tratamiento de sus datos personales por motivos legítimos.' },
  ];

  readonly reglamentoVigente = {
    norma: 'Decreto Supremo N.º 016-2024-JUS',
    vigencia: 'vigente desde el 30 de marzo de 2025, en reemplazo del D.S. N.º 003-2013-JUS',
    puntos: [
      'Notificación de incidentes de seguridad que afecten datos personales a la Autoridad Nacional de Protección de Datos Personales dentro de las 48 horas de detectados.',
      'Exigencia de designar un Oficial de Datos Personales para el tratamiento habitual, a gran escala o de categorías especiales de datos.',
      'Alcance extraterritorial: aplica a toda organización, nacional o extranjera, que trate datos personales de personas ubicadas en el Perú.',
    ],
  };

  readonly internacional: NormaLegal[] = [
    {
      titulo: 'Seguridad del tratamiento (RGPD / GDPR — Unión Europea)',
      articulo: 'Reglamento (UE) 2016/679, Art. 32',
      texto: 'Teniendo en cuenta el estado de la técnica, los costes de aplicación, y la naturaleza, el alcance, el contexto y los fines del tratamiento, así como riesgos de probabilidad y gravedad variables para los derechos y libertades de las personas físicas, el responsable y el encargado del tratamiento aplicarán medidas técnicas y organizativas apropiadas para garantizar un nivel de seguridad adecuado al riesgo.',
    },
    {
      titulo: 'Acceso ilícito a sistemas informáticos',
      articulo: 'Ley N.º 30096 (Ley de Delitos Informáticos, modificada por Ley N.º 30171), Art. 2',
      texto: 'El que accede sin autorización a todo o parte de un sistema informático, siempre que se realice con vulneración de medidas de seguridad establecidas para impedirlo, será reprimido con pena privativa de libertad.',
    },
  ];

  constructor(
    private readonly router: Router,
    private readonly authService: AuthService,
  ) {}

  volver(): void {
    void this.router.navigateByUrl('/sigre/inicio');
  }

  irALogin(): void {
    void this.authService.invalidateSession().then(() => {
      void this.router.navigateByUrl('/auth/signin');
    });
  }
}
