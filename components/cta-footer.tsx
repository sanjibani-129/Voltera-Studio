import { ArrowRight, CircuitBoard } from "lucide-react"
import { Button } from "@/components/ui/button"

const footerLinks = {
  Product: ["Features", "Live Labs", "Pricing", "Changelog"],
  Learn: ["Courses", "Tutorials", "Certifications", "Community"],
  Company: ["About", "Careers", "Blog", "Contact"],
}

export function CtaFooter() {
  return (
    <footer id="pricing" className="relative mx-auto max-w-6xl px-6 pb-12">
      <div className="glass relative overflow-hidden rounded-[2rem] px-6 py-16 text-center md:py-24">
        <div
          aria-hidden="true"
          className="animate-pulse-glow pointer-events-none absolute left-1/2 top-0 h-72 w-72 -translate-x-1/2 rounded-full"
          style={{ background: "radial-gradient(circle, color-mix(in oklab, var(--primary) 28%, transparent), transparent 70%)" }}
        />
        <div className="relative mx-auto max-w-2xl">
          <h2 className="text-balance text-4xl font-semibold tracking-tight md:text-5xl">
            Start building your intuition today.
          </h2>
          <p className="mt-4 text-pretty text-lg text-muted-foreground">
            Join a quarter million learners turning curiosity into real engineering skill. Free to start.
          </p>
          <div className="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row">
            <Button size="lg" className="rounded-full bg-primary text-primary-foreground hover:bg-primary/90">
              Get started free
              <ArrowRight className="ml-1 h-4 w-4" />
            </Button>
            <Button size="lg" variant="secondary" className="rounded-full">
              Book a demo
            </Button>
          </div>
        </div>
      </div>

      <div className="mt-16 grid grid-cols-2 gap-10 border-t border-border pt-12 md:grid-cols-4">
        <div className="col-span-2 md:col-span-1">
          <a href="#" className="flex items-center gap-2">
            <CircuitBoard className="h-5 w-5 text-primary" />
            <span className="text-base font-semibold tracking-tight">Voltera</span>
          </a>
          <p className="mt-4 max-w-xs text-sm text-muted-foreground">
            The AI-native way to learn electronics, from first principles to production.
          </p>
        </div>
        {Object.entries(footerLinks).map(([group, items]) => (
          <div key={group}>
            <h3 className="text-sm font-semibold">{group}</h3>
            <ul className="mt-4 space-y-3">
              {items.map((item) => (
                <li key={item}>
                  <a href="#" className="text-sm text-muted-foreground transition-colors hover:text-foreground">
                    {item}
                  </a>
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>

      <div className="mt-12 flex flex-col items-center justify-between gap-4 border-t border-border pt-8 text-sm text-muted-foreground sm:flex-row">
        <p>© {new Date().getFullYear()} Voltera Labs, Inc. All rights reserved.</p>
        <div className="flex gap-6">
          <a href="#" className="transition-colors hover:text-foreground">Privacy</a>
          <a href="#" className="transition-colors hover:text-foreground">Terms</a>
          <a href="#" className="transition-colors hover:text-foreground">Security</a>
        </div>
      </div>
    </footer>
  )
}
