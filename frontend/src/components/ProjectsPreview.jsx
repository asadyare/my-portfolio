import { Link } from 'react-router-dom'
import Card from './Card'


export default function ProjectsPreview() {
const preview = [
{ title: 'CI/CD Pipeline', description: 'Secure pipeline with policy checks and automated tests.', tags: ['CI', 'Security'] },
{ title: 'IaC Modules', description: 'Reusable Terraform with linting and tests.', tags: ['Terraform'] }
]


return (
<section className="py-10">
<h2 className="text-xl font-bold text-primary-500">Selected projects</h2>
<div className="mt-6 grid gap-6 md:grid-cols-2">
{preview.map((p) => (
<Card key={p.title} title={p.title} description={p.description} tags={p.tags} />
))}
</div>
<div className="mt-6">
<Link to="/projects" className="underline"> View all projects </Link>
</div>
</section>
)
}