"use client"

import type React from "react"
import { useCallback, useEffect, useRef, useState } from "react"
import ReactMarkdown from "react-markdown"
import remarkGfm from "remark-gfm"
import { AlertCircle, Bot, Check, Copy, RotateCcw, Send, Sparkles, User } from "lucide-react"
import { Button } from "@/components/ui/button"
import { cn } from "@/lib/utils"
import type { Component } from "@/lib/types/database.types"

type Message = {
  id: string
  role: "user" | "assistant"
  content: string
  /** true while an assistant message is still receiving streamed chunks */
  streaming?: boolean
}

function uid() {
  return Math.random().toString(36).slice(2)
}

function buildSuggestedQuestions(component: Component): string[] {
  return [
    `How does the ${component.name} actually work?`,
    `What are the most common applications for a ${component.name}?`,
    `How would I wire a ${component.name} into a beginner circuit?`,
    `What are good alternatives to the ${component.name}, and when should I use them instead?`,
  ]
}

/**
 * Reusable, ChatGPT-style AI tutor chat panel. Streams answers from
 * POST /api/ai-tutor about whichever component page it's mounted on.
 *
 * Note: /api/ai-tutor is currently stateless per question (it does not
 * receive prior turns), so each send is answered independently by the
 * model even though the transcript below shows full chat history.
 */
