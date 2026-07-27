import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

/**
 * Returns true only if the given URL points to a real, meaningful image -
 * not empty, not missing, and not one of the generic gray placeholder
 * graphics. Used to decide when to fall back to a category illustration
 * instead of rendering a blank/generic placeholder image.
 */
export function hasRealImage(url?: string | null): boolean {
  if (!url) return false
  const trimmed = url.trim()
  if (!trimmed) return false
  if (trimmed.startsWith('/placeholder.svg')) return false
  if (trimmed.includes('placeholder-logo')) return false
  if (trimmed === '/placeholder.jpg') return false
  return true
}
