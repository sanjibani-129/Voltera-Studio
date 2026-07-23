import { SiteNav } from "@/components/site-nav"
import { Hero } from "@/components/hero"
import { Stats } from "@/components/stats"
import { FeatureGrid } from "@/components/feature-grid"
import { Showcase } from "@/components/showcase"
import { CtaFooter } from "@/components/cta-footer"
import { getCurrentUser } from "@/lib/actions/auth"

export default async function Page() {
  const user = await getCurrentUser()

  return (
    <main className="relative min-h-screen overflow-x-hidden bg-background">
      <SiteNav isAuthenticated={!!user} />
      <Hero />
      <Stats />
      <FeatureGrid />
      <Showcase />
      <CtaFooter />
    </main>
  )
}
