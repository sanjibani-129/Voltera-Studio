"use client"

import { Suspense } from "react"
import { Canvas } from "@react-three/fiber"
import { Environment, OrbitControls, useGLTF, Center, Bounds } from "@react-three/drei"
import { Box } from "lucide-react"

/**
 * Renders a real .glb/.gltf model when `modelUrl` is provided.
 * When `modelUrl` is null (no verified public model exists for this
 * component yet), renders a premium empty-state card instead of a fake or
 * generated placeholder mesh -- so the viewer is honest about what it does
 * and doesn't show, rather than a dead or misleading component.
 */
export function Component3DViewer({ modelUrl, name }: { modelUrl: string | null; name: string }) {
  if (!modelUrl) {
    return (
      <div className="glass relative flex h-80 w-full flex-col items-center justify-center overflow-hidden rounded-3xl p-10 text-center md:h-[420px]">
        <div
          aria-hidden="true"
          className="pointer-events-none absolute inset-0 opacity-60"
          style={{
            background:
              "radial-gradient(circle at 50% 40%, color-mix(in oklab, var(--primary) 14%, transparent), transparent 65%)",
          }}
        />
        <div className="relative mb-5 flex h-16 w-16 items-center justify-center rounded-2xl border border-border bg-secondary/60">
          <Box className="h-7 w-7 text-primary" />
        </div>
        <h3 className="relative text-lg font-semibold tracking-tight">3D model not yet available.</h3>
        <p className="relative mt-2 max-w-sm text-pretty text-sm text-muted-foreground">
          We only publish verified, real .glb models for {name} -- no generated stand-ins. Check back as the model
          library grows, or explore the Pin Diagram and Specs tabs in the meantime.
        </p>
      </div>
    )
  }

  return (
    <div className="glass relative h-80 w-full overflow-hidden rounded-3xl md:h-[420px]">
      <Canvas camera={{ position: [2.5, 2, 2.5], fov: 45 }} dpr={[1, 2]}>
        <ambientLight intensity={0.6} />
        <directionalLight position={[4, 6, 4]} intensity={1.2} />
        <Suspense fallback={null}>
          <Bounds fit clip observe margin={1.3}>
            <Center>
              <GltfModel url={modelUrl} />
            </Center>
          </Bounds>
          <Environment preset="city" />
        </Suspense>
        <OrbitControls enablePan={false} minDistance={1.5} maxDistance={6} autoRotate autoRotateSpeed={0.8} />
      </Canvas>
      <p className="pointer-events-none absolute bottom-3 left-1/2 -translate-x-1/2 text-xs text-muted-foreground">
        Drag to rotate · scroll to zoom
      </p>
    </div>
  )
}

function GltfModel({ url }: { url: string }) {
  const { scene } = useGLTF(url)
  return <primitive object={scene} />
}
