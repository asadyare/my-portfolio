import data from '../data/projects.json'

function Projects() {
  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold mb-6">Projects</h1>
      <div className="grid gap-6 sm:grid-cols-2">
        {data.map((project, index) => (
          <div key={index} className="p-4 border rounded-lg shadow hover:shadow-lg">
            <h2 className="text-xl font-semibold mb-2">{project.name}</h2>
            <p className="mb-2">{project.description}</p>
            <div className="mb-2">
              {project.badges.map((badge, i) => (
                <span key={i} className="text-sm bg-blue-200 text-blue-800 px-2 py-1 mr-2 rounded">
                  {badge}
                </span>
              ))}
            </div>
            <div className="text-sm text-gray-700">
              Tools: {project.tools.join(", ")}
            </div>
            <a
              href={project.github}
              target="_blank"
              rel="noopener noreferrer"
              className="block mt-3 text-blue-600 hover:underline"
            >
              GitHub Repo
            </a>
          </div>
        ))}
      </div>
    </div>
  )
}

export default Projects
