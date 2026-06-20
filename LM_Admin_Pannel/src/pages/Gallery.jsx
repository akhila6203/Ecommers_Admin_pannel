import { useState } from "react";
import { Pencil, Trash2, Plus, X, Loader2 } from "lucide-react";
import { toast } from "sonner";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getBanners, createBanner, updateBanner, deleteBanner } from "@/services/bannerService";
import { resolveUploadUrl, PLACEHOLDER } from "@/utils/imageUrl";

const emptyForm = {
  title: "",
};

export default function Gallery() {
  const queryClient = useQueryClient();

  const getImageUrl = (imagePath) => resolveUploadUrl(imagePath, "banners");

  const { data: bannersResponse, isLoading, error, refetch } = useQuery({
    queryKey: ["banners"],
    queryFn: () => getBanners(),
  });
  const banners = bannersResponse?.data || [];

  const invalidate = () => queryClient.invalidateQueries({ queryKey: ["banners"] });

  const addMutation = useMutation({
    mutationFn: (data) => createBanner(data),
    onSuccess: () => { invalidate(); toast.success("Banner added."); },
    onError: (err) => toast.error(err.response?.data?.message || err.message),
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }) => updateBanner(id, data),
    onSuccess: () => { invalidate(); toast.success("Banner updated."); },
    onError: (err) => toast.error(err.response?.data?.message || err.message),
  });

  const deleteMutation = useMutation({
    mutationFn: (id) => deleteBanner(id),
    onSuccess: () => { invalidate(); toast.success("Banner deleted."); },
    onError: (err) => toast.error(err.response?.data?.message || err.message),
  });

  const [form, setForm] = useState(emptyForm);
  const [imageFile, setImageFile] = useState(null);
  const [previewUrl, setPreviewUrl] = useState(null);
  const [editing, setEditing] = useState(null);
  const [openModal, setOpenModal] = useState(false);

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!form.title.trim()) {
      return toast.error("Enter banner title.");
    }

    if (!editing && !imageFile) {
      return toast.error("Please select an image file.");
    }

    const payload = new FormData();
    payload.append("title", form.title);
    if (imageFile) {
      payload.append("image", imageFile);
    }

    if (editing) {
      updateMutation.mutate({ id: editing, data: payload });
      setEditing(null);
    } else {
      addMutation.mutate(payload);
    }

    setForm(emptyForm);
    setImageFile(null);
    setPreviewUrl(null);
    setOpenModal(false);
  };

  const handleImageChange = (e) => {
    const file = e.target.files?.[0] || null;
    setImageFile(file);
    if (file) {
      setPreviewUrl(URL.createObjectURL(file));
    } else {
      setPreviewUrl(null);
    }
  };

  const handleAddClick = () => {
    setEditing(null);
    setForm(emptyForm);
    setImageFile(null);
    setPreviewUrl(null);
    setOpenModal(true);
  };

  const handleEdit = (banner) => {
    setEditing(banner.id);
    setForm({
      title: banner.title || "",
    });
    setImageFile(null);
    setPreviewUrl(getImageUrl(banner.image));
    setOpenModal(true);
  };

  const handleDelete = (id) => {
    if (window.confirm("Delete this banner?")) {
      deleteMutation.mutate(id);
    }
  };

  const closeModal = () => {
    setOpenModal(false);
    setEditing(null);
    setForm(emptyForm);
    setImageFile(null);
    setPreviewUrl(null);
  };

  const inputClass =
    "h-10 px-3 rounded-lg bg-secondary border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30";

  if (isLoading) {
    return (
      <div className="p-6 max-w-[1100px] mx-auto flex items-center justify-center min-h-[300px]">
        <Loader2 className="w-8 h-8 animate-spin text-primary" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="p-6 max-w-[1100px] mx-auto flex items-center justify-center min-h-[300px] gap-2 text-destructive">
        <span>Failed to load banners. Please try again.</span>
      </div>
    );
  }

  return (
    <div className="p-6 max-w-[1100px] mx-auto space-y-6">
      {/* Header */}
      <div className="flex items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl font-heading font-bold text-foreground">
            Banners
          </h1>
          <p className="text-sm text-muted-foreground mt-1">
            Manage homepage banners and promotional images
          </p>
        </div>

        <button
          onClick={handleAddClick}
          className="h-10 px-5 rounded-lg bg-primary text-primary-foreground text-sm font-medium flex items-center gap-2"
        >
          <Plus className="w-4 h-4" />
          Add Banner
        </button>
      </div>

      {/* Banner Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {banners.length > 0 ? (
          banners.map((banner) => (
            <div
              key={banner.id}
              className="bg-card rounded-xl border border-border overflow-hidden group"
            >
              <div className="h-40 overflow-hidden bg-muted flex items-center justify-center">
                <img
                  src={getImageUrl(banner.image)}
                  alt={banner.title}
                  onError={(e) => {
                    e.target.src = PLACEHOLDER;
                  }}
                  className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                />
              </div>

              <div className="p-4">
                <h3 className="font-semibold text-foreground">
                  {banner.title}
                </h3>

                <div className="flex gap-2 mt-3">
                  <button
                    onClick={() => handleEdit(banner)}
                    className="h-8 px-3 rounded-lg text-xs font-medium text-primary bg-primary/10 hover:bg-primary/20 flex items-center gap-1"
                  >
                    <Pencil className="w-3.5 h-3.5" />
                    Edit
                  </button>

                  <button
                    onClick={() => handleDelete(banner.id)}
                    className="h-8 px-3 rounded-lg text-xs font-medium text-destructive bg-destructive/10 hover:bg-destructive/20 flex items-center gap-1"
                  >
                    <Trash2 className="w-3.5 h-3.5" />
                    Delete
                  </button>
                </div>
              </div>
            </div>
          ))
        ) : (
          <div className="md:col-span-2 bg-card border border-border rounded-xl p-8 text-center">
            <p className="text-sm text-muted-foreground">
              No banners added yet.
            </p>
          </div>
        )}
      </div>

      {/* Modal Popup */}
      {openModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-4">
          <div className="w-full max-w-[650px] bg-card rounded-2xl border border-border shadow-xl">
            
            <div className="flex items-center justify-between px-5 py-4 border-b border-border">
              <h2 className="text-lg font-semibold text-foreground">
                {editing ? "Update Banner" : "Add Banner"}
              </h2>

              <button
                onClick={closeModal}
                className="w-8 h-8 rounded-lg bg-secondary flex items-center justify-center hover:bg-secondary/80"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            
            <form
              onSubmit={handleSubmit}
              className="p-5 grid grid-cols-1 sm:grid-cols-2 gap-4"
            >
              <div>
                <label className="text-sm font-medium block mb-1">
                  Banner Title *
                </label>
                <input
                  value={form.title}
                  onChange={(e) =>
                    setForm({ ...form, title: e.target.value })
                  }
                  className={`w-full ${inputClass}`}
                  placeholder="Enter banner title"
                />
              </div>

              <div className="sm:col-span-2">
                <label className="text-sm font-medium block mb-1">
                  Banner Image *
                </label>
                <div className="space-y-3">
                  <div className="flex items-center gap-3">
                    <input
                      type="file"
                      accept="image/*"
                      onChange={handleImageChange}
                      className="text-sm"
                    />
                    {editing && !imageFile && (
                      <span className="text-xs text-muted-foreground">
                        Existing image will be kept if you don’t upload a new one
                      </span>
                    )}
                  </div>
                  {previewUrl && (
                    <div className="relative w-40 h-24 border border-border rounded-lg overflow-hidden bg-muted">
                      <img
                        src={previewUrl}
                        alt="Preview"
                        className="w-full h-full object-cover"
                      />
                      <button
                        type="button"
                        onClick={() => {
                          setImageFile(null);
                          setPreviewUrl(editing ? getImageUrl(banners.find((b) => b.id === editing)?.image) : null);
                        }}
                        className="absolute top-1 right-1 bg-background/80 hover:bg-background rounded-full p-1 shadow"
                      >
                        <X className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  )}
                </div>
              </div>

              <div className="sm:col-span-2 flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={closeModal}
                  className="h-10 px-4 rounded-lg bg-secondary text-sm"
                >
                  Cancel
                </button>

                <button
                  type="submit"
                  className="h-10 px-5 rounded-lg bg-primary text-primary-foreground text-sm font-medium flex items-center gap-2"
                >
                  <Plus className="w-4 h-4" />
                  {editing ? "Update Banner" : "Add Banner"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
