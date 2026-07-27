import { GEMINI_MODEL, getGeminiClient } from "@/lib/gemini"

export const runtime = "nodejs"

const SYSTEM_PROMPT = `You are Voltra's AI electronics tutor. You explain circuits, components, and
embedded systems concepts clearly and patiently, adapting to the learner's level. Keep answers
focused and practical - use short paragraphs, and concrete examples (numbers, real component
names) over abstract theory where possible.`

type TutorRequestBody = {
  component?: unknown
  question?: unknown
}

export async function POST(request: Request) {
  if (!process.env.GEMINI_API_KEY) {
    return Response.json(
      { error: "AI tutor is not configured yet. Add GEMINI_API_KEY to your environment." },
      { status: 503 },
    )
  }

  let body: TutorRequestBody
  try {
    body = (await request.json()) as TutorRequestBody
  } catch {
    return Response.json({ error: "Request body must be valid JSON." }, { status: 400 })
  }

  const { component, question } = body

  if (typeof question !== "string" || question.trim().length === 0) {
    return Response.json({ error: "'question' is required and must be a non-empty string." }, { status: 400 })
  }
  if (component !== undefined && typeof component !== "string") {
    return Response.json({ error: "'component' must be a string if provided." }, { status: 400 })
  }

  const trimmedComponent = component?.trim()
  const systemInstruction = trimmedComponent
    ? `${SYSTEM_PROMPT}\n\nThe learner is currently asking about this component: ${trimmedComponent}. Ground your answer in that component's real electrical characteristics.`
    : SYSTEM_PROMPT

  try {
    const ai = getGeminiClient()

    const streamResult = await ai.models.generateContentStream({
      model: GEMINI_MODEL,
      contents: question.trim(),
      config: { systemInstruction },
    })

    const encoder = new TextEncoder()

    const stream = new ReadableStream<Uint8Array>({
      async start(controller) {
        try {
          for await (const chunk of streamResult) {
            const text = chunk.text
            if (text) {
              controller.enqueue(encoder.encode(text))
            }
          }
          controller.close()
        } catch (err) {
          console.error("[ai-tutor] streaming error", err)
          controller.error(err)
        }
      },
      cancel(reason) {
        console.warn("[ai-tutor] client cancelled stream", reason)
      },
    })

    return new Response(stream, {
      status: 200,
      headers: {
        "Content-Type": "text/plain; charset=utf-8",
        "Cache-Control": "no-cache, no-transform",
        "X-Content-Type-Options": "nosniff",
      },
    })
  } catch (err) {
    console.error("[ai-tutor] request setup error", err)
    return Response.json({ error: "The AI tutor couldn't respond. Please try again." }, { status: 500 })
  }
}
