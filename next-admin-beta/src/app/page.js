import NavBar from "@/components/NavBar"

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <NavBar />
      <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm lg:flex">
          Welcome to Old But Gold admin-beta-
      </div>
    </main>
  )
}
