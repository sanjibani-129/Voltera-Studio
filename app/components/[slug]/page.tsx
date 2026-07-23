import type { Metadata } from "next"
import Image from "next/image"
import { notFound } from "next/navigation"
import { SiteNav } from "@/components/site-nav"
import { ComponentDetailTabs } from "@/components/electronics/component-detail-tabs"
import { getComponentBySlug } from "@/lib/actions/components"
import { getCurrentUser } from "@/lib/actions/auth"

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>
}): Promise<Metadata> {
  const { slug } = await params
  const result = await getComponentBySlug(slug)
  return { title: result ? `${result.component.name} — Voltra` : "Component not found — Voltra" }
}

export default async function ComponentDetailPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params
  const [user, result] = await Promise.all([getCurrentUser(), getComponentBySlug(slug)])

  if (!result) notFound()
  const { component, pins } = result

  return (
    <main className="relative min-h-screen overflow-x-hidden bg-background">
      <SiteNav isAuthenticated={!!user} />

      <section className="mx-auto max-w-5xl px-6 pb-24 pt-36">
        <div className="mb-10 flex flex-col items-start gap-6 sm:flex-row sm:items-center">
          <div className="relative flex h-24 w-24 shrink-0 items-center justify-center">
            <div
              aria-hidden="true"
              className="absolute inset-0 rounded-full opacity-60 blur-2xl"
              style={{ background: "radial-gradient(circle, color-mix(in oklab, var(--primary) 30%, transparent), transparent 70%)" }}
            />
            <Image
              src={component.image_url || "/placeholder.svg"}
              alt={component.name}
              width={96}
              height={96}
              className="relative mix-blend-screen"
            />
          </div>
          <div>
            <p className="mb-1 text-sm font-medium uppercase tracking-[0.2em] text-primary">{component.category}</p>
            <h1 className="text-balance text-4xl font-semibold tracking-tight md:text-5xl">{component.name}</h1>
            <p className="mt-3 max-w-2xl text-pretty text-muted-foreground">{component.short_description}</p>
          </div>
        </div>

        <ComponentDetailTabs component={component} pins={pins} />
      </section>
    </main>
  )
}
