import { motion } from "framer-motion";
import { useEffect, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { toast } from "sonner";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useTheme } from "@/contexts/ThemeContext";
import {
  User, Palette, Lock, Check, LogOut, Loader2, AlertCircle,
} from "lucide-react";
import {
  useUICustomization,
  colorPresets,
  fontPresets,
  borderRadiusPresets,
  navColorPresets,
} from "@/contexts/UICustomizationContext";
import { getProfile, updateProfile, changePassword } from "@/services/authService";
import { getSettings, updateSettingsGroup } from "@/services/settingsService";
import { useStoreBranding } from "@/contexts/StoreBrandingContext";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Slider } from "@/components/ui/slider";

const adminSections = [
  { id: "profile", label: "Profile", icon: User },
  { id: "appearance", label: "Appearance", icon: Palette },
  { id: "security", label: "Security", icon: Lock },
];

export default function AdminSettings() {
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const [activeSection, setActiveSection] = useState(
    () => searchParams.get("section") || "profile"
  );
  const { isDark, toggle } = useTheme();
  const ui = useUICustomization();
  const queryClient = useQueryClient();
  const { refreshBranding } = useStoreBranding();

  const [admin, setAdmin] = useState({ name: "", email: "", phone: "" });
  const [passwords, setPasswords] = useState({
    currentPassword: "", newPassword: "", confirmPassword: "",
  });

  // Fetch admin profile
  const { data: profileData, isLoading: profileLoading, error: profileError } = useQuery({
    queryKey: ["adminProfile"],
    queryFn: async () => {
      const res = await getProfile();
      return res.data || {};
    },
  });

  // Fill admin form when profile loads
  useEffect(() => {
    if (profileData && Object.keys(profileData).length > 0) {
      setAdmin({
        name: profileData.name || profileData.username || "",
        email: profileData.email || "",
        phone: profileData.phone || "",
      });
    }
  }, [profileData]);

  // Fetch settings for logoSize
  const { data: settingsData } = useQuery({
    queryKey: ["settings"],
    queryFn: async () => {
      const res = await getSettings();
      return res.data?.settings || {};
    },
  });

  const [logoSize, setLogoSize] = useState(36);

  useEffect(() => {
    if (settingsData && settingsData.store?.logoSize?.value) {
      setLogoSize(Number(settingsData.store.logoSize.value));
    }
  }, [settingsData]);

  useEffect(() => {
    const section = searchParams.get("section");
    if (section && adminSections.some((s) => s.id === section)) {
      setActiveSection(section);
    }
  }, [searchParams]);

  const selectSection = (id) => {
    setActiveSection(id);
    setSearchParams({ section: id });
  };

  // Profile mutation
  const profileMutation = useMutation({
    mutationFn: (data) => updateProfile(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["adminProfile"] });
      toast.success("Admin profile saved!");
    },
    onError: (err) => {
      toast.error(err.response?.data?.message || err.message || "Failed to save profile");
    },
  });

  const handleSaveAdmin = () => {
    profileMutation.mutate({
      name: admin.name,
      email: admin.email,
      phone: admin.phone,
    });
  };

  // Logo size mutation
  const logoSizeMutation = useMutation({
    mutationFn: (size) => updateSettingsGroup("store", { logoSize: size }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["settings"] });
      refreshBranding();
      toast.success("Logo size saved!");
    },
    onError: (err) => {
      toast.error(err.response?.data?.message || err.message || "Failed to save logo size");
    },
  });

  const handleSaveLogoSize = () => {
    logoSizeMutation.mutate(logoSize);
  };

  // Password mutation
  const passwordMutation = useMutation({
    mutationFn: (data) => changePassword(data),
    onSuccess: () => {
      setPasswords({ currentPassword: "", newPassword: "", confirmPassword: "" });
      toast.success("Password changed successfully!");
    },
    onError: (err) => {
      toast.error(err.response?.data?.message || err.message || "Failed to change password");
    },
  });

  const handleSaveSecurity = () => {
    if (!passwords.currentPassword || !passwords.newPassword || !passwords.confirmPassword) {
      toast.error("Please fill all password fields.");
      return;
    }
    if (passwords.newPassword !== passwords.confirmPassword) {
      toast.error("New passwords do not match.");
      return;
    }
    if (passwords.newPassword.length < 6) {
      toast.error("Password must be at least 6 characters.");
      return;
    }
    passwordMutation.mutate({
      currentPassword: passwords.currentPassword,
      newPassword: passwords.newPassword,
    });
  };

  const handleLogout = async () => {
    if (!window.confirm("Are you sure you want to logout?")) return;
    try {
      const { logout } = await import("@/services/authService");
      await logout();
    } catch (err) {
      // Proceed even if API fails
    }
    localStorage.removeItem("lm_admin_token");
    localStorage.removeItem("lm_admin_user");
    localStorage.removeItem("lm_admin_refresh_token");
    navigate("/login");
  };

  return (
    <div className="p-6 max-w-[1200px] mx-auto space-y-4">
      <div>
        <h1 className="text-2xl font-heading font-bold text-foreground">Admin Settings</h1>
        <p className="text-sm text-muted-foreground mt-1">
          Manage your admin profile, appearance, and security preferences
        </p>
      </div>

      <div className="border-b border-border">
        <nav className="flex flex-wrap gap-0 -mb-px">
          {adminSections.map((s) => (
            <button
              key={s.id}
              onClick={() => selectSection(s.id)}
              className={`flex items-center gap-2 px-4 py-3 text-sm font-medium border-b-2 transition whitespace-nowrap ${
                activeSection === s.id
                  ? "border-primary text-primary"
                  : "border-transparent text-muted-foreground hover:text-foreground hover:border-border"
              }`}
            >
              <s.icon className="w-4 h-4" />
              {s.label}
            </button>
          ))}
        </nav>
      </div>

      <motion.div
        key={activeSection}
        initial={{ opacity: 0, y: 6 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-card rounded-xl border border-border p-5 md:p-6 max-w-4xl"
      >
          {activeSection === "profile" && (
            <>
              <h2 className="font-heading font-semibold text-lg text-foreground">Admin Profile</h2>
              {profileLoading ? (
                <div className="flex items-center justify-center py-8">
                  <Loader2 className="w-5 h-5 animate-spin text-muted-foreground" />
                </div>
              ) : profileError ? (
                <div className="flex flex-col items-center gap-2 py-8 text-muted-foreground">
                  <AlertCircle className="w-6 h-6 text-destructive" />
                  <p className="text-sm">Failed to load profile.</p>
                </div>
              ) : (
                <div className="space-y-4 max-w-lg">
                  {[
                    { key: "name", label: "Full Name" },
                    { key: "email", label: "Email", type: "email" },
                    { key: "phone", label: "Phone" },
                  ].map((field) => (
                    <div key={field.key}>
                      <Label>{field.label}</Label>
                      <Input
                        type={field.type || "text"}
                        value={admin[field.key] || ""}
                        onChange={(e) => setAdmin({ ...admin, [field.key]: e.target.value })}
                        className="mt-1.5"
                      />
                    </div>
                  ))}
                  <Button onClick={handleSaveAdmin} disabled={profileMutation.isPending}>
                    {profileMutation.isPending ? "Saving..." : "Save Profile"}
                  </Button>
                </div>
              )}
            </>
          )}

          {activeSection === "appearance" && (
            <>
              <h2 className="font-heading font-semibold text-lg text-foreground mb-4">Appearance</h2>
              <div className="space-y-6">
                <div>
                  <h3 className="text-sm font-semibold text-foreground mb-3">Theme Mode</h3>
                  <div className="flex gap-3">
                    {[
                      { label: "Light", active: !isDark },
                      { label: "Dark", active: isDark },
                    ].map((mode) => (
                      <button
                        key={mode.label}
                        onClick={() => { if (!mode.active) toggle(); }}
                        className={`flex-1 max-w-[160px] h-20 rounded-xl border-2 transition-all flex flex-col items-center justify-center gap-1.5 ${
                          mode.active
                            ? "border-primary bg-primary/10 text-primary"
                            : "border-border bg-secondary text-muted-foreground hover:border-primary/40"
                        }`}
                      >
                        <div className={`w-8 h-5 rounded-md ${mode.label === "Light" ? "bg-white border border-border shadow-sm" : "bg-foreground"}`} />
                        <span className="text-xs font-medium">{mode.label}</span>
                      </button>
                    ))}
                  </div>
                </div>

                <div>
                  <h3 className="text-sm font-semibold text-foreground mb-1">Color Palette</h3>
                  <p className="text-xs text-muted-foreground mb-3">Choose a primary accent color</p>
                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                    {colorPresets.map((preset) => {
                      const isActive = ui.colorPreset === preset.id;
                      return (
                        <button
                          key={preset.id}
                          onClick={() => ui.setColorPreset(preset.id)}
                          className={`relative rounded-xl border-2 p-3 transition-all ${
                            isActive ? "border-primary shadow-md shadow-primary/20" : "border-border hover:border-primary/40"
                          }`}
                        >
                          {isActive && (
                            <div className="absolute top-2 right-2 w-5 h-5 rounded-full bg-primary flex items-center justify-center">
                              <Check className="w-3 h-3 text-primary-foreground" />
                            </div>
                          )}
                          <div className="flex gap-1 mb-2">
                            {preset.preview.map((color, i) => (
                              <div key={i} className="flex-1 h-6 rounded-md" style={{ backgroundColor: color }} />
                            ))}
                          </div>
                          <span className="text-xs font-medium text-foreground">{preset.name}</span>
                        </button>
                      );
                    })}
                  </div>
                </div>

                <div>
                  <h3 className="text-sm font-semibold text-foreground mb-1">Typography</h3>
                  <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
                    {fontPresets.map((preset) => {
                      const isActive = ui.fontPreset === preset.id;
                      return (
                        <button
                          key={preset.id}
                          onClick={() => ui.setFontPreset(preset.id)}
                          className={`relative rounded-xl border-2 p-4 text-left transition-all ${
                            isActive ? "border-primary bg-primary/5" : "border-border hover:border-primary/40"
                          }`}
                        >
                          <span className="block text-base font-bold text-foreground" style={{ fontFamily: `${preset.heading}, sans-serif` }}>
                            {preset.name}
                          </span>
                        </button>
                      );
                    })}
                  </div>
                </div>

                <div>
                  <h3 className="text-sm font-semibold text-foreground mb-3">Border Radius</h3>
                  <div className="flex gap-3 flex-wrap">
                    {borderRadiusPresets.map((preset) => (
                      <button
                        key={preset.id}
                        onClick={() => ui.setBorderRadius(preset.id)}
                        className={`flex flex-col items-center gap-1.5 p-3 rounded-xl border-2 transition-all min-w-[80px] ${
                          ui.borderRadius === preset.id ? "border-primary bg-primary/5" : "border-border hover:border-primary/40"
                        }`}
                      >
                        <div className="w-10 h-10 bg-primary/20 border-2 border-primary/50" style={{ borderRadius: preset.value }} />
                        <span className="text-xs font-medium">{preset.name}</span>
                      </button>
                    ))}
                  </div>
                </div>

                <div>
                  <h3 className="text-sm font-semibold text-foreground mb-3">Navigation Background</h3>
                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                    {navColorPresets.map((preset) => {
                      const isActive = ui.navColorPreset === preset.id;
                      return (
                        <button
                          key={preset.id}
                          onClick={() => ui.setNavColorPreset(preset.id)}
                          className={`relative rounded-xl border-2 p-3 transition-all ${
                            isActive ? "border-primary shadow-md shadow-primary/20" : "border-border hover:border-primary/40"
                          }`}
                        >
                          <div className="w-full h-10 rounded-lg mb-2 border border-border/30" style={{ backgroundColor: preset.preview }} />
                          <span className="text-xs font-medium">{preset.name}</span>
                        </button>
                      );
                    })}
                  </div>
                </div>

                <div>
                  <h3 className="text-sm font-semibold text-foreground mb-3">Logo Size</h3>
                  <p className="text-xs text-muted-foreground mb-4">Adjust sidebar logo size ({logoSize}px)</p>
                  <Slider
                    value={[logoSize]}
                    onValueChange={([v]) => setLogoSize(v)}
                    min={24}
                    max={64}
                    step={2}
                    className="max-w-md"
                  />
                  <Button className="mt-4" onClick={handleSaveLogoSize} disabled={logoSizeMutation.isPending}>
                    {logoSizeMutation.isPending ? "Saving..." : "Save Logo Size"}
                  </Button>
                </div>
              </div>
            </>
          )}

          {activeSection === "security" && (
            <>
              <h2 className="font-heading font-semibold text-lg text-foreground">Security</h2>
              <div className="max-w-lg space-y-4">
                <div>
                  <Label>Current Password</Label>
                  <Input
                    type="password"
                    value={passwords.currentPassword || ""}
                    onChange={(e) =>
                      setPasswords({ ...passwords, currentPassword: e.target.value })
                    }
                    placeholder="Enter current password"
                    className="mt-1.5"
                  />
                </div>

                <div>
                  <Label>New Password</Label>
                  <Input
                    type="password"
                    value={passwords.newPassword || ""}
                    onChange={(e) =>
                      setPasswords({ ...passwords, newPassword: e.target.value })
                    }
                    placeholder="Enter new password"
                    className="mt-1.5"
                  />
                </div>

                <div>
                  <Label>Confirm New Password</Label>
                  <Input
                    type="password"
                    value={passwords.confirmPassword || ""}
                    onChange={(e) =>
                      setPasswords({ ...passwords, confirmPassword: e.target.value })
                    }
                    placeholder="Confirm new password"
                    className="mt-1.5"
                  />
                </div>
                <Button onClick={handleSaveSecurity} disabled={passwordMutation.isPending}>
                  {passwordMutation.isPending ? "Saving..." : "Change Password"}
                </Button>

                <div className="pt-6 mt-6 border-t border-border">
                  <h3 className="text-sm font-semibold text-foreground mb-1">Logout</h3>
                  <p className="text-xs text-muted-foreground mb-4">Sign out from your admin account on this device</p>
                  <Button
                    variant="outline"
                    className="text-destructive border-destructive/30 hover:bg-destructive/10 hover:text-destructive gap-2"
                    onClick={handleLogout}
                  >
                    <LogOut className="w-4 h-4" />
                    Logout
                  </Button>
                </div>
              </div>
            </>
          )}
        </motion.div>
    </div>
  );
}
