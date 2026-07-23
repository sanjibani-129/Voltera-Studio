"use client"

import { useMemo, useState } from "react"
import Image from "next/image"
import { X } from "lucide-react"
import { cn } from "@/lib/utils"
import type { Component } from "@/lib/types/database.types"

const MAX_COMPARE = 3

export function CompareBoard({ components }: { components: Component[] }) {
  const [selectedIds, setSelectedIds] = useState<string[]>([])

  const selected = useMemo(
    () => selectedIds.map((id) => components.find((c) => c.id === id)).filter(Boolean) as Component[],
    [selectedIds, components],
  )

  const allSpecKeys = useMemo(() => {
    const keys = new Set<string>()
    selected.forEach((c) => Object.keys(c.specs).forEach((k) => keys.add(k)))
    return Array.from(keys)
  }, [selected])

  const toggle = (id: string) => {
    setSelectedIds((prev) => {
      if (prev.includes(id)) return prev.filter((x) => x !== id)
      if (prev.length >= MAX_COMPARE) return prev
      return [...prev, id]
    })
  }

  return (
    <div className="mt-10 space-y-8">
      <div className="glass rounded-3xl p-4">
        <p className="mb-3 px-2 text-xs font-medium uppercase tracking-[0.15em] text-muted-foreground">
          Select up to {MAX_COMPARE} components
        </p>
        <div className="flex flex-wrap gap-2 px-2 pb-1">
          {components.map((c) => {
            const active = selectedIds.includes(c.id)
            const disabled = !active && selectedIds.length >= MAX_COMPARE
            return (
              <button
                key={c.id}
                onClick={() => toggle(c.id)}
                disabled={disabled}
                className={cn(
                  "rounded-full border px-3.5 py-1.5 text-sm transition-colors disabled:opacity-40",
                  active
                    ? "border-primary/50 bg-primary/15 text-foreground"
                    : "border-border text-muted-foreground hover:text-foreground",
                )}
              >
                {c.name}
              </button>
            )
          })}
        </div>
      </div>

      {selected.length === 0 ? (
        <p className="text-center text-sm text-muted-foreground">Pick components above to compare their specs.</p>
      ) : (
        <div className="glass overflow-x-auto rounded-3xl">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border">
                <th className="w-40 px-6 py-4 text-left font-medium text-muted-foreground">Spec</th>
                {selected.map((c) => (
                  <th key={c.id} className="min-w-[180px] px-6 py-4 text-left">
                    <div className="flex items-center justify-between gap-2">
                      <div className="flex items-center gap-2">
                        <Image src={c.image_url || "/placeholder.svg"} alt={c.name} width={28} height={28} />
                        <span className="font-semibold tracking-tight">{c.name}</span>
                      </div>
                      <button
                        onClick={() => toggle(c.id)}
                        aria-label={`Remove ${c.name}`}
                        className="text-muted-foreground hover:text-foreground"
                      >
                        <X className="h-3.5 w-3.5" />
                      </button>
                    </div>
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              <tr className="border-b border-border">
                <td className="px-6 py-3.5 font-medium text-muted-foreground">Category</td>
                {selected.map((c) => (
                  <td key={c.id} className="px-6 py-3.5">
                    {c.category}
                  </td>
                ))}
              </tr>
              <tr className="border-b border-border">
                <td className="px-6 py-3.5 font-medium text-muted-foreground">Difficulty</td>
                {selected.map((c) => (
                  <td key={c.id} className="px-6 py-3.5 capitalize">
                    {c.difficulty}
                  </td>
                ))}
              </tr>
              {allSpecKeys.map((key) => (
                <tr key={key} className="border-b border-border last:border-0">
                  <td className="px-6 py-3.5 font-medium text-muted-foreground">{key}</td>
                  {selected.map((c) => (
                    <td key={c.id} className="px-6 py-3.5">
                      {c.specs[key] ?? <span className="text-muted-foreground">—</span>}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
