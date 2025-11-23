import { motion } from 'framer-motion'


export default function About() {
return (
<motion.section initial={{ opacity: 0 }} whileInView={{ opacity: 1 }} viewport={{ once: true }} className="px-0 py-8">
<div className="max-w-3xl">
<h2 className="text-2xl font-bold text-primary-500">About</h2>
<p className="mt-4 text-gray-700 dark:text-gray-300">I am a DevSecOps engineer who builds secure, automated delivery systems. I focus on practical testing, policy as code, and reproducible infrastructure.</p>
</div>
</motion.section>
)
}