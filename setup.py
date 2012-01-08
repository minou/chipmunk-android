from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize

CHIPMUNK_LIBNAME = "chipmunk"

setup(
    name = "chipmunk-android",
    description = "Cython bindings for Chipmunk",
    author = "Nicolas Niemczycki",
    author_email="niemczycki.nicolas@gmail.com",
    cmdclass = {'build_ext': build_ext},
    ext_modules = cythonize(Extension('chipmunk', ['chipmunk/chipmunk.pyx', 'chipmunk/body.pyx', 'chipmunk/shape.pyx', 'chipmunk/space.pyx'], libraries = [CHIPMUNK_LIBNAME]))
)
