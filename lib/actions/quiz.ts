"use server"

import { createClient } from "@/lib/supabase/server"
import type { QuizAttempt, QuizQuestion, QuizTopic } from "@/lib/types/database.types"

export async function getQuizTopics(): Promise<QuizTopic[]> {
  const supabase = await createClient()
  const { data } = await supabase.from("quiz_topics").select("*").order("title")
  return data ?? []
}

export async function getQuizByTopicSlug(
  slug: string,
): Promise<{ topic: QuizTopic; questions: QuizQuestion[] } | null> {
  const supabase = await createClient()
  const { data: topic } = await supabase.from("quiz_topics").select("*").eq("slug", slug).single()
  if (!topic) return null

  const { data: questions } = await supabase
    .from("quiz_questions")
    .select("*")
    .eq("topic_id", topic.id)
    .order("order_index")

  return { topic, questions: questions ?? [] }
}

export async function submitQuizAttempt(input: {
  topicId: string
  score: number
  totalQuestions: number
  answers: { questionId: string; selectedIndex: number; correct: boolean }[]
}): Promise<{ error?: string }> {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) return { error: "not-authenticated" }

  const { error } = await supabase.from("quiz_attempts").insert({
    user_id: user.id,
    topic_id: input.topicId,
    score: input.score,
    total_questions: input.totalQuestions,
    answers: input.answers,
  })

  return error ? { error: error.message } : {}
}

export async function getUserQuizAttempts(): Promise<(QuizAttempt & { quiz_topics: QuizTopic })[]> {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()
  if (!user) return []

  const { data } = await supabase
    .from("quiz_attempts")
    .select("*, quiz_topics(*)")
    .eq("user_id", user.id)
    .order("completed_at", { ascending: false })

  return (data as (QuizAttempt & { quiz_topics: QuizTopic })[]) ?? []
}
