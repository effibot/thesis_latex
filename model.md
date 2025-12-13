# Bi-Steerable Robot

## Configuration

- 4 wheels
- Front-left and rear-right wheels are actuated and steerable
- Front-right and rear-left wheels are passive casters
- Robot frame located at the center of the robot, with $X^b$ axis pointing forward, and $Y^b$ axis pointing to the left side of the robot
- Inertial frame located at the starting position of the robot, with $X_g$ axis pointing forward, and $Y_g$ axis pointing to the left side of the robot
- Robot dimensions:
  - Length: $L$
  - Width: $W$
- The wheel angular velocities are $\omega_f$ and $\omega_r$ for the front-left and rear-right wheels, respectively. They are assumed positive when the wheels move forward (versor of rotation aligned with Y-axis).
- The steering angles are $\delta_f$ and $\delta_r$ for the front-left and rear-right wheels, respectively. They are defined as the angle between the wheel axis and the robot longitudinal axis, positive counter-clockwise.
- The actuators have a dynamic model that is approximated as a first-order system with time constant $\tau$.
$$
\begin{aligned}
\dot{\omega}_i &= \frac{1}{\tau}(\omega_{i_{cmd}} - \omega_i) \quad i \in \{f, r\}\\
\dot{\delta}_i &= \frac{1}{\tau}(\delta_{i_{cmd}} - \delta_i) \quad i \in \{f, r\}
\end{aligned}
$$
Where $\omega_{i_{cmd}}$ and $\delta_{i_{cmd}}$ are the control inputs computed by the control algorithm.

```bash
 Yg
 ^            ^ Yb
 |            |
 |  +---------+---------O (Front Left Wheel) (L/2, W/2)
 |  |         |         |
 |  |         |         |
 |  |    (center)-------|---> Xb (robot heading)
 |  |                   |
 |  O-------------------+
 |  (Rear Right Wheel) (-L/2, -W/2)
 |
(Global)------------------> Xg
```

> **Note**: the frames are not drawn overlapped for clarity.

## Position and Velocity of the wheels

In the robot frame, the position of the front-left and rear-right wheel are given by:
$$
\begin{equation*}
\begin{aligned}
p_f &= d\begin{bmatrix}
cos(\alpha)\\
sin(\alpha)
\end{bmatrix}
\quad
&p_r &= -d\begin{bmatrix}
cos(\alpha)\\
sin(\alpha)
\end{bmatrix}\\
\alpha &= \arctan2(W, L) \quad&
d &= \sqrt{\left(\frac{L}{2}\right)^2 + \left(\frac{W}{2}\right)^2}
\end{aligned}
\end{equation*}
$$
Since the mounting points of the wheels are fixed with respect to the robot frame, their velocities can be computed as:
$$
v_i = v + \omega \times p_i= v+
\dot{\theta}
\begin{bmatrix} 
0\\
0\\
1
\end{bmatrix}\times 
\begin{bmatrix}
p_{i_x}\\
p_{i_y}\\
0
\end{bmatrix} =v+
\dot{\theta}
\begin{bmatrix}
-p_{i_y}\\
p_{i_x}\\
0 
\end{bmatrix} \quad i \in \{f, r\}
$$
Where $v = [\dot{x}, \dot{y}]^T$ is the linear velocity of the robot in the robot frame, and $\omega = [0, 0, \dot{\theta}]^T$ is the angular velocity of the robot. Thus, expanding the position to simplify the expression, we have:
$$
\begin{equation*}
v_f = \begin{bmatrix}
\dot{x} - \dot{\theta} \frac{W}{2}\\
\dot{y} + \dot{\theta} \frac{L}{2}
\end{bmatrix}
\quad
v_r = \begin{bmatrix}
\dot{x} + \dot{\theta} \frac{W}{2}\\
\dot{y} - \dot{\theta} \frac{L}{2}
\end{bmatrix}
\end{equation*}
$$
Now let's distinguish the coordinates and let $x^g, y^g$ the coordinates in the inertial frame, and $x^b, y^b$ the coordinates in the robot (body) frame. 
To get back into the inertial frame, we need to anti-rotate of the robot orientation ($\theta$). Naming $R(\theta)$ the rotation matrix, and recalling that the inverse is its transpose, or a rotation of $-\theta$, we have:
$$
\begin{equation*}
\begin{aligned}
\begin{bmatrix}
\dot{x}^b\\
\dot{y}^b
\end{bmatrix} &= R(-\theta)
\begin{bmatrix}
\dot{x}\\
\dot{y}
\end{bmatrix} =
\begin{bmatrix}
\cos(\theta) & \sin(\theta)\\
-\sin(\theta) & \cos(\theta)
\end{bmatrix}
\begin{bmatrix}
\dot{x}\\
\dot{y}
\end{bmatrix}\\
&= \begin{bmatrix}
\dot{x}\cos(\theta) + \dot{y}\sin(\theta)\\
-\dot{x}\sin(\theta) + \dot{y}\cos(\theta)
\end{bmatrix}
\end{aligned}
\end{equation*}
$$
Conversely, for the speeds at the $i-$th wheel in the inertial frame, we have $v_i^g = R(\theta)v_{i^b}$. 
$$
\begin{equation*}
\begin{aligned}
v_i^g &= R(\theta)v_{i^b} =
\begin{bmatrix}
\cos(\theta) & -\sin(\theta)\\
\sin(\theta) & \cos(\theta)
\end{bmatrix}
\begin{bmatrix}
\dot{x}^b \mp \dot{\theta} \frac{W}{2}\\
\dot{y}^b \pm \dot{\theta} \frac{L}{2}
\end{bmatrix} \quad i \in \{f, r\}
\\
&=\begin{bmatrix}
(\dot{x}^b \mp \dot{\theta} \frac{W}{2})\cos(\theta) - (\dot{y}^b \pm \dot{\theta} \frac{L}{2})\sin(\theta)\\
(\dot{x}^b \mp \dot{\theta} \frac{W}{2})\sin(\theta) + (\dot{y}^b \pm \dot{\theta} \frac{L}{2})\cos(\theta)
\end{bmatrix}
\end{aligned}
\end{equation*}
$$
From the obtained expressions, we can substitute the body velocities and get the speeds at each wheel in the inertial frame.
- For the $x$ component
$$
\begin{equation*}
\begin{aligned}
v_{i_x}^g &= \left(\dot{x}\cos(\theta) + \dot{y}\sin(\theta) \mp \dot{\theta} \frac{W}{2}\right)\cos(\theta) - \left(-\dot{x}\sin(\theta) + \dot{y}\cos(\theta) \pm \dot{\theta} \frac{L}{2}\right)\sin(\theta)\\
&= \dot{x}\cos^2(\theta) + \dot{y}\sin(\theta)\cos(\theta) \mp \dot{\theta} \frac{W}{2}\cos(\theta) + \dot{x}\sin^2(\theta) - \dot{y}\sin(\theta)\cos(\theta) \mp \dot{\theta} \frac{L}{2}\sin(\theta)\\
&= \dot{x} \mp \dot{\theta}\left(\frac{W}{2}\cos(\theta) + \frac{L}{2}\sin(\theta)\right)
\end{aligned}
\end{equation*}
$$
- For the $y$ component
$$
\begin{equation*}
\begin{aligned}
v_{i_y}^g &= \left(\dot{x}\cos(\theta) + \dot{y}\sin(\theta) \mp \dot{\theta} \frac{W}{2}\right)\sin(\theta) + \left(-\dot{x}\sin(\theta) + \dot{y}\cos(\theta) \pm \dot{\theta} \frac{L}{2}\right)\cos(\theta)\\
&= \dot{x}\cos(\theta)\sin(\theta) + \dot{y}\sin^2(\theta) \mp \dot{\theta} \frac{W}{2}\sin(\theta) - \dot{x}\sin(\theta)\cos(\theta) + \dot{y}\cos^2(\theta) \pm \dot{\theta} \frac{L}{2}\cos(\theta)\\
&= \dot{y} \pm \dot{\theta}\left(-\frac{W}{2}\sin(\theta) + \frac{L}{2}\cos(\theta)\right)
\end{aligned}
\end{equation*}
$$

