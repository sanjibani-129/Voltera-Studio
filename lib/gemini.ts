import { GoogleGenAI } from "@google/genai"

/**
 * Model used by every call through this client. Centralized here so the
 * whole app upgrades by changing one string.
 */
export const GEMINI_MODEL = "gemini-2.5-flash"

let client: GoogleGenAI | null = null

/**
 * Returns a shared, lazily-initialized Gemini client.
 *
 * Lazy init (rather than instantiating at module load) means importing this
 * file never throws just because GEMINI_API_KEY isn't set in an environment
 * that doesn't need it (e.g. local dev, tests, or unrelated build steps) --
 * the error only surfaces when the client is actually used.
 */
export function getGeminiClient(): GoogleGenAI {
  if (client) return client

  const apiKey = process.env.GEMINI_API_KEY
  if (!apiKey) {
    throw new Error("GEMINI_API_KEY is not set. Add it to your environment variables (e.g. .env.local).")
  }

  client = new GoogleGenAI({ apiKey })
  return client
}

/**
 * Convenience helper for the common case: send a prompt to Gemini 2.5 Flash
 * and get back plain text. For streaming, multi-turn chat, function calling,
 * or multimodal input, use getGeminiClient().models.* directly.
 */
export async function generateText(prompt: string): Promise<string> {
  const ai = getGeminiClient()

  const response = await ai.models.generateContent({
    model: GEMINI_MODEL,
    contents: prompt,
  })

  return response.text ?? ""
}
