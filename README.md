# Voltera — Learn Electronics with AI

Voltera turns dense electronics theory into an interactive, searchable reference: a curated
component encyclopedia with real specs and pin diagrams, short topic quizzes, a side-by-side
comparison tool, and an AI tutor that can answer questions about whatever component you're
looking at.

**Live app:** [voltera-studio.vercel.app](https://voltera-studio.vercel.app/)

---

## Screenshots

### Landing page
Hero section with a live component search and quick-start topic suggestions.

![Landing page](./screenshots/01-hero.png)

### Component library
Searchable, filterable grid of every component in the catalog, filterable by category and
difficulty level.

![Component library](./screenshots/02-component-library.png)

### Component detail
Each component page includes an overview, an interactive 3D model, a clickable pin diagram,
full specs, and an "Ask AI Tutor" tab for that specific part — shown here on the pin diagram
tab for the Arduino Uno R3.

![Component detail — pin diagram](./screenshots/03-component-detail.png)

### Quiz
Short, focused multiple-choice quizzes per topic to check understanding as you learn.

![Quiz topic picker](./screenshots/04-quiz.png)

### Compare
Pick up to three components and compare their specs side by side.

![Compare components](./screenshots/05-compare.png)

---

## Tech stack

- **Framework:** Next.js 16 (App Router), React 19, TypeScript
- **Styling:** Tailwind CSS
- **Database/Auth:** Supabase (Postgres + `@supabase/ssr`)
- **AI Tutor:** Google Gemini (`@google/genai`), streamed responses, Markdown rendering via
  `react-markdown` + `remark-gfm`

## Getting started

```bash
npm install
```

Create a `.env.local` with:

```
NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
GEMINI_API_KEY=...
```

Then:

```bash
npm run dev
```

## Project structure

```
app/                 Next.js App Router routes and pages
components/          Reusable UI and feature components
lib/                 Supabase clients, Gemini client, server actions, types
supabase/            SQL migrations and seed data (schema, components, quiz questions)
screenshots/          App screenshots used in this README
```