## Forward Kinematic Model

### Non-slipping constraints

The core for a mobile robot is to avoid slipping of the wheels. This means that the lateral velocity at each wheel must be zero, or, that the tangential component of the velocity at each wheel is orthogonal to the wheel rotation axis.

Now, to enforce the non-slipping condition, we need to find the versor orthogonal to the wheel rotation axis. Since the steering angle is defined as the angle between the wheel axis and the robot longitudinal axis, it's defined as it is in the robot frame, so it's easier to compute the no-slip condition in this frame. The versor orthogonal to the wheel axis is then:
$$
n_i = 
\begin{bmatrix}
-\sin(\delta_i)\\
\cos(\delta_i)
\end{bmatrix} \quad i \in \{f, r\}
$$
Thus, the non-slipping condition can be expressed as:
$$
n_i^T v_i^b = 0 \quad i \in \{f, r\}
$$
Expanding the expression, we have:
$$
\begin{equation*}
-\sin(\delta_i)\left(\dot{x}^b \mp \dot{\theta} \frac{W}{2}\right) + \cos(\delta_i)\left(\dot{y}^b \pm \dot{\theta} \frac{L}{2}\right) = 0 \quad i \in \{f, r\}
\end{equation*}
$$

Now we can join the constraints equations together to form the complete kinematic model of the robot with non-slipping wheels in the form of $A^\top(q)\dot{q} = 0$, where $q = [x, y, \theta]^T$ is the state vector.

$$
A(q)^\top=\begin{bmatrix}- \sin{\left(\delta_{f}{\left(t \right)} \right)} & \cos{\left(\delta_{f}{\left(t \right)} \right)} & \frac{L \cos{\left(\delta_{f}{\left(t \right)} \right)}}{2} + \frac{W \sin{\left(\delta_{f}{\left(t \right)} \right)}}{2}\\- \sin{\left(\delta_{r}{\left(t \right)} \right)} & \cos{\left(\delta_{r}{\left(t \right)} \right)} & - \frac{L \cos{\left(\delta_{r}{\left(t \right)} \right)}}{2} - \frac{W \sin{\left(\delta_{r}{\left(t \right)} \right)}}{2}\end{bmatrix}
$$


The rank of this matrix is always 2, but the shape is $2 \times 3$, meaning that the system has one degree of freedom. A solution for this system can be found looking at the null space of the constraints matrix, which gives:

