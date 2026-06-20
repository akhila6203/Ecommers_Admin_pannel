import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Eye, X } from "lucide-react";
import { toast } from "sonner";
import { DataTable } from "@/components/DataTable";
import PageQueryState, { TableSkeleton } from "@/components/PageQueryState";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import {
  getOrders,
  getOrder,
  updateOrderStatus,
  updatePaymentStatus,
  cancelOrder,
} from "@/services/orderService";

const ORDER_STATUSES = ["pending", "confirmed", "packed", "shipped", "delivered", "cancelled"];
const PAYMENT_STATUSES = ["pending", "paid", "failed", "refunded"];

function formatStatus(status) {
  if (!status) return "—";
  return status.charAt(0).toUpperCase() + status.slice(1);
}

function statusBadge(status) {
  const s = (status || "").toLowerCase();
  const colors = {
    delivered: "bg-green-100 text-green-700",
    shipped: "bg-blue-100 text-blue-700",
    packed: "bg-indigo-100 text-indigo-700",
    confirmed: "bg-yellow-100 text-yellow-700",
    pending: "bg-orange-100 text-orange-700",
    cancelled: "bg-red-100 text-red-700",
  };
  return (
    <span className={`px-2.5 py-0.5 rounded-full text-xs font-medium ${colors[s] || "bg-secondary"}`}>
      {formatStatus(status)}
    </span>
  );
}

