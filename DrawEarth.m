function [ sx ] = DrawEarth( R )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    load('topo.mat','topo');
    [x,y,z]=sphere(35);
    sx = surface(R*x,R*y,R*z,'FaceColor','texturemap','CData',topo);
    set(sx,'EdgeColor','none');
end

