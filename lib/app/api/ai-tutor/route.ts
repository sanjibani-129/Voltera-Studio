export const runtime = "nodejs"

const SYSTEM_PROMPT = `
You are Voltera's AI Electronics Tutor.

Explain electronics concepts clearly and accurately.
Use simple language.
Give practical examples.
If the question is about a component, explain:
- What it is
- How it works
- Pin configuration
- Applications
- Advantages
- Common mistakes
`

export async function POST(request: Request) {
  try {
    const { component, question } = await request.json()

    const prompt = component
      ? `${SYSTEM_PROMPT}

Current Component:
${component}

Question:
${question}`
      : `${SYSTEM_PROMPT}

Question:
${question}`

    const response = await fetch("http://127.0.0.1:11434/api/chat", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "qwen3:8b",
        stream: false,
        messages: [
          {
            role: "user",
            content: prompt,
          },
        ],
      }),
    })

    if (!response.ok) {
      throw new Error("Failed to communicate with Ollama.")
    }

    const data = await response.json()

    return Response.json({
      text: data.message?.content || "No response generated.",
    })
  } catch (err) {
    console.error(err)

    return Response.json(
      {
        error:
          err instanceof Error
            ? err.message
            : "Unable to contact AI Tutor.",
      },
      { status: 500 },
    )
  }
}