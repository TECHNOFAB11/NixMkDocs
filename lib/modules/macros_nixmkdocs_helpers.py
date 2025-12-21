import os

def define_env(env):
    @env.macro
    def include_raw(filename):
        """
        Reads a file and returns its content as a string, bypassing Jinja evaluation.
        """
        include_dir = env.config['include_dir']
        file_path = os.path.join(include_dir, filename)

        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