$$
\ker(A(q)^\top)=\left[\begin{matrix}\frac{L \cos{\left(\delta_{f}{\left(t \right)} \right)} \cos{\left(\delta_{r}{\left(t \right)} \right)}}{\sin{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}} + \frac{W \sin{\left(\delta_{f}{\left(t \right)} + \delta_{r}{\left(t \right)} \right)}}{2 \sin{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}}\\\frac{L \sin{\left(\delta_{f}{\left(t \right)} + \delta_{r}{\left(t \right)} \right)}}{2 \sin{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}} + \frac{W \sin{\left(\delta_{f}{\left(t \right)} \right)} \sin{\left(\delta_{r}{\left(t \right)} \right)}}{\sin{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}}\\1\end{matrix}\right]= h(\delta_f, \delta_r)
$$

So, the state $\dot{q}$ is a scalar multiple of this vector. It's evident that we need to know the steering angles in order to compute it. We could choose a different state representation including the steering angles extend the matrix $A(q)^\top$ with two more columns (basically adding two more vectors of zeros), to find a nullspace of dimension 5 that says that
$$
\delta_f = \dot{\delta_f}_{des} \quad , \quad \delta_r = \dot{\delta_r}_{des}
$$
Or model the actuators dynamics to have a more realistic model of the steering angles evolution. This would allow us to have a chain of integrators from the steering commands up to body velocities.

### Pure rolling constraints

We can add more constraints to the system by enforcing the pure rolling condition at each wheel. This means that the linear velocity at the contact point of each wheel must be equal to the tangential velocity due to the wheel rotation. Or:
$$v_i = r \omega_i \quad i \in \{f, r\}
$$
And it must be equal to the projection of the wheel velocity along the wheel direction, that is:
$$v_i = v_i^b \cdot u_i^b =
\begin{bmatrix}
\dot{x}^b \mp \dot{\theta} \frac{W}{2}\\
\dot{y}^b \pm \dot{\theta} \frac{L}{2}
\end{bmatrix} \cdot
\begin{bmatrix}
\cos(\delta_i)\\
\sin(\delta_i)
\end{bmatrix}= r \omega_i \quad i \in \{f, r\}
$$

For the front and rear wheel, this gives:

$$
\begin{aligned}
\left(\frac{L \dot{\theta}{\left(t \right)}}{2} + \dot{y}^b{\left(t \right)}\right) \sin{\left(\delta_{f}{\left(t \right)} \right)} + \left(- \frac{W \dot{\theta}{\left(t \right)}}{2} + \dot{x}^b{\left(t \right)}\right) \cos{\left(\delta_{f}{\left(t \right)} \right)}&= r \omega_{f}{\left(t \right)}\\
\left(- \frac{L \dot{\theta}{\left(t \right)}}{2} + \dot{y}^b{\left(t \right)}\right) \sin{\left(\delta_{r}{\left(t \right)} \right)} + \left(\frac{W \dot{\theta}{\left(t \right)}}{2} + \dot{x}^b{\left(t \right)}\right) \cos{\left(\delta_{r}{\left(t \right)} \right)}&= r \omega_{r}{\left(t \right)}
\end{aligned}
$$

## Extended Constraints matrix

If now we consider both the non-slipping and the pure rolling constraints together, we can form an extended constraints matrix $A_{ext}(q)^\top$ such that:
$$
A_{ext}(q)^\top \dot{q} = \begin{bmatrix}0\\0\\r \omega_f\\r \omega_r\end{bmatrix}
$$
Where
$$
A_{ext}^\top=\left[\begin{matrix}- \sin{\left(\delta_{f}{\left(t \right)} \right)} & \cos{\left(\delta_{f}{\left(t \right)} \right)} & \frac{L \cos{\left(\delta_{f}{\left(t \right)} \right)}}{2} + \frac{W \sin{\left(\delta_{f}{\left(t \right)} \right)}}{2}\\- \sin{\left(\delta_{r}{\left(t \right)} \right)} & \cos{\left(\delta_{r}{\left(t \right)} \right)} & - \frac{L \cos{\left(\delta_{r}{\left(t \right)} \right)}}{2} - \frac{W \sin{\left(\delta_{r}{\left(t \right)} \right)}}{2}\\\cos{\left(\delta_{f}{\left(t \right)} \right)} & \sin{\left(\delta_{f}{\left(t \right)} \right)} & \frac{L \sin{\left(\delta_{f}{\left(t \right)} \right)}}{2} - \frac{W \cos{\left(\delta_{f}{\left(t \right)} \right)}}{2}\\\cos{\left(\delta_{r}{\left(t \right)} \right)} & \sin{\left(\delta_{r}{\left(t \right)} \right)} & - \frac{L \sin{\left(\delta_{r}{\left(t \right)} \right)}}{2} + \frac{W \cos{\left(\delta_{r}{\left(t \right)} \right)}}{2}\end{matrix}\right]
$$

