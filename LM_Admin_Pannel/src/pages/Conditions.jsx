import { useState, useEffect, useRef } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { Loader2, Save, Upload, Eye, MapPin, Mail, Phone, X, Plus, Trash2, Clock } from "lucide-react";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";
import { getContentPage, updateContentPage } from "@/services/settingsService";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";

import { resolveUploadUrl } from "@/utils/imageUrl";
import { toGoogleMapsEmbedUrl } from "@/utils/googleMaps";

const quillModules = {
  toolbar: [
    [{ header: [1, 2, 3, false] }],
    ["bold", "italic", "underline", "strike"],
    [{ list: "ordered" }, { list: "bullet" }],
    ["blockquote", "code-block"],
    [{ color: [] }, { background: [] }],
    ["link", "image"],
    ["clean"],
  ],
};

const quillFormats = [
  "header",
  "bold", "italic", "underline", "strike",
  "list", "bullet",
  "blockquote", "code-block",
  "color", "background",
  "link", "image",
];

const PAGE_TABS = [
  { value: "about", label: "About Us" },
  { value: "contact", label: "Contact Us" },
  { value: "privacy-policy", label: "Privacy Policy" },
  { value: "terms-conditions", label: "Terms & Conditions" },
  { value: "shipping-policy", label: "Shipping Policy" },
  { value: "refund-policy", label: "Refund Policy" },
];

const TAB_TRIGGER_CLASS =
  "rounded-md px-3 py-2 text-xs sm:text-sm font-medium whitespace-nowrap shrink-0 transition-colors data-[state=active]:bg-primary data-[state=active]:text-primary-foreground data-[state=active]:shadow-sm text-muted-foreground hover:text-foreground";

const EMPTY_POLICY_FORM = { title: "", content: "" };

const EMPTY_CONTACT_FORM = {
  storeName: "",
  email: "",
  mobile: "",
  alternateMobile: "",
  address: "",
  googleMapsUrl: "",
  whatsappNumber: "",
  working_hours: [],
};

function resetFormForTab(tab, setters) {
  const {
    setAboutForm,
    setAboutImageFile,
    setAboutImagePreview,
    setContactForm,
    setPrivacyForm,
    setTermsForm,
    setShippingForm,
    setRefundForm,
  } = setters;

  switch (tab) {
    case "about":
      setAboutForm({ ...EMPTY_POLICY_FORM });
      setAboutImageFile(null);
      setAboutImagePreview(null);
      break;
    case "contact":
      setContactForm({ ...EMPTY_CONTACT_FORM });
      break;
    case "privacy-policy":
      setPrivacyForm({ ...EMPTY_POLICY_FORM });
      break;
    case "terms-conditions":
      setTermsForm({ ...EMPTY_POLICY_FORM });
      break;
    case "shipping-policy":
      setShippingForm({ ...EMPTY_POLICY_FORM });
      break;
    case "refund-policy":
      setRefundForm({ ...EMPTY_POLICY_FORM });
      break;
    default:
      break;
  }
}

function EditorPreviewLayout({ editor, preview }) {
  return (
    <div className="mt-4 grid grid-cols-1 lg:grid-cols-2 gap-4 items-start">
      <div className="min-w-0">{editor}</div>
      <div className="min-w-0">{preview}</div>
    </div>
  );
}

function EditorCard({ title, description, children }) {
  return (
    <Card>
      <CardHeader className="py-3 px-4 space-y-0">
        <CardTitle className="text-base">{title}</CardTitle>
        {description ? <CardDescription className="text-xs mt-1">{description}</CardDescription> : null}
      </CardHeader>
      <CardContent className="px-4 pb-4 pt-0">{children}</CardContent>
    </Card>
  );
}

function LivePreviewCard({ children }) {
  return (
    <Card className="border-primary/20 shadow-sm">
      <CardHeader className="py-2 px-4 bg-secondary/30 border-b">
        <CardTitle className="text-xs font-medium flex items-center gap-1.5 text-primary">
          <Eye className="w-3.5 h-3.5" /> Live Website Preview
        </CardTitle>
      </CardHeader>
      <CardContent className="p-4 pt-3">{children}</CardContent>
    </Card>
  );
}

