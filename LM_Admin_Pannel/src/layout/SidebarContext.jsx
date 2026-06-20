import { createContext, useContext } from "react";

export const SidebarContext = createContext({ collapsed: false, setCollapsed: () => {} });

export function useSidebar() {
  return useContext(SidebarContext);
}