Using the Moore-Penrose pseudoinverse, we can find
$$
\begin{aligned}
A_{ext}^\dagger &= \left(A_{ext}^\top A_{ext}\right)^{-1} A_{ext}^\top\\
&=\left[\begin{matrix}- \frac{\sin{\left(\delta_{f}{\left(t \right)} \right)}}{2} & - \frac{\sin{\left(\delta_{r}{\left(t \right)} \right)}}{2} & \frac{\cos{\left(\delta_{f}{\left(t \right)} \right)}}{2} & \frac{\cos{\left(\delta_{r}{\left(t \right)} \right)}}{2}\\\frac{\cos{\left(\delta_{f}{\left(t \right)} \right)}}{2} & \frac{\cos{\left(\delta_{r}{\left(t \right)} \right)}}{2} & \frac{\sin{\left(\delta_{f}{\left(t \right)} \right)}}{2} & \frac{\sin{\left(\delta_{r}{\left(t \right)} \right)}}{2}\\\frac{L \cos{\left(\delta_{f}{\left(t \right)} \right)} + W \sin{\left(\delta_{f}{\left(t \right)} \right)}}{L^{2} + W^{2}} & - \frac{L \cos{\left(\delta_{r}{\left(t \right)} \right)} + W \sin{\left(\delta_{r}{\left(t \right)} \right)}}{L^{2} + W^{2}} & \frac{L \sin{\left(\delta_{f}{\left(t \right)} \right)} - W \cos{\left(\delta_{f}{\left(t \right)} \right)}}{L^{2} + W^{2}} & \frac{- L \sin{\left(\delta_{r}{\left(t \right)} \right)} + W \cos{\left(\delta_{r}{\left(t \right)} \right)}}{L^{2} + W^{2}}\end{matrix}\right]
\end{aligned}
$$
Multiplying by the right-hand side and factorizing in terms of body velocities, we obtain

$$
\begin{aligned}
\dot{q}&= g(q,u)\\
\begin{bmatrix}
\dot{x}^b\\
\dot{y}^b\\
\dot{\theta}
\end{bmatrix} &= \left[\begin{matrix}\frac{r \cos{\left(\delta_{f}{\left(t \right)} \right)}}{2} & \frac{r \cos{\left(\delta_{r}{\left(t \right)} \right)}}{2}\\\frac{r \sin{\left(\delta_{f}{\left(t \right)} \right)}}{2} & \frac{r \sin{\left(\delta_{r}{\left(t \right)} \right)}}{2}\\\frac{r \left(L \sin{\left(\delta_{f}{\left(t \right)} \right)} - W \cos{\left(\delta_{f}{\left(t \right)} \right)}\right)}{L^{2} + W^{2}} & \frac{r \left(- L \sin{\left(\delta_{r}{\left(t \right)} \right)} + W \cos{\left(\delta_{r}{\left(t \right)} \right)}\right)}{L^{2} + W^{2}}\end{matrix}\right]\begin{bmatrix}\omega_{f}{\left(t \right)}\\\omega_{r}{\left(t \right)}\end{bmatrix}
\end{aligned}
$$

The extended model depends explicitly on the robot's geometry ($L, W$) and the velocities are 
- a weighted average of the wheel contributions for the linear velocities
- the angular moment generated by the wheels, normalized by the robot's moment of inertia approximation ($L^2 + W^2$).
- does not explicitly consider the ICR constraints.

Moreover,
- can handle independently the wheel angular velocities and steering angles as inputs.
- gives an approximate solution in the least squares sense when the pure rolling constraints cannot be exactly satisfied.
- can handle more complex situations like crabbing and spinning in place.

On the last point:
- Crabbing: setting $\delta_f = \delta_r = \pm \pi/2$ (wheels perpendicular to the robot longitudinal axis) and $\omega_f = \omega_r = \omega$, we have

$$
\begin{bmatrix}
\dot{x}^b\\
\dot{y}^b\\
\dot{\theta}
\end{bmatrix} =
\left[\begin{matrix}0 & 0\\\frac{r}{2} & \frac{r}{2}\\\frac{L r}{L^{2} + W^{2}} & - \frac{L r}{L^{2} + W^{2}}\end{matrix}\right]\begin{bmatrix}\omega\\\omega\end{bmatrix} =
\begin{bmatrix}0\\
r \omega\\
0
\end{bmatrix}
$$

- Spinning in place: To have a perfect rotation in place, we need to set the steering angles such that the ICR is at the robot center: $\delta_f = \alpha+\frac{\pi}{2}$, $\delta_r = \alpha-\frac{\pi}{2}$. Now, setting $\omega_f = \omega_r = \omega$, we have
$$
\begin{bmatrix}
\dot{x}^b\\
\dot{y}^b\\
\dot{\theta}
\end{bmatrix} =
\left[\begin{matrix}- \frac{r \sin{\left(\alpha \right)}}{2} & \frac{r \sin{\left(\alpha \right)}}{2}\\\frac{r \cos{\left(\alpha \right)}}{2} & - \frac{r \cos{\left(\alpha \right)}}{2}\\\frac{r \left(L \cos{\left(\alpha \right)} + W \sin{\left(\alpha \right)}\right)}{L^{2} + W^{2}} & \frac{r \left(L \cos{\left(\alpha \right)} + W \sin{\left(\alpha \right)}\right)}{L^{2} + W^{2}}\end{matrix}\right]
\begin{bmatrix}\omega\\\omega\end{bmatrix} =
\begin{bmatrix}0\\0\\\frac{2 r \left(L \cos{\left(\alpha \right)} + W \sin{\left(\alpha \right)}\right)}{L^{2} + W^{2}} \omega
\end{bmatrix}
$$