function PolicyPreview({ title, content, fallbackTitle }) {
  return (
    <>
      <h1 className="text-xl font-bold text-foreground leading-tight">{title || fallbackTitle}</h1>
      <div
        className="prose prose-sm dark:prose-invert text-foreground/80 max-w-none mt-2"
        dangerouslySetInnerHTML={{ __html: content || "<p>Write content to see live preview.</p>" }}
      />
    </>
  );
}

export default function Conditions() {
  const queryClient = useQueryClient();
  const [activeTab, setActiveTab] = useState("about");
  const skipPopulateRef = useRef(false);

  // Tab Content States
  const [aboutForm, setAboutForm] = useState({ ...EMPTY_POLICY_FORM });
  const [aboutImageFile, setAboutImageFile] = useState(null);
  const [aboutImagePreview, setAboutImagePreview] = useState(null);

  const [contactForm, setContactForm] = useState({ ...EMPTY_CONTACT_FORM });

  const [privacyForm, setPrivacyForm] = useState({ ...EMPTY_POLICY_FORM });
  const [termsForm, setTermsForm] = useState({ ...EMPTY_POLICY_FORM });
  const [shippingForm, setShippingForm] = useState({ ...EMPTY_POLICY_FORM });
  const [refundForm, setRefundForm] = useState({ ...EMPTY_POLICY_FORM });

  const formSetters = {
    setAboutForm,
    setAboutImageFile,
    setAboutImagePreview,
    setContactForm,
    setPrivacyForm,
    setTermsForm,
    setShippingForm,
    setRefundForm,
  };

  // Queries
  const { data: pageData, isLoading: isPageLoading } = useQuery({
    queryKey: ["contentPage", activeTab],
    queryFn: () => getContentPage(activeTab).then(r => r.data),
    staleTime: 0
  });

  // Populate States based on Query Data (skip after save so fields stay cleared)
  useEffect(() => {
    if (!pageData) return;
    if (skipPopulateRef.current) {
      skipPopulateRef.current = false;
      return;
    }
    
    if (activeTab === "about") {
      setAboutForm({
        title: pageData.title || "",
        content: pageData.content || ""
      });
      setAboutImagePreview(pageData.image ? resolveUploadUrl(pageData.image, "content") : null);
      setAboutImageFile(null);
    } else if (activeTab === "contact") {
      const contactData = pageData.content || {};
      setContactForm({
        storeName: contactData.storeName || "",
        email: contactData.email || "",
        mobile: contactData.mobile || "",
        alternateMobile: contactData.alternateMobile || "",
        address: contactData.address || "",
        googleMapsUrl: contactData.googleMapsUrl || "",
        whatsappNumber: contactData.whatsappNumber || "",
        working_hours: Array.isArray(contactData.working_hours) ? contactData.working_hours : [],
      });
    } else if (activeTab === "privacy-policy") {
      setPrivacyForm({
        title: pageData.title || "",
        content: pageData.content || ""
      });
    } else if (activeTab === "terms-conditions") {
      setTermsForm({
        title: pageData.title || "",
        content: pageData.content || ""
      });
    } else if (activeTab === "shipping-policy") {
      setShippingForm({
        title: pageData.title || "",
        content: pageData.content || ""
      });
    } else if (activeTab === "refund-policy") {
      setRefundForm({
        title: pageData.title || "",
        content: pageData.content || ""
      });
    }
  }, [pageData, activeTab]);

  // Mutations
  const updateMutation = useMutation({
    mutationFn: ({ key, payload }) => updateContentPage(key, payload),
    onSuccess: (_, variables) => {
      skipPopulateRef.current = true;
      resetFormForTab(variables.key, formSetters);
      queryClient.invalidateQueries({ queryKey: ["contentPage", variables.key] });
      toast.success("Page updated successfully!");
    },
    onError: (err) => {
      toast.error(err.response?.data?.message || err.message || "Failed to update page");
    }
  });

  const handleImageChange = (e) => {
    const file = e.target.files?.[0];
    if (file) {
      setAboutImageFile(file);
      setAboutImagePreview(URL.createObjectURL(file));
    }
  };

  const handleSaveAbout = (e) => {
    e.preventDefault();
    const formData = new FormData();
    formData.append("title", aboutForm.title);
    formData.append("content", aboutForm.content);
    if (aboutImageFile) {
      formData.append("image", aboutImageFile);
    } else if (aboutImagePreview === null) {
      formData.append("image", "");
    }
    updateMutation.mutate({ key: "about", payload: formData });
  };

  const handleSaveContact = (e) => {
    e.preventDefault();
    updateMutation.mutate({
      key: "contact",
      payload: {
        title: "Contact Us",
        content: {
          ...contactForm,
          working_hours: (contactForm.working_hours || []).filter(
            (row) => row.label?.trim() || row.time?.trim()
          ),
        },
      },
    });
  };

  const addWorkingHourRow = () => {
    setContactForm((prev) => ({
      ...prev,
      working_hours: [...(prev.working_hours || []), { label: "", time: "" }],
    }));
  };

  const updateWorkingHourRow = (index, field, value) => {
    setContactForm((prev) => {
      const rows = [...(prev.working_hours || [])];
      rows[index] = { ...rows[index], [field]: value };
      return { ...prev, working_hours: rows };
    });
  };

  const removeWorkingHourRow = (index) => {
    setContactForm((prev) => ({
      ...prev,
      working_hours: (prev.working_hours || []).filter((_, i) => i !== index),
    }));
  };

  const handleSavePolicy = (key, state) => {
    updateMutation.mutate({
      key,
      payload: {
        title: state.title,
        content: state.content
      }
    });
  };

  return (
    <div className="p-4 md:p-6 max-w-[1400px] mx-auto space-y-4">
      <div>
        <h1 className="text-2xl font-heading font-bold text-foreground">Pages</h1>
        <p className="text-sm text-muted-foreground mt-1">
          Manage store content, contact info, and legal policies.
        </p>
      </div>

      <Tabs
        value={activeTab}
        onValueChange={(tab) => {
          skipPopulateRef.current = false;
          setActiveTab(tab);
        }}
        className="w-full"
      >
        <div className="sticky top-16 z-20 -mx-4 md:-mx-6 px-4 md:px-6 py-2 bg-background/95 backdrop-blur-md border-b border-border">
          <TabsList className="inline-flex h-auto w-full min-w-0 flex-nowrap justify-start gap-1 overflow-x-auto rounded-lg bg-secondary/50 p-1">
            {PAGE_TABS.map((tab) => (
              <TabsTrigger key={tab.value} value={tab.value} className={TAB_TRIGGER_CLASS}>
                {tab.label}
              </TabsTrigger>
            ))}
          </TabsList>
        </div>

        {isPageLoading ? (
          <div className="flex items-center justify-center py-12">
            <Loader2 className="w-8 h-8 animate-spin text-primary" />
          </div>
        ) : (
          <>
            {/* ════ ABOUT US TAB ════ */}
            <TabsContent value="about">
              <EditorPreviewLayout
                editor={
                  <EditorCard title="About Us Editor" description="Title, rich text, and image">
                    <form onSubmit={handleSaveAbout} className="space-y-3">
                      <div>
                        <Label htmlFor="about-title">Title</Label>
                        <Input
                          id="about-title"
                          value={aboutForm.title}
                          onChange={(e) => setAboutForm({ ...aboutForm, title: e.target.value })}
                          placeholder="e.g. Our Story"
                          className="mt-1"
                        />
                      </div>
                      <div>
                        <Label>Content (Rich Text)</Label>
                        <div className="rich-editor-wrapper mt-1">
                          <ReactQuill
                            theme="snow"
                            value={aboutForm.content}
                            onChange={(content) => setAboutForm({ ...aboutForm, content })}
                            modules={quillModules}
                            formats={quillFormats}
                          />
                        </div>
                      </div>
                      <div>
                        <Label>About Image</Label>
                        <div className="mt-1 flex items-center gap-3">
                          <label className="flex flex-col items-center justify-center px-3 py-4 border-2 border-dashed border-border rounded-lg cursor-pointer hover:border-primary bg-secondary/20 transition">
                            <Upload className="w-5 h-5 text-muted-foreground" />
                            <span className="text-xs text-muted-foreground mt-1">Upload</span>
                            <input type="file" accept="image/*" onChange={handleImageChange} className="hidden" />
                          </label>
                          {aboutImagePreview && (
                            <div className="relative w-28 h-20 border rounded overflow-hidden">
                              <img src={aboutImagePreview} alt="About preview" className="w-full h-full object-cover" />
                              <button
                                type="button"
                                onClick={() => {
                                  setAboutImagePreview(null);
                                  setAboutImageFile(null);
                                }}
                                className="absolute top-1 right-1 bg-background/80 hover:bg-background rounded-full p-1 shadow"
                              >
                                <X className="w-3.5 h-3.5 text-destructive" />
                              </button>
                            </div>
                          )}
                        </div>
                      </div>
                      <Button type="submit" disabled={updateMutation.isPending} size="sm">
                        {updateMutation.isPending ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : <Save className="w-4 h-4 mr-2" />}
                        Save Changes
                      </Button>
                    </form>
                  </EditorCard>
                }
                preview={
                  <LivePreviewCard>
                    {aboutImagePreview && (
                      <div className="w-full h-32 rounded-lg overflow-hidden bg-muted mb-3">
                        <img src={aboutImagePreview} alt="About Page Image" className="w-full h-full object-cover" />
                      </div>
                    )}
                    <h1 className="text-xl font-bold font-heading text-foreground leading-tight">
                      {aboutForm.title || "About Us Title"}
                    </h1>
                    <div
                      className="prose prose-sm dark:prose-invert text-foreground/80 max-w-none mt-2"
                      dangerouslySetInnerHTML={{ __html: aboutForm.content || "<p>Provide page content in the editor to see it here.</p>" }}
                    />
                  </LivePreviewCard>
                }
              />
            </TabsContent>

            {/* ════ CONTACT US TAB ════ */}
            <TabsContent value="contact">
              <EditorPreviewLayout
                editor={
                  <EditorCard title="Contact Details" description="Update store contact information">
                    <form onSubmit={handleSaveContact} className="grid grid-cols-1 md:grid-cols-2 gap-3">
                      <div>
                        <Label htmlFor="storeName">Store Name</Label>
                        <Input id="storeName" className="mt-1" value={contactForm.storeName} onChange={(e) => setContactForm({ ...contactForm, storeName: e.target.value })} placeholder="LM Shopping Mall" />
                      </div>
                      <div>
                        <Label htmlFor="contact-email">Email Address</Label>
                        <Input id="contact-email" className="mt-1" value={contactForm.email} onChange={(e) => setContactForm({ ...contactForm, email: e.target.value })} placeholder="contact@domain.com" />
                      </div>
                      <div>
                        <Label htmlFor="contact-mobile">Mobile Number</Label>
                        <Input id="contact-mobile" className="mt-1" value={contactForm.mobile} onChange={(e) => setContactForm({ ...contactForm, mobile: e.target.value })} placeholder="+91 9876543210" />
                      </div>
                      <div>
                        <Label htmlFor="contact-alt-mobile">Alternate Mobile</Label>
                        <Input id="contact-alt-mobile" className="mt-1" value={contactForm.alternateMobile} onChange={(e) => setContactForm({ ...contactForm, alternateMobile: e.target.value })} placeholder="+91 9998887776" />
                      </div>
                      <div>
                        <Label htmlFor="whatsapp">WhatsApp Number</Label>
                        <Input id="whatsapp" className="mt-1" value={contactForm.whatsappNumber} onChange={(e) => setContactForm({ ...contactForm, whatsappNumber: e.target.value })} placeholder="+91 9876543210" />
                      </div>
                      <div>
                        <Label htmlFor="gmaps">Google Maps URL</Label>
                        <Input id="gmaps" className="mt-1" value={contactForm.googleMapsUrl} onChange={(e) => setContactForm({ ...contactForm, googleMapsUrl: e.target.value })} placeholder="https://maps.google.com/..." />
                      </div>
                      <div className="md:col-span-2">
                        <Label htmlFor="address">Store Address</Label>
                        <Textarea id="address" className="mt-1" value={contactForm.address} onChange={(e) => setContactForm({ ...contactForm, address: e.target.value })} placeholder="123 Shopping Plaza, City Centre..." rows={2} />
                      </div>
                      <div className="md:col-span-2 space-y-3">
                        <div className="flex items-center justify-between">
                          <Label>Working Hours</Label>
                          <Button type="button" variant="outline" size="sm" onClick={addWorkingHourRow}>
                            <Plus className="w-4 h-4 mr-1" />
                            Add Row
                          </Button>
                        </div>
                        {(contactForm.working_hours || []).length === 0 ? (
                          <p className="text-xs text-muted-foreground">No working hours added yet.</p>
                        ) : (
                          <div className="space-y-2">
                            {(contactForm.working_hours || []).map((row, index) => (
                              <div key={index} className="grid grid-cols-1 sm:grid-cols-[1fr_1fr_auto] gap-2 items-end">
                                <div>
                                  <Label className="text-xs">Label</Label>
                                  <Input
                                    value={row.label || ""}
                                    onChange={(e) => updateWorkingHourRow(index, "label", e.target.value)}
                                    placeholder="Monday to Friday"
                                    className="mt-1"
                                  />
                                </div>
                                <div>
                                  <Label className="text-xs">Time</Label>
                                  <Input
                                    value={row.time || ""}
                                    onChange={(e) => updateWorkingHourRow(index, "time", e.target.value)}
                                    placeholder="9:00 AM to 8:00 PM"
                                    className="mt-1"
                                  />
                                </div>
                                <Button
                                  type="button"
                                  variant="ghost"
                                  size="icon"
                                  className="text-destructive shrink-0"
                                  onClick={() => removeWorkingHourRow(index)}
                                  title="Remove row"
                                >
                                  <Trash2 className="w-4 h-4" />
                                </Button>
                              </div>
                            ))}
                          </div>
                        )}
                      </div>
                      <div className="md:col-span-2">
                        <Button type="submit" size="sm" disabled={updateMutation.isPending}>
                          {updateMutation.isPending ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : <Save className="w-4 h-4 mr-2" />}
                          Save Contact Us
                        </Button>
                      </div>
                    </form>
                  </EditorCard>
                }
                preview={
                  <LivePreviewCard>
                    <h2 className="text-xl font-bold text-foreground leading-tight">{contactForm.storeName || "Store Name"}</h2>
                    <p className="text-xs text-muted-foreground mt-0.5">Get in touch with us</p>
                    <div className="mt-3 grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div className="space-y-3">
                        {contactForm.address && (
                          <div className="flex gap-2 text-sm text-foreground/80">
                            <MapPin className="w-4 h-4 text-primary shrink-0 mt-0.5" />
                            <div>
                              <p className="font-semibold text-foreground text-xs">Address</p>
                              <p className="text-sm">{contactForm.address}</p>
                            </div>
                          </div>
                        )}
                        {contactForm.email && (
                          <div className="flex gap-2 text-sm text-foreground/80">
                            <Mail className="w-4 h-4 text-primary shrink-0 mt-0.5" />
                            <div>
                              <p className="font-semibold text-foreground text-xs">Email</p>
                              <p className="text-sm">{contactForm.email}</p>
                            </div>
                          </div>
                        )}
                        {(contactForm.mobile || contactForm.alternateMobile) && (
                          <div className="flex gap-2 text-sm text-foreground/80">
                            <Phone className="w-4 h-4 text-primary shrink-0 mt-0.5" />
                            <div>
                              <p className="font-semibold text-foreground text-xs">Phone</p>
                              <p className="text-sm">
                                {contactForm.mobile}
                                {contactForm.alternateMobile ? ` / ${contactForm.alternateMobile}` : ""}
                              </p>
                            </div>
                          </div>
                        )}
                        {contactForm.whatsappNumber && (
                          <div className="flex gap-2 text-sm text-foreground/80">
                            <Phone className="w-4 h-4 text-green-500 shrink-0 mt-0.5" />
                            <div>
                              <p className="font-semibold text-foreground text-xs">WhatsApp</p>
                              <p className="text-sm">{contactForm.whatsappNumber}</p>
                            </div>
                          </div>
                        )}
                        {(contactForm.working_hours || []).length > 0 && (
                          <div className="flex gap-2 text-sm text-foreground/80">
                            <Clock className="w-4 h-4 text-primary shrink-0 mt-0.5" />
                            <div>
                              <p className="font-semibold text-foreground text-xs">Working Hours</p>
                              <ul className="text-sm space-y-1 mt-1">
                                {contactForm.working_hours.map((row, index) => (
                                  <li key={index}>
                                    <span className="font-medium">{row.label || "Hours"}:</span>{" "}
                                    {row.time || "—"}
                                  </li>
                                ))}
                              </ul>
                            </div>
                          </div>
                        )}
                        {!contactForm.address && !contactForm.email && !contactForm.mobile && !contactForm.alternateMobile && !contactForm.whatsappNumber && !(contactForm.working_hours || []).length && (
                          <p className="text-sm text-muted-foreground">Fill in contact details to preview them here.</p>
                        )}
                      </div>
                      <div className="min-h-[280px] md:min-h-[320px]">
                        {(() => {
                          const embedUrl = toGoogleMapsEmbedUrl(contactForm.googleMapsUrl);
                          if (embedUrl) {
                            return (
                              <iframe
                                title="Google Map"
                                src={embedUrl}
                                className="w-full h-full min-h-[280px] md:min-h-[320px] rounded-lg border border-border"
                                loading="lazy"
                                referrerPolicy="no-referrer-when-downgrade"
                                allowFullScreen
                              />
                            );
                          }
                          if (contactForm.googleMapsUrl) {
                            return (
                              <div className="min-h-[280px] rounded-lg border border-border bg-muted flex flex-col items-center justify-center gap-2 px-3 text-center">
                                <MapPin className="w-6 h-6 text-muted-foreground" />
                                <p className="text-xs text-muted-foreground">This map link cannot be embedded.</p>
                                <a href={contactForm.googleMapsUrl} target="_blank" rel="noreferrer" className="text-xs text-primary underline">Open in Google Maps</a>
                              </div>
                            );
                          }
                          return (
                            <div className="min-h-[280px] rounded-lg border border-dashed border-border bg-muted/50 flex flex-col items-center justify-center gap-2 px-3 text-center">
                              <MapPin className="w-6 h-6 text-muted-foreground/60" />
                              <p className="text-xs text-muted-foreground">Add a Google Maps URL to display the map.</p>
                            </div>
                          );
                        })()}
                      </div>
                    </div>
                  </LivePreviewCard>
                }
              />
            </TabsContent>

            {/* ════ PRIVACY POLICY TAB ════ */}
            <TabsContent value="privacy-policy">
              <EditorPreviewLayout
                editor={
                  <EditorCard title="Privacy Policy Editor">
                    <form onSubmit={(e) => { e.preventDefault(); handleSavePolicy("privacy-policy", privacyForm); }} className="space-y-3">
                      <div>
                        <Label htmlFor="privacy-title">Title</Label>
                        <Input id="privacy-title" className="mt-1" value={privacyForm.title} onChange={(e) => setPrivacyForm({ ...privacyForm, title: e.target.value })} placeholder="Privacy Policy" />
                      </div>
                      <div>
                        <Label>Content (Rich Text)</Label>
                        <div className="rich-editor-wrapper mt-1">
                          <ReactQuill theme="snow" value={privacyForm.content} onChange={(content) => setPrivacyForm({ ...privacyForm, content })} modules={quillModules} formats={quillFormats} />
                        </div>
                      </div>
                      <Button type="submit" size="sm" disabled={updateMutation.isPending}>
                        {updateMutation.isPending ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : <Save className="w-4 h-4 mr-2" />}
                        Save Privacy Policy
                      </Button>
                    </form>
                  </EditorCard>
                }
                preview={
                  <LivePreviewCard>
                    <PolicyPreview title={privacyForm.title} content={privacyForm.content} fallbackTitle="Privacy Policy" />
                  </LivePreviewCard>
                }
              />
            </TabsContent>

            {/* ════ TERMS & CONDITIONS TAB ════ */}
            <TabsContent value="terms-conditions">
              <EditorPreviewLayout
                editor={
                  <EditorCard title="Terms & Conditions Editor">
                    <form onSubmit={(e) => { e.preventDefault(); handleSavePolicy("terms-conditions", termsForm); }} className="space-y-3">
                      <div>
                        <Label htmlFor="terms-title">Title</Label>
                        <Input id="terms-title" className="mt-1" value={termsForm.title} onChange={(e) => setTermsForm({ ...termsForm, title: e.target.value })} placeholder="Terms & Conditions" />
                      </div>
                      <div>
                        <Label>Content (Rich Text)</Label>
                        <div className="rich-editor-wrapper mt-1">
                          <ReactQuill theme="snow" value={termsForm.content} onChange={(content) => setTermsForm({ ...termsForm, content })} modules={quillModules} formats={quillFormats} />
                        </div>
                      </div>
                      <Button type="submit" size="sm" disabled={updateMutation.isPending}>
                        {updateMutation.isPending ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : <Save className="w-4 h-4 mr-2" />}
                        Save Terms
                      </Button>
                    </form>
                  </EditorCard>
                }
                preview={
                  <LivePreviewCard>
                    <PolicyPreview title={termsForm.title} content={termsForm.content} fallbackTitle="Terms & Conditions" />
                  </LivePreviewCard>
                }
              />
            </TabsContent>

            {/* ════ SHIPPING POLICY TAB ════ */}
            <TabsContent value="shipping-policy">
              <EditorPreviewLayout
                editor={
                  <EditorCard title="Shipping Policy Editor">
                    <form onSubmit={(e) => { e.preventDefault(); handleSavePolicy("shipping-policy", shippingForm); }} className="space-y-3">
                      <div>
                        <Label htmlFor="shipping-title">Title</Label>
                        <Input id="shipping-title" className="mt-1" value={shippingForm.title} onChange={(e) => setShippingForm({ ...shippingForm, title: e.target.value })} placeholder="Shipping Policy" />
                      </div>
                      <div>
                        <Label>Content (Rich Text)</Label>
                        <div className="rich-editor-wrapper mt-1">
                          <ReactQuill theme="snow" value={shippingForm.content} onChange={(content) => setShippingForm({ ...shippingForm, content })} modules={quillModules} formats={quillFormats} />
                        </div>
                      </div>
                      <Button type="submit" size="sm" disabled={updateMutation.isPending}>
                        {updateMutation.isPending ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : <Save className="w-4 h-4 mr-2" />}
                        Save Shipping Policy
                      </Button>
                    </form>
                  </EditorCard>
                }
                preview={
                  <LivePreviewCard>
                    <PolicyPreview title={shippingForm.title} content={shippingForm.content} fallbackTitle="Shipping Policy" />
                  </LivePreviewCard>
                }
              />
            </TabsContent>

            {/* ════ REFUND POLICY TAB ════ */}
            <TabsContent value="refund-policy">
              <EditorPreviewLayout
                editor={
                  <EditorCard title="Refund Policy Editor">
                    <form onSubmit={(e) => { e.preventDefault(); handleSavePolicy("refund-policy", refundForm); }} className="space-y-3">
                      <div>
                        <Label htmlFor="refund-title">Title</Label>
                        <Input id="refund-title" className="mt-1" value={refundForm.title} onChange={(e) => setRefundForm({ ...refundForm, title: e.target.value })} placeholder="Refund Policy" />
                      </div>
                      <div>
                        <Label>Content (Rich Text)</Label>
                        <div className="rich-editor-wrapper mt-1">
                          <ReactQuill theme="snow" value={refundForm.content} onChange={(content) => setRefundForm({ ...refundForm, content })} modules={quillModules} formats={quillFormats} />
                        </div>
                      </div>
                      <Button type="submit" size="sm" disabled={updateMutation.isPending}>
                        {updateMutation.isPending ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : <Save className="w-4 h-4 mr-2" />}
                        Save Refund Policy
                      </Button>
                    </form>
                  </EditorCard>
                }
                preview={
                  <LivePreviewCard>
                    <PolicyPreview title={refundForm.title} content={refundForm.content} fallbackTitle="Refund Policy" />
                  </LivePreviewCard>
                }
              />
            </TabsContent>
          </>
        )}
      </Tabs>
    </div>
  );
}
