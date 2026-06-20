import { cn } from "@/lib/utils";

function Skeleton({ className, ...props }) {
  return <div className={cn("animate-pulse rounded-md bg-muted", className)} {...props} />;
}

export { Skeleton };


// import { cn } from "@/lib/utils";

// // ✅ Skeleton Component
// function Skeleton({ className, ...props }) {
//   return (
//     <div
//       className={cn(
//         "animate-pulse rounded-md bg-muted",
//         className
//       )}
//       {...props}
//     />
//   );
// }

// // ✅ Export
// export { Skeleton };