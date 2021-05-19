function force = area_force_z(XYZ, minx, miny, maxx, maxy, z_pos)
x = XYZ(1);
y = XYZ(2);
z = XYZ(3);
force = 0; 
if z == z_pos
    if minx <= x && x <= maxx && miny <= y && y <= maxy
        force =+ force + 1;
        if minx < x && x < maxx
            force =+ force + 1;
        end
        if miny < y && y < maxy
            force =+ force +1;
        end
        if minx < x && x < maxx && miny < y && y < maxy
            force =+ force + 1;
        end
    end
end