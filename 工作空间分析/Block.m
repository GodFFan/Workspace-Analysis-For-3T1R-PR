%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%     �������ܣ��˺�������ʵ����ָ��λ�����������
%%%%     �������ͣ�xn yn znΪ�����������
%%%%              xmin ymin zminΪʵ����������
%%%%              tx ty tzΪ����ϵ��         
%%%%              %%����xmin ymin zmin ��tx ty tz���Խ�����ʵ�������ӳ��
%%%%              [xn, yn, zn]-[1,1,1]�ǽ����ƫ����1�Ŷ���
function Block(xn,yn,zn,xmin,ymin,zmin,tx,ty,tz)%%xn yn znΪÿһ��С�������λ��
	vertices_matrix = [0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
	faces_matrix = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;4 3 2 1;5 6 7 8];
    
    map=([xn, yn, zn]-[1,1,1] + vertices_matrix).*[tx,ty,tz]+[xmin,ymin,zmin];%%��Ԫ���鵽ʵ�������ӳ��
    
	patch('Vertices', map,'Faces',faces_matrix,...%%[xn, yn, zn]-[0.5, 0.5, 0.5]Ϊƫ��
		'FaceVertexCData',cool(8), 'FaceColor','interp');
	view(3)
    hold on;
end
% %% ����һ����Ⱦ��ʽ
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
% c = cool( 110 );   %%%%-------hsv( ),ע���������������Ҫ��w()����Ӧ������Ҫ��ſ��ԣ���
% fill3(x,y,z,c(xn,:));
% colormap( cool );   %%%%-----�Ż�ǰ��winter,�Ż�����cool
% hold on
% end


% %% example
% %%������������ִ��
% vertices_matrix = [0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
% faces_matrix = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;4 3 2 1;5 6 7 8];
% 
% patch('Vertices', vertices_matrix,'Faces',faces_matrix ,'FaceVertexCData',cool(8), 'FaceColor','interp');
% 
% %patch('Vertices', vertices_matrix,'Faces',faces_matrix,...%%[xn, yn, zn]-[0.5, 0.5, 0.5]Ϊƫ��
% %    'FaceVertexCData',hsv(8), 'FaceColor','interp');
% view(3)
% hold on;