And for a generic steering angle $\gamma$, enforcing $\omega_r = \omega_f = \omega$, we have
$$
\begin{bmatrix}
\dot{x}^b\\
\dot{y}^b\\
\dot{\theta}
\end{bmatrix} =
\left[\begin{matrix}\frac{r \cos{\left(\gamma \right)}}{2} & \frac{r \cos{\left(\gamma \right)}}{2}\\\frac{r \sin{\left(\gamma \right)}}{2} & \frac{r \sin{\left(\gamma \right)}}{2}\\\frac{r \left(L \sin{\left(\gamma \right)} - W \cos{\left(\gamma \right)}\right)}{L^{2} + W^{2}} & \frac{r \left(- L \sin{\left(\gamma \right)} + W \cos{\left(\gamma \right)}\right)}{L^{2} + W^{2}}\end{matrix}\right]
\begin{bmatrix}\omega\\\omega\end{bmatrix} = \left[\begin{matrix}r \omega{\left(t \right)} \cos{\left(\gamma \right)}\\r \omega{\left(t \right)} \sin{\left(\gamma \right)}\\0\end{matrix}\right]
$$
Which is a natural diagonal motion along the direction defined by the steering angle $\gamma$.

### Global Frame

To express the kinematic model in the inertial frame, we can use the rotation matrix $R(\theta)$ to rotate the body velocities into the inertial frame:
$$
\begin{bmatrix}
\dot{x}^g\\
\dot{y}^g\\
\dot{\theta}
\end{bmatrix} =
\begin{bmatrix}
\cos(\theta) & -\sin(\theta) & 0\\
\sin(\theta) & \cos(\theta) & 0\\
0 & 0 & 1
\end{bmatrix}
\begin{bmatrix}
\dot{x}^b\\
\dot{y}^b\\
\dot{\theta}
\end{bmatrix}
$$

$$
\begin{bmatrix}
\dot{x}\\
\dot{y}\\
\dot{\theta}
\end{bmatrix} =
\left[\begin{matrix}\frac{r \cos{\left(\delta_{f}{\left(t \right)} + \theta{\left(t \right)} \right)}}{2} & \frac{r \cos{\left(\delta_{r}{\left(t \right)} + \theta{\left(t \right)} \right)}}{2}\\\frac{r \sin{\left(\delta_{f}{\left(t \right)} + \theta{\left(t \right)} \right)}}{2} & \frac{r \sin{\left(\delta_{r}{\left(t \right)} + \theta{\left(t \right)} \right)}}{2}\\\frac{r \left(L \sin{\left(\delta_{f}{\left(t \right)} \right)} - W \cos{\left(\delta_{f}{\left(t \right)} \right)}\right)}{L^{2} + W^{2}} & \frac{r \left(- L \sin{\left(\delta_{r}{\left(t \right)} \right)} + W \cos{\left(\delta_{r}{\left(t \right)} \right)}\right)}{L^{2} + W^{2}}\end{matrix}\right]\begin{bmatrix}\omega_{f}{\left(t \right)}\\\omega_{r}{\left(t \right)}\end{bmatrix}
$$


### ICR analysis

To allow physical interpretation of the motion, we can compute the Instantaneous Center of Rotation (ICR) of the robot. The ICR is the point in the plane around which the robot is instantaneously rotating. For a multi-wheel robot, the ICR can be found as the intersection point of the perpendicular lines to each wheel plane passing through the wheel contact point.

For the front wheel, the ICR is given by
$$
\begin{bmatrix}
x_{icr} \\
y_{icr}
\end{bmatrix}=
\begin{bmatrix}
\frac{L}{2} \\
\frac{W}{2}
\end{bmatrix}+ s_f \begin{bmatrix}
-sin(\delta_f) \\
cos(\delta_f)
\end{bmatrix}
$$
Where $s_f$ is a scalar parameter defining the position along the perpendicular line. Similarly, for the rear wheel, we have:
$$
\begin{bmatrix}
x_{icr} \\
y_{icr}
\end{bmatrix}=
\begin{bmatrix}
-\frac{L}{2} \\
-\frac{W}{2}
\end{bmatrix}+ s_r \begin{bmatrix}
-sin(\delta_r) \\
cos(\delta_r)
\end{bmatrix}
$$

By equating the two expressions, we can solve for $s_f$ and $s_r$, and find the coordinates of the ICR.
Using this method, we can at the same time find the radius of each wheel with respect to the ICR, and is given by the two distances $\|s_f\|$ and $\|s_r\|$. We have:

$$
\begin{equation*}
\begin{aligned}
s_f &= \frac{L \cos{\left(\delta_{r}{\left(t \right)} \right)} + W \sin{\left(\delta_{r}{\left(t \right)} \right)}}{\sin{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}}
\\
s_r &= \frac{L \cos{\left(\delta_{f}{\left(t \right)} \right)} + W \sin{\left(\delta_{f}{\left(t \right)} \right)}}{\sin{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}}
\end{aligned}
\end{equation*}
$$

