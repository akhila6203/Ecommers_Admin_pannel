import { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import { Pencil, Trash2, Plus, ChevronRight, ChevronDown, Loader2, AlertCircle, X } from "lucide-react";
import { toast } from "sonner";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getCategoryHierarchy, createCategory, createSubCategory, createChildCategory, updateCategory, updateSubCategory, updateChildCategory, deleteCategory, deleteSubCategory, deleteChildCategory } from "@/services/categoryService";
import { resolveUploadUrl, PLACEHOLDER } from "@/utils/imageUrl";
import { motion, AnimatePresence } from "framer-motion";

export default function Categories() {
  const { type } = useParams();
  const activeTab = type || "main";
  const queryClient = useQueryClient();

  const [newName, setNewName] = useState("");
  const [imageFile, setImageFile] = useState(null);
  const [imagePreview, setImagePreview] = useState(null);
  const [editImageFile, setEditImageFile] = useState(null);
  const [editImagePreview, setEditImagePreview] = useState(null);
  const [selectedMain, setSelectedMain] = useState("");
  const [selectedSub, setSelectedSub] = useState("");
  const [editingId, setEditingId] = useState(null);
  const [editName, setEditName] = useState("");
  const [expandedMains, setExpandedMains] = useState({});
  const [expandedSubs, setExpandedSubs] = useState({});

  const getCategoryImageUrl = (item) => resolveUploadUrl(item?.image_url || item?.image, "categories");

  const buildCategoryFormData = (fields, file) => {
    const formData = new FormData();
    Object.entries(fields).forEach(([key, value]) => {
      if (value !== undefined && value !== null) formData.append(key, value);
    });
    if (file) formData.append("image", file);
    return formData;
  };

  const clearAddImage = () => {
    setImageFile(null);
    setImagePreview(null);
  };

  const clearEditImage = () => {
    setEditImageFile(null);
    setEditImagePreview(null);
  };

  const handleAddImageChange = (e) => {
    const file = e.target.files?.[0] || null;
    setImageFile(file);
    setImagePreview(file ? URL.createObjectURL(file) : null);
  };

  const handleEditImageChange = (e) => {
    const file = e.target.files?.[0] || null;
    setEditImageFile(file);
    setEditImagePreview(file ? URL.createObjectURL(file) : null);
  };

  const CategoryThumb = ({ item, className = "w-8 h-8" }) => (
    <img
      src={getCategoryImageUrl(item)}
      alt={item?.name || "Category"}
      onError={(e) => { e.target.src = PLACEHOLDER; }}
      className={`${className} rounded object-cover border border-border shrink-0`}
    />
  );

  const getErrorMessage = (err) => err.response?.data?.message || err.message || "Something went wrong";

  const { data: hierarchyResponse, isLoading, error } = useQuery({
    queryKey: ["category-hierarchy"],
    queryFn: getCategoryHierarchy,
  });
  const categories = hierarchyResponse?.data || [];

  const invalidate = () => queryClient.invalidateQueries({ queryKey: ["category-hierarchy"] });

  const addMainMutation = useMutation({
    mutationFn: ({ name, file }) => createCategory(buildCategoryFormData({ name }, file)),
    onSuccess: () => { invalidate(); toast.success("Main category added."); clearAddImage(); },
    onError: (err) => toast.error(getErrorMessage(err)),
  });

  const addSubMutation = useMutation({
    mutationFn: ({ mainId, name, file }) => createSubCategory(buildCategoryFormData({ main_category_id: mainId, name }, file)),
    onSuccess: () => { invalidate(); toast.success("Sub category added."); clearAddImage(); },
    onError: (err) => toast.error(getErrorMessage(err)),
  });

  const addChildMutation = useMutation({
    mutationFn: ({ subId, name, file }) => createChildCategory(buildCategoryFormData({ sub_category_id: subId, name }, file)),
    onSuccess: () => { invalidate(); toast.success("Child category added."); clearAddImage(); },
    onError: (err) => toast.error(getErrorMessage(err)),
  });

  const deleteMainMutation = useMutation({
    mutationFn: (id) => deleteCategory(id),
    onSuccess: () => { invalidate(); toast.success("Category deleted."); },
    onError: (err) => toast.error(getErrorMessage(err)),
  });

  const deleteSubMutation = useMutation({
    mutationFn: (id) => deleteSubCategory(id),
    onSuccess: () => { invalidate(); toast.success("Sub category deleted."); },
    onError: (err) => toast.error(getErrorMessage(err)),
  });

  const deleteChildMutation = useMutation({
    mutationFn: (id) => deleteChildCategory(id),
    onSuccess: () => { invalidate(); toast.success("Child category deleted."); },
    onError: (err) => toast.error(getErrorMessage(err)),
  });

  const updateMainMutation = useMutation({
    mutationFn: ({ id, name, file }) => updateCategory(id, buildCategoryFormData({ name }, file)),
    onSuccess: () => { invalidate(); toast.success("Category updated."); setEditingId(null); clearEditImage(); },
    onError: (err) => toast.error(getErrorMessage(err)),
  });

  const updateSubMutation = useMutation({
    mutationFn: ({ id, name, main_category_id, file }) => updateSubCategory(id, buildCategoryFormData({ name, main_category_id }, file)),
    onSuccess: () => { invalidate(); toast.success("Sub category updated."); setEditingId(null); clearEditImage(); },
    onError: (err) => toast.error(getErrorMessage(err)),
  });

  const updateChildMutation = useMutation({
    mutationFn: ({ id, name, sub_category_id, file }) => updateChildCategory(id, buildCategoryFormData({ name, sub_category_id }, file)),
    onSuccess: () => { invalidate(); toast.success("Child category updated."); setEditingId(null); clearEditImage(); },
    onError: (err) => toast.error(getErrorMessage(err)),
  });

  useEffect(() => {
    if (categories.length > 0) {
      const mains = {};
      const subs = {};
      categories.forEach((main) => {
        mains[main.id] = true;
        main.sub_categories?.forEach((sub) => {
          subs[sub.id] = true;
        });
      });
      setExpandedMains(mains);
      setExpandedSubs(subs);
    }
  }, [categories.length]);

  const toggleMain = (id) => {
    setExpandedMains((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  const toggleSub = (id) => {
    setExpandedSubs((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  const handleAddMain = () => {
    if (!newName.trim()) return toast.error("Enter category name.");
    addMainMutation.mutate({ name: newName.trim(), file: imageFile });
    setNewName("");
    clearAddImage();
  };

  const handleAddSub = () => {
    if (!selectedMain || !newName.trim()) return toast.error("Select main category and enter name.");
    addSubMutation.mutate({ mainId: selectedMain, name: newName.trim(), file: imageFile });
    setNewName("");
    clearAddImage();
    setExpandedMains((prev) => ({ ...prev, [selectedMain]: true }));
  };

  const handleAddChild = () => {
    if (!selectedMain || !selectedSub || !newName.trim()) return toast.error("Select categories and enter name.");
    addChildMutation.mutate({ subId: selectedSub, name: newName.trim(), file: imageFile });
    setNewName("");
    clearAddImage();
    setExpandedMains((prev) => ({ ...prev, [selectedMain]: true }));
    setExpandedSubs((prev) => ({ ...prev, [selectedSub]: true }));
  };

  const handleDeleteMain = (id) => {
    if (!window.confirm("Delete this main category and all sub/child categories?")) return;
    deleteMainMutation.mutate(id);
  };

  const handleDeleteSub = (subId) => {
    if (!window.confirm("Delete this sub category?")) return;
    deleteSubMutation.mutate(subId);
  };

  const handleDeleteChild = (childId) => {
    if (!window.confirm("Delete this child category?")) return;
    deleteChildMutation.mutate(childId);
  };

  const handleSaveEdit = (level, mainId, subId, childId, item) => {
    if (!editName.trim()) return toast.error("Enter a category name.");
    if (level === "main") updateMainMutation.mutate({ id: mainId, name: editName.trim(), file: editImageFile });
    else if (level === "sub") updateSubMutation.mutate({ id: subId, name: editName.trim(), main_category_id: mainId, file: editImageFile });
    else updateChildMutation.mutate({ id: childId, name: editName.trim(), sub_category_id: subId, file: editImageFile });
  };

  const startEdit = (level, item) => {
    setEditingId(editKey(level, item.id));
    setEditName(item.name);
    clearEditImage();
    setEditImagePreview(getCategoryImageUrl(item));
  };

  const cancelEdit = () => {
    setEditingId(null);
    clearEditImage();
  };

  const ImageUploadField = ({ preview, onChange, onClear, compact = false }) => (
    <div className={`flex items-center gap-2 ${compact ? "" : "mt-2"}`}>
      <input type="file" accept="image/*" onChange={onChange} className="text-xs max-w-[180px]" />
      {preview && (
        <div className="relative">
          <img src={preview} alt="Preview" className="w-10 h-10 rounded object-cover border border-border" />
          <button type="button" onClick={onClear} className="absolute -top-1 -right-1 bg-background rounded-full p-0.5 shadow">
            <X className="w-3 h-3" />
          </button>
        </div>
      )}
    </div>
  );

  const editKey = (level, id) => `${level}-${id}`;

  const inputClass = "h-10 px-3 rounded-lg bg-secondary border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30";

  const tabTitles = {
    main: "Main Categories",
    sub: "Sub Categories",
    child: "Child Categories",
  };

  const hasSubs = (main) => main.sub_categories?.length > 0;
  const hasChildren = (sub) => sub.child_categories?.length > 0;

  if (isLoading) {
    return (
      <div className="p-6 max-w-[1000px] mx-auto flex items-center justify-center min-h-[300px]">
        <Loader2 className="w-8 h-8 animate-spin text-primary" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="p-6 max-w-[1000px] mx-auto flex items-center justify-center min-h-[300px] gap-2 text-destructive">
        <AlertCircle className="w-5 h-5" />
        <span>Failed to load categories. Please try again.</span>
      </div>
    );
  }

  return (
    <div className="p-6 max-w-[1000px] mx-auto space-y-6">
      <div>
        <h1 className="text-2xl font-heading font-bold text-foreground">{tabTitles[activeTab] || "Categories"}</h1>
        <p className="text-sm text-muted-foreground mt-1">Manage your 3-level category hierarchy</p>
      </div>

      <div className="bg-card rounded-xl border border-border p-5 space-y-4">
        {activeTab === "main" && (
          <div className="space-y-3">
            <div className="flex gap-3">
              <input value={newName} onChange={(e) => setNewName(e.target.value)} placeholder="New main category name" className={`flex-1 ${inputClass}`} />
              <button onClick={handleAddMain} className="h-10 px-4 rounded-lg bg-primary text-primary-foreground text-sm font-medium flex items-center gap-2">
                <Plus className="w-4 h-4" /> Add Main
              </button>
            </div>
            <ImageUploadField preview={imagePreview} onChange={handleAddImageChange} onClear={clearAddImage} />
          </div>
        )}

        {activeTab === "sub" && (
          <div className="space-y-3">
            <div className="flex flex-wrap gap-3">
              <select value={selectedMain} onChange={(e) => setSelectedMain(e.target.value)} className={inputClass}>
                <option value="">Select main category</option>
                {categories.map((m) => <option key={m.id} value={m.id}>{m.name}</option>)}
              </select>
              <input value={newName} onChange={(e) => setNewName(e.target.value)} placeholder="New sub category name" className={`flex-1 min-w-[200px] ${inputClass}`} />
              <button onClick={handleAddSub} className="h-10 px-4 rounded-lg bg-primary text-primary-foreground text-sm font-medium flex items-center gap-2">
                <Plus className="w-4 h-4" /> Add Sub
              </button>
            </div>
            <ImageUploadField preview={imagePreview} onChange={handleAddImageChange} onClear={clearAddImage} />
          </div>
        )}

        {activeTab === "child" && (
          <div className="space-y-3">
            <div className="flex flex-wrap gap-3">
              <select value={selectedMain} onChange={(e) => { setSelectedMain(e.target.value); setSelectedSub(""); }} className={inputClass}>
                <option value="">Select main category</option>
                {categories.map((m) => <option key={m.id} value={m.id}>{m.name}</option>)}
              </select>
              <select value={selectedSub} onChange={(e) => setSelectedSub(e.target.value)} className={inputClass} disabled={!selectedMain}>
                <option value="">Select sub category</option>
                {categories.find((m) => String(m.id) === String(selectedMain))?.sub_categories?.map((s) => (
                  <option key={s.id} value={s.id}>{s.name}</option>
                ))}
              </select>
              <input value={newName} onChange={(e) => setNewName(e.target.value)} placeholder="New child category name" className={`flex-1 min-w-[200px] ${inputClass}`} />
              <button onClick={handleAddChild} className="h-10 px-4 rounded-lg bg-primary text-primary-foreground text-sm font-medium flex items-center gap-2">
                <Plus className="w-4 h-4" /> Add Child
              </button>
            </div>
            <ImageUploadField preview={imagePreview} onChange={handleAddImageChange} onClear={clearAddImage} />
          </div>
        )}
      </div>

      <div className="bg-card rounded-xl border border-border p-5">
        <h3 className="font-heading font-semibold mb-4">Category Tree</h3>
        <div className="space-y-2">
          {categories.map((main) => (
            <div key={main.id} className="border border-border rounded-lg overflow-hidden">
              <div className="flex items-center justify-between px-3 py-2.5 bg-secondary/20 hover:bg-secondary/40 transition-colors">
                <div className="flex items-center gap-2 min-w-0">
                  {hasSubs(main) ? (
                    <button
                      onClick={() => toggleMain(main.id)}
                      className="w-6 h-6 rounded flex items-center justify-center text-primary hover:bg-primary/10 shrink-0"
                    >
                      {expandedMains[main.id] ? (
                        <ChevronDown className="w-4 h-4" />
                      ) : (
                        <ChevronRight className="w-4 h-4" />
                      )}
                    </button>
                  ) : (
                    <span className="w-6 shrink-0" />
                  )}
                  {editingId === editKey("main", main.id) ? (
                    <div className="flex flex-col gap-2 min-w-0">
                      <div className="flex gap-2">
                        <input value={editName} onChange={(e) => setEditName(e.target.value)} className={`${inputClass} w-48`} />
                        <button onClick={() => handleSaveEdit("main", main.id, null, null, main)} className="text-xs text-primary font-medium">Save</button>
                        <button onClick={cancelEdit} className="text-xs text-muted-foreground">Cancel</button>
                      </div>
                      <ImageUploadField
                        preview={editImagePreview}
                        onChange={handleEditImageChange}
                        onClear={() => { setEditImageFile(null); setEditImagePreview(getCategoryImageUrl(main)); }}
                        compact
                      />
                    </div>
                  ) : (
                    <div className="flex items-center gap-2 min-w-0">
                      <CategoryThumb item={main} />
                      <span className="font-semibold text-sm text-foreground">{main.name}</span>
                    </div>
                  )}
                  {hasSubs(main) && (
                    <span className="text-[10px] text-muted-foreground bg-secondary px-1.5 py-0.5 rounded">
                      {main.sub_categories.length} sub
                    </span>
                  )}
                </div>
                <div className="flex gap-1 shrink-0">
                  <button onClick={() => startEdit("main", main)} className="w-7 h-7 rounded flex items-center justify-center text-primary hover:bg-primary/10"><Pencil className="w-3.5 h-3.5" /></button>
                  {activeTab === "main" && (
                    <button onClick={() => handleDeleteMain(main.id)} className="w-7 h-7 rounded flex items-center justify-center text-destructive hover:bg-destructive/10"><Trash2 className="w-3.5 h-3.5" /></button>
                  )}
                </div>
              </div>

              <AnimatePresence initial={false}>
                {expandedMains[main.id] && hasSubs(main) && (
                  <motion.div
                    initial={{ height: 0, opacity: 0 }}
                    animate={{ height: "auto", opacity: 1 }}
                    exit={{ height: 0, opacity: 0 }}
                    transition={{ duration: 0.2 }}
                    className="overflow-hidden"
                  >
                    <div className="border-t border-border/50">
                      {main.sub_categories.map((sub) => (
                        <div key={sub.id}>
                          <div className="flex items-center justify-between pl-8 pr-3 py-2 border-b border-border/30 hover:bg-secondary/20 transition-colors">
                            <div className="flex items-center gap-2 min-w-0">
                              {hasChildren(sub) ? (
                                <button
                                  onClick={() => toggleSub(sub.id)}
                                  className="w-5 h-5 rounded flex items-center justify-center text-primary hover:bg-primary/10 shrink-0"
                                >
                                  {expandedSubs[sub.id] ? (
                                    <ChevronDown className="w-3.5 h-3.5" />
                                  ) : (
                                    <ChevronRight className="w-3.5 h-3.5" />
                                  )}
                                </button>
                              ) : (
                                <span className="w-5 shrink-0" />
                              )}
                              {editingId === editKey("sub", sub.id) ? (
                                <div className="flex flex-col gap-2">
                                  <div className="flex gap-2">
                                    <input value={editName} onChange={(e) => setEditName(e.target.value)} className={`${inputClass} w-40`} />
                                    <button onClick={() => handleSaveEdit("sub", main.id, sub.id, null, sub)} className="text-xs text-primary font-medium">Save</button>
                                    <button onClick={cancelEdit} className="text-xs text-muted-foreground">Cancel</button>
                                  </div>
                                  <ImageUploadField
                                    preview={editImagePreview}
                                    onChange={handleEditImageChange}
                                    onClear={() => { setEditImageFile(null); setEditImagePreview(getCategoryImageUrl(sub)); }}
                                    compact
                                  />
                                </div>
                              ) : (
                                <div className="flex items-center gap-2">
                                  <CategoryThumb item={sub} className="w-7 h-7" />
                                  <span className="text-sm font-medium text-muted-foreground">{sub.name}</span>
                                </div>
                              )}
                              {hasChildren(sub) && (
                                <span className="text-[10px] text-muted-foreground">
                                  ({sub.child_categories.length})
                                </span>
                              )}
                            </div>
                            <div className="flex gap-1 shrink-0">
                              <button onClick={() => startEdit("sub", sub)} className="w-7 h-7 rounded flex items-center justify-center text-primary hover:bg-primary/10"><Pencil className="w-3.5 h-3.5" /></button>
                              {activeTab === "sub" && (
                                <button onClick={() => handleDeleteSub(sub.id)} className="w-7 h-7 rounded flex items-center justify-center text-destructive hover:bg-destructive/10"><Trash2 className="w-3.5 h-3.5" /></button>
                              )}
                            </div>
                          </div>

                          <AnimatePresence initial={false}>
                            {expandedSubs[sub.id] && hasChildren(sub) && (
                              <motion.div
                                initial={{ height: 0, opacity: 0 }}
                                animate={{ height: "auto", opacity: 1 }}
                                exit={{ height: 0, opacity: 0 }}
                                transition={{ duration: 0.2 }}
                                className="overflow-hidden"
                              >
                                {sub.child_categories.map((child) => (
                                  <div key={child.id} className="flex items-center justify-between pl-16 pr-3 py-1.5 border-b border-border/20 hover:bg-secondary/10 transition-colors">
                                    <span className="text-sm text-muted-foreground">
                                      {editingId === editKey("child", child.id) ? (
                                        <div className="flex flex-col gap-2">
                                          <div className="flex gap-2">
                                            <input value={editName} onChange={(e) => setEditName(e.target.value)} className={`${inputClass} w-36`} />
                                            <button onClick={() => handleSaveEdit("child", main.id, sub.id, child.id, child)} className="text-xs text-primary font-medium">Save</button>
                                            <button onClick={cancelEdit} className="text-xs text-muted-foreground">Cancel</button>
                                          </div>
                                          <ImageUploadField
                                            preview={editImagePreview}
                                            onChange={handleEditImageChange}
                                            onClear={() => { setEditImageFile(null); setEditImagePreview(getCategoryImageUrl(child)); }}
                                            compact
                                          />
                                        </div>
                                      ) : (
                                        <div className="flex items-center gap-2">
                                          <CategoryThumb item={child} className="w-6 h-6" />
                                          <span>{child.name}</span>
                                        </div>
                                      )}
                                    </span>
                                    <div className="flex gap-1 shrink-0">
                                      <button onClick={() => startEdit("child", child)} className="w-7 h-7 rounded flex items-center justify-center text-primary hover:bg-primary/10"><Pencil className="w-3.5 h-3.5" /></button>
                                      {activeTab === "child" && (
                                        <button onClick={() => handleDeleteChild(child.id)} className="w-7 h-7 rounded flex items-center justify-center text-destructive hover:bg-destructive/10"><Trash2 className="w-3.5 h-3.5" /></button>
                                      )}
                                    </div>
                                  </div>
                                ))}
                              </motion.div>
                            )}
                          </AnimatePresence>
                        </div>
                      ))}
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
