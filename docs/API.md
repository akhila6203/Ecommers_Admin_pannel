# LM Shopping Mall API Documentation

Base URL: `http://localhost:5000/api`

## Response Format

```json
{ "success": true, "message": "Success", "data": {}, "timestamp": "..." }
```

Paginated: `{ pagination: { total, totalRecords, page, limit, totalPages } }`

## Key Endpoints

- **Auth:** POST `/auth/login`, POST `/auth/refresh-token`, GET `/auth/profile`
- **Dashboard:** GET `/dashboard/stats` (includes totalBanners)
- **Products:** GET `/products?page=1&limit=20`
- **Collections:** GET/POST `/collections`, GET/PUT/DELETE `/collections/:id`
- **Orders:** GET `/orders`, GET `/orders/:id`, PUT `/orders/:id/status`, PUT `/orders/:id/payment`
- **Customers:** GET `/customers`, PUT `/customers/:id/block`, DELETE `/customers/:id`
- **Settings:** GET/PUT `/settings/store-information`, `/settings/about-us`, etc.

About Us canonical endpoint: `/api/settings/about-us` (not `/api/content/about`).

Run tests: `cd backend && npm test`
