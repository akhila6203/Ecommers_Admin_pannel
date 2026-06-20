import { createContext, useContext, useEffect, useMemo } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { getSettings, getStoreInformation } from "@/services/settingsService";
import { resolveUploadUrl } from "@/utils/imageUrl";

const StoreBrandingContext = createContext(null);

function resolveLogoUrl(url) {
  if (!url) return "";
  if (url.startsWith("http://") || url.startsWith("https://")) return url;
  return resolveUploadUrl(url, "settings");
}

function updateFavicon(logoUrl) {
  if (!logoUrl) return;
  let link = document.querySelector("link[rel='icon']");
  if (!link) {
    link = document.createElement("link");
    link.rel = "icon";
    document.head.appendChild(link);
  }
  link.href = logoUrl;
}

export function StoreBrandingProvider({ children }) {
  const queryClient = useQueryClient();

  const { data: settingsData } = useQuery({
    queryKey: ["settings"],
    queryFn: () => getSettings().then((r) => r.data?.settings || {}),
    staleTime: 60000,
  });

  const { data: storeInfoData } = useQuery({
    queryKey: ["settings", "store-information"],
    queryFn: () => getStoreInformation().then((r) => r.data || {}),
    staleTime: 60000,
  });

  const branding = useMemo(() => {
    const storeSettings = settingsData?.store || {};
    const storeInfo = storeInfoData || {};
    const logoUrl = resolveLogoUrl(
      storeInfo.storeLogo || storeSettings?.logoUrl?.value || ""
    );
    const storeName =
      storeInfo.companyName || storeSettings?.storeName?.value || "LM Shopping Mall";
    const logoSize = Number(storeSettings?.logoSize?.value) || 36;
    return { logoUrl, storeName, logoSize };
  }, [settingsData, storeInfoData]);

  useEffect(() => {
    if (branding.logoUrl) updateFavicon(branding.logoUrl);
  }, [branding.logoUrl]);

  const refreshBranding = () => {
    queryClient.invalidateQueries({ queryKey: ["settings"] });
    queryClient.invalidateQueries({ queryKey: ["settings", "store-information"] });
  };

  return (
    <StoreBrandingContext.Provider value={{ ...branding, refreshBranding }}>
      {children}
    </StoreBrandingContext.Provider>
  );
}

export function useStoreBranding() {
  const ctx = useContext(StoreBrandingContext);
  if (!ctx) {
    return {
      logoUrl: "",
      storeName: "LM Shopping Mall",
      logoSize: 36,
      refreshBranding: () => {},
    };
  }
  return ctx;
}
