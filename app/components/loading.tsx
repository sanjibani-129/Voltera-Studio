export default function Loading() {
  return (
    <main className="relative min-h-screen overflow-x-hidden bg-background">
      <div className="mx-auto max-w-6xl px-6 pb-24 pt-36">
        <div className="mx-auto mb-10 h-24 max-w-2xl animate-pulse rounded-3xl bg-secondary/40" />
        <div className="h-16 animate-pulse rounded-3xl bg-secondary/40" />
        <div className="mt-10 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {Array.from({ length: 6 }).map((_, i) => (
            <div key={i} className="h-64 animate-pulse rounded-3xl bg-secondary/40" />
          ))}
        </div>
      </div>
    </main>
  )
}
