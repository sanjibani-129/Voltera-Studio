import type { Metadata } from "next"
import { notFound } from "next/navigation"
import { SiteNav } from "@/components/site-nav"
import { QuizRunner } from "@/components/electronics/quiz-runner"
import { getQuizByTopicSlug } from "@/lib/actions/quiz"
import { getCurrentUser } from "@/lib/actions/auth"

export async function generateMetadata({
  params,
}: {
  params: Promise<{ topic: string }>
}): Promise<Metadata> {
  const { topic } = await params
  const result = await getQuizByTopicSlug(topic)
  return { title: result ? `${result.topic.title} Quiz — Voltera` : "Quiz not found — Voltera" }
}

export default async function QuizPage({ params }: { params: Promise<{ topic: string }> }) {
  const { topic } = await params
  const [user, result] = await Promise.all([getCurrentUser(), getQuizByTopicSlug(topic)])

  if (!result || result.questions.length === 0) notFound()

  return (
    <main className="relative min-h-screen overflow-x-hidden bg-background">
      <SiteNav isAuthenticated={!!user} />

      <section className="mx-auto max-w-2xl px-6 pb-24 pt-36">
        <div className="mb-10 text-center">
          <p className="mb-3 text-sm font-medium uppercase tracking-[0.2em] text-primary">{result.topic.difficulty}</p>
          <h1 className="text-balance text-4xl font-semibold tracking-tight">{result.topic.title}</h1>
        </div>

        <QuizRunner topic={result.topic} questions={result.questions} isAuthenticated={!!user} />
      </section>
    </main>
  )
}
