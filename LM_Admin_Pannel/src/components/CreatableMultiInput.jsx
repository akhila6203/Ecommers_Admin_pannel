import { useState } from "react";
import { X } from "lucide-react";
import { Badge } from "@/components/ui/badge";

export function CreatableMultiInput({ values, onChange, placeholder = "Small, Medium, Large, XL" }) {
  const [draft, setDraft] = useState("");

  const addValue = (raw) => {
    const val = raw.trim();
    if (!val || values.includes(val)) return;
    onChange([...values, val]);
    setDraft("");
  };

  const removeValue = (val) => onChange(values.filter((v) => v !== val));

  return (
    <div className="flex flex-wrap items-center gap-1.5 min-h-10 max-h-20 overflow-y-auto px-2 py-1.5 rounded-md border border-input bg-background focus-within:ring-2 focus-within:ring-primary/30 focus-within:border-primary/30">
      {values.map((val) => (
        <Badge key={val} variant="secondary" className="text-xs gap-0.5 pr-1 shrink-0">
          {val}
          <button
            type="button"
            className="ml-0.5 inline-flex rounded-sm hover:bg-muted"
            onClick={() => removeValue(val)}
            aria-label={`Remove ${val}`}
          >
            <X className="w-3 h-3" />
          </button>
        </Badge>
      ))}
      <input
        type="text"
        value={draft}
        onChange={(e) => setDraft(e.target.value)}
        onKeyDown={(e) => {
          if (e.key === "Enter" || e.key === ",") {
            e.preventDefault();
            addValue(draft.replace(/,/g, ""));
          } else if (e.key === "Backspace" && !draft && values.length) {
            removeValue(values[values.length - 1]);
          }
        }}
        onBlur={() => {
          if (draft.trim()) addValue(draft);
        }}
        placeholder={values.length === 0 ? placeholder : ""}
        className="flex-1 min-w-[100px] h-7 bg-transparent text-sm outline-none placeholder:text-muted-foreground"
      />
    </div>
  );
}
