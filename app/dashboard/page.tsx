import type { Metadata } from "next"
import Link from "next/link"
import { redirect } from "next/navigation"
import { Trophy, Heart, Percent } from "lucide-react"
import { SiteNav } from "@/components/site-nav"
import { ComponentCard } from "@/components/electronics/component-card"
import { getCurrentUser } from "@/lib/actions/auth"
import { getUserQuizAttempts } from "@/lib/actions/quiz"
import { createClient } from "@/lib/supabase/server"
import type { Component } from "@/lib/types/database.types"

export const metadata: Metadata = { title: "Dashboard — Voltra" }

export default async function DashboardPage() {
  const user = await getCurrentUser()
  if (!user) redirect("/login?next=/dashboard")

  const supabase = await createClient()

  const [{ data: favoriteRows }, attempts, { data: profile }] = await Promise.all([
    supabase.from("favorites").select("components(*)").eq("user_id", user.id),
    getUserQuizAttempts(),
    supabase.from("profiles").select("*").eq("id", user.id).single(),
  ])

  const favorites = (favoriteRows ?? []).map((row) => row.components).filter(Boolean) as unknown as Component[]

  const avgScore =
    attempts.length > 0
      ? Math.round((attempts.reduce((sum, a) => sum + a.score / a.total_questions, 0) / attempts.length) * 100)
      : 0

  return (
    <main className="relative min-h-screen overflow-x-hidden bg-background">
      <SiteNav isAuthenticated />

      <section className="mx-auto max-w-6xl px-6 pb-24 pt-36">
        <div className="mb-10">
          <p className="mb-2 text-sm font-medium uppercase tracking-[0.2em] text-primary">Dashboard</p>
          <h1 className="text-balance text-4xl font-semibold tracking-tight md:text-5xl">
            Welcome back{profile?.full_name ? `, ${profile.full_name.split(" ")[0]}` : ""}.
          </h1>
        </div>

        <div className="mb-10 grid grid-cols-1 gap-4 sm:grid-cols-3">
          <StatCard icon={Heart} label="Favorited components" value={favorites.length} />
          <StatCard icon={Trophy} label="Quizzes completed" value={attempts.length} />
          <StatCard icon={Percent} label="Average score" value={`${avgScore}%`} />
        </div>

        <div className="mb-16">
          <div className="mb-4 flex items-center justify-between">
            <h2 className="text-xl font-semibold tracking-tight">Your favorites</h2>
            <Link href="/components" className="text-sm text-primary hover:underline">
              Browse more
            </Link>
          </div>
          {favorites.length === 0 ? (
            <p className="glass rounded-3xl p-8 text-center text-sm text-muted-foreground">
              You haven&apos;t favorited any components yet.
            </p>
          ) : (
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
              {favorites.map((c) => (
                <ComponentCard key={c.id} component={c} isFavorited showFavorite={false} />
              ))}
            </div>
          )}
        </div>

        <div>
          <div className="mb-4 flex items-center justify-between">
            <h2 className="text-xl font-semibold tracking-tight">Recent quiz attempts</h2>
            <Link href="/quiz" className="text-sm text-primary hover:underline">
              Take a quiz
            </Link>
          </div>
          {attempts.length === 0 ? (
            <p className="glass rounded-3xl p-8 text-center text-sm text-muted-foreground">
              You haven&apos;t taken any quizzes yet.
            </p>
          ) : (
            <div className="glass overflow-hidden rounded-3xl">
              {attempts.map((a, i) => (
                <div
                  key={a.id}
                  className={`flex items-center justify-between px-6 py-4 ${i !== 0 ? "border-t border-border" : ""}`}
                >
                  <div>
                    <p className="font-medium">{a.quiz_topics.title}</p>
                    <p className="text-xs text-muted-foreground">
                      {new Date(a.completed_at).toLocaleDateString(undefined, {
                        month: "short",
                        day: "numeric",
                        year: "numeric",
                      })}
                    </p>
                  </div>
                  <span className="text-sm font-medium text-primary">
                    {a.score}/{a.total_questions}
                  </span>
                </div>
              ))}
            </div>
          )}
        </div>
      </section>
    </main>
  )
}

function StatCard({ icon: Icon, label, value }: { icon: typeof Heart; label: string; value: string | number }) {
  return (
    <div className="glass rounded-3xl p-6">
      <div className="mb-4 inline-flex h-10 w-10 items-center justify-center rounded-2xl border border-border bg-secondary/60">
        <Icon className="h-5 w-5 text-primary" />
      </div>
      <div className="text-2xl font-semibold tracking-tight">{value}</div>
      <div className="text-sm text-muted-foreground">{label}</div>
    </div>
  )
}
