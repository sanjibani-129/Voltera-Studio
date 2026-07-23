"use client"

import { useState, useRef, useEffect } from "react"
import { Bot, Loader2, Send, User } from "lucide-react"
import { Button } from "@/components/ui/button"
import { cn } from "@/lib/utils"

type Message = { role: "user" | "assistant"; content: string }

export function AiTutorChat({ contextName }: { contextName?: string }) {
  const [messages, setMessages] = useState<Message[]>([
    {
      role: "assistant",
      content: contextName
        ? `Ask me anything about the ${contextName} - how it works, how to wire it, or how it compares to alternatives.`
        : "Ask me anything about electronics, circuits, or embedded systems.",
    },
  ])
  const [input, setInput] = useState("")
  const [pending, setPending] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const scrollRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight, behavior: "smooth" })
  }, [messages])

  const send = async () => {
    if (!input.trim() || pending) return
    const nextMessages = [...messages, { role: "user" as const, content: input.trim() }]
    setMessages(nextMessages)
    setInput("")
    setPending(true)
    setError(null)

    try {
      const res = await fetch("/api/ai-tutor", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ messages: nextMessages, contextName }),
      })
      const data = await res.json()
      if (!res.ok) {
        setError(data.error ?? "Something went wrong.")
        return
      }
      setMessages((prev) => [...prev, { role: "assistant", content: data.reply }])
    } catch {
      setError("Network error - please try again.")
    } finally {
      setPending(false)
    }
  }

  return (
    <div className="glass flex h-[520px] flex-col rounded-3xl p-4">
      <div ref={scrollRef} className="flex-1 space-y-4 overflow-y-auto px-2 py-2">
        {messages.map((m, i) => (
          <div key={i} className={cn("flex gap-3", m.role === "user" && "flex-row-reverse")}>
            <div
              className={cn(
                "flex h-7 w-7 shrink-0 items-center justify-center rounded-full",
                m.role === "user" ? "bg-secondary" : "bg-primary/15",
              )}
            >
              {m.role === "user" ? (
                <User className="h-3.5 w-3.5 text-muted-foreground" />
              ) : (
                <Bot className="h-3.5 w-3.5 text-primary" />
              )}
            </div>
            <div
              className={cn(
                "max-w-[80%] rounded-2xl px-4 py-2.5 text-sm leading-relaxed",
                m.role === "user" ? "bg-secondary text-foreground" : "bg-secondary/40 text-muted-foreground",
              )}
            >
              {m.content}
            </div>
          </div>
        ))}
        {pending && (
          <div className="flex items-center gap-2 px-2 text-xs text-muted-foreground">
            <Loader2 className="h-3.5 w-3.5 animate-spin" /> Thinking...
          </div>
        )}
        {error && <p className="rounded-xl bg-destructive/10 px-4 py-2.5 text-sm text-destructive">{error}</p>}
      </div>

      <form
        onSubmit={(e) => {
          e.preventDefault()
          send()
        }}
        className="mt-3 flex items-center gap-2 rounded-full border border-border bg-secondary/40 p-1.5 pl-4"
      >
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Ask a question..."
          className="min-w-0 flex-1 bg-transparent text-sm text-foreground outline-none placeholder:text-muted-foreground"
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
