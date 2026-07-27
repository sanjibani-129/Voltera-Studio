/** @type {import('next').NextConfig} */
const nextConfig = {
  typescript: {
    ignoreBuildErrors: true,
  },
  images: {
    // Local /public assets are already optimized by default.
    // Add your Supabase project's storage host once you're using it for
    // component images / 3D models so next/image can optimize those too.
    remotePatterns: [
      {
        protocol: "https",
        hostname: "*.supabase.co",
        pathname: "/storage/v1/object/public/**",
      },
      {
        // Verified, real component photography from Wikimedia Commons
        // (used via the stable Special:FilePath redirect, so no per-file
        // upload hash needs to be hardcoded here).
        protocol: "https",
        hostname: "commons.wikimedia.org",
        pathname: "/wiki/Special:FilePath/**",
      },
    ],
  },
}

export default nextConfig
