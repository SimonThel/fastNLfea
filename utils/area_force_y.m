function force = area_force_y(XYZ, minx, minz, maxx, maxz, y_pos)
x = XYZ(1);
y = XYZ(2);
z = XYZ(3);
force = 0; 
if y == y_pos
    if minx <= x && x <= maxx && minz <= z && z <= maxz
        force =+ force + 1;
        if minx < x && x < maxx
            force =+ force + 1;
        end
        if minz < z && z < maxz
            force =+ force +1;
        end
        if minx < x && x < maxx && minz < z && z < maxz
            force =+ force + 1;
        end
    end
end