"use server"

import { redirect } from "next/navigation"
import { revalidatePath } from "next/cache"
import { z } from "zod"
import { createClient } from "@/lib/supabase/server"

const emailSchema = z.string().email("Enter a valid email address.")
const passwordSchema = z.string().min(8, "Password must be at least 8 characters.")

export type AuthState = { error?: string } | undefined

export async function signIn(_prevState: AuthState, formData: FormData): Promise<AuthState> {
  const email = emailSchema.safeParse(formData.get("email"))
  const password = passwordSchema.safeParse(formData.get("password"))

  if (!email.success) return { error: email.error.issues[0].message }
  if (!password.success) return { error: password.error.issues[0].message }

  const supabase = await createClient()
  const { error } = await supabase.auth.signInWithPassword({
    email: email.data,
    password: password.data,
  })

  if (error) return { error: error.message }

  revalidatePath("/", "layout")
  redirect("/dashboard")
}

export async function signUp(_prevState: AuthState, formData: FormData): Promise<AuthState> {
  const email = emailSchema.safeParse(formData.get("email"))
  const password = passwordSchema.safeParse(formData.get("password"))
  const fullName = String(formData.get("fullName") ?? "").trim()

  if (!email.success) return { error: email.error.issues[0].message }
  if (!password.success) return { error: password.error.issues[0].message }
  if (!fullName) return { error: "Enter your name." }

  const supabase = await createClient()
  const { error } = await supabase.auth.signUp({
    email: email.data,
    password: password.data,
    options: { data: { full_name: fullName } },
  })

  if (error) return { error: error.message }

  revalidatePath("/", "layout")
  redirect("/dashboard")
}

export async function signOut() {
  const supabase = await createClient()
  await supabase.auth.signOut()
  revalidatePath("/", "layout")
  redirect("/")
}

export async function getCurrentUser() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()
  return user
}
