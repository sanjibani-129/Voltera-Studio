"use client"

import { useEffect } from "react"
import Link from "next/link"
import { AlertTriangle } from "lucide-react"
import { Button } from "@/components/ui/button"

export default function Error({ error, reset }: { error: Error & { digest?: string }; reset: () => void }) {
  useEffect(() => {
    console.error("[page-error]", error)
  }, [error])

  return (
    <main className="flex min-h-[70vh] flex-col items-center justify-center px-6 text-center">
      <div className="glass max-w-md rounded-3xl p-10">
        <AlertTriangle className="mx-auto mb-4 h-8 w-8 text-destructive" />
        <h1 className="text-2xl font-semibold tracking-tight">Something went wrong</h1>
        <p className="mt-2 text-pretty text-muted-foreground">
          This page hit an unexpected error. Try again, or head back home.
        </p>
        <div className="mt-8 flex justify-center gap-3">
          <Button onClick={() => reset()} variant="secondary" className="rounded-full">
            Try again
          </Button>
          <Button
            nativeButton={false}
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
