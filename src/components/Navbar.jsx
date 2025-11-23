import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'


export default function Navbar() {
const [menuOpen, setMenuOpen] = useState(false)
const [darkMode, setDarkMode] = useState(() => localStorage.getItem('theme') === 'dark')


useEffect(() => {
if (darkMode) {
document.documentElement.classList.add('dark')
localStorage.setItem('theme', 'dark')
} else {
document.documentElement.classList.remove('dark')
localStorage.setItem('theme', 'light')
}
}, [darkMode])


return (
<nav className="sticky top-0 z-40 backdrop-blur-md bg-white/60 dark:bg-gray-900/60 border-b border-gray-200 dark:border-gray-800">
<div className="max-w-6xl mx-auto px-4 py-3 flex items-center justify-between">
<div className="flex items-center space-x-3">
<Link to="/" className="flex items-center space-x-3">
<div className="w-10 h-10 rounded-lg flex items-center justify-center bg-primary-700 text-white font-bold">AH</div>
<div className="font-semibold text-lg">My Portfolio</div>
</Link>
</div>


<div className="hidden md:flex items-center space-x-6">
<Link to="/" className="hover:text-primary-500">Home</Link>
<Link to="/projects" className="hover:text-primary-500">Projects</Link>
<Link to="/contact" className="hover:text-primary-500">Contact</Link>
<button onClick={() => setDarkMode(!darkMode)} className="ml-2 px-3 py-1 rounded-md border border-gray-300 dark:border-gray-700">{darkMode ? 'Light' : 'Dark'}</button>
</div>


<div className="md:hidden">
<button onClick={() => setMenuOpen(!menuOpen)} className="p-2 rounded-md border">☰</button>
</div>
</div>


{menuOpen && (
<div className="md:hidden px-4 pb-4 space-y-2">
<Link to="/" onClick={() => setMenuOpen(false)} className="block py-2">Home</Link>
<Link to="/projects" onClick={() => setMenuOpen(false)} className="block py-2">Projects</Link>
<Link to="/contact" onClick={() => setMenuOpen(false)} className="block py-2">Contact</Link>
<Link to="/about" onClick={() => setMenuOpen(false)} className="block py-2">About</Link>
<button onClick={() => { setDarkMode(!darkMode); setMenuOpen(false) }} className="w-full text-left py-2">{darkMode ? 'Light' : 'Dark'}</button> 
</div>
)}
</nav>
)
}