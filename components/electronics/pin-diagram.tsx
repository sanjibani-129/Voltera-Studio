"use client"

import { useState } from "react"
import Image from "next/image"
import { CircuitBoard } from "lucide-react"
import { cn, hasRealImage } from "@/lib/utils"
import type { ComponentPin } from "@/lib/types/database.types"
import { CategoryIllustration } from "@/components/electronics/category-illustration"

const PIN_COLORS: Record<ComponentPin["pin_type"], string> = {
  power: "bg-red-400",
  ground: "bg-zinc-400",
  io: "bg-primary",
  analog: "bg-amber-400",
  special: "bg-violet-400",
}

export function PinDiagram({
  imageUrl,
  pins,
  category,
}: {
  imageUrl: string | null
  pins: ComponentPin[]
  category: string
}) {
  const [activePin, setActivePin] = useState<ComponentPin | null>(pins[0] ?? null)

  if (pins.length === 0) {
    return (
      <div className="glass flex aspect-square flex-col items-center justify-center rounded-3xl p-10 text-center md:aspect-auto md:h-[420px]">
        <div className="mb-5 flex h-16 w-16 items-center justify-center rounded-2xl border border-border bg-secondary/60">
          <CircuitBoard className="h-7 w-7 text-primary" />
        </div>
        <h3 className="text-lg font-semibold tracking-tight">Pin diagram coming soon.</h3>
        <p className="mt-2 max-w-sm text-pretty text-sm text-muted-foreground">
          We haven&apos;t mapped out the pinout for this component yet. Check back soon, or explore the Specs and
          Overview tabs in the meantime.
        </p>
      </div>
    )
  }

  return (
    <div className="grid gap-4 md:grid-cols-[1.2fr_1fr]">
      <div className="glass relative aspect-square overflow-hidden rounded-3xl p-6">
        {hasRealImage(imageUrl) ? (
          <Image
            src={imageUrl as string}
            alt="Pin diagram"
            fill
            sizes="(max-width: 768px) 100vw, 50vw"
            className="object-contain p-10 opacity-90"
          />
        ) : (
          <CategoryIllustration category={category} className="absolute inset-0 h-full w-full p-14 opacity-70" />
        )}
        {pins.map((pin) => (
          <button
            key={pin.id}
            onMouseEnter={() => setActivePin(pin)}
            onFocus={() => setActivePin(pin)}
            onClick={() => setActivePin(pin)}
            aria-label={`Pin ${pin.pin_number}: ${pin.label}`}
            className={cn(
              "absolute h-4 w-4 -translate-x-1/2 -translate-y-1/2 rounded-full ring-2 ring-background transition-transform hover:scale-125",
              PIN_COLORS[pin.pin_type],
              activePin?.id === pin.id && "scale-125 ring-primary",
            )}
            style={{ left: `${pin.x}%`, top: `${pin.y}%` }}
          />
        ))}
      </div>

      <div className="glass flex flex-col rounded-3xl p-6">
        <p className="mb-4 text-xs font-medium uppercase tracking-[0.15em] text-primary">Pin details</p>
        {activePin ? (
          <div className="flex-1">
            <div className="flex items-center gap-2">
              <span className={cn("h-2.5 w-2.5 rounded-full", PIN_COLORS[activePin.pin_type])} />
              <h3 className="text-lg font-semibold tracking-tight">
                Pin {activePin.pin_number} · {activePin.label}
              </h3>
            </div>
            <p className="mt-1 text-xs capitalize text-muted-foreground">{activePin.pin_type} pin</p>
            <p className="mt-4 text-sm leading-relaxed text-muted-foreground">
              {activePin.description || "No additional description available."}
            </p>
          </div>
        ) : (
          <p className="text-sm text-muted-foreground">Hover or tap a pin to see details.</p>
        )}

        <div className="mt-6 space-y-1.5 border-t border-border pt-4">
          {pins.map((pin) => (
            <button
              key={pin.id}
              onClick={() => setActivePin(pin)}
              className={cn(
                "flex w-full items-center gap-2 rounded-xl px-2.5 py-1.5 text-left text-sm transition-colors hover:bg-secondary/60",
                activePin?.id === pin.id && "bg-secondary/60",
              )}
            >
              <span className={cn("h-2 w-2 shrink-0 rounded-full", PIN_COLORS[pin.pin_type])} />
              <span className="text-muted-foreground">
                {pin.pin_number}. {pin.label}
              </span>
            </button>
          ))}
        </div>
      </div>
    </div>
  )
}
