export function SpecsTable({ specs }: { specs: Record<string, string> }) {
  const entries = Object.entries(specs)
  if (entries.length === 0) {
    return <p className="text-sm text-muted-foreground">No specs listed for this component yet.</p>
  }

  return (
    <div className="glass overflow-hidden rounded-3xl">
      <table className="w-full text-sm">
        <tbody>
          {entries.map(([key, value], i) => (
            <tr key={key} className={i !== 0 ? "border-t border-border" : ""}>
              <td className="px-6 py-3.5 font-medium text-muted-foreground">{key}</td>
              <td className="px-6 py-3.5 text-right text-foreground">{value}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
