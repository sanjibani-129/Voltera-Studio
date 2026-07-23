import type { Metadata } from "next"
import { SiteNav } from "@/components/site-nav"
import { CompareBoard } from "@/components/electronics/compare-board"
import { searchComponents } from "@/lib/actions/components"
import { getCurrentUser } from "@/lib/actions/auth"

export const metadata: Metadata = { title: "Compare Components — Voltra" }

export default async function ComparePage() {
  const [user, components] = await Promise.all([getCurrentUser(), searchComponents({})])

  return (
    <main className="relative min-h-screen overflow-x-hidden bg-background">
      <SiteNav isAuthenticated={!!user} />

      <section className="mx-auto max-w-6xl px-6 pb-24 pt-36">
        <div className="mx-auto mb-10 max-w-2xl text-center">
          <p className="mb-3 text-sm font-medium uppercase tracking-[0.2em] text-primary">Compare</p>
          <h1 className="text-balance text-4xl font-semibold tracking-tight md:text-5xl">
            Put components side by side.
          </h1>
          <p className="mt-4 text-pretty text-lg text-muted-foreground">
            Pick up to three components to compare specs at a glance.
          </p>
        </div>

        <CompareBoard components={components} />
      </section>
    </main>
  )
}
