import { Loader2, AlertCircle, RefreshCw, Inbox } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";

export function PageLoader({ message = "Loading..." }) {
  return (
    <div className="p-6 max-w-[1600px] mx-auto flex flex-col items-center justify-center min-h-[300px] gap-3">
      <Loader2 className="w-8 h-8 animate-spin text-primary" />
      <p className="text-sm text-muted-foreground">{message}</p>
    </div>
  );
}

export function TableSkeleton({ rows = 5, cols = 4 }) {
  return (
    <div className="space-y-3 p-6">
      {Array.from({ length: rows }).map((_, i) => (
        <div key={i} className="flex gap-4">
          {Array.from({ length: cols }).map((__, j) => (
            <Skeleton key={j} className="h-10 flex-1" />
          ))}
        </div>
      ))}
    </div>
  );
}

export function PageError({ message, onRetry }) {
  return (
    <div className="p-6 max-w-[1600px] mx-auto flex flex-col items-center justify-center min-h-[300px] gap-4 text-center">
      <AlertCircle className="w-10 h-10 text-destructive" />
      <p className="text-sm text-destructive max-w-md">{message || "Something went wrong."}</p>
      {onRetry && (
        <Button variant="outline" onClick={onRetry}>
          <RefreshCw className="w-4 h-4 mr-2" />
          Retry
        </Button>
      )}
    </div>
  );
}

export function EmptyState({ message, action }) {
  return (
    <div className="flex flex-col items-center justify-center py-16 gap-3 text-center">
      <Inbox className="w-12 h-12 text-muted-foreground/50" />
      <p className="text-sm text-muted-foreground">{message}</p>
      {action}
    </div>
  );
}

export default function PageQueryState({ isLoading, error, onRetry, skeleton, children, loadingMessage }) {
  if (isLoading) {
    if (skeleton) return skeleton;
    return <PageLoader message={loadingMessage} />;
  }
  if (error) {
    return <PageError message={error.message} onRetry={onRetry} />;
  }
  return children;
}
