import { cn } from "@/lib/utils"

/**
 * Renders a distinctive, on-brand SVG illustration for a given component
 * category. Used whenever a component has no real image_url, so the app
 * never shows a blank/generic placeholder graphic.
 */
export function CategoryIllustration({ category, className }: { category: string; className?: string }) {
  return (
    <svg
      viewBox="0 0 200 200"
      className={cn("h-full w-full", className)}
      xmlns="http://www.w3.org/2000/svg"
      aria-hidden="true"
    >
      <defs>
        <linearGradient id="voltera-accent" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0%" stopColor="var(--primary)" stopOpacity="0.9" />
          <stop offset="100%" stopColor="var(--primary)" stopOpacity="0.4" />
        </linearGradient>
      </defs>
      {getIllustrationBody(category)}
    </svg>
  )
}

function getIllustrationBody(category: string) {
  switch (category) {
    case "Passive Components":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <path d="M30 100h20l10-24 16 48 16-48 16 48 16-48 16 24h20" />
          <circle cx="40" cy="100" r="4" fill="var(--primary)" stroke="none" />
          <circle cx="160" cy="100" r="4" fill="var(--primary)" stroke="none" />
        </g>
      )
    case "Active Components":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <path d="M40 100h40" />
          <path d="M120 100h40" />
          <path d="M80 70v60l40-30-40-30Z" fill="var(--primary)" fillOpacity="0.25" />
          <path d="M120 70v60" />
        </g>
      )
    case "Integrated Circuits":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <rect x="60" y="60" width="80" height="80" rx="8" fill="var(--primary)" fillOpacity="0.12" />
          {[0, 1, 2, 3].map((i) => (
            <g key={i}>
              <path d={`M${72 + i * 20} 60V44`} />
              <path d={`M${72 + i * 20} 156v-16`} />
              <path d={`M60 ${72 + i * 20}H44`} />
              <path d={`M156 ${72 + i * 20}h-16`} />
            </g>
          ))}
          <circle cx="76" cy="76" r="3" fill="var(--primary)" stroke="none" />
        </g>
      )
    case "Sensors":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round">
          <circle cx="100" cy="110" r="10" fill="var(--primary)" stroke="none" />
          <path d="M100 110c0-30 0-30 0-30" strokeDasharray="0" opacity="0" />
          <path d="M76 86a34 34 0 0 1 48 0" />
          <path d="M60 70a58 58 0 0 1 80 0" />
          <path d="M44 54a82 82 0 0 1 112 0" />
        </g>
      )
    case "Modules":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <rect x="40" y="50" width="120" height="90" rx="8" fill="var(--primary)" fillOpacity="0.1" />
          <rect x="80" y="70" width="40" height="30" rx="4" />
          {[0, 1, 2, 3, 4, 5].map((i) => (
            <path key={i} d={`M${52 + i * 18} 140v14`} />
          ))}
        </g>
      )
    case "Displays":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <rect x="40" y="55" width="120" height="80" rx="8" fill="var(--primary)" fillOpacity="0.1" />
          <path d="M55 100l20-20 15 15 20-25 35 30" />
          <path d="M85 150h30" />
        </g>
      )
    case "Power Electronics":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <rect x="55" y="45" width="90" height="110" rx="10" fill="var(--primary)" fillOpacity="0.1" />
          <path d="M110 55 80 105h20l-10 40 40-55h-22l12-30Z" fill="var(--primary)" fillOpacity="0.6" stroke="none" />
        </g>
      )
    case "Communication Modules":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round">
          <path d="M100 150V70" />
          <circle cx="100" cy="60" r="8" fill="var(--primary)" stroke="none" />
          <path d="M76 90a34 34 0 0 1 48 0" />
          <path d="M60 74a58 58 0 0 1 80 0" />
        </g>
      )
    case "Development Boards":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <rect x="35" y="55" width="130" height="90" rx="8" fill="var(--primary)" fillOpacity="0.1" />
          <rect x="80" y="75" width="40" height="40" rx="4" />
          {[0, 1, 2].map((i) => (
            <path key={i} d={`M45 ${75 + i * 15}h20`} />
          ))}
          <rect x="130" y="80" width="18" height="30" rx="2" />
        </g>
      )
    case "Connectors":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <rect x="45" y="80" width="50" height="40" rx="4" fill="var(--primary)" fillOpacity="0.15" />
          <path d="M95 90h60M95 100h60M95 110h60" />
          <circle cx="160" cy="90" r="3" fill="var(--primary)" stroke="none" />
          <circle cx="160" cy="100" r="3" fill="var(--primary)" stroke="none" />
          <circle cx="160" cy="110" r="3" fill="var(--primary)" stroke="none" />
        </g>
      )
    case "Switches":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <rect x="55" y="80" width="90" height="45" rx="22" fill="var(--primary)" fillOpacity="0.12" />
          <circle cx="130" cy="102" r="16" fill="var(--primary)" fillOpacity="0.7" stroke="none" />
        </g>
      )
    case "Relays":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <rect x="45" y="55" width="50" height="60" rx="4" fill="var(--primary)" fillOpacity="0.12" />
          <path d="M52 65v40M62 65v40M72 65v40M82 65v40" strokeWidth="3" />
          <path d="M110 70l35 15-35 15" />
        </g>
      )
    case "Motors":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <circle cx="90" cy="100" r="45" fill="var(--primary)" fillOpacity="0.1" />
          <circle cx="90" cy="100" r="18" />
          <path d="M135 100h30" />
        </g>
      )
    case "Batteries":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <rect x="45" y="75" width="95" height="50" rx="6" fill="var(--primary)" fillOpacity="0.12" />
          <rect x="140" y="90" width="10" height="20" rx="2" fill="var(--primary)" stroke="none" />
          <path d="M65 100h20M75 90v20" />
          <path d="M110 100h20" />
        </g>
      )
    case "Crystals":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <rect x="65" y="65" width="70" height="70" rx="10" fill="var(--primary)" fillOpacity="0.12" />
          <path d="M80 100h8l6-16 10 32 10-32 6 16h10" />
        </g>
      )
    case "Fuses":
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <rect x="55" y="85" width="90" height="30" rx="15" fill="var(--primary)" fillOpacity="0.12" />
          <path d="M70 100h10l8-12 8 24 8-24 8 24 8-12h10" strokeWidth="3" />
        </g>
      )
    default:
      return (
        <g fill="none" stroke="url(#voltera-accent)" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
          <rect x="55" y="55" width="90" height="90" rx="12" fill="var(--primary)" fillOpacity="0.1" />
          <path d="M80 100h40M100 80v40" />
        </g>
      )
  }
}
