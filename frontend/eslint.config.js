import babelParser from "@babel/eslint-parser"
import reactPlugin from "eslint-plugin-react"

export default [
  {
    ignores: [
      "node_modules",
      "dist",
      "package.json",
      "package-lock.json"
    ]
  },
  {
    files: ["src/**/*.{js,jsx}"],
    languageOptions: {
      parser: babelParser,
      parserOptions: {
        requireConfigFile: false,
        babelOptions: {
          presets: ["@babel/preset-react"]
        }
      }
    },
    plugins: {
      react: reactPlugin
    },
    rules: {
      "react/jsx-uses-react": "off",
      "react/react-in-jsx-scope": "off"
    }
  }
]
