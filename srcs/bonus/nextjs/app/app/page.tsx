export default function Home() {
  return (
    <div className="container mx-auto px-4 py-8 relative bg-cover bg-center">
      <h1 className="text-4xl font-bold text-center mb-8 text-white">
        Welcome to my portfolio!
      </h1>
      <p className="text-lg text-white mb-16 text-center">
        Get to know me and my projects.
      </p>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        <div className="bg-gray-800 text-white shadow-lg rounded-lg px-8 py-6 flex flex-col items-center">
          <h2 className="text-2xl font-semibold mb-4">About Me</h2>
          <p className="text-gray-300">
            Hi, I'm Rileone, a passionate web developer with a love for
            creating visually stunning and highly functional websites. With a
            background in backend development, I
            specialize in front-end development using modern technologies like
            React, Next.js, and Tailwind CSS.
          </p>
          <p className="text-gray-300 mt-4">
            My journey began with a fascination for how websites are built and
            evolved into a career where I now help clients bring their digital
            visions to life. I thrive in collaborative environments and enjoy
            solving complex problems with innovative solutions. In my free time,
            I love to go on the slack line and weird shit like that.
          </p>
          <p className="text-gray-300 mt-4">
            Feel free to reach out if you’d like to discuss a project or just
            connect. I'm always open to new opportunities and exciting
            challenges.
          </p>
        </div>

        <div className="bg-gray-800 text-white shadow-lg rounded-lg px-8 py-6">
          <h2 className="text-2xl font-semibold mb-4">Projects</h2>
          <ul className="list-disc pl-6">
            <li className="text-gray-300">
              <a
                href="https://github.com/PapaLeoneIV/42minishell"
                className="text-blue-400 hover:underline transition ease-in-out duration-300 hover:text-blue-300"
              >
                Minishell42
              </a>
            </li>
            <li className="text-gray-300">
              <a
                href="https://github.com/PapaLeoneIV/42minishell"
                className="text-blue-400 hover:underline transition ease-in-out duration-300 hover:text-blue-300"
              >
                restAPIv3
              </a>
            </li>
            <li className="text-gray-300">
              <a
                href="https://github.com/PapaLeoneIV/42-cub3D"
                className="text-blue-400 hover:underline transition ease-in-out duration-300 hover:text-blue-300"
              >
                cub3D
              </a>
            </li>
          </ul>
        </div>
      </div>

      <div className="flex justify-center mt-8">
        <a
          href="mailto:your_email@example.com"
          className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition ease-in-out duration-300"
        >
          Contact
        </a>
      </div>
    </div>
  );
}
