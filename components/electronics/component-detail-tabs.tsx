"use client"

import { useState } from "react"
import dynamic from "next/dynamic"
import { cn } from "@/lib/utils"
import { PinDiagram } from "@/components/electronics/pin-diagram"
import { SpecsTable } from "@/components/electronics/specs-table"
import { AiTutorChat } from "@/components/electronics/ai-tutor-chat"
import type { Component, ComponentPin } from "@/lib/types/database.types"

// three.js + react-three-fiber are heavy - only load this bundle when the
// "3D Model" tab is actually opened, not on initial component-page load.
const Component3DViewer = dynamic(
  () => import("@/components/electronics/component-3d-viewer").then((m) => m.Component3DViewer),
  {
    ssr: false,
    loading: () => (
      <div className="glass flex h-80 w-full items-center justify-center rounded-3xl md:h-[420px]">
        <p className="text-sm text-muted-foreground">Loading 3D viewer...</p>
      </div>
    ),
  },
)

const TABS = ["Overview", "3D Model", "Pin Diagram", "Specs", "Ask AI Tutor"] as const

export function ComponentDetailTabs({ component, pins }: { component: Component; pins: ComponentPin[] }) {
  const [tab, setTab] = useState<(typeof TABS)[number]>("Overview")

  return (
    <div>
      <div className="glass mb-8 inline-flex flex-wrap gap-1 rounded-full p-1">
        {TABS.map((t) => (
          <button
            key={t}
            onClick={() => setTab(t)}
            className={cn(
              "rounded-full px-4 py-2 text-sm transition-colors",
              tab === t ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:text-foreground",
            )}
          >
            {t}
          </button>
        ))}
      </div>

      {tab === "Overview" && (
        <div className="glass rounded-3xl p-8">
          <p className="text-pretty leading-relaxed text-muted-foreground">
            {component.long_description || component.short_description}
          </p>
          {component.tags.length > 0 && (
            <div className="mt-6 flex flex-wrap gap-2">
              {component.tags.map((tag) => (
                <span key={tag} className="rounded-full border border-border px-3 py-1 text-xs text-muted-foreground">
                  {tag}
                </span>
              ))}
            </div>
          )}
        </div>
      )}

      {tab === "3D Model" && <Component3DViewer modelUrl={component.model_url} name={component.name} />}

      {tab === "Pin Diagram" && <PinDiagram imageUrl={component.image_url} pins={pins} />}

      {tab === "Specs" && <SpecsTable specs={component.specs} />}

      {tab === "Ask AI Tutor" && <AiTutorChat contextName={component.name} />}
    </div>
  )
}
