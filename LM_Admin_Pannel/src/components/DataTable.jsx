import { useState, useEffect, useMemo } from "react";
import { ChevronLeft, ChevronRight, Search } from "lucide-react";

const PAGE_SIZE_OPTIONS = [
  { label: "10", value: 10 },
  { label: "20", value: 20 },
  { label: "50", value: 50 },
  { label: "100", value: 100 },
  { label: "All", value: "all" },
];

function getRowSearchText(row, columns) {
  const parts = columns.map((col) => {
    if (col.render) {
      const rendered = col.render(row);
      if (typeof rendered === "string" || typeof rendered === "number") return String(rendered);
    }
    const value = row[col.key];
    if (value == null) return "";
    return String(value);
  });
  return parts.join(" ").toLowerCase();
}

export function DataTable({
  columns,
  data,
  emptyMessage = "No data found.",
  paginate = true,
  defaultPageSize = 10,
  searchable = true,
  searchPlaceholder = "Search...",
  searchKeys,
  itemLabel = "items",
  embedded = false,
}) {
  const [page, setPage] = useState(1);
  const [pageSizeOption, setPageSizeOption] = useState(defaultPageSize);
  const [searchQuery, setSearchQuery] = useState("");

  const filteredData = useMemo(() => {
    if (!data?.length) return [];
    const query = searchQuery.trim().toLowerCase();
    if (!query) return data;

    return data.filter((row) => {
      if (searchKeys?.length) {
        return searchKeys.some((key) =>
          String(row[key] ?? "").toLowerCase().includes(query)
        );
      }
      return getRowSearchText(row, columns).includes(query);
    });
  }, [data, searchQuery, columns, searchKeys]);

  const effectivePageSize =
    pageSizeOption === "all"
      ? Math.max(filteredData.length, 1)
      : Number(pageSizeOption);

  const totalItems = filteredData.length;
  const totalPages = Math.max(1, Math.ceil(totalItems / effectivePageSize));

  useEffect(() => {
    setPage(1);
  }, [searchQuery, pageSizeOption, data?.length]);

  useEffect(() => {
    if (page > totalPages) setPage(totalPages);
  }, [page, totalPages]);

  const paginatedData = useMemo(() => {
    if (!paginate || !filteredData.length) return filteredData;
    const start = (page - 1) * effectivePageSize;
    return filteredData.slice(start, start + effectivePageSize);
  }, [filteredData, page, effectivePageSize, paginate]);

  const startItem = totalItems === 0 ? 0 : (page - 1) * effectivePageSize + 1;
  const endItem = Math.min(page * effectivePageSize, totalItems);

  const showToolbar = searchable || paginate;
  const containerClass = embedded
    ? "space-y-4"
    : "bg-card rounded-xl border border-border overflow-hidden";

  return (
    <div className={containerClass}>
      {showToolbar && (
        <div
          className={`flex flex-col sm:flex-row sm:items-center justify-between gap-3 ${
            embedded ? "" : "px-5 pt-5"
          }`}
        >
          {searchable ? (
            <div className="relative flex-1 max-w-md">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder={searchPlaceholder}
                className="w-full h-10 pl-9 pr-4 rounded-lg bg-secondary/60 border border-border text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary/30 transition"
              />
            </div>
          ) : (
            <div />
          )}

          {paginate && (
            <div className="flex items-center gap-2 text-sm text-muted-foreground shrink-0">
              <span>Rows per page</span>
              <select
                value={pageSizeOption}
                onChange={(e) => {
                  const value = e.target.value;
                  setPageSizeOption(value === "all" ? "all" : Number(value));
                }}
                className="h-9 px-2.5 rounded-lg bg-card border border-border text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-primary/30"
              >
                {PAGE_SIZE_OPTIONS.map((option) => (
                  <option key={option.label} value={option.value}>
                    {option.label}
                  </option>
                ))}
              </select>
            </div>
          )}
        </div>
      )}

      {!filteredData.length ? (
        <div className={`text-center py-12 text-muted-foreground text-sm ${embedded ? "" : "px-5 pb-5"}`}>
          {searchQuery.trim() ? "No results match your search." : emptyMessage}
        </div>
      ) : (
        <div className={`overflow-x-auto ${embedded ? "" : "mt-4"}`}>
          <table className="w-full text-sm">
            <thead>
              <tr className="border-y border-border bg-secondary/30">
                {columns.map((col) => (
                  <th
                    key={col.key}
                    className="text-left py-3 px-5 font-semibold text-muted-foreground text-xs uppercase tracking-wide whitespace-nowrap"
                  >
                    {col.label}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {paginatedData.map((row, i) => (
                <tr
                  key={row.id || i}
                  className="border-b border-border/50 hover:bg-secondary/20 transition-colors last:border-0"
                >
                  {columns.map((col) => (
                    <td key={col.key} className="py-3.5 px-5 align-middle text-sm text-foreground">
                      {col.render ? col.render(row) : row[col.key]}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {paginate && totalItems > 0 && (
        <div
          className={`flex flex-col sm:flex-row items-center justify-between gap-3 border-t border-border ${
            embedded ? "pt-4" : "px-5 py-4"
          }`}
        >
          <p className="text-sm text-muted-foreground">
            Showing {startItem}–{endItem} of {totalItems} {itemLabel}
          </p>

          <div className="flex items-center gap-2">
            <button
              onClick={() => setPage((p) => Math.max(1, p - 1))}
              disabled={page <= 1}
              className="flex items-center gap-1 h-9 px-3 rounded-lg text-sm font-medium border border-border bg-card hover:bg-secondary disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
            >
              <ChevronLeft className="w-4 h-4" />
              Previous
            </button>
            <button
              onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
              disabled={page >= totalPages}
              className="flex items-center gap-1 h-9 px-3 rounded-lg text-sm font-medium border border-border bg-card hover:bg-secondary disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
            >
              Next
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
