// Hand-written to match supabase/migrations/0001_init.sql and 0002_seed_pins_and_quiz.sql.
// Once your Supabase project is live, regenerate the source of truth with:
//   pnpm db:types
// (requires SUPABASE_PROJECT_ID env var and the Supabase CLI)

export type Json = string | number | boolean | null | { [key: string]: Json } | Json[]

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          email: string
          full_name: string | null
          avatar_url: string | null
          created_at: string
        }
        Insert: Partial<Database["public"]["Tables"]["profiles"]["Row"]> & { id: string; email: string }
        Update: Partial<Database["public"]["Tables"]["profiles"]["Row"]>
      }
      components: {
        Row: {
          id: string
          slug: string
          name: string
          category: string
          manufacturer: string | null
          short_description: string
          long_description: string | null
          working_principle: string | null
          applications: string | null
          advantages: string | null
          disadvantages: string | null
          image_url: string | null
          model_url: string | null
          datasheet_url: string | null
          specs: Record<string, string>
          tags: string[]
          difficulty: "beginner" | "intermediate" | "advanced"
          created_at: string
        }
        Insert: Partial<Database["public"]["Tables"]["components"]["Row"]> & {
          slug: string
          name: string
          category: string
          short_description: string
        }
        Update: Partial<Database["public"]["Tables"]["components"]["Row"]>
      }
      component_pins: {
        Row: {
          id: string
          component_id: string
          pin_number: number
          label: string
          description: string | null
          x: number
          y: number
          pin_type: "power" | "ground" | "io" | "analog" | "special"
        }
        Insert: Partial<Database["public"]["Tables"]["component_pins"]["Row"]> & {
          component_id: string
          pin_number: number
          label: string
          x: number
          y: number
        }
        Update: Partial<Database["public"]["Tables"]["component_pins"]["Row"]>
      }
      component_relations: {
        Row: {
          id: string
          component_id: string
          related_component_id: string
          note: string | null
          created_at: string
        }
        Insert: Partial<Database["public"]["Tables"]["component_relations"]["Row"]> & {
          component_id: string
          related_component_id: string
        }
        Update: Partial<Database["public"]["Tables"]["component_relations"]["Row"]>
      }
      quiz_topics: {
        Row: {
          id: string
          slug: string
          title: string
          description: string | null
          difficulty: "beginner" | "intermediate" | "advanced"
        }
        Insert: Partial<Database["public"]["Tables"]["quiz_topics"]["Row"]> & { slug: string; title: string }
        Update: Partial<Database["public"]["Tables"]["quiz_topics"]["Row"]>
      }
      quiz_questions: {
        Row: {
          id: string
          topic_id: string
          question: string
          options: string[]
          correct_index: number
          explanation: string | null
          order_index: number
        }
        Insert: Partial<Database["public"]["Tables"]["quiz_questions"]["Row"]> & {
          topic_id: string
          question: string
          options: string[]
          correct_index: number
        }
        Update: Partial<Database["public"]["Tables"]["quiz_questions"]["Row"]>
      }
      quiz_attempts: {
        Row: {
          id: string
          user_id: string
          topic_id: string
          score: number
          total_questions: number
          answers: Json
          completed_at: string
        }
        Insert: Partial<Database["public"]["Tables"]["quiz_attempts"]["Row"]> & {
          user_id: string
          topic_id: string
          score: number
          total_questions: number
        }
        Update: Partial<Database["public"]["Tables"]["quiz_attempts"]["Row"]>
      }
      favorites: {
        Row: {
          user_id: string
          component_id: string
          created_at: string
        }
        Insert: { user_id: string; component_id: string; created_at?: string }
        Update: Partial<Database["public"]["Tables"]["favorites"]["Row"]>
      }
      tutor_messages: {
        Row: {
          id: string
          user_id: string
          role: "user" | "assistant"
          content: string
          created_at: string
        }
        Insert: Partial<Database["public"]["Tables"]["tutor_messages"]["Row"]> & {
          user_id: string
          role: "user" | "assistant"
          content: string
        }
        Update: Partial<Database["public"]["Tables"]["tutor_messages"]["Row"]>
      }
    }
  }
}

export type Component = Database["public"]["Tables"]["components"]["Row"]
export type ComponentPin = Database["public"]["Tables"]["component_pins"]["Row"]
export type ComponentRelation = Database["public"]["Tables"]["component_relations"]["Row"]
export type QuizTopic = Database["public"]["Tables"]["quiz_topics"]["Row"]
export type QuizQuestion = Database["public"]["Tables"]["quiz_questions"]["Row"]
export type QuizAttempt = Database["public"]["Tables"]["quiz_attempts"]["Row"]
export type Profile = Database["public"]["Tables"]["profiles"]["Row"]
