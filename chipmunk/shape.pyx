from chipmunk cimport *
from body cimport Body

cdef class Shape:
    def __cinit__(self):
        self._shape = NULL
        self.automanaged = 0
    
    def __dealloc__(self):
        if self.automanaged:
            cpShapeFree(self._shape)

    def _get_sensor(self):
        return self._shape.sensor
    def _set_sensor(self, is_sensor):
        self._shape.sensor = is_sensor
    sensor = property(_get_sensor, _set_sensor)

    def _get_collision_type(self):
        return self._shape.collision_type
    def _set_collision_type(self, t):
        self._shape.collision_type = t
    collision_type = property(_get_collision_type, _set_collision_type)

    def _get_group(self):
        return self._shape.group
    def _set_group(self, group):
        self._shape.group = group
    group = property(_get_group, _set_group)

    def _get_elasticity(self):
        return self._shape.e
    def _set_elasticity(self, e):
        self._shape.e = e
    elasticity = property(_get_elasticity, _set_elasticity)

    def _get_friction(self):
        return self._shape.u
    def _set_friction(self, u):
        self._shape.u = u
    friction = property(_get_friction, _set_friction)

    def _get_surface_velocity(self):
        return self._shape.surface_v
    def _set_surface_velocity(self, surface_v):
        self._shape.surface_v = cpv(surface_v.x, surface_v.y)
    surface_velocity = property(_get_surface_velocity, _set_surface_velocity)

    body = property(lambda self: self._body)

    def cache_bb(self):
        return cpShapeCacheBB(self._shape)

    def point_query(self, p):
        return cpShapePointQuery(self._shape, cpv(p.x, p.y))

    def segment_query(self, start, end):
        cdef cpSegmentQueryInfo* info
        if cpShapeSegmentQuery(self._shape, cpv(start.x, start.y), cpv(end.x, end.y), info):
            return SegmentQueryInfo(self, start, end, info.t, info.n)
        else:
            return None


cdef class Circle(Shape):
    def __cinit__(self, Body body, cpFloat radius, offset = (0, 0)):
        self._body = body
        self._shape = cpCircleShapeNew(body._body, radius, cpv(offset.x, offset.y))
        #self._cs = ct.cast(self._shape, ct.POINTER(cp.cpCircleShape))

    def unsafe_set_radius(self, r):
        cpCircleShapeSetRadius(self._shape, r)

    #def _get_radius(self):
    #    return cpCircleShapeGetRadius(self._shape)
    #radius = property(_get_radius)

    def unsafe_set_offset(self, o):
        cpCircleShapeSetOffset(self._shape, cpv(o.x, o.y))

    #def _get_offset (self):
    #    return cp.cpCircleShapeGetOffset(self._shape)
    #offset = property(_get_offset)


cdef class Segment(Shape):
    def __cinit__(self, Body body, a, b, cpFloat radius):
        self._body = body
        self._shape = cpSegmentShapeNew(body._body, cpv(a.x, a.y), cpv(b.x, b.y), radius)
        #self._segment_shape.shape = self._shape

    def _set_a(self, a):
        self._segment_shape.a = cpv(a.x, a.y)
    def _get_a(self):
        return self._segment_shape.a
    a = property(_get_a, _set_a)

    #def _set_b(self, b):
    #    ct.cast(self._shape, ct.POINTER(cp.cpSegmentShape)).contents.b = b
    #def _get_b(self):
    #    return ct.cast(self._shape, ct.POINTER(cp.cpSegmentShape)).contents.b
    #b = property(_get_b, _set_b)

    #def _set_radius(self, r):
    #    ct.cast(self._shape, ct.POINTER(cp.cpSegmentShape)).contents.r = r
    #def _get_radius(self):
    #    return ct.cast(self._shape, ct.POINTER(cp.cpSegmentShape)).contents.r
    #radius = property(_get_radius, _set_radius)


cdef class Poly(Shape):
    def __cinit__(self, body, vertices, offset=(0, 0), auto_order_vertices=True):
        self._body = body
        self.offset = offset
        #self.verts = (Vec2d * len(vertices))
        #self.verts = self.verts(Vec2d(0, 0))
 
        i_vs = enumerate(vertices)
        #if auto_order_vertices and not u.is_clockwise(vertices):
        #    i_vs = zip(range(len(vertices)-1, -1, -1), vertices)
 
        for (i, vertex) in i_vs:
            self.verts[i].x = vertex[0]
            self.verts[i].y = vertex[1]

        #self._shape = cpPolyShapeNew(body._body, len(vertices), self.verts, offset)


    #@staticmethod
    #def create_box(body, size=(10,10)):
    #    x,y = size[0]*.5,size[1]*.5
    #    vs = [(-x,-y),(-x,y),(x,y),(x,-y)]
    #    return Poly(body,vs)

    #def get_points(self):
    #    points = []
    #    rv = self._body.rotation_vector
    #    bp = self._body.position
    #    vs = self.verts
    #    o = self.offset
    #    for i in range(len(vs)):
    #        p = (vs[i]+o).cpvrotate(rv)+bp
    #        points.append(Vec2d(p))
    #    return points


cdef class SegmentQueryInfo:
    def __cinit__(self, shape, start, end, t, n):
        self._shape = shape
        self._t = t
        self._n = n
        self._start = start
        self._end = end
        
    def __repr__(self):
        return "SegmentQueryInfo(%s, %s, %s, %s, %s)" % (self.shape, self._start, self._end, self.t, self.n)

    shape = property(lambda self: self._shape)
    t = property(lambda self: self._t)
    n = property(lambda self: self._n)

    #def get_hit_point(self):
    #    return Vec2d(self._start).interpolate_to(self._end, self.t)

    #def get_hit_distance(self):
    #    return Vec2d(self._start).get_distance(self._end) * self.t
