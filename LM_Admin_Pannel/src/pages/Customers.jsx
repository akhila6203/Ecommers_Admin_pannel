import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Ban, Trash2, UserCheck } from "lucide-react";
import { toast } from "sonner";
import { DataTable } from "@/components/DataTable";
import PageQueryState, { TableSkeleton, EmptyState } from "@/components/PageQueryState";
import { Button } from "@/components/ui/button";
import { getCustomers, blockCustomer, deleteCustomer } from "@/services/customerService";

export default function Customers() {
  const queryClient = useQueryClient();
  const [page, setPage] = useState(1);

  const { data, isLoading, error, refetch } = useQuery({
    queryKey: ["customers", page],
    queryFn: () => getCustomers({ page, limit: 20 }),
  });

  const customers = data?.data || [];
  const pagination = data?.pagination;

  const invalidate = () => queryClient.invalidateQueries({ queryKey: ["customers"] });

  const blockMutation = useMutation({
    mutationFn: (id) => blockCustomer(id),
    onSuccess: (res) => {
      invalidate();
      toast.success(res.message || "Customer status updated.");
    },
    onError: (err) => toast.error(err.message || "Failed to update customer"),
  });

  const deleteMutation = useMutation({
    mutationFn: (id) => deleteCustomer(id),
    onSuccess: () => {
      invalidate();
      toast.success("Customer deleted.");
    },
    onError: (err) => toast.error(err.message || "Failed to delete customer"),
  });

  const handleBlock = (customer) => {
    const action = customer.status === "blocked" ? "unblock" : "block";
    const name = `${customer.first_name || ""} ${customer.last_name || ""}`.trim() || customer.email;
    if (window.confirm(`${action.charAt(0).toUpperCase() + action.slice(1)} customer "${name}"?`)) {
      blockMutation.mutate(customer.id);
    }
  };

  const handleDelete = (customer) => {
    const name = `${customer.first_name || ""} ${customer.last_name || ""}`.trim() || customer.email;
    if (window.confirm(`Permanently delete customer "${name}"? This cannot be undone.`)) {
      deleteMutation.mutate(customer.id);
    }
  };

  const statusBadge = (status) => (
    <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${
      status === "blocked" ? "bg-red-100 text-red-700" : status === "active" ? "bg-green-100 text-green-700" : "bg-gray-100 text-gray-600"
    }`}>
      {status || "active"}
    </span>
  );

  return (
    <PageQueryState
      isLoading={isLoading}
      error={error}
      onRetry={refetch}
      skeleton={<TableSkeleton rows={6} cols={5} />}
    >
      <div className="p-6 max-w-[1600px] mx-auto space-y-6">
        <div>
          <h1 className="text-2xl font-heading font-bold text-foreground">Customers</h1>
          <p className="text-sm text-muted-foreground mt-1">
            {pagination?.total ?? customers.length} registered customers
          </p>
        </div>

        {customers.length === 0 ? (
          <EmptyState message="No customers found." />
        ) : (
          <DataTable
            columns={[
              {
                key: "name",
                label: "Name",
                render: (r) => `${r.first_name || ""} ${r.last_name || ""}`.trim() || r.name || "—",
              },
              { key: "email", label: "Email" },
              { key: "phone", label: "Phone", render: (r) => r.phone || "—" },
              { key: "order_count", label: "Orders", render: (r) => r.order_count ?? r.total_orders ?? 0 },
              {
                key: "total_spent",
                label: "Total Spent",
                render: (r) => `₹${(r.total_spent_amount ?? r.total_spent ?? 0).toLocaleString()}`,
              },
              { key: "status", label: "Status", render: (r) => statusBadge(r.status) },
              {
                key: "actions",
                label: "Actions",
                render: (r) => (
                  <div className="flex gap-1">
                    <Button
                      size="sm"
                      variant="outline"
                      onClick={() => handleBlock(r)}
                      disabled={blockMutation.isPending}
                      title={r.status === "blocked" ? "Unblock" : "Block"}
                    >
                      {r.status === "blocked" ? <UserCheck className="w-4 h-4" /> : <Ban className="w-4 h-4" />}
                    </Button>
                    <Button
                      size="sm"
                      variant="ghost"
                      className="text-destructive"
                      onClick={() => handleDelete(r)}
                      disabled={deleteMutation.isPending}
                      title="Delete"
                    >
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  </div>
                ),
              },
            ]}
            data={customers}
            searchPlaceholder="Search by name or email..."
            searchKeys={["first_name", "last_name", "email", "phone"]}
            itemLabel="customers"
            paginate={false}
          />
        )}

        {pagination && pagination.totalPages > 1 && (
          <div className="flex justify-center gap-2">
            <Button variant="outline" disabled={page <= 1} onClick={() => setPage((p) => p - 1)}>Previous</Button>
            <span className="text-sm text-muted-foreground self-center">Page {pagination.page} of {pagination.totalPages}</span>
            <Button variant="outline" disabled={page >= pagination.totalPages} onClick={() => setPage((p) => p + 1)}>Next</Button>
          </div>
        )}
      </div>
    </PageQueryState>
  );
}
