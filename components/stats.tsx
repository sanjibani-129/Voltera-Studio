const stats = [
  { value: "250K+", label: "Active learners" },
  { value: "1,200+", label: "Interactive lessons" },
  { value: "98%", label: "Completion rate" },
  { value: "4.9/5", label: "Average rating" },
]

export function Stats() {
  return (
    <section className="mx-auto max-w-6xl px-6">
      <div className="glass grid grid-cols-2 gap-8 rounded-3xl px-8 py-10 md:grid-cols-4">
        {stats.map((s) => (
          <div key={s.label} className="text-center">
            <div className="text-3xl font-semibold tracking-tight text-primary md:text-4xl">{s.value}</div>
            <div className="mt-1 text-sm text-muted-foreground">{s.label}</div>
          </div>
        ))}
      </div>
    </section>
  )
}
