import * as React from "react";

import { cn } from "@/lib/utils";

const Input = React.forwardRef(
  ({ className, type, ...props }, ref) => {
    return (
      <input
        type={type}
        className={cn(
          "flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-base ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
          className
        )}
        ref={ref}
        {...props}
      />
    );
  }
);
Input.displayName = "Input";

export { Input };


// import * as React from "react";

// import { cn } from "@/lib/utils";

// // ✅ Input Component
// const Input = React.forwardRef(
//   ({ className, type = "text", ...props }, ref) => {
//     return (
//       <input
//         ref={ref}
//         type={type}
//         className={cn(
//           "flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-base",
//           "ring-offset-background placeholder:text-muted-foreground",
          
//           // ✅ File input styles
//           "file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground",
          
//           // ✅ Focus styles
//           "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
          
//           // ✅ Disabled styles
//           "disabled:cursor-not-allowed disabled:opacity-50",
          
//           // ✅ Responsive
//           "md:text-sm",
          
//           className
//         )}
//         {...props}
//       />
//     );
//   }
// );

// Input.displayName = "Input";

// // ✅ Export
// export { Input };