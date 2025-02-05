const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Jost", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        primary: {
          DEFAULT: "#4661E6", // Primary Blue
          dark: "#3741A6", // Darker Blue (Hover)
        },
        secondary: {
          DEFAULT: "#AD1FEA", // Accent Purple
        },
        dark: {
          DEFAULT: "#3A4374", // Deep Navy
          muted: "#647196", // Muted Navy
        },
        light: {
          DEFAULT: "#F7F8FD", // Soft White
          subtle: "#F2F4FF", // Off White Variation
        },
        warning: {
          DEFAULT: "#F49F85", // Soft Orange
        },
        info: {
          DEFAULT: "#62BCFA", // Sky Blue
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ],
};