Using this two coefficients in the first or the second equation, we can find the coordinates of the ICR as:
$$
\begin{equation*}
\begin{aligned}
x_{icr} &= - \frac{L \sin{\left(\delta_{f}{\left(t \right)} + \delta_{r}{\left(t \right)} \right)} + 2 W \sin{\left(\delta_{f}{\left(t \right)} \right)} \sin{\left(\delta_{r}{\left(t \right)} \right)}}{2 \sin{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}}
\\
y_{icr} &= \frac{2 L \cos{\left(\delta_{f}{\left(t \right)} \right)} \cos{\left(\delta_{r}{\left(t \right)} \right)} + W \sin{\left(\delta_{f}{\left(t \right)} + \delta_{r}{\left(t \right)} \right)}}{2 \sin{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}}
\end{aligned}
\end{equation*}
$$


Now, the angular velocity of each wheel is related to the angular velocity of the robot around the ICR by the relation:
$$\dot{\theta}=\frac{r \omega_i}{R_i} \quad i \in \{f, r\}$$
Where $R_i$ is the distance between the ICR and the $i-$th wheel contact point, which can be computed as:
$$
\begin{equation*}
\begin{aligned}
R_i &= \|ICR - p_i\| \quad i \in \{f, r\}\\
&= \sqrt{(x_{icr} - p_{i_x})^2 + (y_{icr} - p_{i_y})^2} \quad i \in \{f, r\}
\end{aligned}
\end{equation*}
$$
Since they must be equal, we have the relation:
$$\frac{r \omega_f}{R_f} = \frac{r \omega_r}{R_r}$$
or
$$R_r\omega_f = R_f\omega_r$$
Those equations are called the compatibility equations.
Computing the radii $R_f$ and $R_r$ from the ICR to the front and rear wheel contact points respectively, we have:
$$
\begin{equation*}
\begin{aligned}
R_f &= \sqrt{\frac{\left(L \cos{\left(\delta_{r}{\left(t \right)} \right)} + W \sin{\left(\delta_{r}{\left(t \right)} \right)}\right)^{2}}{\sin^{2}{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}}}
\\
R_r &=\sqrt{\frac{\left(L \cos{\left(\delta_{f}{\left(t \right)} \right)} + W \sin{\left(\delta_{f}{\left(t \right)} \right)}\right)^{2}}{\sin^{2}{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}}}
\end{aligned}
\end{equation*}
$$

> Here, one can notice that $\|s_f\| = R_f$ and $\|s_r\| = R_r$.

#### ICR singularities

It's clear from the expressions of $R_f$ and $R_r$ that when the steering angles are equal ($\delta_f = \delta_r$), the denominators become zero, and the radii go to infinity. This situation corresponds to both wheels being parallel, and thus the ICR being at infinity, meaning that the robot is moving in a straight line. In this way, the compatibility equation becomes 
$$\omega_f = \omega_r$$
> Meaning that both wheels must spin at the same rate to maintain a straight trajectory.

### Pseudoinverse and Constraints

It's important to note that using the pseudoinverse approach provides a least-squares solution to the system of equations, which may not always satisfy all constraints exactly, especially in cases where the system is over-constrained or when the pure rolling conditions cannot be met simultaneously with the non-slipping conditions. In such scenarios, the solution minimizes the overall error but may lead to slight deviations from the ideal non-slipping and pure rolling conditions at the wheels.

This is always true when the ICR is not finite, as in the case of both wheels being parallel (crabbing and spinning). In such cases, the pseudoinverse provides a best-effort solution that balances the constraints but may not fully satisfy them all.

## Inverse Kinematic Model

The inverse kinematic model can be derived by the ICR equations. 
Given a desired robot velocity $\dot{q}_d = [\dot{x}^g, \dot{y}^g, \dot{\theta}]_d^T$, we can compute the required wheel angular velocities and steering angles to achieve that motion.
First, we transform the desired velocities into the body frame:
$$
\begin{bmatrix}
\dot{x}^b_d\\
\dot{y}^b_d\\
\dot{\theta}
\end{bmatrix} =
\begin{bmatrix}
\cos(\theta) & \sin(\theta) & 0\\
-\sin(\theta) & \cos(\theta) & 0\\
0 & 0 & 1
\end{bmatrix}
\begin{bmatrix}
\dot{x}^g_d\\
\dot{y}^g_d\\
\dot{\theta}_d
\end{bmatrix}
$$

Then, from the no-slipping constraints, we can easily find that if they are solved in terms of $\delta_i$, we have:
$$
\begin{equation*}
\begin{aligned}
\delta_f &= \arctan2\left(\dot{y}^b_d + \dot{\theta}_d \frac{L}{2}, \dot{x}^b_d - \dot{\theta}_d \frac{W}{2}\right)\\
\delta_r &= \arctan2\left(\dot{y}^b_d - \dot{\theta}_d \frac{L}{2}, \dot{x}^b_d + \dot{\theta}_d \frac{W}{2}\right)
\end{aligned}
\end{equation*}
$$

Those equations covers both the cases when $\dot{\theta}_d \neq 0$ (turning motion) and $\dot{\theta}_d = 0$ (straight line motion).

> This becomes the $\delta_{i,cmd}$ values when a first-order actuator dynamics is considered for the steering angles. The actuator then tries to reach those desired angles and the instantaneous computed commands are used to compute the wheel angular velocities.


