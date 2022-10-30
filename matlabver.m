%%% Þetta er dæmi um hvernig þetta væri gert í matlab. averu útreikningar voru gerðir í Julia

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

h1 = headloss(data,35000,43,0.2);
h2 = headloss(data,7000,560,0.2);
h = {};
for i = 1:5
	h{i}= h1{i} + h2{i};
end

% scali ekki réttur, er réttur í Julia
plot(h{1}(:,1),h{1}(:,2));
hold on;
for i = 2:5
	plot(h{i}(:,1),h{i}(:,2)) 
end
hold off;

flow = {};
for i = 1:5
	flow{i} = data{i} .* 1000;
end

eta = 0.7533;
g_n = 9.80665;
W = {};
for i = 1:5
	W{i} = flow{i}(:,2) .* g_n .* h{i}(:,2) .* eta .* 0.0000002778 .* 60 .* 60 .* 24;
end



w_ari = [];
for i = 1:5
	w_ari(i) = sum(W{i});
end
w_ari

bar(w_ari)


vetni = [];
for i = 1:5
	vetni(i) = w_ari(i)/48/1000
end

bar(vetni)

function headloss = headloss(data,L,S,z)
	g_n = 9.80665;
	S_f = S/L;
	maxs = ones(1,5);
	k = 2.5e-5;
	for i = 1:5
		m = max(data{i});
		maxs(i) = m(2);
	end
	desflow = max(maxs);
	n = 0.012*k^(1/6);

	y =(2^0.25 / ((2*sqrt(1+z^2)-z)^(3/8))*(desflow*n / sqrt(S_f))^3/8) * 1.5
	b=2*y*(sqrt(1+z^2)-z)
	t=2*y*(sqrt(1+z^2))

	A = y/2*(b+t);
	perim = b+2*(hypot(t-b,y));

	U = {};
	for i = 1:5
		U{i} = data{i} ./ A;
	end

	D = 4*A/perim;

	v = 1.52e-6;

	Re = {};
	for i = 1:5
		Re{i} = U{i} .* D ./ v;
	end

	f = {};
	for i = 1:5
		f{i} = 0.25 ./ log10(k ./ (3.7 .* D) + 5.74 ./ Re{i} .^ 0.9) .^ 2;
	end

	headloss = {};
	for i = 1:5
		headloss{i} = f{i} .* L ./ D .* U{i}.^2 ./ 2*g_n;
	end
end