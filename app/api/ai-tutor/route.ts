import Anthropic from "@anthropic-ai/sdk"
import { createClient } from "@/lib/supabase/server"

export const runtime = "nodejs"

const SYSTEM_PROMPT = `You are Voltra's AI electronics tutor. You explain circuits, components, and
embedded systems concepts clearly and patiently, adapting to the learner's level. Keep answers
focused and practical - use short paragraphs, and concrete examples (numbers, real component
names) over abstract theory where possible. If asked about a specific component, ground your
answer in that component's real electrical characteristics.`

export async function POST(request: Request) {
  if (!process.env.ANTHROPIC_API_KEY) {
    return Response.json(
      { error: "AI tutor is not configured yet. Add ANTHROPIC_API_KEY to your environment." },
      { status: 503 },
    )
  }

  const { messages, contextName } = (await request.json()) as {
    messages: { role: "user" | "assistant"; content: string }[]
    contextName?: string
  }

  if (!Array.isArray(messages) || messages.length === 0) {
    return Response.json({ error: "No messages provided." }, { status: 400 })
  }

  const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY })

  const system = contextName
    ? `${SYSTEM_PROMPT}\n\nThe learner is currently viewing the component page for: ${contextName}.`
    : SYSTEM_PROMPT

  try {
    const response = await anthropic.messages.create({
      model: "claude-sonnet-4-6",
      max_tokens: 1024,
      system,
      messages: messages.map((m) => ({ role: m.role, content: m.content })),
    })

    const text = response.content
      .map((block) => (block.type === "text" ? block.text : ""))
      .filter(Boolean)
      .join("\n")

    // Best-effort persistence of the exchange - never blocks the response.
    persistExchange(messages[messages.length - 1]?.content, text).catch(() => {})

    return Response.json({ reply: text })
  } catch (err) {
    console.error("[ai-tutor]", err)
    return Response.json({ error: "The AI tutor couldn't respond. Please try again." }, { status: 500 })
  }
}

async function persistExchange(userMessage: string | undefined, assistantMessage: string) {
  if (!userMessage) return
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()
  if (!user) return

  await supabase.from("tutor_messages").insert([
    { user_id: user.id, role: "user", content: userMessage },
    { user_id: user.id, role: "assistant", content: assistantMessage },
  ])
}
