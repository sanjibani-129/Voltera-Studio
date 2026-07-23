"use client"

import { useEffect, useState, useTransition } from "react"
import { useRouter, useSearchParams } from "next/navigation"
import { Search } from "lucide-react"

const DIFFICULTIES = ["all", "beginner", "intermediate", "advanced"] as const

export function ComponentSearchBar({ categories }: { categories: string[] }) {
  const router = useRouter()
  const searchParams = useSearchParams()
  const [query, setQuery] = useState(searchParams.get("q") ?? "")
  const [, startTransition] = useTransition()

  useEffect(() => {
    const timeout = setTimeout(() => {
      const params = new URLSearchParams(searchParams.toString())
      if (query) params.set("q", query)
      else params.delete("q")
      startTransition(() => router.replace(`/components?${params.toString()}`))
    }, 300)
    return () => clearTimeout(timeout)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [query])

  const setFilter = (key: string, value: string) => {
    const params = new URLSearchParams(searchParams.toString())
    if (value === "all") params.delete(key)
    else params.set(key, value)
    router.replace(`/components?${params.toString()}`)
  }

  return (
    <div className="glass flex flex-col gap-3 rounded-3xl p-4 md:flex-row md:items-center">
      <div className="flex flex-1 items-center gap-2 rounded-full bg-secondary/40 px-4 py-2.5">
        <Search className="h-4 w-4 shrink-0 text-muted-foreground" />
        <input
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Search components by name, category, or keyword..."
          className="min-w-0 flex-1 bg-transparent text-sm text-foreground outline-none placeholder:text-muted-foreground"
          aria-label="Search components"
        />
      </div>

      <select
        defaultValue={searchParams.get("category") ?? "all"}
        onChange={(e) => setFilter("category", e.target.value)}
        className="rounded-full border border-border bg-secondary/40 px-4 py-2.5 text-sm text-foreground outline-none"
        aria-label="Filter by category"
      >
        <option value="all">All categories</option>
        {categories.map((c) => (
          <option key={c} value={c}>
            {c}
          </option>
        ))}
      </select>

      <select
        defaultValue={searchParams.get("difficulty") ?? "all"}
        onChange={(e) => setFilter("difficulty", e.target.value)}
        className="rounded-full border border-border bg-secondary/40 px-4 py-2.5 text-sm text-foreground outline-none"
        aria-label="Filter by difficulty"
      >
        {DIFFICULTIES.map((d) => (
          <option key={d} value={d}>
            {d === "all" ? "All levels" : d[0].toUpperCase() + d.slice(1)}
          </option>
        ))}
      </select>
    </div>
  )
}
