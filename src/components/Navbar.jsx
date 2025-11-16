import { useState, useEffect } from 'react';


function Navbar() {
  const [menuOpen, setMenuOpen] = useState(false);
  const [darkMode, setDarkMode] = useState(false);

  useEffect(() => {
    if (darkMode) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }, [darkMode]);

  return (
    <nav className="bg-gray-800 dark:bg-gray-900 text-white">
      <div className="max-w-6xl mx-auto px-4 py-3 flex justify-between items-center">
        <h1 className="text-xl font-bold">My Portfolio</h1>
        <button className="md:hidden p-2 border rounded" onClick={() => setMenuOpen(!menuOpen)}>
          ☰
        </button>

        <div className={`md:flex space-x-6 ${menuOpen ? 'block' : 'hidden'} md:block`}>
          <Link
            to="/"
            onClick={() => setMenuOpen(false)}
            className="block py-2 hover:text-blue-400"
          >
            Home
          </Link>
          <Link
            to="/about"
            onClick={() => setMenuOpen(false)}
            className="block py-2 hover:text-blue-400"
          >
            About
          </Link>
          <Link
            to="/projects"
            onClick={() => setMenuOpen(false)}
            className="block py-2 hover:text-blue-400"
          >
            Projects
          </Link>
          <Link
            to="/contact"
            onClick={() => setMenuOpen(false)}
            className="block py-2 hover:text-blue-400"
          >
            Contact
          </Link>
          <button
            onClick={() => setDarkMode(!darkMode)}
            className="ml-4 py-1 px-3 border rounded hover:bg-gray-700"
          >
            {darkMode ? 'Light' : 'Dark'}
          </button>
        </div>
      </div>
    </nav>
  );
}

export default Navbar;