Then, we need to find the wheel angular velocities. Using the pure rolling constraints, we have:
- $\dot{\theta}_d \neq 0$
$$
\begin{equation*}
\begin{aligned}
\omega_f &= \frac{1}{r}\left[\left(\dot{y}^b_d + \dot{\theta}_d \frac{L}{2}\right) \sin(\delta_f) + \left(\dot{x}^b_d - \dot{\theta}_d \frac{W}{2}\right) \cos(\delta_f)\right]\\
\omega_r &= \frac{1}{r}\left[\left(\dot{y}^b_d - \dot{\theta}_d \frac{L}{2}\right) \sin(\delta_r) + \left(\dot{x}^b_d + \dot{\theta}_d \frac{W}{2}\right) \cos(\delta_r)\right]
\end{aligned}
\end{equation*}
$$
- $\dot{\theta}_d = 0$
$$
\omega_f = \omega_r = \frac{1}{r}\sqrt{(\dot{x}^b_d)^2 + (\dot{y}^b_d)^2}
$$


---

# Old model


$$
\begin{align}
&\begin{cases}
\dot{x} &= v \cos(\theta+\beta) \\
\dot{y} &= v \sin(\theta+\beta) \\
\dot{\theta} &= \frac{v\cos(\beta)}{l_f+l_r}\left(\tan(\delta_f)-\tan(\delta_r)\right)
\end{cases}\\
&\beta = \tan^{-1}\left(\frac{l_r \tan(\delta_f) + l_f \tan(\delta_r)}{l_f + l_r}\right)\\
&v = \frac{v_f \cos(\delta_f) + v_r \cos(\delta_r)}{2cos(\beta)}
\end{align}
$$

Recalling that, for a wheel, the linear velocity is given by
$$
v_i = r \omega_i\qquad i \in \{f, r\}
$$
We can rewrite the linear velocity of the robot as:
$$
v = r\frac{\omega_f \cos(\delta_f) + \omega_r \cos(\delta_r)}{2\cos(\beta)}
$$

For the actuators, we consider a first-order dynamic model:
$$
P(s) = \frac{1}{\tau s + 1} \\
$$
which in time domain corresponds to:
$$
\dot{u}_i = -\frac{1}{\tau}(u_i - u_{i,ref})
$$
The control inputs to the system are then: $$ \mathbf{u} = [\omega_f, \omega_r, \delta_f, \delta_r]^T $$
## Model rewrite

With some algebraic manipulations, we can rewrite the model as:

$$
\begin{bmatrix}
\dot{x} \\
\dot{y} \\
\dot{\theta}
\end{bmatrix} =
\frac{r}{2}\begin{bmatrix}
\left[\cos(\theta)-\sin(\theta)(\Sigma_{tan})\right]\cos(\delta_f) &
\left[\cos(\theta)-\sin(\theta)(\Sigma_{tan})\right]\cos(\delta_r) \\
\left[\sin(\theta)+\cos(\theta)(\Sigma_{tan})\right]\cos(\delta_f) &
\left[\sin(\theta)+\cos(\theta)(\Sigma_{tan})\right]\cos(\delta_r) \\
\frac{\Delta_{tan}}{l}\cos(\delta_f) & \frac{\Delta_{tan}}{l}\cos(\delta_r)
\end{bmatrix}
\begin{bmatrix}
\omega_f \\
\omega_r \\
\end{bmatrix}
$$
Where we defined:
$$
\begin{equation*}
\begin{aligned}
\Sigma_{tan} &= \frac{l_r \tan(\delta_f) + l_f \tan(\delta_r)}{l_f + l_r} \\
\Delta_{tan} &= \tan(\delta_f) - \tan(\delta_r) \\
l &= l_f + l_r
\end{aligned}
\end{equation*}
$$

## ICR for old model

From the kinematic model, we can derive the ICR as:
$$
\begin{bmatrix}
x_{icr} \\
y_{icr}
\end{bmatrix} =
\begin{bmatrix}
l_f \\
0
\end{bmatrix} + s_f \begin{bmatrix}
-\sin(\delta_f) \\
\cos(\delta_f)
\end{bmatrix} =
\begin{bmatrix}
-l_r \\
0
\end{bmatrix} + s_r \begin{bmatrix}
-\sin(\delta_r) \\
\cos(\delta_r)
\end{bmatrix}
$$

Solving in $s_f$ and $s_r$, we can find as before the two radius:

$$
\begin{equation*}
\begin{aligned}
R_f &=\sqrt{\frac{\left(l_{f} + l_{r}\right)^{2} \cos^{2}{\left(\delta_{r}{\left(t \right)} \right)}}{\sin^{2}{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}}}\\
R_r &= \sqrt{\frac{\left(l_{f} + l_{r}\right)^{2} \cos^{2}{\left(\delta_{f}{\left(t \right)} \right)}}{\sin^{2}{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}}}
\end{aligned}
\end{equation*}
$$

The coordinates of the ICR are:

$$
\begin{equation*}
\begin{aligned}
x_{icr} &=- \frac{l_{f} \sin{\left(\delta_{r}{\left(t \right)} \right)} \cos{\left(\delta_{f}{\left(t \right)} \right)} + l_{r} \sin{\left(\delta_{f}{\left(t \right)} \right)} \cos{\left(\delta_{r}{\left(t \right)} \right)}}{\sin{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}}\\
y_{icr} &= \frac{\left(l_{f} + l_{r}\right) \cos{\left(\delta_{f}{\left(t \right)} \right)} \cos{\left(\delta_{r}{\left(t \right)} \right)}}{\sin{\left(\delta_{f}{\left(t \right)} - \delta_{r}{\left(t \right)} \right)}}
\end{aligned}
\end{equation*}
$$

