import Link from "next/link"
import { CircuitBoard } from "lucide-react"
import { Button } from "@/components/ui/button"

export default function NotFound() {
  return (
    <main className="relative flex min-h-screen flex-col items-center justify-center overflow-hidden px-6 text-center">
      <div
        aria-hidden="true"
        className="grid-fade pointer-events-none absolute inset-0 opacity-40"
        style={{
          backgroundImage:
            "linear-gradient(to right, color-mix(in oklab, var(--foreground) 8%, transparent) 1px, transparent 1px), linear-gradient(to bottom, color-mix(in oklab, var(--foreground) 8%, transparent) 1px, transparent 1px)",
          backgroundSize: "56px 56px",
        }}
      />
      <div className="glass relative z-10 max-w-md rounded-3xl p-10">
        <CircuitBoard className="mx-auto mb-4 h-8 w-8 text-primary" />
        <h1 className="text-3xl font-semibold tracking-tight">404</h1>
        <p className="mt-2 text-pretty text-muted-foreground">
          We couldn&apos;t find that page or component. It may have been renamed or removed.
        </p>
        <div className="mt-8 flex justify-center gap-3">
          <Button variant="secondary" render={<Link href="/components" />} className="rounded-full">
            Browse components
          </Button>
          <Button
            render={<Link href="/" />}
            className="rounded-full bg-primary text-primary-foreground hover:bg-primary/90"
          >
            Go home
          </Button>
        </div>
      </div>
    </main>
  )
}
