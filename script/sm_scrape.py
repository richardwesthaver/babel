#!/usr/bin/env python3
import requests
from bs4 import BeautifulSoup as bs

domain = 'pinouts.ru'

r = requests.get('https://' + domain + '/sitemap.xml')
soup = bs(r.text)
pages = soup.find_all('loc')

print("sitemap parse success\n")

pl = {}

for i, k in zip(range(10), pages) :
    r = requests.get(k.text)
    ir = bs(r.text)
    conns = [i['src'] for i in ir.select("img[src*='/connectors/']")]
    dias = [i['src'] for i in ir.select("img[src*='/diagrams/']")]
    phos = [i['src'] for i in ir.select("img[src*='/photos/']")]
    imgs = [i['src'] for i in ir.select("img[src*='/images/']")]
    vis = [i['src'] for i in ir.select("img[src*='/visual/']")]    
    ps = [i.text.strip() for i in ir.find_all("p")]
    sects = [i.text.strip() for i in ir.find_all("h2")]


    pl.update({k.text: [#ir.find("title").text.strip(),
                        #ir.find("div", {"id": "content_header"}).text.strip(),
                        sects,
                        ps,
                        conns,
                        dias,
                        phos,
                        imgs,
                        vis
                        ]})
    print("iter#: " + str(i) +  " -- success\n" + k.text)

print("data is ready for export")

with open(domain.replace('.', '_') + '.txt', 'w') as f:
    f.write("PAGE : [TITLE, CONTENT_HEADER, [IMG_URLS]..]\n")
    for k in pl.keys():
        f.write("%s : %s\n"%(k, pl[k]))
print("mission success")
