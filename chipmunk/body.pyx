from chipmunk cimport *

cdef class Body:
    def __cinit__(self, float mass = None, float moment = None):
        if mass == None and moment == None:
            self._body = cpBodyNewStatic()
        else:
            self._body = cpBodyNew(mass, moment)
            self.automanaged = 1
        #self._position_callback = None
        #self._velocity_callback = None
    
    def __dealloc__(self):
        if self.automanaged:
            cpBodyFree(self._body)


    def _set_mass(self, mass):
        cpBodySetMass(self._body, mass)
    def _get_mass(self):
        return self._body.m
    mass = property(_get_mass, _set_mass)

    
    def _set_moment(self, moment):
        cpBodySetMoment(self._body, moment)
    def _get_moment(self):
        return self._bodycontents.i
    moment = property(_get_moment, _set_moment) 

    def _set_angle(self, angle):
        cpBodySetAngle(self._body, angle)
    def _get_angle(self):
        return self._body.a
    angle = property(_get_angle, _set_angle)

    def _get_rotation_vector(self):
        return self._bodycontents.rot
    rotation_vector = property(_get_rotation_vector)

    def _set_torque(self, t):
        self._body.t = t
    def _get_torque(self):
        return self._body.t
    torque = property(_get_torque, _set_torque)

    def _set_position(self, pos):
        self._body.p = cpv(pos.x, pos.y)
    def _get_position(self):
        return self._body.p
    position = property(_get_position, _set_position)

    def _set_velocity(self, vel):
        self._body.v = cpv(vel.x, vel.y)
    def _get_velocity(self):
        return self._body.v
    velocity = property(_get_velocity, _set_velocity)

    def _set_velocity_limit(self, vel):
        self._body.v_limit = vel
    def _get_velocity_limit(self):
        return self._body.v_limit
    velocity_limit = property(_get_velocity_limit, _set_velocity_limit)

    def _set_angular_velocity(self, w):
        self._body.w = w
    def _get_angular_velocity(self):
        return self._body.w
    angular_velocity = property(_get_angular_velocity, _set_angular_velocity)

    def _set_angular_velocity_limit(self, w):
        self._body.w_limit = w
    def _get_angular_velocity_limit(self):
        return self._body.w_limit
    angular_velocity_limit = property(_get_angular_velocity_limit, _set_angular_velocity_limit)

    def _set_force(self, f):
        self._body.f = cpv(f.x, f.y)
    def _get_force(self):
        return self._body.f
    force = property(_get_force, _set_force)

    #def _set_velocity_func(self, func):
    #    def _impl(_, gravity, damping, dt):
    #        return func(self, gravity, damping, dt)

    #    self._velocity_callback = cpBodyVelocityFunc(_impl)
    #    self._bodycontents.velocity_func = self._velocity_callback
    #velocity_func = property(fset=_set_velocity_func)
    # 
    # def _set_position_func(self, func):
    #
    # def _set_position_func(self, func):
    #

    #@staticmethod
    #@classmethod
    #def update_velocity(body, gravity, damping, dt):
    #    cpBodyUpdateVelocity(body._body, cpv(gravity.x, gravity.y), damping, dt)

    #@staticmethod
    #@classmethod
    #def update_position(body, dt):
    #    cpBodyUpdatePosition(body._body, dt)

    def apply_impulse(self, j, r=(0, 0)):
        cpBodyApplyImpulse(self._body, cpv(j.x, j.y), cpv(r.x, r.y))


    def reset_forces(self):
        cpBodyResetForces(self._body)
    def apply_force(self, f, r=(0, 0)):
        cpBodyApplyForce(self._body, cpv(f.x, f.y), cpv(r.x, r.y))

    #def apply_damped_spring(self, b, anchor1, anchor2, rlen, k, dmp, dt):
    #    cpApplyDampedSpring(self._body, b._body, anchor1, anchor2, rlen, k, dmp, dt)
    
    def activate(self):
        cpBodyActivate(self._body)
        
    def sleep(self):
        cpBodySleep(self._body)
        
    #def sleep_with_group(self, body):
    #    cpBodySleepWithGroup(self._body, body._body)

    def _is_sleeping(self):
        return cpBodyIsSleeping(self._body)
    is_sleeping = property(_is_sleeping)

    def _is_rogue(self):
        return cpBodyIsRogue(self._body)
    is_rogue = property(_is_rogue)

    def _is_static(self):
        return cpBodyIsStatic(self._body)
    is_static = property(_is_static)

    def local_to_world(self, v):
        return cpBodyLocal2World(self._body, cpv(v.x, v.y))

    def world_to_local(self, v):
        return cpBodyWorld2Local(self._body, cpv(v.x, v.y))
