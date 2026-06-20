import * as CollapsiblePrimitive from "@radix-ui/react-collapsible";

const Collapsible = CollapsiblePrimitive.Root;

const CollapsibleTrigger = CollapsiblePrimitive.CollapsibleTrigger;

const CollapsibleContent = CollapsiblePrimitive.CollapsibleContent;

export { Collapsible, CollapsibleTrigger, CollapsibleContent };



// import * as React from "react";
// import * as CollapsiblePrimitive from "@radix-ui/react-collapsible";

// import { cn } from "@/lib/utils";

// // ✅ Root
// const Collapsible = CollapsiblePrimitive.Root;

// // ✅ Trigger (with Tailwind styling)
// const CollapsibleTrigger = React.forwardRef(
//   ({ className, ...props }, ref) => (
//     <CollapsiblePrimitive.Trigger
//       ref={ref}
//       className={cn(
//         "cursor-pointer transition-colors hover:text-primary",
//         className
//       )}
//       {...props}
//     />
//   )
// );
// CollapsibleTrigger.displayName = "CollapsibleTrigger";

// // ✅ Content (with smooth animation)
// const CollapsibleContent = React.forwardRef(
//   ({ className, ...props }, ref) => (
//     <CollapsiblePrimitive.Content
//       ref={ref}
//       className={cn(
//         "overflow-hidden transition-all",
//         "data-[state=open]:animate-accordion-down",
//         "data-[state=closed]:animate-accordion-up",
//         className
//       )}
//       {...props}
//     />
//   )
// );
// CollapsibleContent.displayName = "CollapsibleContent";

// // ✅ Export
// export {
//   Collapsible,
//   CollapsibleTrigger,
//   CollapsibleContent,
// };
