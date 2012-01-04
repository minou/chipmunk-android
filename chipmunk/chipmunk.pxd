ctypedef int bool

cdef extern from "chipmunk/chipmunk.h":
    cdef void cpInitChipmunk()

    ctypedef float cpFloat 
    cpFloat INFINITY
    ctypedef struct cpVect:
        cpFloat x,y
    ctypedef void* cpDataPointer
    ctypedef bool cpBool
    ctypedef int cpGroup
    ctypedef int cpLayers
    ctypedef int cpCollisionType
    ctypedef struct cpBB:
        cpFloat l, b, r ,t
    cpVect cpv(cpFloat x, cpFloat y)


    ctypedef struct cpBody:
        # Mass of the body
        cpFloat m
        # Mass inverse
        cpFloat m_inv
        # Moment of inertia of the body
        cpFloat i
        # Moment of inertia inverse
        cpFloat i_inv
        # Position of the rigid body's center of gravity
        cpVect p
        # Velocity of the rigid body's center of gravity
        cpVect v
        # Force acting on the rigid body's center of gravity
        cpVect f
        # Rotation of the body around it's center of gravity in radians
        cpFloat a
        # Angular velocity of the body around it's center of gravity in radians/second
        cpFloat w
        # Torque applied to the body around it's center of gravity
        cpFloat t
        # Cached unit length vector representing the angle of the body
        cpVect rot
        # User definable data pointer
        cpDataPointer data
        # Maximum velocity allowed when updating the velocity
        cpFloat v_limit
        # Maximum rotational rate (in radians/second) allowed when updating the angular velocity
        cpFloat w_limit


    ctypedef struct cpShape:
        # The rigid body this collision shape is attached to
        cpBody *body
        # The current bounding box of the shape
        cpBB bb
        # Sensor flag
        cpBool sensor
        # Coefficient of restitution (elasticity)
        cpFloat e
        # Coefficient of friction
        cpFloat u
        # Surface velocity used when solving for friction
        cpVect surface_v
        # User definable data pointer
        cpDataPointer data
        # Collision type of this shape used when picking collision handlers
        cpCollisionType collision_type
        # Group of this shape. Shapes in the same group don't collide
        cpGroup group


    ctypedef struct cpSegmentQueryInfo:
        # The shape that was hit, NULL if no collision occured
        cpShape *shape
        # The normalized distance along the query segment in the range [0, 1]
        cpFloat t
        # The normal of the surface hit
        cpVect n
