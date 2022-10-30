sitestr = webread("https://www.landsvirkjun.is/rennsli-um-yfirfall-halslons");
arrReg = '\[(\[\d+,\d*[.]*\d*\][,\]])+';

datas = regexp(sitestr, arrReg, 'match');
names = {'2022','2021','2020','2019','2018'}; % geri þetta sjálvirkt í juliu

