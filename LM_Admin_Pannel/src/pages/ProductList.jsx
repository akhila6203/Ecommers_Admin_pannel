import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Pencil, Trash2, Loader2, AlertCircle, Star, ExternalLink, Search } from "lucide-react";
import { toast } from "sonner";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import PageQueryState, { TableSkeleton } from "@/components/PageQueryState";
import { DataTable } from "@/components/DataTable";
import { Button } from "@/components/ui/button";
import { getProducts, updateProduct, deleteProduct, toggleFeatured } from "@/services/productService";
import { getCategoryHierarchy } from "@/services/categoryService";
import { resolveUploadUrl } from "@/utils/imageUrl";

const inputClass = "w-full h-10 px-3 rounded-lg bg-secondary border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 transition";
const labelClass = "text-sm font-medium text-foreground mb-1.5 block";

export default function ProductList() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [page, setPage] = useState(1);
  const [pageSize] = useState(20);
  const [editing, setEditing] = useState(null);
  const [editForm, setEditForm] = useState({});

  const { data: productsResponse, isLoading, error, refetch } = useQuery({
    queryKey: ["products", page, pageSize],
    queryFn: () => getProducts({ page, limit: pageSize }),
  });

  const products = productsResponse?.data || [];
  const pagination = productsResponse?.pagination;

  const { data: hierarchyResponse } = useQuery({
    queryKey: ["categoryHierarchy"],
    queryFn: () => getCategoryHierarchy(),
  });
  const categories = hierarchyResponse?.data || [];

  // Derive subs/childs for the selected main category in edit mode
  const selectedMain = editForm.category_id
    ? categories.find((c) => c.id === Number(editForm.category_id))
    : null;
  const editSubs = selectedMain?.sub_categories || [];
  const selectedSub = editForm.sub_category_id
    ? editSubs.find((s) => s.id === Number(editForm.sub_category_id))
    : null;
  const editChilds = selectedSub?.child_categories || [];

  // Delete mutation
  const deleteMutation = useMutation({
    mutationFn: (id) => deleteProduct(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["products"] });
      toast.success("Product deleted.");
    },
    onError: (err) => {
      toast.error(err.response?.data?.message || err.message || "Failed to delete product");
    },
  });

  // Toggle featured mutation
  const featuredMutation = useMutation({
    mutationFn: (id) => toggleFeatured(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["products"] });
      toast.success("Featured status toggled");
    },
    onError: (err) => {
      toast.error(err.response?.data?.message || err.message || "Failed to toggle featured");
    },
  });

  const handleDelete = (id) => {
    if (window.confirm("Delete this product?")) {
      deleteMutation.mutate(id);
    }
  };

  const handleEdit = (product) => {
    setEditing(product.id);
    setEditForm({
      name: product.name || "",
      category_id: product.category_id || "",
      sub_category_id: product.sub_category_id || "",
      child_category_id: product.child_category_id || "",
      brand: product.brand || "",
      material: product.material || "",
      price: product.price || "",
      offer_price: product.offer_price || "",
      discount_percentage: product.discount_percentage || 0,
      size: product.size || "",
      fabric: product.fabric || "",
      occasion: product.occasion || "",
      stock: product.stock || "",
      short_description: product.short_description || "",
      long_description: product.long_description || "",
      status: product.status || "active",
      is_featured: Boolean(product.is_featured),
      is_trending: Boolean(product.is_trending),
      is_best_seller: Boolean(product.is_best_seller),
    });
  };

  const handleMainChange = (id) => {
    setEditForm((f) => ({ ...f, category_id: id, sub_category_id: "", child_category_id: "" }));
  };

  const handleSubChange = (id) => {
    setEditForm((f) => ({ ...f, sub_category_id: id, child_category_id: "" }));
  };

  const handleEditChange = (e) => {
    const { name, value, type, checked } = e.target;
    setEditForm((f) => {
      const updated = { ...f, [name]: type === "checkbox" ? checked : value };
      if (name === "price" || name === "offer_price") {
        const price = parseFloat(name === "price" ? value : f.price);
        const offer = parseFloat(name === "offer_price" ? value : f.offer_price);
        if (price > 0 && offer > 0 && offer < price) {
          updated.discount_percentage = Math.round(((price - offer) / price) * 100);
        }
      }
      return updated;
    });
  };

  // Update mutation
  const updateMutation = useMutation({
    mutationFn: ({ id, data }) => updateProduct(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["products"] });
      setEditing(null);
      toast.success("Product updated.");
    },
    onError: (err) => {
      toast.error(err.response?.data?.message || err.message || "Failed to update product");
    },
  });

  const handleSaveEdit = () => {
    if (!editForm.name || !editForm.category_id || !editForm.price) {
      toast.error("Please fill required fields.");
      return;
    }
    const payload = new FormData();
    payload.append("name", editForm.name);
    payload.append("category_id", editForm.category_id);
    payload.append("sub_category_id", editForm.sub_category_id || "");
    payload.append("child_category_id", editForm.child_category_id || "");
    payload.append("brand", editForm.brand || "");
    payload.append("material", editForm.material || "");
    payload.append("price", String(editForm.price));
    payload.append("offer_price", String(editForm.offer_price || editForm.price));
    payload.append("stock", String(editForm.stock || 0));
    payload.append("size", editForm.size || "");
    payload.append("fabric", editForm.fabric || "");
    payload.append("occasion", editForm.occasion || "");
    payload.append("short_description", editForm.short_description || "");
    payload.append("long_description", editForm.long_description || "");
    payload.append("status", editForm.status || "active");
    payload.append("is_featured", editForm.is_featured ? "1" : "0");
    payload.append("is_trending", editForm.is_trending ? "1" : "0");
    payload.append("is_best_seller", editForm.is_best_seller ? "1" : "0");

    if (editForm._newImages) {
      for (let i = 0; i < editForm._newImages.length; i++) {
        payload.append("images", editForm._newImages[i]);
      }
    }

    updateMutation.mutate({ id: editing, data: payload });
  };

  const statusBadge = (status) => (
    <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${
      status === "active" || status === "Active"
        ? "bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400"
        : status === "inactive" || status === "Inactive"
        ? "bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400"
        : "bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-400"
    }`}>
      {status?.charAt(0).toUpperCase() + status?.slice(1) || "—"}
    </span>
  );

  const getImageSrc = (product) => {
    const thumbFromImages = product.images?.find((img) => img.image_type === "thumbnail")?.image;
    const fallbackImage = product.images?.[0]?.image;
    const imagePath = thumbFromImages || product.thumbnail || fallbackImage;
    if (imagePath) {
      return resolveUploadUrl(imagePath, "products");
    }
    return null;
  };

  if (isLoading) {
    return <TableSkeleton rows={8} cols={6} />;
  }

  if (error) {
    return (
      <div className="flex flex-col items-center justify-center h-[60vh] gap-3">
        <AlertCircle className="w-8 h-8 text-destructive" />
        <p className="text-sm text-destructive">Failed to load products.</p>
        <Button variant="outline" onClick={() => refetch()}>Retry</Button>
      </div>
    );
  }

  return (
    <div className="p-6 max-w-[1600px] mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-heading font-bold text-foreground">Product List</h1>
          <p className="text-sm text-muted-foreground mt-1">
            {pagination?.total ?? products.length} products
            {pagination ? ` · Page ${pagination.page} of ${pagination.totalPages}` : ""}
          </p>
        </div>
      </div>

      <DataTable
        columns={[
          {
            key: "image", label: "Image",
            render: (r) => {
              const src = getImageSrc(r);
              return src ? (
                <img src={src} alt={r.name} className="w-10 h-10 rounded-md object-cover border border-border" />
              ) : (
                <div className="w-10 h-10 rounded-md bg-secondary flex items-center justify-center text-[10px] text-muted-foreground">N/A</div>
              );
            },
          },
          { key: "name", label: "Product Name" },
          {
            key: "category", label: "Category",
            render: (r) => [r.category_name, r.sub_category_name, r.child_category_name].filter(Boolean).join(" › "),
          },
          { key: "brand", label: "Brand", render: (r) => r.brand || "—" },
          { key: "price", label: "Price", render: (r) => `₹${Number(r.price)?.toLocaleString()}` },
          { key: "offer_price", label: "Offer", render: (r) => r.offer_price ? `₹${Number(r.offer_price)?.toLocaleString()}` : "—" },
          { key: "discount_percentage", label: "Disc %", render: (r) => r.discount_percentage ? `${r.discount_percentage}%` : "—" },
          { key: "fabric", label: "Fabric", render: (r) => r.fabric || "—" },
          { key: "stock", label: "Stock" },
          {
            key: "is_featured", label: "Featured",
            render: (r) => (
              <button
                onClick={() => featuredMutation.mutate(r.id)}
                disabled={featuredMutation.isPending}
                className={`p-1 rounded-md transition ${
                  r.is_featured ? "text-yellow-500 hover:text-yellow-600" : "text-muted-foreground hover:text-yellow-500"
                }`}
                title={r.is_featured ? "Remove from featured" : "Mark as featured"}
              >
                <Star className={`w-4 h-4 ${r.is_featured ? "fill-current" : ""}`} />
              </button>
            ),
          },
          { key: "status", label: "Status", render: (r) => statusBadge(r.status) },
          {
            key: "actions", label: "Actions",
            render: (r) => (
              <div className="flex items-center gap-1">
                <button onClick={() => navigate(`/products/edit/${r.id}`)} className="w-7 h-7 rounded-md flex items-center justify-center text-primary hover:bg-primary/10 transition" title="Edit full product">
                  <Pencil className="w-3.5 h-3.5" />
                </button>
                <button
                  onClick={() => handleDelete(r.id)}
                  disabled={deleteMutation.isPending}
                  className="w-7 h-7 rounded-md flex items-center justify-center text-destructive hover:bg-destructive/10 transition"
                  title="Delete product"
                >
                  <Trash2 className="w-3.5 h-3.5" />
                </button>
                <button
                  onClick={() => navigate(`/products/${r.id}/seo`)}
                  className="w-7 h-7 rounded-md flex items-center justify-center text-muted-foreground hover:text-primary hover:bg-primary/10 transition"
                  title="Edit SEO"
                >
                  <Search className="w-3.5 h-3.5" />
                </button>
              </div>
            ),
          },
        ]}
        data={products}
        searchPlaceholder="Search products..."
        itemLabel="products"
        paginate={false}
      />

      {pagination && pagination.totalPages > 1 && (
        <div className="flex justify-center gap-2">
          <Button variant="outline" disabled={page <= 1} onClick={() => setPage((p) => p - 1)}>Previous</Button>
          <span className="text-sm text-muted-foreground self-center">
            Page {pagination.page} of {pagination.totalPages} ({pagination.total} total)
          </span>
          <Button variant="outline" disabled={page >= pagination.totalPages} onClick={() => setPage((p) => p + 1)}>Next</Button>
        </div>
      )}

      {/* Inline Edit Modal */}
      {editing && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm p-4">
          <div className="bg-card rounded-xl border border-border p-6 w-full max-w-2xl space-y-4 max-h-[90vh] overflow-y-auto">
            <h3 className="font-heading font-semibold text-lg">Edit Product</h3>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="sm:col-span-2">
                <label className={labelClass}>Product Name *</label>
                <input name="name" value={editForm.name || ""} onChange={handleEditChange} className={inputClass} required />
              </div>

              <div>
                <label className={labelClass}>Main Category *</label>
                <select value={editForm.category_id || ""} onChange={(e) => handleMainChange(e.target.value)} className={inputClass} required>
                  <option value="">Select main category</option>
                  {categories.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
                </select>
              </div>

              <div>
                <label className={labelClass}>Sub Category</label>
                <select value={editForm.sub_category_id || ""} onChange={(e) => handleSubChange(e.target.value)} className={inputClass} disabled={!editForm.category_id}>
                  <option value="">Select sub category</option>
                  {editSubs.map((s) => <option key={s.id} value={s.id}>{s.name}</option>)}
                </select>
              </div>

              <div>
                <label className={labelClass}>Child Category</label>
                <select name="child_category_id" value={editForm.child_category_id || ""} onChange={handleEditChange} className={inputClass} disabled={!editForm.sub_category_id}>
                  <option value="">Select child category</option>
                  {editChilds.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
                </select>
              </div>

              <div>
                <label className={labelClass}>Brand</label>
                <input name="brand" value={editForm.brand || ""} onChange={handleEditChange} className={inputClass} placeholder="Brand name" />
              </div>

              <div>
                <label className={labelClass}>Material</label>
                <input name="material" value={editForm.material || ""} onChange={handleEditChange} className={inputClass} placeholder="Material type" />
              </div>

              <div>
                <label className={labelClass}>Price (₹) *</label>
                <input name="price" type="number" value={editForm.price || ""} onChange={handleEditChange} className={inputClass} required />
              </div>

              <div>
                <label className={labelClass}>Offer Price (₹)</label>
                <input name="offer_price" type="number" value={editForm.offer_price || ""} onChange={handleEditChange} className={inputClass} />
              </div>

              <div>
                <label className={labelClass}>Discount %</label>
                <input name="discount_percentage" type="number" value={editForm.discount_percentage || ""} onChange={handleEditChange} className={inputClass} readOnly />
              </div>

              <div>
                <label className={labelClass}>Size</label>
                <input name="size" value={editForm.size || ""} onChange={handleEditChange} className={inputClass} />
              </div>

              <div>
                <label className={labelClass}>Fabric</label>
                <input name="fabric" value={editForm.fabric || ""} onChange={handleEditChange} className={inputClass} />
              </div>

              <div>
                <label className={labelClass}>Occasion</label>
                <input name="occasion" value={editForm.occasion || ""} onChange={handleEditChange} className={inputClass} />
              </div>

              <div>
                <label className={labelClass}>Stock</label>
                <input name="stock" type="number" value={editForm.stock || ""} onChange={handleEditChange} className={inputClass} />
              </div>

              <div className="sm:col-span-2">
                <label className={labelClass}>Short Description</label>
                <textarea name="short_description" value={editForm.short_description || ""} onChange={handleEditChange} rows={2} className={`${inputClass} h-auto py-2`} />
              </div>

              <div className="sm:col-span-2">
                <label className={labelClass}>Full Description</label>
                <textarea name="long_description" value={editForm.long_description || ""} onChange={handleEditChange} rows={3} className={`${inputClass} h-auto py-2`} />
              </div>

              <div className="sm:col-span-2">
                <label className={labelClass}>Product Images</label>
                <input
                  type="file"
                  multiple
                  accept="image/*"
                  onChange={(e) => {
                    const files = e.target.files;
                    if (files) {
                      setEditForm((f) => ({ ...f, _newImages: files }));
                    }
                  }}
                  className={`${inputClass} py-1.5`}
                />
                <p className="text-xs text-muted-foreground mt-1">Select new images to replace or add to existing gallery</p>
              </div>

              <div className="sm:col-span-2">
                <label className={labelClass}>Status</label>
                <select name="status" value={editForm.status || "active"} onChange={handleEditChange} className={inputClass}>
                  <option value="active">Active</option>
                  <option value="inactive">Inactive</option>
                  <option value="draft">Draft</option>
                </select>
              </div>

              {/* Toggles */}
              <div className="sm:col-span-2 flex gap-6">
                <label className="flex items-center gap-2 text-sm">
                  <input type="checkbox" name="is_featured" checked={editForm.is_featured} onChange={handleEditChange} />
                  Featured
                </label>
                <label className="flex items-center gap-2 text-sm">
                  <input type="checkbox" name="is_trending" checked={editForm.is_trending} onChange={handleEditChange} />
                  Trending
                </label>
                <label className="flex items-center gap-2 text-sm">
                  <input type="checkbox" name="is_best_seller" checked={editForm.is_best_seller} onChange={handleEditChange} />
                  Best Seller
                </label>
              </div>
            </div>
            <div className="flex gap-3 pt-2">
              <button
                onClick={handleSaveEdit}
                disabled={updateMutation.isPending}
                className="h-10 px-5 rounded-lg bg-primary text-primary-foreground text-sm font-medium disabled:opacity-50"
              >
                {updateMutation.isPending ? "Saving..." : "Save"}
              </button>
              <button onClick={() => setEditing(null)} className="h-10 px-5 rounded-lg bg-secondary text-sm font-medium">Cancel</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
