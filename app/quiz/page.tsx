import type { Metadata } from "next"
import Link from "next/link"
import { ArrowRight } from "lucide-react"
import { SiteNav } from "@/components/site-nav"
import { getQuizTopics } from "@/lib/actions/quiz"
import { getCurrentUser } from "@/lib/actions/auth"

export const metadata: Metadata = { title: "Quizzes — Voltera" }

export default async function QuizIndexPage() {
  const [user, topics] = await Promise.all([getCurrentUser(), getQuizTopics()])

  return (
    <main className="relative min-h-screen overflow-x-hidden bg-background">
      <SiteNav isAuthenticated={!!user} />

      <section className="mx-auto max-w-4xl px-6 pb-24 pt-36">
        <div className="mx-auto mb-12 max-w-2xl text-center">
          <p className="mb-3 text-sm font-medium uppercase tracking-[0.2em] text-primary">Test yourself</p>
          <h1 className="text-balance text-4xl font-semibold tracking-tight md:text-5xl">Pick a quiz.</h1>
          <p className="mt-4 text-pretty text-lg text-muted-foreground">
            Short, focused quizzes that check your understanding as you learn.
          </p>
        </div>

        <div className="grid gap-4 sm:grid-cols-2">
          {topics.map((topic) => (
            <Link
              key={topic.id}
              href={`/quiz/${topic.slug}`}
              className="glass group flex flex-col justify-between rounded-3xl p-6 transition-all duration-300 hover:-translate-y-1 hover:border-primary/30"
            >
              <div>
                <span className="mb-3 inline-flex items-center rounded-full border border-border px-2.5 py-1 text-[11px] capitalize text-muted-foreground">
                  {topic.difficulty}
                </span>
                <h2 className="text-lg font-semibold tracking-tight">{topic.title}</h2>
                <p className="mt-1.5 text-sm leading-relaxed text-muted-foreground">{topic.description}</p>
              </div>
              <div className="mt-6 flex items-center gap-1.5 text-sm text-primary">
                Start quiz <ArrowRight className="h-3.5 w-3.5 transition-transform group-hover:translate-x-0.5" />
              </div>
            </Link>
          ))}
        </div>
      </section>
    </main>
  )
}
