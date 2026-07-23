import Image from "next/image"
import { Check } from "lucide-react"

const points = [
  "Real-time circuit simulation with live measurements",
  "AI explains every node, current, and voltage drop",
  "Export designs straight to your breadboard or PCB",
]

export function Showcase() {
  return (
    <section id="courses" className="relative mx-auto max-w-6xl px-6 py-24 md:py-32">
      <div className="glass relative overflow-hidden rounded-[2rem] p-8 md:p-14">
        <div
          aria-hidden="true"
          className="animate-scan pointer-events-none absolute inset-x-0 top-0 h-40 opacity-30"
          style={{ background: "linear-gradient(to bottom, color-mix(in oklab, var(--primary) 25%, transparent), transparent)" }}
        />
        <div className="relative grid items-center gap-12 lg:grid-cols-2">
          <div>
            <p className="mb-3 text-sm font-medium uppercase tracking-[0.2em] text-primary">Live labs</p>
            <h2 className="text-balance text-3xl font-semibold tracking-tight md:text-4xl">
              Design it, simulate it, understand it.
            </h2>
            <p className="mt-4 text-pretty leading-relaxed text-muted-foreground">
              Our in-browser simulator pairs with the AI tutor so every experiment comes with instant,
              contextual explanation. No hardware required to get started.
            </p>
            <ul className="mt-8 space-y-4">
              {points.map((p) => (
                <li key={p} className="flex items-start gap-3">
                  <span className="mt-0.5 flex h-5 w-5 shrink-0 items-center justify-center rounded-full bg-primary/15">
                    <Check className="h-3 w-3 text-primary" />
                  </span>
                  <span className="text-sm text-muted-foreground">{p}</span>
                </li>
              ))}
            </ul>
          </div>

          <div className="relative">
            <div
              aria-hidden="true"
              className="absolute inset-0 -z-10 rounded-full opacity-70 blur-2xl"
              style={{ background: "radial-gradient(circle, color-mix(in oklab, var(--primary) 25%, transparent), transparent 70%)" }}
            />
            <Image
              src="/circuit-hero.png"
              alt="A glowing wireframe render of an AI microchip and circuit board"
              width={560}
              height={560}
              className="animate-float-slow mx-auto w-full max-w-md"
            />
          </div>
        </div>
      </div>
    </section>
  )
}
