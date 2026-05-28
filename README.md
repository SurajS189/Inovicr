# ⚡ Invoicr — Multi-tenant Invoice SaaS

> Smart invoicing for modern businesses — built with React, Node.js, PostgreSQL, Redis, and AI.

## Project structure

```
invoicr/
├── apps/
│   ├── api/          # Node.js + Express + Prisma backend
│   └── web/          # React + Vite + TailwindCSS frontend
├── packages/
│   └── shared/       # Shared types, validators, invoice calculator
├── docker-compose.yml
├── turbo.json
└── package.json
```

## Prerequisites

- Node.js >= 20
- Docker & Docker Compose
- npm >= 10

## Local development

```bash
# 1. Clone and install
git clone <repo-url>
cd invoicr
npm install

# 2. Start local services (PostgreSQL + Redis)
docker compose up -d

# 3. Setup API environment
cp apps/api/.env.example apps/api/.env
# Fill in your values in apps/api/.env

# 4. Run DB migrations
npm run db:migrate --workspace=apps/api

# 5. Start everything
npm run dev
```

- API: http://localhost:4000
- Web: http://localhost:5173
- Redis Commander: http://localhost:8081
- Prisma Studio: `npm run db:studio --workspace=apps/api`

## Scripts

| Command | Description |
|---|---|
| `npm run dev` | Start all apps in dev mode |
| `npm run build` | Build all apps |
| `npm run lint` | Lint all apps |
| `npm run type-check` | TypeScript check all apps |
| `npm test` | Run all tests |

## Tech stack

| Layer | Technology |
|---|---|
| Frontend | React 18, Vite, TailwindCSS, React Query, React Hook Form |
| Backend | Node.js, Express, TypeScript |
| Database | PostgreSQL (Prisma ORM) |
| Cache / Queue | Redis, BullMQ |
| Auth | JWT, Google OAuth2 |
| AI | OpenAI API |
| Payments | Razorpay |
| Infra | AWS (EC2, RDS, S3, SES), Docker |
| CI/CD | GitHub Actions |