# Inverse kinematics for the old model

With the old model, we need to find a relationship between the side-slip angle $\beta$ and the control inputs. Again, given $\dot{q}_{d} = [\dot{x}_d, \dot{y}_d, \dot{\theta}_d]^T$, we want to find ${\omega_f, \omega_r, \delta_f, \delta_r}$ such that the desired motion is achieved.

From the kinematic equations (before the rewrite), we have:
$$
\begin{equation*}
\begin{aligned}
\dot{x}_d &= v \cos(\theta + \beta) \\
\dot{y}_d &= v \sin(\theta + \beta) 
\end{aligned}
\end{equation*}
$$
So:
$$
\begin{aligned}
v_d &= \sqrt{\dot{x}_d^2 + \dot{y}_d^2} \\
\beta_d &= \arctan2(\dot{y}_d, \dot{x}_d) - \theta
\end{aligned}
$$

> Here we assume that $\theta$ is known from the robot state.

- $\dot{\theta}_d \neq 0$

Now, $\beta_d$ must satisfy its relation with the steering angles:
$$
\beta_d = \tan^{-1}\left(\frac{l_r \tan(\delta_f) + l_f \tan(\delta_r)}{l_f + l_r}\right)
$$

The same is true for $\dot{\theta}_d$:
$$
\dot{\theta}_d = \frac{v_d \cos(\beta_d)}{l_f + l_r}\left(l_r \tan(\delta_f) - l_f \tan(\delta_r)\right)
$$

From which we can derive a system of equations in the unknowns $\tan(\delta_f)$ and $\tan(\delta_r)$. Let:
$$
\begin{aligned}
S &= \tan(\beta_d) \\
D &= \frac{l \dot{\theta}_d}{v_d \cos(\beta_d)}
\end{aligned}
$$

Then

$$
\begin{cases}
l_r \tan(\delta_f) + l_f \tan(\delta_r) = lS \\
\tan(\delta_f) - \tan(\delta_r) = D
\end{cases}
$$
Solving for $\tan(\delta_f)$ and $\tan(\delta_r)$, we have:

$$
\begin{aligned}
\delta_f &= \arctan\left(\frac{lS + l_f D}{l}\right)=\arctan\left(\frac{\dot{\theta}_{d} l_{f} + v_{d} \sin{\left(\beta_{d} \right)}}{v_{d} \cos{\left(\beta_{d} \right)}}\right) \\
\delta_r &= \arctan\left(\frac{lS - l_r D}{l}\right)=\arctan\left(\frac{v_{d} \sin{\left(\beta_{d} \right)} - \dot{\theta}_{d} l_{r}}{v_{d} \cos{\left(\beta_{d} \right)}}\right)
\end{aligned}
$$

> This means that we cannot ask for crabbing at $\pi/2$, as this would require $\cos(\beta_d)=0$.
> We neither can ask for pure rotation in place, as this would require $v_d=0$.

Now, we have some choices:
- compute the ICR for the given steering angles and derive the wheel angular velocities from there using the compatibility condition
- use $\omega_r = \omega_f=\omega$ to make a simpler choice and void slipping when the ICR degenerates (es $\delta_f = \delta_r$)

With the second choice, we have:
$$
\omega_d = \frac{2 v_{d} \cos{\left(\beta_d \right)}}{r \left(\cos{\left(\delta_{f}{\left(t \right)} \right)} + \cos{\left(\delta_{r}{\left(t \right)} \right)}\right)}
$$

With the first choice, assuming that $R_f$ and $R_r$ are known, we can set
$$
\omega_r = \frac{R_r}{R_f} \omega_f
$$

And then
$$
\omega_f = \frac{2 R_{f} v_{d} \cos{\left(\beta_{d} \right)}}{r \left(R_{f} \cos{\left(\delta_{f}{\left(t \right)} \right)} + R_{r} \cos{\left(\delta_{r}{\left(t \right)} \right)}\right)}
$$


- $\dot{\theta}_d = 0$

If we want a straight line motion, we have that $D=0$ and this would require:
$$\tan(\delta_f)=\tan(\delta_r)$$

So both steering angles must be equal to an angle $\delta$. Then, $\beta_d$ must satisfy
$$
\beta_d = \tan^{-1}\left(\frac{l_r + l_f}{l_f + l_r}\tan(\delta)\right) = \delta
$$
Conversely, we must set:
$$
\begin{aligned}
\delta &= \arctan 2(\dot{y}_d, \dot{x}_d) - \theta\\
\omega &= \frac{1}{r}\sqrt{\dot{x}_d^2 + \dot{y}_d^2}
\end{aligned}
$$

- How to require crabbing:

During crabbing, both wheels are perpendicular to the robot longitudinal axis, so $\delta_f = \delta_r = \pm \frac{\pi}{2}$. In this case, from the kinematic equations, we have:
$$
\begin{aligned}
\dot{x}_d &= 0 \\
\dot{y}_d &= v_d \\
\dot{\theta}_d &= 0
\end{aligned}
$$
So, to achieve crabbing motion, we must set the steering angles to $\pm \frac{\pi}{2}$ and the wheel angular velocities to:
$$
\omega_f = \omega_r = \frac{v_d}{r}
$$

> With this model is impossible to spin in place.