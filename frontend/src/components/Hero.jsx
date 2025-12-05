import { motion } from 'framer-motion'


export default function Hero() {
return (
<section className="pt-12">
<motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6 }} className="grid gap-8 md:grid-cols-2 items-center">
<div>
<h1 className="text-4xl font-extrabold text-primary-500 leading-tight">Secure pipelines, faster delivery</h1>
<p className="mt-4 text-gray-700 dark:text-gray-300">I build automated CI pipelines with security in mind. I merge infrastructure, policy, and testing into reliable releases.</p>
<div className="mt-6 flex items-center space-x-4">
<a href="/projects" className="bg-secondary-700 text-white px-5 py-2 rounded-xl shadow">View projects</a>
<a href="/contact" className="px-5 py-2 rounded-xl border border-gray-300 dark:border-gray-700">Contact</a>
</div>
</div>


<motion.div initial={{ scale: 0.98, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} transition={{ duration: 0.7 }} className="bg-linear-to-br from-primary-500 to-indigo-500 rounded-3xl p-6 text-white shadow-xl">
<div className="text-sm font-medium opacity-90">Featured</div>
<h3 className="mt-4 text-2xl font-bold">Portfolio overview</h3>
<p className="mt-2 opacity-90">Highlights of CI/CD, IaC, and security automations.</p>
<div className="mt-4 grid grid-cols-2 gap-3">
<div className="bg-white/10 p-3 rounded-lg">CI/CD</div>
<div className="bg-white/10 p-3 rounded-lg">Terraform</div>
<div className="bg-white/10 p-3 rounded-lg">Security</div>
<div className="bg-white/10 p-3 rounded-lg">Testing</div>
</div>
</motion.div>
</motion.div>
</section>
)
}