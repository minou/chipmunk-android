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
        cpdef cpSegmentQueryInfo* info
        if cpShapeSegmentQuery(self._shape, cpv(start.x, start.y), cpv(end.x, end.y), info):
            return SegmentQueryInfo(self, start, end, info.t, info.n)
        else:
            return None


class SegmentQueryInfo(object):
    def __init__(self, shape, start, end, t, n):
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
