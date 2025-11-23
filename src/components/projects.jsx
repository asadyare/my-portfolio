import Card from './Card'


export default function Projects() {
const items = [
{ title: 'CI/CD Pipeline', description: 'Secure pipeline with policy checks and automated tests.', tags: ['CI', 'Security', 'Testing'] },
{ title: 'Infrastructure as Code', description: 'Reusable Terraform modules with validation checks.', tags: ['Terraform', 'IaC'] },
{ title: 'Threat Modelling', description: 'Automated threat scans integrated into CI.', tags: ['Security'] }
]


return (
<section className="py-10">
<h2 className="text-2xl font-bold text-primary-500">Projects</h2>
<div className="mt-6 grid gap-6 md:grid-cols-2 lg:grid-cols-3">
{items.map((it) => (
<Card key={it.title} title={it.title} description={it.description} tags={it.tags} />
))}
</div>
</section>
)
}