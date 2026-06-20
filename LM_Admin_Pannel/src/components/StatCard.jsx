import { motion } from "framer-motion";
import { AnimatedCounter } from "@/components/AnimatedCounter";

export function StatCard({ title, value, icon, delay = 0, prefix = "", suffix = "" }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, delay }}
      className="bg-card rounded-xl border border-border p-5 hover:shadow-md hover:border-primary/20 transition-all duration-300 group"
    >
      <div className="flex items-start justify-between mb-3">
        <div className="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center group-hover:bg-primary/15 transition-colors">
          {icon}
        </div>
      </div>
      <div className="text-2xl font-heading font-bold text-foreground mb-1">
        <AnimatedCounter target={value} prefix={prefix} suffix={suffix} />
      </div>
      <p className="text-sm text-muted-foreground">{title}</p>
    </motion.div>
  );
}
