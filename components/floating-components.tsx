import Image from "next/image"

type FloatingItem = {
  src: string
  className: string
  animation: string
  width: number
  delay?: string
}

const items: FloatingItem[] = [
  {
    src: "/comp-pcb.png",
    className: "left-[2%] top-[20%] w-64 opacity-45 md:w-96",
    animation: "animate-float",
    width: 640,
  },
  {
    src: "/comp-esp32.png",
    className: "right-[3%] top-[16%] w-52 opacity-45 md:w-80",
    animation: "animate-float-slow",
    width: 560,
    delay: "1.5s",
  },
  {
    src: "/comp-transistor.png",
    className: "right-[8%] bottom-[16%] hidden w-32 opacity-40 md:block md:w-44",
    animation: "animate-float",
    width: 320,
    delay: "0.8s",
  },
  {
    src: "/comp-led.png",
    className: "left-[16%] bottom-[14%] hidden w-24 opacity-40 lg:block md:w-32",
    animation: "animate-float-slow",
    width: 240,
    delay: "2.2s",
  },
  {
    src: "/comp-relay.png?v=2",
    className: "right-[16%] top-[46%] hidden w-36 opacity-40 lg:block md:w-48",
    animation: "animate-float",
    width: 380,
    delay: "1.1s",
  },
  {
    src: "/comp-radar.png",
    className: "left-[6%] bottom-[10%] w-28 opacity-40 md:w-40",
    animation: "animate-float-slow",
    width: 320,
    delay: "1.8s",
  },
]

export function FloatingComponents() {
  return (
    <div aria-hidden="true" className="pointer-events-none absolute inset-0 overflow-hidden">
      {items.map((item, i) => (
        <Image
          key={i}
          src={item.src || "/placeholder.svg"}
          alt=""
          width={item.width}
          height={item.width}
          className={`${item.animation} absolute mix-blend-screen ${item.className}`}
          style={{ animationDelay: item.delay }}
        />
      ))}
    </div>
  )
}
