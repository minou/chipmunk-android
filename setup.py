from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

CHIPMUNK_LIBNAME = "chipmunk"

ext_modules = [
    Extension('chipmunk.chipmunk', ['chipmunk/chipmunk.pyx'], libraries = [CHIPMUNK_LIBNAME]),
    Extension("chipmunk.body", ['chipmunk/body.pyx'], libraries = [CHIPMUNK_LIBNAME]),
    Extension('chipmunk.shape', ['chipmunk/shape.pyx'], libraries = [CHIPMUNK_LIBNAME]),
    Extension('chipmunk.space', ['chipmunk/space.pyx'], libraries = [CHIPMUNK_LIBNAME]),
]

setup(
    name = "chipmunk-android",
    description = "Cython bindings for Chipmunk",
    author = "Nicolas Niemczycki",
    author_email="niemczycki.nicolas@gmail.com",
    cmdclass = {'build_ext': build_ext},
    ext_modules = ext_modules,
)
