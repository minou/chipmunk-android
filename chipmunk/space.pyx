from chipmunk cimport *
from body cimport Body
from shape cimport Shape

cdef class Space:
    def __cinit__(self, int iterations = 10):
        self._space = cpSpaceNew()
        self._space.iterations = iterations
        self._static_body = Body(autocreate = 0)
        
        self._static_body._body = &self._space.staticBody

        #self._handlers = {}
        #self._default_handler = None
        #self._post_step_callbacks = {}
        self._shapes = []
        self._static_shapes = []
        self._bodies = []
        self._constraints = []
        #self._bodies = set()
        #self._constraints = set()
    
    def __dealloc__(self):
        self._static_body = None
        cpSpaceFree(self._space)
   

    def _get_shapes(self):
        return list(self._shapes.values())
    shapes = property(_get_shapes)

    def _get_static_shapes(self):
        return list(self._static_shapes.values())
    static_shapes = property(_get_static_shapes)

    def _get_bodies(self):
        return list(self._bodies)
    bodies = property(_get_bodies)

    #def _get_constraints(self):
    #    return list(self._constraints)
    #constraints = property(_get_constraints)

    def _get_static_body(self):
        return self._static_body
    static_body = property(_get_static_body)

    def _set_iterations(self, iterations):
        self._space.iterations = iterations
    def _get_iterations(self):
        return self._space.iterations
    iterations = property(_get_iterations, _set_iterations)

    def _set_gravity(self, gravity_vec):
        self._space.gravity = cpv(gravity_vec.x, gravity_vec.y)
    def _get_gravity(self):
        return self._space.gravity
    gravity = property(_get_gravity, _set_gravity)

    def _set_damping(self, damping):
        self._space.damping = damping
    def _get_damping(self):
        return self._space.damping
    damping = property(_get_damping, _set_damping)

    def _set_idle_speed_threshold(self, idle_speed_threshold):
        self._space.idleSpeedThreshold = idle_speed_threshold
    def _get_idle_speed_threshold(self):
        return self._space.idleSpeedThreshold
    idle_speed_threshold = property(_get_idle_speed_threshold, _set_idle_speed_threshold)

    def _set_sleep_time_threshold(self, sleep_time_threshold):
        self._space.sleepTimeThreshold = sleep_time_threshold
    def _get_sleep_time_threshold(self):
        return self._space.sleepTimeThreshold
    sleep_time_threshold = property(_get_sleep_time_threshold, _set_sleep_time_threshold)

    def _set_collision_slop(self, collision_slop):
        self._space.collisionSlop = collision_slop
    def _get_collision_slop(self):
        return self._space.collisionSlop
    collision_slop = property(_get_collision_slop, _set_collision_slop)

    def _set_collision_bias(self, collision_bias):
        self._space.collisionBias = collision_bias
    def _get_collision_bias(self):
        return self._space.collisionBias
    collision_bias = property(_get_collision_bias, _set_collision_bias)

    def _set_collision_persistence(self, collision_persistence):
        self._space.collisionPersistence = collision_persistence
    def _get_collision_persistence(self):
        return self._space.collisionPersistence
    collision_persistence = property(_get_collision_persistence, _set_collision_persistence)

    def _set_enable_contact_graph(self, enable_contact_graph):
        self._space.enableContactGraph = enable_contact_graph
    def _get_enable_contact_graph(self):
        return self._space.enableContactGraph
    enable_contact_graph = property(_get_enable_contact_graph, _set_enable_contact_graph)
    

    def add(self, *objs):
        for o in objs:
            if isinstance(o, Body):
                self._add_body(o)
            elif isinstance(o, Shape):
                self._add_shape(o)
            #elif isinstance(o, Constraint):
            #    self._add_constraint(o)
            else:
                for oo in o:
                    self.add(oo)
                    
    def add_static(self, *objs):
        for o in objs:
            if isinstance(o, Shape):
                self._add_static_shape(o)
            else:
                for oo in o:
                    self.add_static(oo)

    def _add_shape(self, Shape shape):
        assert shape._hashid_private not in self._shapes, "shape already added to space"
        self._shapes[shape._hashid_private] = shape
        cpSpaceAddShape(self._space, shape._shape)

    def _add_static_shape(self, Shape static_shape):
        assert static_shape._hashid_private not in self._static_shapes, "shape already added to space"
        self._static_shapes[static_shape._hashid_private] = static_shape
        cpSpaceAddStaticShape(self._space, static_shape._shape)

    def _add_body(self, Body body):
        assert body not in self._bodies, "body already added to space"
        self._bodies.add(body)
        cpSpaceAddBody(self._space, body._body)

    def _add_constraint(self, constraint):
        assert constraint not in self._constraints, "constraint already added to space"
        self._constraints.add(constraint)
    #    cpSpaceAddConstraint(self._space, constraint._constraint)


    def remove(self, *objs):
        for o in objs:
            if isinstance(o, Body):
                self._remove_body(o)
            elif isinstance(o, Shape):
                self._remove_shape(o)
            #elif isinstance(o, Constraint):
            #    self._remove_constraint(o)
            else:
                for oo in o:
                    self.remove(oo)

    def remove_static(self, *objs):
        for o in objs:
            if isinstance(o, Shape):
                self._remove_static_shape(o)
            else:
                for oo in o:
                    self.remove_static(oo)

    def _remove_shape(self, Shape shape):
        del self._shapes[shape._hashid_private]
        cpSpaceRemoveShape(self._space, shape._shape)

    def _remove_static_shape(self, Shape static_shape):
        del self._static_shapes[static_shape._hashid_private]
        cpSpaceRemoveStaticShape(self._space, static_shape._shape)

    def _remove_body(self, Body body):
        self._bodies.remove(body)
        cpSpaceRemoveBody(self._space, body._body)

    def _remove_constraint(self, constraint):
        self._constraints.remove(constraint)
    #    cpSpaceRemoveConstraint(self._space, constraint._constraint)


    def reindex_static(self):
        cpSpaceReindexStatic(self._space)

    def reindex_shape(self, Shape shape):
        cpSpaceReindexShape(self._space, shape._shape)
        
    def step(self, dt):
        cpSpaceStep(self._space, dt)
        for obj, (func, args, kwargs) in self._post_step_callbacks.items():
            func(obj, *args, **kwargs)
        self._post_step_callbacks = {}

    #def add_collision_handler(self, a, b, begin=None, pre_solve=None, post_solve=None, separate=None, *args, **kwargs):
    #    _functions = self._collision_function_helper(begin, pre_solve, post_solve, separate, *args, **kwargs)
    #    self._handlers[(a, b)] = _functions
    #    cpSpaceAddCollisionHandler(self._space, a, b, 
    #        _functions[0], _functions[1], _functions[2], _functions[3], None)
        
    #def set_default_collision_handler(self, begin=None, pre_solve=None, post_solve=None, separate=None, *args, **kwargs):
    #    _functions = self._collision_function_helper(
    #        begin, pre_solve, post_solve, separate, *args, **kwargs
    #        )
    #    self._default_handler = _functions
    #    cpSpaceSetDefaultCollisionHandler(self._space,
    #        _functions[0], _functions[1], _functions[2], _functions[3], None)
