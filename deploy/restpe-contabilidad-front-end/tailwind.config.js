colors = require('tailwindcss/colors');
/** @type {import('tailwindcss').Config} */

module.exports = {
  content: [
    './src/app/**/*.{html,ts}',
    './src/theme/**/*.scss',
  ],
  theme: {
    screens: {
      'sm': '640px',
      // => @media (min-width: 640px) { ... }

      'md': '768px',
      // => @media (min-width: 768px) { ... }

      'lg': '1024px',
      // => @media (min-width: 1024px) { ... }

      'xl': '1280px',
      // => @media (min-width: 1280px) { ... }

      '2xl': '1536px',
      // => @media (min-width: 1536px) { ... }

      '3xl': '1920px',
      // => @media (max-width: 1920px) { ... }

      '4xl': '2500px',
      // => @media (max-width: 2500px) { ... }

    },
    extend: {
      colors: {
        warning: {
          5: "#FFF3EC",
          10: "#FFDECC",
          25: "#FFCDB1",
          45: "#FFBC97",
          65: "#FFAB7C",
          85: "#FF9A62",
          DEFAULT: "#FF8947",
        },
        danger: {
          5: "#FFF5F5",
          10: "#FBD0D0",
          25: "#F9B4B4",
          45: "#F69898",
          65: "#F47C7C",
          85: "#F16060",
          DEFAULT: "#EF4444",
        },
        yellow: {
          5: "#FFF9E7",
          10: "#FFEBAD",
          25: "#FFE287",
          45: "#FFD85B",
          65: "#FFD334",
          85: "#FFC800",
          DEFAULT: "#F2A626",
        },
        text: {
          5: "#E4E4E4",
          10: "#C7C7C7",
          15: "#ECECEC",
          25: "#878787",
          45: "#646464",
          65: "#4F4F4F",
          85: "#363636",
          DEFAULT: "#979797",
        },
        primary: {
            5: "#ECF4FF",
            10: "#CEE0FD",
            25: "#B1CDFB",
            45: "#93BAFA",
            65: "#76A8F9",
            85: "#5895F7",
            DEFAULT: "#3B82F6",
        },
        success: {
                    5: "#F5FBF4",
                    10: "#DDF1DA",
                    25: "#C6E8C1",
                    45: "#B0E0A9",
                    65: "#9AD791",
                    85: "#83CE78",
                    DEFAULT: "#6DC560",
                },
        primarypurple: {
            5: "#ECF4FF",
            DEFAULT: "#63c",
        },
        'secondary': '#F08F32',
        'blues': '#F5F7FC',
        'light': '#FAFCFE',
        'Background-light': '#F5F7FC',
        'body-base': '#636E95',
        'body-dark': '#454E5A',
        'control': '#e1e3e5',
        'link': colors.blue[500],
        'separator': colors.gray[200],
      },
      fontSize: {
        xxs: "10px", // Añade el tamaño de fuente personalizado
        xxss: "8px",
      },
      fontFamily: {
        'nunito': ['"Nunito Sans"', 'sans-serif'],
        'sans': ['"Nunito Sans"', 'sans-serif'] // Cambiado a Roboto como fuente principal
      },
      fontWeight: {
        thin: '100',
        extralight: '200',
        light: '300',
        normal: '400',
        medium: '500',
        semibold: '600',
        bold: '700',
        extrabold: '800',
        black: '900',
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}

