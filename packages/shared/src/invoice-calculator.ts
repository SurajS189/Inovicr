import { LineItemInput, InvoiceTotals } from './types';

/**
 * Single source of truth for invoice calculations.
 * Used in:
 *   - apps/web: live preview as user types
 *   - apps/api: server-side verification before saving
 *
 * NEVER calculate invoice totals anywhere else.
 */
export function calculateLineItem(item: LineItemInput): number {
  const gross = item.quantity * item.unitPrice;
  const tax = gross * (item.taxPercent / 100);
  const total = gross + tax - item.discount;
  return parseFloat(total.toFixed(2));
}

export function calculateInvoiceTotals(items: LineItemInput[]): InvoiceTotals {
  const subtotal = items.reduce((sum, item) => {
    return sum + item.quantity * item.unitPrice;
  }, 0);

  const taxAmount = items.reduce((sum, item) => {
    return sum + item.quantity * item.unitPrice * (item.taxPercent / 100);
  }, 0);

  const discountAmount = items.reduce((sum, item) => sum + item.discount, 0);

  const total = subtotal + taxAmount - discountAmount;

  return {
    subtotal: parseFloat(subtotal.toFixed(2)),
    taxAmount: parseFloat(taxAmount.toFixed(2)),
    discountAmount: parseFloat(discountAmount.toFixed(2)),
    total: parseFloat(total.toFixed(2)),
  };
}
