"use client"

import { useState, useTransition } from "react"
import { useRouter } from "next/navigation"
import { Heart } from "lucide-react"
import { cn } from "@/lib/utils"
import { toggleFavorite } from "@/lib/actions/favorites"

export function FavoriteButton({
  componentId,
  initialFavorited,
}: {
  componentId: string
  initialFavorited: boolean
}) {
  const [favorited, setFavorited] = useState(initialFavorited)
  const [isPending, startTransition] = useTransition()
  const router = useRouter()

  const onClick = (e: React.MouseEvent) => {
    e.preventDefault()
    e.stopPropagation()
    startTransition(async () => {
      const result = await toggleFavorite(componentId)
      if (result.error === "not-authenticated") {
        router.push("/login?next=/components")
        return
      }
      setFavorited(result.favorited)
    })
  }

  return (
    <button
      onClick={onClick}
      disabled={isPending}
      aria-label={favorited ? "Remove from favorites" : "Add to favorites"}
      aria-pressed={favorited}
      className="flex h-8 w-8 items-center justify-center rounded-full border border-border bg-background/60 backdrop-blur transition-colors hover:border-primary/40"
    >
      <Heart className={cn("h-4 w-4 transition-colors", favorited ? "fill-primary text-primary" : "text-muted-foreground")} />
    </button>
  )
}
