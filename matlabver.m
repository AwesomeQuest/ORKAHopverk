sitestr = webread("https://www.landsvirkjun.is/rennsli-um-yfirfall-halslons");
arrReg = '\[(\[\d+,\d*[.]*\d*\][,\]])+';

datas = regexp(sitestr, arrReg, 'match');
names = {'2022','2021','2020','2019','2018'}; % geri þetta sjálvirkt í juliu

data{5} = {};

m = size(datas);
for i = 1:m(2)
	data{i} = str2num(datas{i});
	n = size(data{i});
	if i == 1
		data{i} = [data{i}, zeros(1, 246 - n(2))];
	end
	data{i} = reshape(data{i}, 2,123)';
	n = size(data{i});
	data{i}(:,1) = cumsum([data{i}(1,1),ones(1,n(1)-1)*(data{i}(1,1) - data{i}(2,1))]);
end

plot(data{1}(:,1),data{1}(:,2))
hold on;
for i = 2:m(2)
	plot(data{i}(:,1),data{i}(:,2))
end
hold off;

function headloss = headloss(L,S,z)
	S_f = S/L
end