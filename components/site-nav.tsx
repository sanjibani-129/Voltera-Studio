"use client"

import { useEffect, useState } from "react"
import Link from "next/link"
import { CircuitBoard, Menu, X } from "lucide-react"
import { Button } from "@/components/ui/button"
import { cn } from "@/lib/utils"
import { signOut } from "@/lib/actions/auth"

const links = [
  { label: "Components", href: "/components" },
  { label: "Quiz", href: "/quiz" },
  { label: "Compare", href: "/compare" },
  { label: "Pricing", href: "/#pricing" },
]

export function SiteNav({ isAuthenticated = false }: { isAuthenticated?: boolean }) {
  const [scrolled, setScrolled] = useState(false)
  const [open, setOpen] = useState(false)

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 12)
    onScroll()
    window.addEventListener("scroll", onScroll, { passive: true })
    return () => window.removeEventListener("scroll", onScroll)
  }, [])

  return (
    <header className="fixed inset-x-0 top-0 z-50 flex justify-center px-4 pt-4">
      <nav
        className={cn(
          "flex w-full max-w-5xl items-center justify-between rounded-full px-4 py-2.5 transition-all duration-300",
          scrolled ? "glass shadow-lg shadow-black/20" : "border border-transparent",
        )}
      >
        <Link href="/" className="flex items-center gap-2 pl-1">
          <CircuitBoard className="h-5 w-5 text-primary" />
          <span className="text-base font-semibold tracking-tight">Voltra</span>
        </Link>

        <div className="hidden items-center gap-1 md:flex">
          {links.map((l) => (
            <Link
              key={l.label}
              href={l.href}
              className="rounded-full px-4 py-2 text-sm text-muted-foreground transition-colors hover:text-foreground"
            >
              {l.label}
            </Link>
          ))}
        </div>

        <div className="hidden items-center gap-2 md:flex">
          {isAuthenticated ? (
            <>
              <Button
                variant="ghost"
                nativeButton={false}
                render={<Link href="/dashboard" />}
                className="rounded-full text-sm text-muted-foreground hover:text-foreground"
              >
                Dashboard
              </Button>
              <form action={signOut}>
                <Button
                  type="submit"
                  className="rounded-full bg-primary text-primary-foreground hover:bg-primary/90"
                >
                  Sign out
                </Button>
              </form>
            </>
          ) : (
            <>
              <Button
                variant="ghost"
                nativeButton={false}
                render={<Link href="/login" />}
                className="rounded-full text-sm text-muted-foreground hover:text-foreground"
              >
                Sign in
              </Button>
              <Button
                nativeButton={false}
                render={<Link href="/signup" />}
                className="rounded-full bg-primary text-primary-foreground hover:bg-primary/90"
              >
                Get started
              </Button>
            </>
          )}
        </div>

        <button
          className="flex h-9 w-9 items-center justify-center rounded-full text-foreground md:hidden"
          onClick={() => setOpen((o) => !o)}
          aria-label="Toggle menu"
          aria-expanded={open}
          aria-controls="mobile-nav-menu"
        >
          {open ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
        </button>
      </nav>

      {open && (
        <div id="mobile-nav-menu" className="glass absolute inset-x-4 top-20 rounded-3xl p-4 md:hidden">
          <div className="flex flex-col gap-1">
            {links.map((l) => (
              <Link
                key={l.label}
                href={l.href}
                onClick={() => setOpen(false)}
                className="rounded-xl px-4 py-3 text-sm text-muted-foreground transition-colors hover:bg-secondary hover:text-foreground"
              >
                {l.label}
              </Link>
            ))}
            <div className="mt-2 flex flex-col gap-2">
              {isAuthenticated ? (
                <>
                  <Button
                    variant="secondary"
                    nativeButton={false}
                    render={<Link href="/dashboard" onClick={() => setOpen(false)} />}
                    className="w-full rounded-xl"
                  >
                    Dashboard
                  </Button>
                  <form action={signOut}>
                    <Button type="submit" className="w-full rounded-xl bg-primary text-primary-foreground">
                      Sign out
                    </Button>
                  </form>
                </>
              ) : (
                <>
                  <Button
                    variant="secondary"
                    nativeButton={false}
                    render={<Link href="/login" onClick={() => setOpen(false)} />}
                    className="w-full rounded-xl"
                  >
                    Sign in
                  </Button>
                  <Button
                    nativeButton={false}
                    render={<Link href="/signup" onClick={() => setOpen(false)} />}
                    className="w-full rounded-xl bg-primary text-primary-foreground"
                  >
                    Get started
                  </Button>
                </>
              )}
            </div>
          </div>
        </div>
      )}
    </header>
  )
}