export function AiTutorChat({
  component,
  isConfigured = true,
}: {
  component: Component
  isConfigured?: boolean
}) {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: "welcome",
      role: "assistant",
      content: `Ask me anything about the **${component.name}** - how it works, how to wire it, or how it compares to alternatives.`,
    },
  ])
  const [input, setInput] = useState("")
  const [pending, setPending] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [lastQuestion, setLastQuestion] = useState<string | null>(null)

  const scrollRef = useRef<HTMLDivElement>(null)
  const inputRef = useRef<HTMLInputElement>(null)
  const abortRef = useRef<AbortController | null>(null)

  useEffect(() => {
    scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight, behavior: "smooth" })
  }, [messages])

  useEffect(() => {
    return () => abortRef.current?.abort()
  }, [])

  const send = useCallback(
    async (question: string) => {
      const trimmed = question.trim()
      if (!trimmed || pending) return

      setError(null)
      setLastQuestion(trimmed)
      setInput("")

      const userMessage: Message = { id: uid(), role: "user", content: trimmed }
      const assistantId = uid()
      setMessages((prev) => [...prev, userMessage, { id: assistantId, role: "assistant", content: "", streaming: true }])
      setPending(true)

      const controller = new AbortController()
      abortRef.current = controller

      try {
        const res = await fetch("/api/ai-tutor", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ component: component.name, question: trimmed }),
          signal: controller.signal,
        })

        // IMPORTANT: check res.ok on its own. res.body being falsy is NOT
        // an error condition by itself - some browsers/runtimes (older
        // Safari/WebKit, some in-app webviews, certain proxies) return a
        // perfectly valid 200 response but don't expose a readable stream
        // via res.body. Bundling "!res.body" into the same failure branch
        // as "!res.ok" was the actual bug here: it discarded a real,
        // successful 200 response and always fell through to this hardcoded
        // message, even though the model's answer had already arrived.
        if (!res.ok) {
          const data = await res.json().catch(() => ({}) as { error?: string })
          throw new Error(data.error || `The AI tutor couldn't respond (HTTP ${res.status}). Please try again.`)
        }

        let accumulated = ""

        if (res.body && typeof res.body.getReader === "function") {
          // Preferred path: read the stream incrementally so the UI updates
          // token-by-token as Gemini generates the response.
          const reader = res.body.getReader()
          const decoder = new TextDecoder()

          while (true) {
            const { done, value } = await reader.read()
            if (done) break
            accumulated += decoder.decode(value, { stream: true })
            setMessages((prev) =>
              prev.map((m) => (m.id === assistantId ? { ...m, content: accumulated, streaming: true } : m)),
            )
          }
        } else {
          // Fallback path: this environment's fetch doesn't support a
          // readable stream body. The response is still a valid, complete
          // 200 - read it all at once with res.text() rather than treating
          // its absence of a stream as a failure.
          console.warn("[ai-tutor] res.body has no readable stream in this environment - falling back to res.text()")
          accumulated = await res.text()
          setMessages((prev) =>
            prev.map((m) => (m.id === assistantId ? { ...m, content: accumulated, streaming: true } : m)),
          )
        }

        setMessages((prev) => prev.map((m) => (m.id === assistantId ? { ...m, streaming: false } : m)))

        if (!accumulated.trim()) {
          throw new Error("The AI tutor returned an empty response. Please try again.")
        }
      } catch (err) {
        if ((err as Error).name === "AbortError") return
        const messageText = err instanceof Error ? err.message : "Network error - please try again."
        setError(messageText)
        // Remove the empty streaming bubble left behind by the failed attempt.
        setMessages((prev) => prev.filter((m) => m.id !== assistantId))
      } finally {
        setPending(false)
        abortRef.current = null
      }
    },
    [component.name, pending],
  )

  if (!isConfigured) {
    return (
      <div className="glass flex h-[520px] flex-col items-center justify-center rounded-3xl p-8 text-center">
        <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-secondary/60">
          <Bot className="h-6 w-6 text-muted-foreground" />
        </div>
        <h3 className="text-lg font-semibold tracking-tight">AI Tutor isn&apos;t available yet</h3>
        <p className="mt-2 max-w-sm text-pretty text-sm text-muted-foreground">
          AI Tutor will be available after configuring an API key. Everything else on this page works normally in
          the meantime.
        </p>
      </div>
    )
  }

  const showSuggestions = messages.length <= 1 && !pending

  return (
    <div className="glass flex h-[560px] flex-col rounded-3xl p-4">
      <div ref={scrollRef} className="flex-1 space-y-4 overflow-y-auto px-2 py-2">
        {messages.map((m) => (
          <ChatBubble key={m.id} message={m} />
        ))}

        {pending && messages[messages.length - 1]?.content === "" && <TypingIndicator />}

        {error && (
          <div className="flex items-start gap-2 rounded-2xl bg-destructive/10 px-4 py-2.5 text-sm text-destructive">
            <AlertCircle className="mt-0.5 h-4 w-4 shrink-0" />
            <div className="flex-1">
              <p>{error}</p>
              {lastQuestion && (
                <button
                  onClick={() => send(lastQuestion)}
                  className="mt-1.5 inline-flex items-center gap-1.5 text-xs font-medium text-destructive underline underline-offset-2 hover:opacity-80"
                >
                  <RotateCcw className="h-3 w-3" /> Try again
                </button>
              )}
            </div>
          </div>
        )}
      </div>

      {showSuggestions && (
        <div className="mb-3 flex flex-wrap gap-2 px-2">
          {buildSuggestedQuestions(component).map((q) => (
            <button
              key={q}
              onClick={() => send(q)}
              className="flex items-center gap-1.5 rounded-full border border-border bg-secondary/40 px-3 py-1.5 text-left text-xs text-muted-foreground transition-colors hover:border-primary/40 hover:text-foreground"
            >
              <Sparkles className="h-3 w-3 shrink-0 text-primary" />
              {q}
            </button>
          ))}
        </div>
      )}

      <form
        onSubmit={(e) => {
          e.preventDefault()
          send(input)
        }}
        className="flex items-center gap-2 rounded-full border border-border bg-secondary/40 p-1.5 pl-4"
      >
        <input
          ref={inputRef}
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder={`Ask about the ${component.name}...`}
          disabled={pending}
          className="min-w-0 flex-1 bg-transparent text-sm text-foreground outline-none placeholder:text-muted-foreground disabled:opacity-60"
        />
        <Button
          type="submit"
          size="icon"
          disabled={pending || !input.trim()}
          className="rounded-full bg-primary text-primary-foreground hover:bg-primary/90"
          aria-label="Send message"
        >
          <Send className="h-4 w-4" />
        </Button>
      </form>
    </div>
  )
}

