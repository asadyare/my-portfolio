import babelParser from "@babel/eslint-parser";

export default [
  {
    files: ["frontend/src/**/*.{jsx,js}"],
    languageOptions: {
      parser: babelParser,
      parserOptions: {
        requireConfigFile: false,
        babelOptions: {
          presets: ["@babel/preset-react"]
        }
      }
    },
    rules: {
      "no-unused-vars": "warn",
      "no-console": "off"
    }
  }
];
