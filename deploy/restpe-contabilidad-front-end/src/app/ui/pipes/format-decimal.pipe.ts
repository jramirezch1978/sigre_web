import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'formatDecimal',
  standalone: false
})
export class FormatDecimalPipe implements PipeTransform {
  transform(value: any): string {
    if (value === null || value === undefined || value === '') {
      return '';
    }
    const numValue = parseFloat(value);
    if (isNaN(numValue)) {
      return value;
    }
    return numValue.toFixed(2);
  }
}
