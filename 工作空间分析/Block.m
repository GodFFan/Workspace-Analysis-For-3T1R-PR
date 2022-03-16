%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%     函数功能：此函数用来实现在指定位置填充立方体
%%%%     参数解释：xn yn zn为立方体的形心
%%%%              xmin ymin zmin为实际坐标下限
%%%%              tx ty tz为比例系数         
%%%%              %%利用xmin ymin zmin 和tx ty tz可以建立与实际坐标的映射
%%%%              [xn, yn, zn]-[1,1,1]是将起点偏移至1号顶点
function Block(xn,yn,zn,xmin,ymin,zmin,tx,ty,tz)%%xn yn zn为每一个小块的形心位置
	vertices_matrix = [0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
	faces_matrix = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;4 3 2 1;5 6 7 8];
    
    map=([xn, yn, zn]-[1,1,1] + vertices_matrix).*[tx,ty,tz]+[xmin,ymin,zmin];%%三元数组到实际坐标的映射
    
	patch('Vertices', map,'Faces',faces_matrix,...%%[xn, yn, zn]-[0.5, 0.5, 0.5]为偏移
		'FaceVertexCData',cool(8), 'FaceColor','interp');
	view(3)
    hold on;
end
% %% 另外一种渲染方式
% function Block(xn,yn,zn)
% x = xn + [
%     0 1 1 0 0 0;
%     1 1 0 0 1 1;
%     1 1 0 0 1 1;
%     0 1 1 0 0 0];
% y = yn + [
%     0 0 1 0 0 0;
%     0 1 1 1 0 0;
%     0 1 1 1 1 1;
%     0 0 1 0 1 1];
% z = zn + [
%     0 0 0 0 0 1;
%     0 0 0 0 0 1;
%     1 1 1 1 0 1;
%     1 1 1 1 0 1];
% c = cool( 110 );   %%%%-------hsv( ),注意括号里面的数字要比w()里相应的数字要大才可以！！
% fill3(x,y,z,c(xn,:));
% colormap( cool );   %%%%-----优化前用winter,优化后用cool
% hold on
% end


% %% example
% %%拷贝到命令行执行
% vertices_matrix = [0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
% faces_matrix = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;4 3 2 1;5 6 7 8];
% 
% patch('Vertices', vertices_matrix,'Faces',faces_matrix ,'FaceVertexCData',cool(8), 'FaceColor','interp');
% 
% %patch('Vertices', vertices_matrix,'Faces',faces_matrix,...%%[xn, yn, zn]-[0.5, 0.5, 0.5]为偏移
% %    'FaceVertexCData',hsv(8), 'FaceColor','interp');
% view(3)
% hold on;
