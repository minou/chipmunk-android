from chipmunk cimport *
from body cimport Body

cdef extern from "chipmunk/chipmunk.h":
    ctypedef struct cpSegmentShape:
        cpShape shape
        cpVect a, b, n
        cpVect ta, tb, tn
        cpFloat r
        cpVect a_tangent, b_tangent

    void cpShapeDestroy(cpShape *shape)
    void cpShapeFree(cpShape *shape)

    cpBB cpShapeCacheBB(cpShape *shape)
    cpBool cpShapePointQuery(cpShape *shape, cpVect p)

    cpBool cpShapeSegmentQuery(cpShape *shape, cpVect a, cpVect b, cpSegmentQueryInfo *info)

    cpShape cpCircleShape
    CP_DeclareShapeGetter(cpCircleShape, cpFloat, Radius)
    cpShape* cpCircleShapeNew(cpBody *body, cpFloat radius, cpVect offset)
    void cpCircleShapeSetRadius(cpShape *shape, cpFloat radius)
    void cpCircleShapeSetOffset(cpShape *shape, cpVect offset)

    cpShape* cpSegmentShapeNew(cpBody *body, cpVect a, cpVect b, cpFloat radius)


    cpShape* cpPolyShapeNew(cpBody *body, int numVerts, cpVect *verts, cpVect offset)


cdef class Shape:
    cdef cpShape* _shape
    cdef int automanaged


cdef class Circle(Shape):
    cdef Body _body
    

cdef class Segment(Shape):
    cdef Body _body
    cdef cpSegmentShape* _segment_shape


cdef class Poly(Shape):
    cdef Body _body
