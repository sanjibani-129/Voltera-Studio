"use client"

import { useState } from "react"
import dynamic from "next/dynamic"
import { Download, FileX } from "lucide-react"
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
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

export function ComponentDetailTabs({
  component,
  pins,
  isAiTutorConfigured,
}: {
  component: Component
  pins: ComponentPin[]
  isAiTutorConfigured: boolean
}) {
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
        <div className="space-y-4">
          <div className="glass rounded-3xl p-8">
            <p className="mb-2 text-xs font-medium uppercase tracking-[0.15em] text-primary">Description</p>
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

          {component.working_principle && (
            <div className="glass rounded-3xl p-8">
              <p className="mb-2 text-xs font-medium uppercase tracking-[0.15em] text-primary">Working Principle</p>
              <p className="text-pretty leading-relaxed text-muted-foreground">{component.working_principle}</p>
            </div>
          )}

          {component.applications && (
            <div className="glass rounded-3xl p-8">
              <p className="mb-2 text-xs font-medium uppercase tracking-[0.15em] text-primary">Applications</p>
              <p className="text-pretty leading-relaxed text-muted-foreground">{component.applications}</p>
            </div>
          )}

          {(component.advantages || component.disadvantages) && (
            <div className="grid gap-4 sm:grid-cols-2">
              {component.advantages && (
                <div className="glass rounded-3xl p-8">
                  <p className="mb-2 text-xs font-medium uppercase tracking-[0.15em] text-primary">Advantages</p>
                  <p className="text-pretty leading-relaxed text-muted-foreground">{component.advantages}</p>
                </div>
              )}
              {component.disadvantages && (
                <div className="glass rounded-3xl p-8">
                  <p className="mb-2 text-xs font-medium uppercase tracking-[0.15em] text-primary">Disadvantages</p>
                  <p className="text-pretty leading-relaxed text-muted-foreground">{component.disadvantages}</p>
                </div>
              )}
            </div>
          )}
        </div>
      )}

      {tab === "3D Model" && <Component3DViewer modelUrl={component.model_url} name={component.name} />}

      {tab === "Pin Diagram" && <PinDiagram imageUrl={component.image_url} pins={pins} category={component.category} />}

      {tab === "Specs" && (
        <div className="space-y-4">
          <SpecsTable specs={component.specs} />

          <div className="glass flex flex-wrap items-center justify-between gap-4 rounded-3xl p-6">
            <div>
              <p className="mb-1 text-xs font-medium uppercase tracking-[0.15em] text-primary">Datasheet</p>
              <p className="text-sm text-muted-foreground">
                {component.datasheet_url
                  ? "Download the full manufacturer datasheet for detailed electrical specifications."
                  : "Datasheet unavailable."}
              </p>
            </div>
            {component.datasheet_url ? (
              <Button
                nativeButton={false}
                render={<a href={component.datasheet_url} target="_blank" rel="noopener noreferrer" />}
                className="rounded-full bg-primary text-primary-foreground hover:bg-primary/90"
              >
                <Download className="h-4 w-4" /> Download datasheet
              </Button>
            ) : (
              <span className="flex items-center gap-2 rounded-full border border-border px-4 py-2 text-sm text-muted-foreground">
                <FileX className="h-4 w-4" /> Datasheet unavailable.
              </span>
            )}
          </div>
        </div>
      )}

      {tab === "Ask AI Tutor" && <AiTutorChat component={component} isConfigured={isAiTutorConfigured} />}
    </div>
  )
}