function ChatBubble({ message }: { message: Message }) {
  const isUser = message.role === "user"
  const [copied, setCopied] = useState(false)

  const copyMessage = () => {
    navigator.clipboard.writeText(message.content).then(() => {
      setCopied(true)
      setTimeout(() => setCopied(false), 1500)
    })
  }

  return (
    <div className={cn("group flex gap-3", isUser && "flex-row-reverse")}>
      <div
        className={cn(
          "flex h-7 w-7 shrink-0 items-center justify-center rounded-full",
          isUser ? "bg-secondary" : "bg-primary/15",
        )}
      >
        {isUser ? (
          <User className="h-3.5 w-3.5 text-muted-foreground" />
        ) : (
          <Bot className="h-3.5 w-3.5 text-primary" />
        )}
      </div>

      <div className={cn("relative max-w-[85%]", isUser && "flex flex-col items-end")}>
        <div
          className={cn(
            "rounded-2xl px-4 py-2.5 text-sm leading-relaxed",
            isUser ? "bg-secondary text-foreground" : "bg-secondary/40 text-foreground",
          )}
        >
          {isUser ? (
            <p className="text-pretty whitespace-pre-wrap">{message.content}</p>
          ) : message.content ? (
            <div className="prose-chat">
              <ReactMarkdown
                remarkPlugins={[remarkGfm]}
                components={{
                  pre: ({ children }) => <>{children}</>,
                  code: (props) => <MarkdownCode {...props} />,
                  a: ({ href, children }) => (
                    <a
                      href={href}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-primary underline underline-offset-2 hover:opacity-80"
                    >
                      {children}
                    </a>
                  ),
                  ul: ({ children }) => <ul className="my-2 list-disc space-y-1 pl-5">{children}</ul>,
                  ol: ({ children }) => <ol className="my-2 list-decimal space-y-1 pl-5">{children}</ol>,
                  p: ({ children }) => <p className="mb-2 text-pretty leading-relaxed last:mb-0">{children}</p>,
                  strong: ({ children }) => <strong className="font-semibold text-foreground">{children}</strong>,
                  h1: ({ children }) => <h4 className="mb-1.5 mt-3 text-base font-semibold first:mt-0">{children}</h4>,
                  h2: ({ children }) => <h4 className="mb-1.5 mt-3 text-base font-semibold first:mt-0">{children}</h4>,
                  h3: ({ children }) => <h4 className="mb-1.5 mt-3 text-sm font-semibold first:mt-0">{children}</h4>,
                  table: ({ children }) => (
                    <div className="my-2 overflow-x-auto rounded-lg border border-border">
                      <table className="w-full text-xs">{children}</table>
                    </div>
                  ),
                  th: ({ children }) => (
                    <th className="border-b border-border bg-secondary/60 px-2 py-1 text-left font-medium">
                      {children}
                    </th>
                  ),
                  td: ({ children }) => <td className="border-b border-border/60 px-2 py-1">{children}</td>,
                }}
              >
                {message.content}
              </ReactMarkdown>
              {message.streaming && (
                <span className="ml-0.5 inline-block h-3.5 w-1.5 animate-pulse bg-primary/70 align-middle" />
              )}
            </div>
          ) : null}
        </div>

        {!isUser && message.content && !message.streaming && (
          <button
            onClick={copyMessage}
            className="absolute -bottom-5 left-1 flex items-center gap-1 text-[11px] text-muted-foreground opacity-0 transition-opacity hover:text-foreground group-hover:opacity-100"
            aria-label="Copy response"
          >
            {copied ? (
              <>
                <Check className="h-3 w-3" /> Copied
              </>
            ) : (
              <>
                <Copy className="h-3 w-3" /> Copy
              </>
            )}
          </button>
        )}
      </div>
    </div>
  )
}

function MarkdownCode({
  className,
  children,
}: {
  className?: string
  children?: React.ReactNode
}) {
  const text = String(children ?? "").replace(/\n$/, "")
  const isBlock = text.includes("\n")

  if (!isBlock) {
    return <code className="rounded bg-secondary px-1.5 py-0.5 font-mono text-[0.85em] text-foreground">{text}</code>
  }

  const language = /language-(\w+)/.exec(className || "")?.[1]
  return <CodeBlock language={language} code={text} />
}

function CodeBlock({ language, code }: { language?: string; code: string }) {
  const [copied, setCopied] = useState(false)

  const copy = () => {
    navigator.clipboard.writeText(code).then(() => {
      setCopied(true)
      setTimeout(() => setCopied(false), 1500)
    })
  }

  return (
    <div className="my-2 overflow-hidden rounded-xl border border-border bg-background/60">
      <div className="flex items-center justify-between border-b border-border px-3 py-1.5">
        <span className="font-mono text-[11px] uppercase tracking-wide text-muted-foreground">
          {language || "code"}
        </span>
        <button
          onClick={copy}
          className="flex items-center gap-1 text-[11px] text-muted-foreground transition-colors hover:text-foreground"
          aria-label="Copy code"
        >
          {copied ? (
            <>
              <Check className="h-3 w-3" /> Copied
            </>
          ) : (
            <>
              <Copy className="h-3 w-3" /> Copy
            </>
          )}
        </button>
      </div>
      <pre className="overflow-x-auto p-3">
        <code className="font-mono text-xs leading-relaxed text-foreground">{code}</code>
      </pre>
    </div>
  )
}

function TypingIndicator() {
  return (
    <div className="flex items-center gap-3">
      <div className="flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-primary/15">
        <Bot className="h-3.5 w-3.5 text-primary" />
      </div>
      <div className="flex items-center gap-1 rounded-2xl bg-secondary/40 px-4 py-3">
        {[0, 1, 2].map((i) => (
          <span
            key={i}
            className="h-1.5 w-1.5 animate-bounce rounded-full bg-muted-foreground/60"
            style={{ animationDelay: `${i * 0.15}s` }}
          />
        ))}
      </div>
    </div>
  )
}
