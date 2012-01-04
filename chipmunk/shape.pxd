from chipmunk cimport *

cdef extern from "chipmunk/chipmunk.h":
    void cpShapeDestroy(cpShape *shape)
    void cpShapeFree(cpShape *shape)

    cpBB cpShapeCacheBB(cpShape *shape)
    cpBool cpShapePointQuery(cpShape *shape, cpVect p)

    cpBool cpShapeSegmentQuery(cpShape *shape, cpVect a, cpVect b, cpSegmentQueryInfo *info)


cdef class Shape:
    cdef cpShape* _shape
    cdef int automanaged
