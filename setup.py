from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize


setup(
    name = "chipmunk-android",
    description = "Cython bindings for Chipmunk",
    author = "Nicolas Niemczycki",
    author_email="niemczycki.nicolas@gmail.com",
    cmdclass = {'build_ext': build_ext},
    ext_modules = cythonize(Extension('cymunk', ['chipmunk/chipmunk.pyx', 'chipmunk/body.pyx', 'chipmunk/shape.pyx', 'chipmunk/space.pyx']))
)
