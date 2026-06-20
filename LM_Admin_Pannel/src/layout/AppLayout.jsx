import { useState } from "react";
import { Outlet } from "react-router-dom";
import { Sidebar } from "./Sidebar";
import { Header } from "./Header";
import { SidebarContext } from "./SidebarContext";
import { StoreBrandingProvider } from "@/contexts/StoreBrandingContext";

export function AppLayout() {
  const [collapsed, setCollapsed] = useState(false);

  return (
    <StoreBrandingProvider>
      <SidebarContext.Provider value={{ collapsed, setCollapsed }}>
        <div className="flex min-h-screen w-full bg-background">
          <Sidebar />
          <div
            className="flex-1 flex flex-col min-w-0 transition-all duration-300"
            style={{ marginLeft: collapsed ? 72 : 260 }}
          >
            <Header />
            <main className="flex-1 overflow-auto pt-16">
              <Outlet />
            </main>
          </div>
        </div>
      </SidebarContext.Provider>
    </StoreBrandingProvider>
  );
}
