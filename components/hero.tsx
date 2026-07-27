"use client"

import type React from "react"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { ArrowRight, Search, Sparkles } from "lucide-react"
import { Button } from "@/components/ui/button"
import { FloatingComponents } from "@/components/floating-components"

const suggestions = ["Ohm's law", "PCB design", "Arduino PWM", "Op-amps", "Signal filtering"]

export function Hero() {
  const [query, setQuery] = useState("")
  const router = useRouter()

  const onSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    const params = new URLSearchParams(query ? { q: query } : {})
    router.push(`/components${params.toString() ? `?${params}` : ""}`)
  }

  return (
    <section className="relative flex min-h-screen flex-col items-center justify-center overflow-hidden px-6 pt-32 pb-20">
      {/* Background grid */}
      <div
        aria-hidden="true"
        className="grid-fade pointer-events-none absolute inset-0 opacity-40"
        style={{
          backgroundImage:
            "linear-gradient(to right, color-mix(in oklab, var(--foreground) 8%, transparent) 1px, transparent 1px), linear-gradient(to bottom, color-mix(in oklab, var(--foreground) 8%, transparent) 1px, transparent 1px)",
          backgroundSize: "56px 56px",
        }}
      />

      {/* Glow */}
      <div
        aria-hidden="true"
        className="animate-pulse-glow pointer-events-none absolute left-1/2 top-1/3 h-[520px] w-[520px] -translate-x-1/2 -translate-y-1/2 rounded-full"
        style={{ background: "radial-gradient(circle, color-mix(in oklab, var(--primary) 30%, transparent) 0%, transparent 65%)" }}
      />

      {/* Floating 3D electronic components */}
      <FloatingComponents />

      {/* Content */}
      <div className="relative z-10 flex w-full max-w-3xl flex-col items-center text-center">
        <div className="animate-fade-up mb-6 inline-flex items-center gap-2 rounded-full border border-border bg-secondary/50 px-4 py-1.5 text-xs text-muted-foreground backdrop-blur">
          <Sparkles className="h-3.5 w-3.5 text-primary" />
          Introducing AI-guided circuit labs
        </div>

        <h1
          className="animate-fade-up text-balance text-5xl font-semibold leading-[1.05] tracking-tight sm:text-6xl md:text-7xl"
          style={{ animationDelay: "80ms" }}
        >
          <span className="text-gradient">Master electronics,</span>
          <br />
          <span className="text-primary">powered by AI.</span>
        </h1>

        <p
          className="animate-fade-up mt-6 max-w-xl text-pretty text-lg leading-relaxed text-muted-foreground"
          style={{ animationDelay: "160ms" }}
        >
          Voltra turns dense theory into interactive, adaptive lessons — from Ohm&apos;s law to embedded
          firmware. Ask anything, build anything.
        </p>

        {/* Search bar */}
        <form
          onSubmit={onSubmit}
          className="animate-fade-up glass mt-10 flex w-full max-w-xl items-center gap-2 rounded-full p-2 pl-5"
          style={{ animationDelay: "240ms" }}
        >
          <Search className="h-5 w-5 shrink-0 text-muted-foreground" />
          <input
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Ask Voltra to explain any concept..."
            className="min-w-0 flex-1 bg-transparent text-sm text-foreground outline-none placeholder:text-muted-foreground"
            aria-label="Search concepts"
          />
          <Button type="submit" className="rounded-full bg-primary text-primary-foreground hover:bg-primary/90">
            Explore
            <ArrowRight className="ml-1 h-4 w-4" />
          </Button>
        </form>

        <div
          className="animate-fade-up mt-4 flex flex-wrap items-center justify-center gap-2"
          style={{ animationDelay: "320ms" }}
        >
          {suggestions.map((s) => (
            <button
              key={s}
              onClick={() => setQuery(s)}
              className="rounded-full border border-border px-3 py-1.5 text-xs text-muted-foreground transition-colors hover:border-primary/40 hover:text-foreground"
            >
              {s}
            </button>
          ))}
        </div>
      </div>
    </section>
  )
}
