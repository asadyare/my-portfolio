import js from "@eslint/js";
import react from "eslint-plugin-react";
import reactHooks from "eslint-plugin-react-hooks";
import jsxA11y from "eslint-plugin-jsx-a11y";
import importPlugin from "eslint-plugin-import";
import prettier from "eslint-config-prettier";

export default [
{
files: ["**/*"],
ignores: ["dist", "node_modules"],
languageOptions: {
globals: {
window: "readonly",
document: "readonly",
console: "readonly"
}
}
},

js.configs.recommended,
prettier,

{
files: ["src/**/*.{js,jsx}"],
plugins: {
react,
"react-hooks": reactHooks,
"jsx-a11y": jsxA11y,
import: importPlugin
},
settings: {
react: {
version: "detect"
}
},
languageOptions: {
ecmaVersion: "latest",
sourceType: "module",
parserOptions: {
ecmaFeatures: {
jsx: true
}
}
},
rules: {
"react/react-in-jsx-scope": "off",
"react/prop-types": "off",
"react/jsx-no-target-blank": "warn",
"no-unused-vars": "warn"
}
},

{
files: ["*.cjs"],
languageOptions: {
globals: {
module: "readonly",
require: "readonly",
__dirname: "readonly"
}
}
},

{
files: ["**/*.json"],
rules: {
"react/display-name": "off",
"react/jsx-no-target-blank": "off",
"react/react-in-jsx-scope": "off"
}
}
];