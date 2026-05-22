# template-vite-vps

Template GitHub per frontend Vite + React + Vitest, deployato come **file statici** in `/var/www/<nome>/` sul VPS `zaknafein.ovh`.

A differenza dei template backend, **non gira in Docker**: nginx serve direttamente i file `dist/`. Più semplice, più veloce, niente container da gestire.

## Stack

| Layer | Tecnologia |
|---|---|
| Bundler | Vite 5 |
| Runtime | React 18 |
| Test | Vitest + Testing Library |
| Deploy | rsync su `/var/www/<nome>/` |

## Pattern split frontend/backend

Lo stack assume che il frontend e il backend condividano lo stesso sottodominio (vedi `fantarole.zaknafein.ovh` di `schedina`):

```
https://myapp.zaknafein.ovh/         → frontend statico (questo template)
https://myapp.zaknafein.ovh/api/*    → backend proxy a 127.0.0.1:PORT (template Quarkus/Spring/NestJS/FastAPI)
```

L'API URL nei build di produzione è `/api` (path relativo, gestito da nginx).

## Endpoint

- `GET /` → home React (build di Vite)
- `GET /api/*` → backend (configurato a livello nginx, non in questo repo)

## Test

```bash
npm install
npm test
```

## Sviluppo locale

```bash
npm run dev
# → http://localhost:5173
```

Per chiamare un backend locale, esporta `VITE_API_URL=http://localhost:8080` in `.env.local`.

## Build di produzione

```bash
npm run build
# Output in dist/
npm run preview   # opzionale, prova il build in locale
```

## Init

Dopo `gh repo create --template`, lancia:
```bash
./init-rename.sh <nome-progetto>
```

## Licenza

[MIT](LICENSE)
