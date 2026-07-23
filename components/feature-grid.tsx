import { Bot, CircuitBoard, Cpu, GraduationCap, LineChart, Zap } from "lucide-react"

const features = [
  {
    icon: Bot,
    title: "AI Tutor",
    description:
      "A patient, always-on mentor that adapts explanations to your level and answers follow-ups instantly.",
  },
  {
    icon: CircuitBoard,
    title: "Interactive Labs",
    description: "Build and simulate real circuits in the browser. Drag components, wire them up, and watch them run.",
  },
  {
    icon: Cpu,
    title: "Embedded Systems",
    description: "Go from blinking an LED to writing firmware for microcontrollers with guided, hands-on projects.",
  },
  {
    icon: LineChart,
    title: "Adaptive Paths",
    description: "Personalized learning tracks that adjust in real time based on how you progress and where you struggle.",
  },
  {
    icon: GraduationCap,
    title: "Certifications",
    description: "Earn verifiable credentials as you complete modules — from fundamentals to advanced signal design.",
  },
  {
    icon: Zap,
    title: "Instant Feedback",
    description: "Automated analysis catches wiring mistakes and suggests fixes before you ever burn out a resistor.",
  },
]

export function FeatureGrid() {
  return (
    <section id="features" className="relative mx-auto max-w-6xl px-6 py-24 md:py-32">
      <div className="mx-auto mb-16 max-w-2xl text-center">
        <p className="mb-3 text-sm font-medium uppercase tracking-[0.2em] text-primary">The platform</p>
        <h2 className="text-balance text-4xl font-semibold tracking-tight md:text-5xl">
          Everything you need to think in circuits.
        </h2>
        <p className="mt-4 text-pretty text-lg text-muted-foreground">
          A complete, intelligent toolkit designed to take you from curious beginner to confident engineer.
        </p>
      </div>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {features.map((f) => (
          <article
            key={f.title}
            className="glass group relative overflow-hidden rounded-3xl p-8 transition-all duration-300 hover:-translate-y-1 hover:border-primary/30"
          >
            <div
              aria-hidden="true"
              className="absolute -right-16 -top-16 h-40 w-40 rounded-full opacity-0 transition-opacity duration-300 group-hover:opacity-100"
              style={{ background: "radial-gradient(circle, color-mix(in oklab, var(--primary) 22%, transparent), transparent 70%)" }}
            />
            <div className="relative">
              <div className="mb-6 inline-flex h-12 w-12 items-center justify-center rounded-2xl border border-border bg-secondary/60">
                <f.icon className="h-6 w-6 text-primary" />
              </div>
              <h3 className="mb-2 text-lg font-semibold tracking-tight">{f.title}</h3>
              <p className="text-sm leading-relaxed text-muted-foreground">{f.description}</p>
            </div>
          </article>
        ))}
      </div>
    </section>
  )
}
