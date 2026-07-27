import Image from "next/image"
import Link from "next/link"
import type { Component } from "@/lib/types/database.types"
import { FavoriteButton } from "@/components/electronics/favorite-button"
import { CategoryIllustration } from "@/components/electronics/category-illustration"
import { hasRealImage } from "@/lib/utils"

export function ComponentCard({
  component,
  isFavorited = false,
  showFavorite = true,
}: {
  component: Component
  isFavorited?: boolean
  showFavorite?: boolean
}) {
  return (
    <div className="glass group relative overflow-hidden rounded-3xl p-6 transition-all duration-300 hover:-translate-y-1 hover:border-primary/30">
      {showFavorite && (
        <div className="absolute right-4 top-4 z-10">
          <FavoriteButton componentId={component.id} initialFavorited={isFavorited} />
        </div>
      )}
      <Link href={`/components/${component.slug}`} className="block cursor-pointer" aria-label={`View details for ${component.name}`}>
        <div className="relative mx-auto mb-4 flex h-32 w-32 items-center justify-center">
          <div
            aria-hidden="true"
            className="absolute inset-0 rounded-full opacity-60 blur-2xl"
            style={{ background: "radial-gradient(circle, color-mix(in oklab, var(--primary) 25%, transparent), transparent 70%)" }}
          />
          {hasRealImage(component.image_url) ? (
            <Image
              src={component.image_url as string}
              alt={component.name}
              width={128}
              height={128}
              className="relative mix-blend-screen"
            />
          ) : (
            <CategoryIllustration category={component.category} className="relative h-24 w-24" />
          )}
        </div>
        <p className="mb-1 text-xs font-medium uppercase tracking-[0.15em] text-primary">{component.category}</p>
        <h3 className="mb-1.5 text-lg font-semibold tracking-tight">{component.name}</h3>
        <p className="line-clamp-2 text-sm leading-relaxed text-muted-foreground">{component.short_description}</p>
        <span className="mt-3 inline-flex items-center rounded-full border border-border px-2.5 py-1 text-[11px] capitalize text-muted-foreground">
          {component.difficulty}
        </span>
      </Link>
    </div>
  )
}
