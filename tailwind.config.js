/** @type {import('tailwindcss').Config} */

import withMT from "@material-tailwind/react/utils/withMT"
export default withMT({
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'primary': '#ED547B',
        'dark-primary': '#E9446A',
        'accent-primary': '#bc1e70',
        'accent2-primary': '#dd7e28',
        'accent-ligth-primary': '#F8EBED',
      },
    },
  },
  plugins: [],
});

