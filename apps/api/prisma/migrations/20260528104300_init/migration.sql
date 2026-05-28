-- CreateEnum
CREATE TYPE "TenantRole" AS ENUM ('OWNER', 'ACCOUNTANT', 'VIEWER');

-- CreateEnum
CREATE TYPE "InvoiceStatus" AS ENUM ('DRAFT', 'SENT', 'VIEWED', 'PAID', 'OVERDUE', 'CANCELLED');

-- CreateEnum
CREATE TYPE "RecurringFreq" AS ENUM ('WEEKLY', 'MONTHLY', 'QUARTERLY', 'YEARLY');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('INVOICE_VIEWED', 'PAYMENT_RECEIVED', 'INVOICE_OVERDUE', 'REMINDER_SENT', 'AI_INSIGHT');

-- CreateTable
CREATE TABLE "tenants" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "logoUrl" TEXT,
    "address" TEXT,
    "gstNumber" TEXT,
    "invoicePrefix" TEXT NOT NULL DEFAULT 'INV',
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tenants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT,
    "name" TEXT NOT NULL,
    "avatarUrl" TEXT,
    "googleId" TEXT,
    "emailVerified" BOOLEAN NOT NULL DEFAULT false,
    "verifyToken" TEXT,
    "resetToken" TEXT,
    "resetTokenExp" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tenant_users" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "role" "TenantRole" NOT NULL DEFAULT 'VIEWER',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tenant_users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "tokenHash" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revokedAt" TIMESTAMP(3),

    CONSTRAINT "refresh_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invites" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "role" "TenantRole" NOT NULL DEFAULT 'VIEWER',
    "token" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "accepted" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "invites_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "clients" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT,
    "address" TEXT,
    "gstNumber" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "clients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoices" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "invoiceNumber" TEXT NOT NULL,
    "status" "InvoiceStatus" NOT NULL DEFAULT 'DRAFT',
    "issueDate" TIMESTAMP(3) NOT NULL,
    "dueDate" TIMESTAMP(3) NOT NULL,
    "notes" TEXT,
    "subtotal" DECIMAL(12,2) NOT NULL,
    "taxAmount" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "discountAmount" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "total" DECIMAL(12,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "pdfUrl" TEXT,
    "viewToken" TEXT NOT NULL,
    "viewedAt" TIMESTAMP(3),
    "paidAt" TIMESTAMP(3),
    "paymentMethod" TEXT,
    "razorpayLinkId" TEXT,
    "razorpayLinkUrl" TEXT,
    "isRecurring" BOOLEAN NOT NULL DEFAULT false,
    "recurringFreq" "RecurringFreq",
    "nextRunAt" TIMESTAMP(3),
    "parentInvoiceId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "invoices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "line_items" (
    "id" TEXT NOT NULL,
    "invoiceId" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "quantity" DECIMAL(10,2) NOT NULL,
    "unitPrice" DECIMAL(12,2) NOT NULL,
    "taxPercent" DECIMAL(5,2) NOT NULL DEFAULT 0,
    "discount" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "total" DECIMAL(12,2) NOT NULL,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "line_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" TEXT NOT NULL,
    "invoiceId" TEXT NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "method" TEXT NOT NULL,
    "reference" TEXT,
    "note" TEXT,
    "paidAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "expenses" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "category" TEXT,
    "aiCategory" TEXT,
    "aiConfidence" DOUBLE PRECISION,
    "receiptUrl" TEXT,
    "expenseDate" TIMESTAMP(3) NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "expenses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" "NotificationType" NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "metadata" JSONB,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reminder_logs" (
    "id" TEXT NOT NULL,
    "invoiceId" TEXT NOT NULL,
    "sentAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "type" TEXT NOT NULL,
    "emailTo" TEXT NOT NULL,

    CONSTRAINT "reminder_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_googleId_key" ON "users"("googleId");

-- CreateIndex
CREATE UNIQUE INDEX "tenant_users_tenantId_userId_key" ON "tenant_users"("tenantId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_tokenHash_key" ON "refresh_tokens"("tokenHash");

-- CreateIndex
CREATE UNIQUE INDEX "invites_token_key" ON "invites"("token");

-- CreateIndex
CREATE INDEX "clients_tenantId_idx" ON "clients"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "invoices_viewToken_key" ON "invoices"("viewToken");

-- CreateIndex
CREATE INDEX "invoices_tenantId_status_idx" ON "invoices"("tenantId", "status");

-- CreateIndex
CREATE INDEX "invoices_tenantId_dueDate_idx" ON "invoices"("tenantId", "dueDate");

-- CreateIndex
CREATE UNIQUE INDEX "invoices_tenantId_invoiceNumber_key" ON "invoices"("tenantId", "invoiceNumber");

-- CreateIndex
CREATE INDEX "expenses_tenantId_expenseDate_idx" ON "expenses"("tenantId", "expenseDate");

-- CreateIndex
CREATE INDEX "notifications_userId_read_idx" ON "notifications"("userId", "read");

-- AddForeignKey
ALTER TABLE "tenant_users" ADD CONSTRAINT "tenant_users_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tenant_users" ADD CONSTRAINT "tenant_users_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invites" ADD CONSTRAINT "invites_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "clients" ADD CONSTRAINT "clients_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "clients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "line_items" ADD CONSTRAINT "line_items_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoices"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoices"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expenses" ADD CONSTRAINT "expenses_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reminder_logs" ADD CONSTRAINT "reminder_logs_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoices"("id") ON DELETE CASCADE ON UPDATE CASCADE;
