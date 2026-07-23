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
