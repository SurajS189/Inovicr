import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import { logger } from './utils/logger';

const app = express();
const PORT = process.env.PORT || 4000;

// ── Middleware ──────────────────────────────────────────────
app.use(helmet());
app.use(cors({ origin: process.env.WEB_URL, credentials: true }));
app.use(compression());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ── Health check ────────────────────────────────────────────
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ── Routes (add as you build each sprint) ───────────────────
// app.use('/auth',     authRouter);
// app.use('/invoices', invoiceRouter);
// app.use('/clients',  clientRouter);
// app.use('/expenses', expenseRouter);

// ── 404 handler ─────────────────────────────────────────────
app.use((_req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// ── Global error handler ─────────────────────────────────────
app.use((err: Error, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  logger.error(err);
  res.status(500).json({ error: 'Internal server error' });
});

// ── Start ───────────────────────────────────────────────────
app.listen(PORT, () => {
  logger.info(`API running on http://localhost:${PORT}`);
});

export default app;
