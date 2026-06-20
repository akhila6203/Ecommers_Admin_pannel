import * as React from "react";
import * as TabsPrimitive from "@radix-ui/react-tabs";

import { cn } from "@/lib/utils";

const Tabs = TabsPrimitive.Root;

const TabsList = React.forwardRef(
  ({ className, ...props }, ref) => (
    <TabsPrimitive.List
      ref={ref}
      className={cn(
        "inline-flex h-10 items-center justify-center rounded-md bg-muted p-1 text-muted-foreground",
        className
      )}
      {...props}
    />
  )
);
TabsList.displayName = TabsPrimitive.List.displayName;

const TabsTrigger = React.forwardRef(
  ({ className, ...props }, ref) => (
    <TabsPrimitive.Trigger
      ref={ref}
      className={cn(
        "inline-flex items-center justify-center whitespace-nowrap rounded-sm px-3 py-1.5 text-sm font-medium ring-offset-background transition-all data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
        className
      )}
      {...props}
    />
  )
);
TabsTrigger.displayName = TabsPrimitive.Trigger.displayName;

const TabsContent = React.forwardRef(
  ({ className, ...props }, ref) => (
    <TabsPrimitive.Content
      ref={ref}
      className={cn(
        "mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
        className
      )}
      {...props}
    />
  )
);
TabsContent.displayName = TabsPrimitive.Content.displayName;

export { Tabs, TabsList, TabsTrigger, TabsContent };


// import * as React from "react";
// import * as TabsPrimitive from "@radix-ui/react-tabs";

// import { cn } from "@/lib/utils";

// // ✅ Root Tabs
// const Tabs = TabsPrimitive.Root;

// // ✅ Tabs List
// const TabsList = React.forwardRef(({ className, ...props }, ref) => (
//   <TabsPrimitive.List
//     ref={ref}
//     className={cn(
//       "inline-flex h-10 items-center justify-center rounded-md bg-muted p-1 text-muted-foreground",
//       className
//     )}
//     {...props}
//   />
// ));
// TabsList.displayName = "TabsList";

// // ✅ Tabs Trigger (Button)
// const TabsTrigger = React.forwardRef(({ className, ...props }, ref) => (
//   <TabsPrimitive.Trigger
//     ref={ref}
//     className={cn(
//       "inline-flex items-center justify-center whitespace-nowrap rounded-sm px-3 py-1.5 text-sm font-medium transition-all",

//       // active state
//       "data-[state=active]:bg-background data-[state=active]:text-foreground shadow-sm",

//       // focus styles
//       "focus:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",

//       // disabled
//       "disabled:pointer-events-none disabled:opacity-50",

//       className
//     )}
//     {...props}
//   />
// ));
// TabsTrigger.displayName = "TabsTrigger";

// // ✅ Tabs Content
// const TabsContent = React.forwardRef(({ className, ...props }, ref) => (
//   <TabsPrimitive.Content
//     ref={ref}
//     className={cn(
//       "mt-2",

//       // focus styles
//       "focus:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",

//       className
//     )}
//     {...props}
//   />
// ));
// TabsContent.displayName = "TabsContent";

// // ✅ Export
// export { Tabs, TabsList, TabsTrigger, TabsContent };