import type { Metadata } from "next"
import { SiteNav } from "@/components/site-nav"
import { ComponentSearchBar } from "@/components/electronics/component-search-bar"
import { ComponentCard } from "@/components/electronics/component-card"
import { searchComponents, getCategories } from "@/lib/actions/components"
import { getFavoriteIds } from "@/lib/actions/favorites"
import { getCurrentUser } from "@/lib/actions/auth"

export const metadata: Metadata = { title: "Component Library — Voltera" }

export default async function ComponentsPage({
  searchParams,
}: {
  searchParams: Promise<{ q?: string; category?: string; difficulty?: string }>
}) {
  const params = await searchParams
  const [user, components, categories, favoriteIds] = await Promise.all([
    getCurrentUser(),
    searchComponents({ query: params.q, category: params.category, difficulty: params.difficulty }),
    getCategories(),
    getFavoriteIds(),
  ])

  return (
    <main className="relative min-h-screen overflow-x-hidden bg-background">
      <SiteNav isAuthenticated={!!user} />

      <section className="mx-auto max-w-6xl px-6 pb-24 pt-36">
        <div className="mx-auto mb-10 max-w-2xl text-center">
          <p className="mb-3 text-sm font-medium uppercase tracking-[0.2em] text-primary">Library</p>
          <h1 className="text-balance text-4xl font-semibold tracking-tight md:text-5xl">
            Browse the component library.
          </h1>
          <p className="mt-4 text-pretty text-lg text-muted-foreground">
            Search real components with interactive 3D models, pin diagrams, and specs.
          </p>
        </div>

        <ComponentSearchBar categories={categories} />

        {components.length === 0 ? (
          <p className="mt-16 text-center text-sm text-muted-foreground">
            No components matched your search. Try a different term or clear filters.
          </p>
        ) : (
          <div className="mt-10 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {components.map((component) => (
              <ComponentCard key={component.id} component={component} isFavorited={favoriteIds.has(component.id)} />
            ))}
          </div>
        )}
      </section>
    </main>
  )
}
