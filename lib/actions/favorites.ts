"use server"

import { revalidatePath } from "next/cache"
import { createClient } from "@/lib/supabase/server"

export async function toggleFavorite(componentId: string): Promise<{ favorited: boolean; error?: string }> {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    return { favorited: false, error: "not-authenticated" }
  }

  const { data: existing } = await supabase
    .from("favorites")
    .select("*")
    .eq("user_id", user.id)
    .eq("component_id", componentId)
    .maybeSingle()

  if (existing) {
    await supabase.from("favorites").delete().eq("user_id", user.id).eq("component_id", componentId)
    revalidatePath("/dashboard")
    revalidatePath("/components")
    return { favorited: false }
  }

  await supabase.from("favorites").insert({ user_id: user.id, component_id: componentId })
  revalidatePath("/dashboard")
  revalidatePath("/components")
  return { favorited: true }
}

export async function getFavoriteIds(): Promise<Set<string>> {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()
  if (!user) return new Set()

  const { data } = await supabase.from("favorites").select("component_id").eq("user_id", user.id)
  return new Set((data ?? []).map((row) => row.component_id))
}
