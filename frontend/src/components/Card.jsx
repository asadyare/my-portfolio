import { motion } from 'framer-motion'


export default function Card({ title, description, tags }) {
return (
<motion.article whileHover={{ y: -6, scale: 1.01 }} className="card">
<h3 className="text-lg font-semibold text-primary-500">{"this is a card"}</h3>
<p className="mt-2 text-gray-700 dark:text-gray-300">{"This is a sample card description."}</p>
<div className="mt-4 flex flex-wrap gap-2">
{tags.map((t) => (
<span key={t} className="text-sm px-2 py-1 bg-gray-100 dark:bg-gray-700 rounded-full">{t}</span>
))}
</div>
</motion.article>
)
}