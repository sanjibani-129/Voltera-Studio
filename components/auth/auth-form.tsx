"use client"

import { useActionState } from "react"
import Link from "next/link"
import { CircuitBoard, Loader2 } from "lucide-react"
import { Button } from "@/components/ui/button"
import { signIn, signUp, type AuthState } from "@/lib/actions/auth"

export function AuthForm({ mode }: { mode: "login" | "signup" }) {
  const action = mode === "login" ? signIn : signUp
  const [state, formAction, pending] = useActionState<AuthState, FormData>(action, undefined)

  return (
    <div className="relative flex min-h-screen items-center justify-center overflow-hidden px-6 py-24">
      <div
        aria-hidden="true"
        className="grid-fade pointer-events-none absolute inset-0 opacity-40"
        style={{
          backgroundImage:
            "linear-gradient(to right, color-mix(in oklab, var(--foreground) 8%, transparent) 1px, transparent 1px), linear-gradient(to bottom, color-mix(in oklab, var(--foreground) 8%, transparent) 1px, transparent 1px)",
          backgroundSize: "56px 56px",
        }}
      />
      <div
        aria-hidden="true"
        className="animate-pulse-glow pointer-events-none absolute left-1/2 top-1/3 h-[420px] w-[420px] -translate-x-1/2 -translate-y-1/2 rounded-full"
        style={{
          background: "radial-gradient(circle, color-mix(in oklab, var(--primary) 30%, transparent) 0%, transparent 65%)",
        }}
      />

      <div className="glass relative z-10 w-full max-w-md rounded-3xl p-8">
        <Link href="/" className="mb-8 flex items-center justify-center gap-2">
          <CircuitBoard className="h-5 w-5 text-primary" />
          <span className="text-base font-semibold tracking-tight">Voltera</span>
        </Link>

        <h1 className="text-balance text-center text-2xl font-semibold tracking-tight">
          {mode === "login" ? "Welcome back" : "Create your account"}
        </h1>
        <p className="mt-2 text-center text-sm text-muted-foreground">
          {mode === "login" ? "Sign in to continue your learning path." : "Start building your electronics intuition."}
        </p>

        <form action={formAction} className="mt-8 flex flex-col gap-4">
          {mode === "signup" && (
            <div className="flex flex-col gap-1.5">
              <label htmlFor="fullName" className="text-xs font-medium text-muted-foreground">
                Full name
              </label>
              <input
                id="fullName"
                name="fullName"
                type="text"
                required
                placeholder="Ada Lovelace"
                className="rounded-xl border border-border bg-secondary/40 px-4 py-2.5 text-sm text-foreground outline-none placeholder:text-muted-foreground focus:border-primary/50"
              />
            </div>
          )}

          <div className="flex flex-col gap-1.5">
            <label htmlFor="email" className="text-xs font-medium text-muted-foreground">
              Email
            </label>
            <input
              id="email"
              name="email"
              type="email"
              required
              placeholder="you@example.com"
              className="rounded-xl border border-border bg-secondary/40 px-4 py-2.5 text-sm text-foreground outline-none placeholder:text-muted-foreground focus:border-primary/50"
            />
          </div>

          <div className="flex flex-col gap-1.5">
            <label htmlFor="password" className="text-xs font-medium text-muted-foreground">
              Password
            </label>
            <input
              id="password"
              name="password"
              type="password"
              required
              minLength={8}
              placeholder="••••••••"
              className="rounded-xl border border-border bg-secondary/40 px-4 py-2.5 text-sm text-foreground outline-none placeholder:text-muted-foreground focus:border-primary/50"
            />
          </div>

          {state?.error && (
            <p role="alert" className="rounded-xl bg-destructive/10 px-4 py-2.5 text-sm text-destructive">
              {state.error}
            </p>
          )}

          <Button
            type="submit"
            disabled={pending}
            className="mt-2 w-full rounded-full bg-primary text-primary-foreground hover:bg-primary/90"
          >
            {pending && <Loader2 className="h-4 w-4 animate-spin" />}
            {mode === "login" ? "Sign in" : "Create account"}
          </Button>
        </form>

        <p className="mt-6 text-center text-sm text-muted-foreground">
          {mode === "login" ? (
            <>
              Don&apos;t have an account?{" "}
              <Link href="/signup" className="text-foreground underline underline-offset-4">
                Sign up
              </Link>
            </>
          ) : (
            <>
              Already have an account?{" "}
              <Link href="/login" className="text-foreground underline underline-offset-4">
                Sign in
              </Link>
            </>
          )}
        </p>
      </div>
    </div>
  )
}
