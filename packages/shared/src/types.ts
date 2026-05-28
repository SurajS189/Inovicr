// ── Invoice types ────────────────────────────────────────────
export type InvoiceStatus = 'DRAFT' | 'SENT' | 'VIEWED' | 'PAID' | 'OVERDUE' | 'CANCELLED';
export type TenantRole = 'OWNER' | 'ACCOUNTANT' | 'VIEWER';
export type RecurringFreq = 'WEEKLY' | 'MONTHLY' | 'QUARTERLY' | 'YEARLY';

export interface LineItemInput {
  description: string;
  quantity: number;
  unitPrice: number;
  taxPercent: number;
  discount: number;
}

export interface InvoiceTotals {
  subtotal: number;
  taxAmount: number;
  discountAmount: number;
  total: number;
}

export interface ApiResponse<T> {
  data: T;
  message?: string;
}

export interface ApiError {
  error: string;
  details?: Record<string, string[]>;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}
