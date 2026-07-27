// export const runtime = "nodejs"

// const SYSTEM_PROMPT = `
// You are Voltera AI Tutor.

// You are an expert Electronics and Embedded Systems tutor.

// Rules:
// - Keep answers under 120 words unless the user asks for more detail.
// - Use simple English.
// - Explain step by step.
// - Use bullet points whenever possible.
// - Give practical examples.
// - If the question is about an electronic component, explain:
//   • What it is
//   • How it works
//   • Pin configuration (if applicable)
//   • Applications
//   • Advantages
// - Never generate unnecessarily long answers.
// `

// export async function POST(request: Request) {
//   try {
//     const { component, question } = await request.json()

//     const prompt = component
//       ? `${SYSTEM_PROMPT}

// Current Component:
// ${component}

// User Question:
// ${question}`
//       : `${SYSTEM_PROMPT}

// User Question:
// ${question}`

//     const response = await fetch("http://127.0.0.1:11434/api/chat", {
//       method: "POST",
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: JSON.stringify({
//         model: "qwen2.5:3b",
//         stream: false,
//         messages: [
//           {
//             role: "system",
//             content:
//               "You are Voltera AI Tutor. Reply in less than 120 words. Be concise, practical and beginner-friendly.",
//           },
//           {
//             role: "user",
//             content: prompt,
//           },
//         ],
//         options: {
//           temperature: 0.2,
//           top_p: 0.9,
//           num_predict: 120,
//         },
//       }),
//     })

//     if (!response.ok) {
//       const errorText = await response.text()

//       return Response.json(
//         {
//           error: errorText,
//         },
//         { status: response.status }
//       )
//     }

//     const data = await response.json()

//     return Response.json({
//       text: data.message?.content ?? "No response generated.",
//     })
//   } catch (err) {
//     console.error("[AI Tutor]", err)

//     return Response.json(
//       {
//         error:
//           err instanceof Error
//             ? err.message
//             : "Unable to contact Ollama.",
//       },
//       { status: 500 }
//     )
//   }
// }
export async function POST() {
  return Response.json({
    text: "AI Tutor is available only in the local development version. Cloud support is coming soon!",
  })
}