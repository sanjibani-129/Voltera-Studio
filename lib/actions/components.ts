"use server"

import { createClient } from "@/lib/supabase/server"
import type { Component, ComponentPin } from "@/lib/types/database.types"

export async function searchComponents(params: {
  query?: string
  category?: string
  difficulty?: string
}): Promise<Component[]> {
  const supabase = await createClient()
  let request = supabase.from("components").select("*").order("name")

  if (params.query) {
    request = request.textSearch("search_vector", params.query, { type: "websearch" })
  }
  if (params.category && params.category !== "all") {
    request = request.eq("category", params.category)
  }
  if (params.difficulty && params.difficulty !== "all") {
    request = request.eq("difficulty", params.difficulty)
  }

  const { data, error } = await request
  if (error) {
    console.error("[searchComponents]", error.message)
    return []
  }
  return data ?? []
}

export async function getComponentBySlug(
  slug: string,
): Promise<{ component: Component; pins: ComponentPin[] } | null> {
  const supabase = await createClient()

  const { data: component, error } = await supabase.from("components").select("*").eq("slug", slug).single()

  if (error || !component) return null

  const { data: pins } = await supabase
    .from("component_pins")
    .select("*")
    .eq("component_id", component.id)
    .order("pin_number")

  return { component, pins: pins ?? [] }
}

export async function getCategories(): Promise<string[]> {
  const supabase = await createClient()
  const { data } = await supabase.from("components").select("category")
  return Array.from(new Set((data ?? []).map((row) => row.category))).sort()
}

export async function getRelatedComponents(category: string, excludeId: string, limit = 4): Promise<Component[]> {
  const supabase = await createClient()

  // Prefer the curated, hand-picked relations graph (component_relations) -
  // it captures meaningful pairings (e.g. a driver IC with the motor it
  // drives) rather than just "same category". Falls back to a same-category
  // match if no curated relations exist yet for this component, or if the
  // table itself isn't present (e.g. 03_related_components.sql not yet run).
  const { data: curated, error: curatedError } = await supabase
    .from("component_relations")
    .select("note, related:related_component_id(*)")
    .eq("component_id", excludeId)
    .limit(limit)

  if (!curatedError && curated && curated.length > 0) {
    return curated.map((row: any) => row.related).filter(Boolean) as Component[]
  }

  const { data, error } = await supabase
    .from("components")
    .select("*")
    .eq("category", category)
    .neq("id", excludeId)
    .limit(limit)

  if (error) {
    console.error("[getRelatedComponents]", error.message)
    return []
  }
  return data ?? []
}
