import React from 'react'
import { createRoot } from 'react-dom/client'
import RoutesApp from './Routes'
import './index.css'


createRoot(document.getElementById('root')).render(
<React.StrictMode>
<RoutesApp />
</React.StrictMode>
)