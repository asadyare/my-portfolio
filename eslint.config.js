import babelParser from "@babel/eslint-parser";

export default [
  {
    files: ["*.js", "*.jsx"],
    languageOptions: {
      parser: babelParser,
      parserOptions: {
        requireConfigFile: false
      }
    },
    rules: {
      "no-unused-vars": "warn",
      "no-console": "off",
      "semi": ["error", "always"]
    }
  }
];