export default function Orders() {
  const queryClient = useQueryClient();
  const [page, setPage] = useState(1);
  const [detailId, setDetailId] = useState(null);
  const [statusDraft, setStatusDraft] = useState("");
  const [paymentDraft, setPaymentDraft] = useState("");

  const { data, isLoading, error, refetch } = useQuery({
    queryKey: ["orders", page],
    queryFn: () => getOrders({ page, limit: 20 }),
  });

  const orders = data?.data || [];
  const pagination = data?.pagination;

  const { data: orderDetail, isLoading: detailLoading } = useQuery({
    queryKey: ["order", detailId],
    queryFn: () => getOrder(detailId),
    enabled: !!detailId,
  });

  const order = orderDetail?.data;

  useEffect(() => {
    if (order) {
      setStatusDraft(order.order_status || "");
      setPaymentDraft(order.payment_status || "");
    }
  }, [order]);

  const invalidate = () => {
    queryClient.invalidateQueries({ queryKey: ["orders"] });
    if (detailId) queryClient.invalidateQueries({ queryKey: ["order", detailId] });
  };

  const statusMutation = useMutation({
    mutationFn: ({ id, status }) => updateOrderStatus(id, status),
    onSuccess: () => { invalidate(); toast.success("Order status updated."); },
    onError: (err) => toast.error(err.message || "Failed to update status"),
  });

  const paymentMutation = useMutation({
    mutationFn: ({ id, paymentStatus }) => updatePaymentStatus(id, paymentStatus),
    onSuccess: () => { invalidate(); toast.success("Payment status updated."); },
    onError: (err) => toast.error(err.message || "Failed to update payment"),
  });

  const cancelMutation = useMutation({
    mutationFn: (id) => cancelOrder(id),
    onSuccess: () => {
      invalidate();
      setStatusDraft("cancelled");
      toast.success("Order cancelled.");
    },
    onError: (err) => toast.error(err.message || "Failed to cancel order"),
  });

  const openDetail = (id) => {
    setDetailId(id);
  };

  const statusCounts = ORDER_STATUSES.slice(0, 4).map((s) => ({
    status: s,
    count: orders.filter((o) => (o.order_status || o.status || "").toLowerCase() === s).length,
  }));

  return (
    <PageQueryState
      isLoading={isLoading}
      error={error}
      onRetry={refetch}
      skeleton={<TableSkeleton rows={6} cols={6} />}
    >
      <div className="p-6 max-w-[1600px] mx-auto space-y-6">
        <div>
          <h1 className="text-2xl font-heading font-bold text-foreground">Orders</h1>
          <p className="text-sm text-muted-foreground mt-1">
            Manage customer orders ({pagination?.total ?? orders.length} total)
          </p>
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
          {statusCounts.map(({ status, count }) => (
            <div key={status} className="bg-card rounded-xl border border-border p-4 text-center">
              <p className="text-2xl font-heading font-bold text-primary">{count}</p>
              <p className="text-xs text-muted-foreground mt-1">{formatStatus(status)}</p>
            </div>
          ))}
        </div>

        <DataTable
          columns={[
            { key: "order_number", label: "Order ID" },
            {
              key: "customer_name",
              label: "Customer",
              render: (r) => r.customer_name || `${r.first_name || ""} ${r.last_name || ""}`.trim() || "—",
            },
            {
              key: "items_count",
              label: "Items",
              render: (r) => r.items_count ?? "—",
            },
            {
              key: "total_amount",
              label: "Amount",
              render: (r) => `₹${(r.total_amount || 0).toLocaleString()}`,
            },
            {
              key: "created_at",
              label: "Date",
              render: (r) => (r.created_at ? new Date(r.created_at).toLocaleDateString() : "—"),
            },
            {
              key: "order_status",
              label: "Status",
              render: (r) => statusBadge(r.order_status || r.status),
            },
            {
              key: "actions",
              label: "",
              render: (r) => (
                <Button size="sm" variant="outline" onClick={() => openDetail(r.id)}>
                  <Eye className="w-4 h-4 mr-1" />
                  View
                </Button>
              ),
            },
          ]}
          data={orders}
          searchPlaceholder="Search orders..."
          itemLabel="orders"
          paginate={false}
        />

        {pagination && pagination.totalPages > 1 && (
          <div className="flex justify-center gap-2">
            <Button variant="outline" disabled={page <= 1} onClick={() => setPage((p) => p - 1)}>Previous</Button>
            <span className="text-sm text-muted-foreground self-center">Page {pagination.page} of {pagination.totalPages}</span>
            <Button variant="outline" disabled={page >= pagination.totalPages} onClick={() => setPage((p) => p + 1)}>Next</Button>
          </div>
        )}

        {detailId && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
            <div className="bg-card rounded-xl border border-border w-full max-w-2xl max-h-[90vh] overflow-y-auto p-6 space-y-4">
              <div className="flex items-center justify-between">
                <h2 className="text-lg font-semibold">Order #{order?.order_number || detailId}</h2>
                <button onClick={() => setDetailId(null)}><X className="w-5 h-5" /></button>
              </div>

              {detailLoading ? (
                <TableSkeleton rows={4} cols={2} />
              ) : order ? (
                <>
                  <div className="grid grid-cols-2 gap-4 text-sm">
                    <div><span className="text-muted-foreground">Customer:</span> {order.customer?.first_name} {order.customer?.last_name}</div>
                    <div><span className="text-muted-foreground">Email:</span> {order.email || order.customer?.email || "—"}</div>
                    <div><span className="text-muted-foreground">Phone:</span> {order.phone || "—"}</div>
                    <div><span className="text-muted-foreground">Total:</span> ₹{(order.total_amount || 0).toLocaleString()}</div>
                  </div>

                  <div>
                    <h3 className="font-medium mb-2">Items</h3>
                    <ul className="text-sm space-y-1 border border-border rounded-lg p-3">
                      {(order.items || []).map((item) => (
                        <li key={item.id} className="flex justify-between">
                          <span>{item.product_name || item.name} × {item.quantity}</span>
                          <span>₹{(item.total_price || item.price || 0).toLocaleString()}</span>
                        </li>
                      ))}
                    </ul>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                      <Label>Order Status</Label>
                      <select
                        value={statusDraft}
                        onChange={(e) => setStatusDraft(e.target.value)}
                        className="mt-1 w-full h-10 rounded-lg border border-border bg-background px-3 text-sm"
                      >
                        {ORDER_STATUSES.map((s) => (
                          <option key={s} value={s}>{formatStatus(s)}</option>
                        ))}
                      </select>
                      <Button
                        className="mt-2 w-full"
                        size="sm"
                        onClick={() => statusMutation.mutate({ id: detailId, status: statusDraft })}
                        disabled={statusMutation.isPending}
                      >
                        Update Status
                      </Button>
                    </div>
                    <div>
                      <Label>Payment Status</Label>
                      <select
                        value={paymentDraft}
                        onChange={(e) => setPaymentDraft(e.target.value)}
                        className="mt-1 w-full h-10 rounded-lg border border-border bg-background px-3 text-sm"
                      >
                        {PAYMENT_STATUSES.map((s) => (
                          <option key={s} value={s}>{formatStatus(s)}</option>
                        ))}
                      </select>
                      <Button
                        className="mt-2 w-full"
                        size="sm"
                        variant="secondary"
                        onClick={() => paymentMutation.mutate({ id: detailId, paymentStatus: paymentDraft })}
                        disabled={paymentMutation.isPending}
                      >
                        Update Payment
                      </Button>
                    </div>
                  </div>

                  {order.order_status !== "cancelled" && (
                    <Button
                      variant="destructive"
                      onClick={() => {
                        if (window.confirm("Cancel this order? Stock will be restored.")) {
                          cancelMutation.mutate(detailId);
                        }
                      }}
                      disabled={cancelMutation.isPending}
                    >
                      Cancel Order
                    </Button>
                  )}
                </>
              ) : (
                <p className="text-sm text-muted-foreground">Order not found.</p>
              )}
            </div>
          </div>
        )}
      </div>
    </PageQueryState>
  );
}
