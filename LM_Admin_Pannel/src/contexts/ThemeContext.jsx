import { useState, createContext, useContext } from "react";

const ThemeContext = createContext({ isDark: false, toggle: () => {} });

export const useTheme = () => useContext(ThemeContext);

export function ThemeProvider({ children }) {
  const [isDark, setIsDark] = useState(false);

  const toggle = () => {
    setIsDark((prev) => {
      const next = !prev;
      document.documentElement.classList.toggle("dark", next);
      return next;
    });
  };

  return (
    <ThemeContext.Provider value={{ isDark, toggle }}>
      {children}
    </ThemeContext.Provider>
  );
}

// import { useState, createContext, useContext } from "react";

// // ✅ Create Context with default values
// const ThemeContext = createContext({
//   isDark: false,
//   toggle: () => {},
// });

// // ✅ Custom Hook
// export const useTheme = () => useContext(ThemeContext);

// // ✅ Theme Provider Component
// export function ThemeProvider({ children }) {
//   const [isDark, setIsDark] = useState(false);

//   // ✅ Toggle Function
//   const toggle = () => {
//     setIsDark((prev) => {
//       const next = !prev;

//       // Tailwind dark mode class toggle
//       document.documentElement.classList.toggle("dark", next);

//       return next;
//     });
//   };

//   return (
//     <ThemeContext.Provider value={{ isDark, toggle }}>
//       {children}
//     </ThemeContext.Provider>
//   );
// }