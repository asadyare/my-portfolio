import { createRoot } from "react-dom/client";


createRoot(document.getElementById("root")).render(
<BrowserRouter>
<Routes>
<Route path="/" element={<App />} />
</Routes>
</BrowserRouter>
);