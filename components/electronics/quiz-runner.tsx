"use client"

import { useState } from "react"
import Link from "next/link"
import { Check, X, ArrowRight, RotateCcw } from "lucide-react"
import { Button } from "@/components/ui/button"
import { cn } from "@/lib/utils"
import { submitQuizAttempt } from "@/lib/actions/quiz"
import type { QuizQuestion, QuizTopic } from "@/lib/types/database.types"

type Answer = { questionId: string; selectedIndex: number; correct: boolean }

export function QuizRunner({
  topic,
  questions,
  isAuthenticated,
}: {
  topic: QuizTopic
  questions: QuizQuestion[]
  isAuthenticated: boolean
}) {
  const [index, setIndex] = useState(0)
  const [selected, setSelected] = useState<number | null>(null)
  const [answers, setAnswers] = useState<Answer[]>([])
  const [submitted, setSubmitted] = useState(false)

  const question = questions[index]
  const isLast = index === questions.length - 1
  const score = answers.filter((a) => a.correct).length

  const choose = (optionIndex: number) => {
    if (selected !== null) return
    setSelected(optionIndex)
  }

  const next = async () => {
    if (selected === null) return
    const correct = selected === question.correct_index
    const updatedAnswers = [...answers, { questionId: question.id, selectedIndex: selected, correct }]
    setAnswers(updatedAnswers)

    if (isLast) {
      setSubmitted(true)
      if (isAuthenticated) {
        await submitQuizAttempt({
          topicId: topic.id,
          score: updatedAnswers.filter((a) => a.correct).length,
          totalQuestions: questions.length,
          answers: updatedAnswers,
        })
      }
    } else {
      setIndex((i) => i + 1)
      setSelected(null)
    }
  }

  const restart = () => {
    setIndex(0)
    setSelected(null)
    setAnswers([])
    setSubmitted(false)
  }

  if (submitted) {
    const pct = Math.round((score / questions.length) * 100)
    return (
      <div className="glass rounded-3xl p-10 text-center">
        <p className="text-sm font-medium uppercase tracking-[0.2em] text-primary">Results</p>
        <h2 className="mt-3 text-4xl font-semibold tracking-tight">
          {score} / {questions.length}
        </h2>
        <p className="mt-2 text-muted-foreground">{pct}% correct</p>
        {!isAuthenticated && (
          <p className="mt-4 text-sm text-muted-foreground">
            <Link href="/login" className="text-foreground underline underline-offset-4">
              Sign in
            </Link>{" "}
            to save your quiz history to your dashboard.
          </p>
        )}
        <div className="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row">
          <Button onClick={restart} variant="secondary" className="rounded-full">
            <RotateCcw className="h-4 w-4" /> Retake quiz
          </Button>
          <Button
            render={<Link href="/quiz" />}
            className="rounded-full bg-primary text-primary-foreground hover:bg-primary/90"
          >
            More quizzes
          </Button>
        </div>
      </div>
    )
  }

  return (
    <div className="glass rounded-3xl p-8">
      <div className="mb-6 flex items-center justify-between text-xs text-muted-foreground">
        <span>
          Question {index + 1} of {questions.length}
        </span>
        <span>Score: {score}</span>
      </div>

      <h2 className="mb-6 text-balance text-xl font-semibold leading-relaxed tracking-tight">{question.question}</h2>

      <div className="space-y-3">
        {question.options.map((option, i) => {
          const isCorrect = i === question.correct_index
          const isSelected = i === selected
          const showState = selected !== null

          return (
            <button
              key={i}
              onClick={() => choose(i)}
              disabled={selected !== null}
              className={cn(
                "flex w-full items-center justify-between rounded-2xl border px-5 py-3.5 text-left text-sm transition-colors",
                !showState && "border-border hover:border-primary/40",
                showState && isCorrect && "border-primary/50 bg-primary/10",
                showState && isSelected && !isCorrect && "border-destructive/50 bg-destructive/10",
                showState && !isSelected && !isCorrect && "border-border opacity-50",
              )}
            >
              <span>{option}</span>
              {showState && isCorrect && <Check className="h-4 w-4 text-primary" />}
              {showState && isSelected && !isCorrect && <X className="h-4 w-4 text-destructive" />}
            </button>
          )
        })}
      </div>

      {selected !== null && question.explanation && (
        <p className="mt-5 rounded-2xl bg-secondary/40 px-5 py-3.5 text-sm text-muted-foreground">
          {question.explanation}
        </p>
      )}

      <div className="mt-8 flex justify-end">
        <Button
          onClick={next}
          disabled={selected === null}
          className="rounded-full bg-primary text-primary-foreground hover:bg-primary/90"
        >
          {isLast ? "See results" : "Next question"} <ArrowRight className="h-4 w-4" />
        </Button>
      </div>
    </div>
  )
}
