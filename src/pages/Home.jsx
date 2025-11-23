import Hero from '../components/Hero'
import About from '../components/About'
import ProjectsPreview from '../components/ProjectsPreview'


export default function Home() {
return (
<div className="space-y-16 py-12">
<Hero />
<About />
<ProjectsPreview />
</div>
)
}