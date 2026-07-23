"use client"

import { Suspense, useRef } from "react"
import { Canvas, useFrame } from "@react-three/fiber"
import { Environment, OrbitControls, useGLTF, Center, Bounds } from "@react-three/drei"
import type * as THREE from "three"

/**
 * Renders a real .glb/.gltf model when `modelUrl` is provided.
 * Falls back to a generated placeholder mesh (labeled box) when no model
 * has been uploaded yet, so the viewer is never a dead component.
 */
export function Component3DViewer({ modelUrl, name }: { modelUrl: string | null; name: string }) {
  return (
    <div className="glass relative h-80 w-full overflow-hidden rounded-3xl md:h-[420px]">
      <Canvas camera={{ position: [2.5, 2, 2.5], fov: 45 }} dpr={[1, 2]}>
        <ambientLight intensity={0.6} />
        <directionalLight position={[4, 6, 4]} intensity={1.2} />
        <Suspense fallback={null}>
          {modelUrl ? (
            <Bounds fit clip observe margin={1.3}>
              <Center>
                <GltfModel url={modelUrl} />
              </Center>
            </Bounds>
          ) : (
            <PlaceholderModel />
          )}
          <Environment preset="city" />
        </Suspense>
        <OrbitControls enablePan={false} minDistance={1.5} maxDistance={6} autoRotate autoRotateSpeed={0.8} />
      </Canvas>
      <p className="pointer-events-none absolute bottom-3 left-1/2 -translate-x-1/2 text-xs text-muted-foreground">
        Drag to rotate · scroll to zoom
      </p>
      {!modelUrl && (
        <p className="absolute right-3 top-3 rounded-full border border-border bg-background/70 px-2.5 py-1 text-[11px] text-muted-foreground backdrop-blur">
          Placeholder model — upload a .glb for {name} to replace this
        </p>
      )}
    </div>
  )
}

function GltfModel({ url }: { url: string }) {
  const { scene } = useGLTF(url)
  return <primitive object={scene} />
}

function PlaceholderModel() {
  const mesh = useRef<THREE.Mesh>(null)
  useFrame((_, delta) => {
    if (mesh.current) mesh.current.rotation.y += delta * 0.3
  })
  return (
    <mesh ref={mesh}>
      <boxGeometry args={[1.4, 0.8, 1.4]} />
      <meshStandardMaterial color="#4fd1c5" metalness={0.3} roughness={0.4} />
    </mesh>
  )
}
