# Values of Physical Significance. 
# Units: seconds (time), cm (length), Celsius (Temperature)
scale_length = 32.34
flame_temperature = 85
room_temperature = 29
base_temp = 34
heat_time = 130                              
cool_time = 120
time_scale = 1  
tot_time = (heat_time + cool_time)*time_scale                                             
alpha = 0.042                                                   #thermal diffusivity

# Values relevant to numerical scheme (Forward-Time, Central-Space Euler Method  for 1D Heat Equation with Neumann Boundary Condition)

# Mesh sizes and interval lengths
scale_xmesh = 0.333
xmesh = ceil(21*scale_xmesh)
tmesh = floor(200*time_scale)
x = linspace(0,scale_length, xmesh);
t = linspace(0, tot_time, tmesh); 
h = scale_length/xmesh
dt = tot_time/tmesh      
l = dt/(h^2)                 
f = alpha*l                              # |f| < 0.5 for stability of scheme
disp(f)

# Initial Conditions                      
v = []
v(1, 1:floor(xmesh/2)) = room_temperature
v(1, ceil(xmesh/2)) = base_temp;
v(1, ceil(xmesh/2) + 1:xmesh) = room_temperature;


#phase 1; heating for heat_time seconds to generate appropriate initial conditions for the area-preservation verification step
for n = 1:ceil((heat_time/tot_time)*tmesh)
  for i = 2:xmesh-1
    v(n+1, i) = v(n, i) + f*(v(n, i+1) - 2*v(n, i) + v(n, i-1));
  endfor
  v(n+1, ceil(xmesh/2)) = ((flame_temperature-base_temp)/(heat_time))*t(n) + base_temp;          #Assuming a linear increase in temperature at the centre
  #Neumann Boundary Condition of du/dx = 0:
  v(n + 1 , xmesh) = v(n + 1, xmesh-1);                           
  v(n+1, 1) = v(n+1, 2);                                          
endfor


# phase 2; allowing heat to transfer through scale and to air without external heat source for tot_time - heat_time seconds
for n = ceil((heat_time/tot_time)*tmesh)+1:tmesh-1
  for i = 2:xmesh-1
    v(n+1, i) = v(n, i) + f*(v(n, i+1) - 2*v(n, i) + v(n, i-1));
  endfor
  #Neumann Boundary Condition of du/dx = 0:
  v(n + 1 , xmesh) = v(n + 1, xmesh-1);                           
  v(n+1, 1) = v(n+1, 2);       
  
  plot(x, v(n, 1:xmesh))
  hold on 
  a = 0
  for xi = 1:xmesh-1
    a += 0.5*h*(v(n, xi) + v(n, xi+1));
  endfor
  disp(a)
endfor

